using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class sub : System.Web.UI.Page
    {
        // Sabit plan listesi — veritabanı tablosu gerekmez
        private static readonly List<AbonelikPlani> Planlar = new List<AbonelikPlani>
        {
            new AbonelikPlani
            {
                Id = 1, Ad = "Başlangıç", Fiyat = 0, Periyot = "Süresiz Ücretsiz",
                Aciklama = "Kişisel kullanım ve deneme için ideal.",
                Ozellikler = new[]{ "1 şirket", "50 stok kalemi", "Temel raporlar", "E-posta desteği" },
                Populer = false
            },
            new AbonelikPlani
            {
                Id = 2, Ad = "Pro", Fiyat = 149, Periyot = "/ ay",
                Aciklama = "Büyüyen işletmeler için güçlü özellikler.",
                Ozellikler = new[]{ "5 şirket", "Sınırsız stok", "Gelişmiş raporlar", "Kritik stok alarmları", "Öncelikli destek" },
                Populer = true
            },
            new AbonelikPlani
            {
                Id = 3, Ad = "Kurumsal", Fiyat = 399, Periyot = "/ ay",
                Aciklama = "Kurumsal takımlar ve çok şubeli işletmeler için.",
                Ozellikler = new[]{ "Sınırsız şirket", "Sınırsız stok", "API erişimi", "7/24 telefon desteği", "Özel entegrasyonlar" },
                Populer = false
            }
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EnsureTablesExist();   // Tabloları yoksa oluştur
                MevcutAboneligiGetir();
                PlanlariGetir();
            }
        }

        // ====================== TABLOLARI OLUŞTUR / GÜNCELLE ======================
        private void EnsureTablesExist()
        {
            string connStr = ConfigurationManager.ConnectionStrings["register"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1) Tablo yoksa tüm kolonlarla oluştur
                new SqlCommand(@"
                    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserSubscriptions' AND xtype='U')
                    CREATE TABLE UserSubscriptions (
                        Id        INT IDENTITY PRIMARY KEY,
                        UserId    INT NOT NULL,
                        PlanId    INT NOT NULL DEFAULT 0,
                        PlanName  NVARCHAR(50),
                        Status    NVARCHAR(20) NOT NULL DEFAULT 'active',
                        StartDate DATETIME     NOT NULL DEFAULT GETDATE(),
                        EndDate   DATETIME     NULL
                    )", conn).ExecuteNonQuery();

                // 2) Tablo önceden farklı şemayla oluşturulmuşsa eksik/bozuk kolonları düzelt
                var alterCmds = new[]
                {
                    // PlanName
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='PlanName')
                      ALTER TABLE dbo.UserSubscriptions ADD PlanName NVARCHAR(50)",

                    // StartDate — tablo varsa ama DEFAULT yoksa sütunu yeniden ekleyemeyiz;
                    // bu yüzden NULL olan kayıtları da güncelliyoruz
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='StartDate')
                      ALTER TABLE dbo.UserSubscriptions ADD StartDate DATETIME NOT NULL DEFAULT GETDATE()",

                    // Eski start_date (snake_case) varsa ve StartDate yoksa, yeniden adlandır
                    @"IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='start_date')
                       AND NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='StartDate')
                      EXEC sp_rename 'dbo.UserSubscriptions.start_date', 'StartDate', 'COLUMN'",

                    // EndDate
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='EndDate')
                      ALTER TABLE dbo.UserSubscriptions ADD EndDate DATETIME NULL",

                    // PlanId
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='PlanId')
                      ALTER TABLE dbo.UserSubscriptions ADD PlanId INT NOT NULL DEFAULT 0",

                    // Status
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='Status')
                      ALTER TABLE dbo.UserSubscriptions ADD Status NVARCHAR(20) NOT NULL DEFAULT 'active'",

                    // UserId
                    @"IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.UserSubscriptions') AND name='UserId')
                      ALTER TABLE dbo.UserSubscriptions ADD UserId INT NOT NULL DEFAULT 0",

                    // StartDate NOT NULL ama DEFAULT kısıtlaması eksikse NULL kayıtları düzelt
                    @"UPDATE dbo.UserSubscriptions SET StartDate = GETDATE() WHERE StartDate IS NULL"
                };

                foreach (var sql in alterCmds)
                {
                    try { new SqlCommand(sql, conn).ExecuteNonQuery(); }
                    catch { /* kolon zaten varsa geç */ }
                }
            }
        }

        // ====================== MEVCUT ABONELİĞİ GETİR ======================
        private void MevcutAboneligiGetir()
        {
            if (Session["id"] == null) return;

            try
            {
                int userId = Convert.ToInt32(Session["id"]);
                string connStr = ConfigurationManager.ConnectionStrings["register"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(
                    "SELECT TOP 1 PlanName, Status, EndDate FROM UserSubscriptions WHERE UserId=@uid AND Status='active' ORDER BY StartDate DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblPlanAdi.Text = dr["PlanName"].ToString();
                            lblDurum.Text = "Aktif";
                            lblSonrakiFatura.Text = dr["EndDate"] == DBNull.Value
                                ? "Süresiz"
                                : Convert.ToDateTime(dr["EndDate"]).ToString("dd.MM.yyyy");
                            pnlMevcutAbonelik.Visible = true;
                        }
                    }
                }
            }
            catch { /* bağlantı hatası: panel gizli kalır */ }
        }

        // ====================== PLANLARI REPEATER'A BAĞLA ======================
        private void PlanlariGetir()
        {
            // Kullanıcının aktif plan id'sini bul
            int mevcutPlanId = 0;
            if (Session["id"] != null)
            {
                try
                {
                    int userId = Convert.ToInt32(Session["id"]);
                    string connStr = ConfigurationManager.ConnectionStrings["register"].ConnectionString;
                    using (var conn = new SqlConnection(connStr))
                    using (var cmd = new SqlCommand(
                        "SELECT TOP 1 PlanId FROM UserSubscriptions WHERE UserId=@uid AND Status='active'", conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", userId);
                        conn.Open();
                        var result = cmd.ExecuteScalar();
                        if (result != null) mevcutPlanId = Convert.ToInt32(result);
                    }
                }
                catch { }
            }

            // DataTable oluştur — Repeater'a bağla
            var dt = new DataTable();
            dt.Columns.Add("Id", typeof(int));
            dt.Columns.Add("Ad");
            dt.Columns.Add("Fiyat", typeof(decimal));
            dt.Columns.Add("Periyot");
            dt.Columns.Add("Aciklama");
            dt.Columns.Add("OzelliklerHtml");
            dt.Columns.Add("Populer", typeof(bool));
            dt.Columns.Add("Mevcut", typeof(bool));
            dt.Columns.Add("BtnText");

            foreach (var p in Planlar)
            {
                bool mevcut = (p.Id == mevcutPlanId);
                string html = "";
                foreach (var f in p.Ozellikler)
                    html += $"<li>&#10003; {System.Web.HttpUtility.HtmlEncode(f)}</li>";

                dt.Rows.Add(
                    p.Id, p.Ad, p.Fiyat, p.Periyot, p.Aciklama,
                    html, p.Populer, mevcut,
                    mevcut ? "Mevcut Planınız" : (p.Fiyat == 0 ? "Ücretsiz Başla" : "Abone Ol")
                );
            }

            rptPlanlar.DataSource = dt;
            rptPlanlar.DataBind();
        }

        // ====================== ABONE OL ======================
        protected void rptPlanlar_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "AboneOl") return;

            if (Session["id"] == null)
            {
                lblMesaj.Text = "&#9888; Abone olmak için önce giriş yapmalısınız.";
                lblMesaj.ForeColor = System.Drawing.Color.OrangeRed;
                return;
            }

            int planId = Convert.ToInt32(e.CommandArgument);
            var plan = Planlar.Find(p => p.Id == planId);
            if (plan == null) return;

            int userId = Convert.ToInt32(Session["id"]);

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["register"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Eski aktif abonelikleri pasife al
                    new SqlCommand(
                        "UPDATE UserSubscriptions SET Status='cancelled' WHERE UserId=@uid AND Status='active'",
                        conn)
                    { Parameters = { new SqlParameter("@uid", userId) } }
                    .ExecuteNonQuery();

                    // Yeni abonelik ekle
                    DateTime? endDate = plan.Fiyat == 0 ? (DateTime?)null : DateTime.Now.AddMonths(1);
                    using (var cmd = new SqlCommand(
                        "INSERT INTO UserSubscriptions (UserId, PlanId, PlanName, Status, StartDate, EndDate) VALUES (@uid, @pid, @pname, 'active', GETDATE(), @end)",
                        conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", userId);
                        cmd.Parameters.AddWithValue("@pid", plan.Id);
                        cmd.Parameters.AddWithValue("@pname", plan.Ad);
                        cmd.Parameters.AddWithValue("@end", (object)endDate ?? DBNull.Value);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblMesaj.Text = "&#10003; Abone olundu.";
                lblMesaj.ForeColor = System.Drawing.Color.Green;

                // Sayfayı yenile
                MevcutAboneligiGetir();
                PlanlariGetir();
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }

        // ====================== MODEL ======================
        private class AbonelikPlani
        {
            public int Id { get; set; }
            public string Ad { get; set; }
            public decimal Fiyat { get; set; }
            public string Periyot { get; set; }
            public string Aciklama { get; set; }
            public string[] Ozellikler { get; set; }
            public bool Populer { get; set; }
        }
    }
}