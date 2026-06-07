using System;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["mail"] != null)
            {
                phGirisYapilmadi.Visible = false;
                phGirisYapildi.Visible   = true;
                lblKullaniciAd.Text      = Session["ad"]?.ToString() ?? "Kullanici";
                Button1.Visible          = Session["Yetki"] != null &&
                                           Session["Yetki"].ToString().ToLower() == "admin";
            }
            else
            {
                phGirisYapilmadi.Visible = true;
                phGirisYapildi.Visible   = false;
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/log.aspx");
        }
    }
}
