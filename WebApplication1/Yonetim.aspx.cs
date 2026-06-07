using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Admin yetkisi kontrolü
            if (Session["Yetki"] == null || Session["Yetki"].ToString().ToLower() != "admin")
            {
                Response.Redirect("~/memberpanel.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                MultiView1.ActiveViewIndex  = 0;
                DropDownList1.SelectedIndex = 0;
            }

            // RowUpdating burada değil, InitComplete'de bağlanmalı — ama event sadece
            // Edit→Update akışında tetiklenir, her Page_Load'da yeni instance oluşur, sorun yok.
            // Yine de OnRowUpdating ASPX üzerinden bağlamak en temizi:
            // Bu satır kaldırıldı — Yonetim.aspx'e OnRowUpdating="GridView1_RowUpdating" eklendi.
        }

        // ====================== ÜYELER — ŞİFRE GÜNCELLEME ======================
        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtPwd = (TextBox)GridView1.Rows[e.RowIndex].FindControl("txtPassword");
            if (txtPwd != null && !string.IsNullOrWhiteSpace(txtPwd.Text))
            {
                e.NewValues["password"] = PasswordHelper.HashPassword(txtPwd.Text);
            }
            else
            {
                // Şifre girilmemişse mevcut şifreyi koru
                int uyeno = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Userlist"].ConnectionString))
                using (var cmd  = new SqlCommand("SELECT password FROM Users WHERE uyeno=@uid", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", uyeno);
                    conn.Open();
                    e.NewValues["password"] = cmd.ExecuteScalar()?.ToString() ?? "";
                }
            }
        }

        // ====================== MENÜ SEÇİMİ ======================
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idx = DropDownList1.SelectedIndex;
            MultiView1.ActiveViewIndex = idx;

            switch (idx)
            {
                case 1: gvMesajlar.DataBind();  break;
                case 2: gvYorumlar.DataBind();  break;
                case 3: gvSirketler.DataBind(); break;
                case 4: LoadSmtpSettings();     break;
            }
        }

        // ====================== ŞİRKETLER — SATIR SAYISI ======================
        protected void gvSirketler_DataBound(object sender, EventArgs e)
        {
            int rows = gvSirketler.Rows.Count;
            lblSirketSayisi.Text = rows > 0
                ? $"Toplam {rows} şirket"
                : "Kayıtlı şirket yok";
        }

        // ====================== SORULAR — SİL / YANITLA ======================
        protected void gvMesajlar_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument?.ToString())) return;
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                try
                {
                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Userlist"].ConnectionString))
                    using (var cmd  = new SqlCommand("DELETE FROM sorular WHERE Id=@Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    gvMesajlar.DataBind();
                    JS("alert('✅ Mesaj başarıyla silindi!')");
                }
                catch (Exception ex) { JS($"alert('Hata: {Esc(ex.Message)}')"); }
            }
            else if (e.CommandName == "Yanitla")
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Userlist"].ConnectionString))
                using (var cmd  = new SqlCommand("SELECT Id,AdSoyad,Konu,Mesaj FROM sorular WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblMesajId.Text = dr["Id"].ToString();
                            lblAdSoyad.Text = "Gönderen: " + dr["AdSoyad"];
                            lblKonu.Text    = "Konu: "     + dr["Konu"];
                            lblMesaj.Text   = HttpUtility.HtmlEncode(dr["Mesaj"].ToString())
                                                .Replace("&#13;&#10;", "<br/>");
                            txtCevap.Text   = "";
                        }
                    }
                }
                pnlYanit.Visible = true;
            }
        }

        // ====================== YANIT — GÖNDER ======================
        protected void btnGonder_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtCevap.Text))
            { JS("alert('Lütfen bir cevap yazın!')"); return; }

            try
            {
                int    mesajId    = Convert.ToInt32(lblMesajId.Text);
                string aliciEmail = "";

                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Userlist"].ConnectionString))
                using (var cmd  = new SqlCommand("SELECT Eposta FROM sorular WHERE Id=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", mesajId);
                    conn.Open();
                    aliciEmail = cmd.ExecuteScalar()?.ToString()?.Trim() ?? "";
                }

                if (string.IsNullOrEmpty(aliciEmail))
                { JS("alert('Alıcı e-posta adresi bulunamadı!')"); return; }

                string smtpHost  = ConfigurationManager.AppSettings["SmtpHost"];
                int    smtpPort  = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpPort"]);
                string fromEmail = ConfigurationManager.AppSettings["FromEmail"];
                string smtpPass  = ConfigurationManager.AppSettings["SmtpPassword"];
                bool   enableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"] ?? "true");

                using (var mail = new MailMessage())
                {
                    mail.From       = new MailAddress(fromEmail, "Stokcum.com");
                    mail.To.Add(aliciEmail);
                    mail.Subject    = "RE: " + lblKonu.Text.Replace("Konu: ", "").Trim();
                    mail.IsBodyHtml = true;
                    mail.Body =
                        "<html><body style='font-family:Arial,sans-serif;'>"
                      + "<p>Merhaba <strong>"
                      + HttpUtility.HtmlEncode(lblAdSoyad.Text.Replace("Gönderen: ", "").Trim())
                      + "</strong>,</p><p>"
                      + txtCevap.Text.Replace("\n", "<br>")
                      + "</p><hr><p style='color:#666;font-size:13px;'>Bu yanıt <strong>Stokcum.com</strong> "
                      + "üzerinden " + DateTime.Now.ToString("dd.MM.yyyy HH:mm")
                      + " tarihinde gönderilmiştir.</p></body></html>";

                    using (var smtp = new SmtpClient(smtpHost, smtpPort))
                    {
                        smtp.Credentials = new System.Net.NetworkCredential(fromEmail, smtpPass);
                        smtp.EnableSsl   = enableSsl;
                        smtp.Timeout     = 30000;
                        smtp.Send(mail);
                    }
                }

                JS("alert('✅ Mail başarıyla gönderildi!')");
                pnlYanit.Visible = false;
                txtCevap.Text    = "";
                gvMesajlar.DataBind();
            }
            catch (Exception ex)
            {
                JS($"alert('❌ Mail gönderilemedi: {Esc(ex.Message)}')");
            }
        }

        protected void btnKapat_Click(object sender, EventArgs e)
        {
            pnlYanit.Visible = false;
            txtCevap.Text    = "";
        }

        // ====================== YORUMLAR — ONAYLA / REDDET ======================
        protected void gvYorumlar_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument?.ToString())) return;

            int    yorumId = Convert.ToInt32(e.CommandArgument);
            string query   = null;
            string mesaj   = null;

            if      (e.CommandName == "Onayla") { query = "UPDATE comment SET onay=1 WHERE Id=@Id"; mesaj = "✅ Yorum onaylandı!"; }
            else if (e.CommandName == "Reddet") { query = "UPDATE comment SET onay=0 WHERE Id=@Id"; mesaj = "❌ Yorum reddedildi!"; }

            if (query == null) return;

            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Comment"].ConnectionString))
                using (var cmd  = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", yorumId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                gvYorumlar.DataBind();
                JS($"alert('{mesaj}')");
            }
            catch (Exception ex)
            {
                JS($"alert('Hata: {Esc(ex.Message)}')");
            }
        }

        // ====================== SİSTEM AYARLARI ======================
        private void LoadSmtpSettings()
        {
            txtSmtpHost.Text     = ConfigurationManager.AppSettings["SmtpHost"]  ?? "smtp.gmail.com";
            txtSmtpPort.Text     = ConfigurationManager.AppSettings["SmtpPort"]  ?? "587";
            txtFromEmail.Text    = ConfigurationManager.AppSettings["FromEmail"] ?? "";
            // Şifreyi gösterme
        }

        protected void btnAyarlariKaydet_Click(object sender, EventArgs e)
        {
            lblAyarMesaj.Text      = "ℹ️ SMTP ayarları Web.config üzerinden değiştirilmektedir.";
            lblAyarMesaj.ForeColor = System.Drawing.Color.DarkOrange;
        }

        // ====================== YARDIMCI METODlar ======================
        private void JS(string script)
            => ClientScript.RegisterStartupScript(GetType(),
               "js_" + Guid.NewGuid().ToString("N"), script + ";", true);

        private static string Esc(string s)
            => (s ?? "").Replace("'", "\\'").Replace("\r", " ").Replace("\n", " ");
    }
}
