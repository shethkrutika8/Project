using System;
using System.Web;
using System.Web.UI;
using System.Data.SqlClient;
using Project.Models;

namespace Project
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                if (Request.QueryString["logout"] == "1")
                {
                    Session.Clear();
                    Session.Abandon();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation must pass first — NO JavaScript
            if (!Page.IsValid)
                return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    string query = "SELECT role FROM Register WHERE email = @Email AND password = @Password";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        object roleObj = cmd.ExecuteScalar();
                        if (roleObj != null)
                        {
                            string role = roleObj.ToString().Trim();

                            // Migrate guest cart/wishlist to the authenticated user account
                            string guestEmail = "guest_" + Session.SessionID.Substring(0, Math.Min(8, Session.SessionID.Length)) + "@agriculture.com";
                            DbHelper.MigrateGuestItems(guestEmail, email);

                            Session["UserEmail"] = email;

                            // When Admin logs in, redirect to Admin pages; When User logs in, redirect to User pages
                            if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) || email.ToLower().Contains("admin"))
                            {
                                Session["Role"] = "Admin";
                                Response.Redirect("AdminDashboard.aspx", false);
                            }
                            else
                            {
                                Session["Role"] = "User";
                                Response.Redirect("Dashboard.aspx", false);
                            }
                            Context.ApplicationInstance.CompleteRequest();
                        }
                        else
                        {
                            // ASP.NET Panel-based server-side error — no JavaScript
                            pnlLoginError.Visible = true;
                            litLoginError.Text = "Invalid email address or password. Please check your credentials and try again.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlLoginError.Visible = true;
                litLoginError.Text = "A database error occurred. Please try again later.";
                System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
            }
        }
    }
}