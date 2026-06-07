using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Web;
using System.Web.UI;

namespace WebApplication1
{
    public partial class log : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        // ======================== GİRİŞ ========================
        protected void btnGiris_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtSifre.Text))
            { Alert("E-posta ve şifre gerekli."); return; }

            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["login-register"].ConnectionString))
                using (var cmd = new SqlCommand(
                    "SELECT uyeno,name,password,email,authority FROM Users WHERE email=@e", conn))
                {
                    cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            int    uid   = Convert.ToInt32(dr["uyeno"]);
                            string hash  = dr["password"].ToString();
                            string name  = dr["name"].ToString();
                            string email = dr["email"].ToString();
                            string role  = dr["authority"].ToString();

                            bool validHash = IsValidPBKDF2(hash);
                            if (!validHash)
                            {
                                if (hash != txtSifre.Text) throw new Exception("Hatalı parola");
                                dr.Close();
                                using (var c2 = new SqlConnection(ConfigurationManager.ConnectionStrings["login-register"].ConnectionString))
                                using (var u  = new SqlCommand("UPDATE Users SET password=@p WHERE uyeno=@u", c2))
                                {
                                    u.Parameters.AddWithValue("@p", PasswordHelper.HashPassword(txtSifre.Text));
                                    u.Parameters.AddWithValue("@u", uid);
                                    c2.Open(); u.ExecuteNonQuery();
                                }
                            }
                            else if (!PasswordHelper.Verify(txtSifre.Text, hash))
                                throw new Exception("Hatalı parola");

                            Session["id"]    = uid.ToString();
                            Session["ad"]    = name;
                            Session["mail"]  = email;
                            Session["Yetki"] = role;

                            string box = "<div style='position:fixed;top:0;left:0;width:100%;height:100%;"
                                + "background:rgba(0,0,0,.7);z-index:9999;display:flex;"
                                + "justify-content:center;align-items:center;'>"
                                + "<div style='background:#fff;padding:40px;border-radius:15px;"
                                + "text-align:center;max-width:420px;box-shadow:0 10px 30px rgba(0,0,0,.3);'>"
                                + "<h2 style='color:#3e2723;'>🎉 Hoş Geldiniz!</h2>"
                                + "<p style='font-size:18px;'><b>" + HttpUtility.HtmlEncode(name) + "</b></p>"
                                + "<p style='color:#555;'>" + HttpUtility.HtmlEncode(email) + "</p>"
                                + "<p><span style='background:#e8f5e9;color:#2e7d32;padding:6px 15px;"
                                + "border-radius:20px;font-weight:700;'>Yetkiniz: "
                                + HttpUtility.HtmlEncode(role) + "</span></p>"
                                + "<p style='color:#666;'>Yönlendiriliyorsunuz...</p></div></div>";

                            ClientScript.RegisterStartupScript(GetType(), "welcome",
                                "document.body.innerHTML += `" + box + "`;", true);
                            Response.AppendHeader("Refresh", "3;url=Default.aspx");
                            return;
                        }
                    }
                }
                Alert("E-posta veya şifre hatalı!");
            }
            catch (Exception ex) { Alert("Hata: " + ex.Message); }
        }

        // ======================== KAYIT FORMU GÖSTERİMİ ========================
        protected void btnKayit_Click(object sender, EventArgs e)
            => MultiView1.ActiveViewIndex = 1;

        // ======================== KAYIT: KOD OLUŞTUR & GÖNDER ========================
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            string email = txtKayitEmail.Text.Trim();
            string sifre = txtKayitSifre.Text;
            string ad    = txtAdSoyad.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(sifre))
            { Alert("E-posta ve şifre gerekli."); return; }

            if (sifre != txtKayitSifreTekrar.Text)
            { Alert("Şifreler uyuşmuyor."); return; }

            // E-posta zaten kayıtlı mı?
            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["register"].ConnectionString))
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE email=@e", conn))
                {
                    cmd.Parameters.AddWithValue("@e", email);
                    conn.Open();
                    if ((int)cmd.ExecuteScalar() > 0)
                    { Alert("Bu e-posta adresi zaten kayıtlı."); return; }
                }
            }
            catch (Exception ex) { Alert("Hata: " + ex.Message); return; }

            // 6 haneli doğrulama kodu oluştur
            string kod = new Random().Next(100000, 999999).ToString();

            Session["PendingName"]        = ad;
            Session["PendingEmail"]       = email;
            Session["PendingPassword"]    = sifre;
            Session["VerificationCode"]   = kod;
            Session["VerificationExpiry"] = DateTime.Now.AddMinutes(10);

            try
            {
                GonderDogrulamaMaili(email, ad, kod);
                lblDogrulaEposta.Text      = email;
                lblDogrulamaHata.Text      = "";
                MultiView1.ActiveViewIndex = 2;
            }
            catch (Exception ex) { Alert("E-posta gönderilemedi: " + ex.Message); }
        }

        // ======================== DOĞRULAMA KODU KONTROLÜ ========================
        protected void btnDogrula_Click(object sender, EventArgs e)
        {
            string girilen  = txtDogrulamaKodu.Text.Trim();
            string saklanan = Session["VerificationCode"]?.ToString();
            var    bitis    = Session["VerificationExpiry"] as DateTime?;

            if (string.IsNullOrEmpty(saklanan))
            { HataGoster("⚠️ Oturum sona erdi. Lütfen tekrar kayıt olun."); return; }

            if (bitis.HasValue && DateTime.Now > bitis.Value)
            { HataGoster("⏱ Kodun süresi doldu (10 dk). Lütfen kodu yeniden gönderin."); return; }

            if (girilen != saklanan)
            { HataGoster("❌ Hatalı kod. Lütfen tekrar deneyin."); return; }

            // Kod doğru → kullanıcıyı kaydet
            string name  = Session["PendingName"]?.ToString();
            string email = Session["PendingEmail"]?.ToString();
            string pwd   = Session["PendingPassword"]?.ToString();

            try
            {
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["register"].ConnectionString))
                using (var cmd  = new SqlCommand(
                    "INSERT INTO Users (name,authority,password,email) VALUES (@n,@a,@p,@e)", conn))
                {
                    cmd.Parameters.AddWithValue("@n", name);
                    cmd.Parameters.AddWithValue("@a", "member");
                    cmd.Parameters.AddWithValue("@p", PasswordHelper.HashPassword(pwd));
                    cmd.Parameters.AddWithValue("@e", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Session.Remove("PendingName");       Session.Remove("PendingEmail");
                Session.Remove("PendingPassword");   Session.Remove("VerificationCode");
                Session.Remove("VerificationExpiry");

                Alert("✅ E-posta doğrulandı! Artık giriş yapabilirsiniz.");
                MultiView1.ActiveViewIndex = 0;
            }
            catch (Exception ex) { HataGoster("Kayıt hatası: " + ex.Message); }
        }

        // ======================== KODU YENİDEN GÖNDER ========================
        protected void btnKodTekrar_Click(object sender, EventArgs e)
        {
            string email = Session["PendingEmail"]?.ToString();
            string name  = Session["PendingName"]?.ToString();

            if (string.IsNullOrEmpty(email)) { MultiView1.ActiveViewIndex = 1; return; }

            string yeniKod = new Random().Next(100000, 999999).ToString();
            Session["VerificationCode"]   = yeniKod;
            Session["VerificationExpiry"] = DateTime.Now.AddMinutes(10);

            try
            {
                GonderDogrulamaMaili(email, name, yeniKod);
                lblDogrulamaHata.Text      = "📨 Yeni doğrulama kodu gönderildi.";
                lblDogrulamaHata.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex) { HataGoster("Kod gönderilemedi: " + ex.Message); }
        }

        // ======================== GERİ DÖN ========================
        protected void btnGeriDon_Click(object sender, EventArgs e)
            => MultiView1.ActiveViewIndex = 1;

        // ======================== MAİL GÖNDER (YARDIMCI) ========================
        private void GonderDogrulamaMaili(string to, string name, string kod)
        {
            string host = ConfigurationManager.AppSettings["SmtpHost"];
            int    port = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpPort"]);
            string from = ConfigurationManager.AppSettings["FromEmail"];
            string pass = ConfigurationManager.AppSettings["SmtpPassword"];
            bool   ssl  = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"] ?? "true");

            string htmlBody =
                "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#f5f5f5;font-family:Arial,sans-serif;'>"
              + "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:40px 20px;'>"
              + "<table width='520' style='background:#fff;border-radius:14px;box-shadow:0 4px 18px rgba(0,0,0,.09);overflow:hidden;'>"
              + "<tr><td style='background:linear-gradient(135deg,#3e2723,#5d4037);padding:28px;text-align:center;'>"
              + "<h1 style='margin:0;color:#fff;font-size:22px;'>📦 Stokcum.com</h1></td></tr>"
              + "<tr><td style='padding:36px;'>"
              + "<p style='font-size:15px;color:#333;'>Merhaba <strong>" + HttpUtility.HtmlEncode(name) + "</strong>,</p>"
              + "<p style='font-size:14px;color:#555;line-height:1.7;'>Kayıt işlemini tamamlamak için <strong>6 haneli doğrulama kodunuz:</strong></p>"
              + "<div style='text-align:center;margin:28px 0;'>"
              + "<span style='font-size:42px;font-weight:800;letter-spacing:12px;color:#3e2723;"
              + "background:#fbe9e7;padding:18px 30px;border-radius:12px;border:2px dashed #a1887f;'>"
              + kod + "</span></div>"
              + "<p style='font-size:13px;color:#888;'>⏱ Bu kod <strong>10 dakika</strong> geçerlidir.</p>"
              + "<p style='font-size:12px;color:#bbb;'>Bu isteği siz yapmadıysanız lütfen dikkate almayın.</p>"
              + "</td></tr>"
              + "<tr><td style='background:#fafafa;padding:14px;text-align:center;font-size:11px;color:#bbb;border-top:1px solid #eee;'>"
              + "© 2026 Stokcum.com · Tüm hakları saklıdır.</td></tr>"
              + "</table></td></tr></table></body></html>";

            using (var mail = new MailMessage())
            {
                mail.From       = new MailAddress(from, "Stokcum.com");
                mail.To.Add(to);
                mail.Subject    = "Stokcum.com — E-posta Doğrulama Kodunuz";
                mail.IsBodyHtml = true;
                mail.Body       = htmlBody;

                using (var smtp = new SmtpClient(host, port))
                {
                    smtp.Credentials = new System.Net.NetworkCredential(from, pass);
                    smtp.EnableSsl   = ssl;
                    smtp.Timeout     = 30000;
                    smtp.Send(mail);
                }
            }
        }

        // ======================== YARDIMCI METODlar ========================
        private void Alert(string msg)
            => ClientScript.RegisterStartupScript(GetType(), "alert",
               "alert('" + HttpUtility.JavaScriptStringEncode(msg) + "');", true);

        private void HataGoster(string msg)
        {
            lblDogrulamaHata.Text      = msg;
            lblDogrulamaHata.ForeColor = System.Drawing.Color.Red;
        }

        private bool IsValidPBKDF2(string hash)
        {
            try
            {
                if (string.IsNullOrEmpty(hash) || hash.Length < 40) return false;
                return Convert.FromBase64String(hash).Length == 40;
            }
            catch { return false; }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("log.aspx");
        }
    }
}
