using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["mail"] != null)
            {
                pnlZiyaretci.Visible   = false;
                pnlUyeDashboard.Visible = true;

                if (!IsPostBack)
                    DashboardDoldur();
            }
            else
            {
                pnlZiyaretci.Visible    = true;
                pnlUyeDashboard.Visible = false;
            }
        }

        // ====================== DASHBOARD VERİLERİNİ ÇEK ======================
        private void DashboardDoldur()
        {
            string userId = Session["id"]?.ToString() ?? "0";

            lblAdSoyad.Text       = Session["ad"]?.ToString() ?? "";
            lblSonGuncelleme.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm");

            try
            {
                // ---- Şirket bağlantısı ----
                string compConn = ConfigurationManager.ConnectionStrings["Comp."].ConnectionString;

                // 1. Toplam Şirket
                using (var conn = new SqlConnection(compConn))
                using (var cmd  = new SqlCommand(
                    "SELECT COUNT(*) FROM companies WHERE adminid=@uid", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    lblToplamSirket.Text = cmd.ExecuteScalar().ToString();
                }

                // ---- Stok bağlantısı ----
                string stokConn = ConfigurationManager.ConnectionStrings["Stok"].ConnectionString;

                // 2. Toplam Ürün Çeşidi
                using (var conn = new SqlConnection(stokConn))
                using (var cmd  = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM   Stoklar s
                    INNER JOIN companies c ON s.SirketID = c.id
                    WHERE  c.adminid = @uid", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    lblToplamUrun.Text = cmd.ExecuteScalar().ToString();
                }

                // 3. Kritik Stok (Miktar <= MinStokSeviyesi)
                using (var conn = new SqlConnection(stokConn))
                using (var cmd  = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM   Stoklar s
                    INNER JOIN companies c ON s.SirketID = c.id
                    WHERE  c.adminid = @uid
                      AND  s.Miktar  <= s.MinStokSeviyesi", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    int kritik = (int)cmd.ExecuteScalar();
                    lblKritikStok.Text = kritik.ToString();
                }

                // 4. Toplam Stok Değeri (Miktar * SatisFiyati)
                using (var conn = new SqlConnection(stokConn))
                using (var cmd  = new SqlCommand(@"
                    SELECT ISNULL(SUM(s.Miktar * ISNULL(s.SatisFiyati, 0)), 0)
                    FROM   Stoklar s
                    INNER JOIN companies c ON s.SirketID = c.id
                    WHERE  c.adminid = @uid", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    decimal deger = (decimal)cmd.ExecuteScalar();
                    lblStokDegeri.Text = deger.ToString("N0");
                }

                // 5. Son 8 Ürün
                using (var conn = new SqlConnection(stokConn))
                using (var cmd  = new SqlCommand(@"
                    SELECT TOP 8
                           s.StokAdi, c.companiesname, s.Miktar,
                           s.Birim, s.SatisFiyati, s.MinStokSeviyesi,
                           s.KayitTarihi
                    FROM   Stoklar s
                    INNER JOIN companies c ON s.SirketID = c.id
                    WHERE  c.adminid = @uid
                    ORDER  BY s.KayitTarihi DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    var dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvSonUrunler.DataSource = dt;
                    gvSonUrunler.DataBind();
                }
            }
            catch
            {
                // DB henüz bağlı değilse sıfırlar görünür, uygulama çökmez
            }
        }

        // ====================== HIZLI ARAMA ======================
        protected void btnAra_Click(object sender, EventArgs e)
        {
            string ara    = txtAra.Text.Trim();
            string userId = Session["id"]?.ToString() ?? "0";

            if (string.IsNullOrWhiteSpace(ara))
            {
                lblAramaHata.Text = "Lütfen bir ürün adı veya barkod girin.";
                gvArama.Visible   = false;
                return;
            }

            lblAramaHata.Text = "";

            try
            {
                string stokConn = ConfigurationManager.ConnectionStrings["Stok"].ConnectionString;
                using (var conn = new SqlConnection(stokConn))
                using (var cmd  = new SqlCommand(@"
                    SELECT s.StokAdi, s.StokKodu, s.Miktar, s.Birim,
                           s.SatisFiyati, s.Kategori
                    FROM   Stoklar s
                    INNER JOIN companies c ON s.SirketID = c.id
                    WHERE  c.adminid = @uid
                      AND  (s.StokAdi  LIKE @ara OR
                             s.StokKodu LIKE @ara)", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@ara", "%" + ara + "%");
                    conn.Open();
                    var dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvArama.DataSource = dt;
                    gvArama.DataBind();
                    gvArama.Visible = true;

                    if (dt.Rows.Count == 0)
                        lblAramaHata.Text = $"'{ara}' için sonuç bulunamadı.";
                }
            }
            catch (Exception ex)
            {
                lblAramaHata.Text = "Arama hatası: " + ex.Message;
            }
        }
    }
}
