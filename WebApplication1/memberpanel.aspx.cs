using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                SirketleriDoldur();
        }

        // ====================== ŞİRKETLERİ DROPDOWN'A DOLDUR ======================
        private void SirketleriDoldur()
        {
            try
            {
                string userId = Session["id"]?.ToString() ?? "0";

                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["Comp."].ConnectionString))
                {
                    string query = @"SELECT id, companiesname
                                     FROM   companies
                                     WHERE  adminid = @uid
                                     ORDER  BY companiesname";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", userId);
                        conn.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            DataTable dt = new DataTable();
                            dt.Load(dr);

                            ddlSirketSec.DataSource     = dt;
                            ddlSirketSec.DataTextField  = "companiesname";
                            ddlSirketSec.DataValueField = "id";
                            ddlSirketSec.DataBind();

                            ddlStokSirket.DataSource     = dt;
                            ddlStokSirket.DataTextField  = "companiesname";
                            ddlStokSirket.DataValueField = "id";
                            ddlStokSirket.DataBind();
                        }
                    }
                }

                if (ddlSirketSec.Items.Count > 0)
                {
                    ddlSirketSec.SelectedIndex = 0;
                    GridViewStok.DataBind();
                }
            }
            catch (Exception ex)
            {
                JS($"alert('Şirketler yüklenirken hata: {Esc(ex.Message)}')");
            }
        }

        // ====================== MENÜ SEÇİMİ ======================
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idx = DropDownList1.SelectedIndex;
            MultiView1.ActiveViewIndex = (idx >= 0 && idx < MultiView1.Views.Count) ? idx : 0;
        }

        // ====================== ŞİRKET KAYDET ======================
        protected void btnSirketKaydet_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtSirketAdi.Text))
            {
                JS("alert('Şirket adı zorunludur!')");
                return;
            }

            if (Calendar1.SelectedDate == DateTime.MinValue)
                Calendar1.SelectedDate = DateTime.Today;

            try
            {
                SqlDataSource2.Insert();

                txtSirketAdi.Text     = "";
                txtVergiNo.Text       = "";
                txtCalisanSayisi.Text = "";
                ddlSirketTuru.SelectedIndex = 0;
                Calendar1.SelectedDates.Clear();

                SirketleriDoldur();
                GridView1.DataBind();

                lblSirketMesaj.Text      = "✅ Şirket başarıyla oluşturuldu.";
                lblSirketMesaj.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                JS($"alert('Şirket kaydedilemedi: {Esc(ex.Message)}')");
            }
        }

        // ====================== ŞİRKET SİL ======================
        protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            if (e.Exception == null)
            {
                SirketleriDoldur();
                lblSirketMesaj.Text      = "✅ Şirket başarıyla silindi.";
                lblSirketMesaj.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblSirketMesaj.Text      = "❌ Silme hatası: " + e.Exception.Message;
                lblSirketMesaj.ForeColor = System.Drawing.Color.Red;
                e.ExceptionHandled       = true;
            }
        }

        protected void Calendar1_SelectionChanged(object sender, EventArgs e) { }

        // ====================== ŞİRKET DEĞİŞTİĞİNDE STOK YENİLE ======================
        protected void ddlSirketSec_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewStok.DataBind();
        }

        // ====================== STOK KAYDET ======================
        // NOT: Kategori ve MinStokSeviyesi sütunları veritabanında bulunmadığından çıkarıldı.
        protected void btnStokKaydet_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlStokSirket.SelectedValue))
            { JS("alert('Lütfen bir şirket seçiniz!')"); return; }

            if (string.IsNullOrWhiteSpace(txtStokAdi.Text))
            { JS("alert('Stok adı boş bırakılamaz!')"); return; }

            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["Stok"].ConnectionString))
                {
                    const string sql = @"INSERT INTO Stoklar
                        (SirketID, StokAdi, StokKodu, Miktar, Birim,
                         AlisFiyati, SatisFiyati, Aciklama, KayitTarihi)
                        VALUES
                        (@SirketID, @StokAdi, @StokKodu, @Miktar, @Birim,
                         @AlisFiyati, @SatisFiyati, @Aciklama, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@SirketID",
                            Convert.ToInt32(ddlStokSirket.SelectedValue));
                        cmd.Parameters.AddWithValue("@StokAdi",
                            txtStokAdi.Text.Trim());
                        cmd.Parameters.AddWithValue("@StokKodu",
                            Str(txtStokKodu.Text));
                        cmd.Parameters.AddWithValue("@Miktar",
                            Dec(txtMiktar.Text, 0));
                        cmd.Parameters.AddWithValue("@Birim",
                            ddlBirim.SelectedValue);
                        cmd.Parameters.AddWithValue("@AlisFiyati",
                            DecNull(txtAlisFiyati.Text));
                        cmd.Parameters.AddWithValue("@SatisFiyati",
                            DecNull(txtSatisFiyati.Text));
                        cmd.Parameters.AddWithValue("@Aciklama",
                            Str(txtAciklama.Text));
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                JS("alert('✅ Stok başarıyla kaydedildi!')");
                GridViewStok.DataBind();
                TemizleStokFormu();
            }
            catch (Exception ex)
            {
                JS($"alert('Hata: {Esc(ex.Message)}')");
            }
        }

        private void TemizleStokFormu()
        {
            txtStokAdi.Text  = txtStokKodu.Text = txtMiktar.Text = "";
            txtAlisFiyati.Text = txtSatisFiyati.Text = txtAciklama.Text = "";
            ddlBirim.ClearSelection();
        }

        // ====================== YORUM GÖNDER ======================
        protected void btnYorumGonder_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtYorum.Text))
            { JS("alert('Lütfen bir yorum yazınız!')"); return; }

            SqlDataSource4.Insert();
            txtYorum.Text = "";
            JS("alert('✅ Yorumunuz alındı! Onaydan sonra yayımlanacaktır.')");
        }

        // ====================== YARDIMCI METODLAR ======================
        private void JS(string script)
            => ClientScript.RegisterStartupScript(GetType(), "js_" + Guid.NewGuid().ToString("N"),
               script + ";", true);

        private static string Esc(string s)
            => (s ?? "").Replace("'", "\\'").Replace("\r", " ").Replace("\n", " ");

        private static object Str(string s)
            => string.IsNullOrWhiteSpace(s) ? (object)DBNull.Value : s.Trim();

        private static decimal Dec(string s, decimal def)
        { decimal v; return decimal.TryParse(s, out v) ? v : def; }

        private static object DecNull(string s)
        { decimal v; return decimal.TryParse(s, out v) ? (object)v : DBNull.Value; }
    }
}
