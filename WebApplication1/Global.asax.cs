using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebApplication1
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
        }
    }

    public class BasePage : System.Web.UI.Page
    {
        protected bool HasActiveSubscription(int userId)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["register"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(1) FROM UserSubscriptions WHERE user_id = @uid AND status = 'active'", conn))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    conn.Open();
                    int cnt = Convert.ToInt32(cmd.ExecuteScalar());
                    return cnt > 0;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
