using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using Project.Models;

namespace Project
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Reset_btn_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = Email_txt.Text.Trim();

            string connectionString = DbHelper.GetConnectionString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Register WHERE email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);
                con.Open();

                int count = Convert.ToInt32(cmd.ExecuteScalar());
                con.Close();

                if (count > 0)
                {
                    pnlForgotAlert.Visible = true;
                    pnlForgotAlert.CssClass = "alert alert-success py-2 my-2";
                    litForgotAlert.Text = "Password reset link has been sent to your email address.";
                }
                else
                {
                    pnlForgotAlert.Visible = true;
                    pnlForgotAlert.CssClass = "alert alert-danger py-2 my-2";
                    litForgotAlert.Text = "Email address not found in our records.";
                }
            }
        }
    }
}