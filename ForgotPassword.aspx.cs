using System;
using System.Web;
using System.Web.UI;
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
            // ASP.NET server-side validation must pass first — NO JavaScript
            if (!Page.IsValid)
                return;

            string email = Email_txt.Text.Trim();
            pnlForgotAlert.Visible = false;

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    string query = "SELECT COUNT(*) FROM Register WHERE email = @Email";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        if (count > 0)
                        {
                            pnlForgotAlert.Visible = true;
                            pnlForgotAlert.CssClass = "alert alert-success py-2 my-2";
                            litForgotAlert.Text = "<strong>Success!</strong> Password reset link has been sent to your registered email address.";
                        }
                        else
                        {
                            pnlForgotAlert.Visible = true;
                            pnlForgotAlert.CssClass = "alert alert-danger py-2 my-2";
                            litForgotAlert.Text = "<strong>Error:</strong> Email address not found in our records.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlForgotAlert.Visible = true;
                pnlForgotAlert.CssClass = "alert alert-danger py-2 my-2";
                litForgotAlert.Text = "A database error occurred. Please try again later.";
                System.Diagnostics.Debug.WriteLine("ForgotPassword error: " + ex.Message);
            }
        }
    }
}