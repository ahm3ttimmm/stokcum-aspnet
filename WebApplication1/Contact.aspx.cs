using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        // Page_PreRender, Repeater'ın veri bağlaması tamamlandıktan sonra çalışır.
        // Bu sayede Items.Count doğru değeri verir.
        protected void Page_PreRender(object sender, EventArgs e)
        {
            lblYorumBos.Visible = (rptYorumlar.Items.Count == 0);
        }

        protected void btnGonder_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAd.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtMesaj.Text) ||
                string.IsNullOrEmpty(ddlKonu.SelectedValue))
            {
                lblHata.Text = "Lutfen tum alanlari doldurun.";
                return;
            }

            lblHata.Text = "";

            try
            {
                SqlDataSource1.Insert();

                txtAd.Text    = "";
                txtEmail.Text = "";
                txtMesaj.Text = "";
                ddlKonu.SelectedIndex = 0;

                divBasari.Visible = true;
            }
            catch (Exception ex)
            {
                lblHata.Text = "Bir hata olustu: " + ex.Message;
            }
        }
    }
}
