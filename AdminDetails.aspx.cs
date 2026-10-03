using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class AdminDetails : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                LoadAdminDetails();
            }
        }

        private void LoadAdminDetails()
        {
            string email = Request.QueryString["email"];
            if (string.IsNullOrEmpty(email))
            {
                email = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "admin@agriculture.com";
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string sql = "SELECT TOP 1 name, email, contact, city, role FROM Register WHERE (LOWER(role) = 'admin' OR LOWER(email) = LOWER(@Email)) ORDER BY CASE WHEN LOWER(email) = LOWER(@Email) THEN 0 ELSE 1 END";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string name = r["name"] != DBNull.Value ? r["name"].ToString() : "Administrator";
                                string userEmail = r["email"] != DBNull.Value ? r["email"].ToString() : email;
                                string contact = r["contact"] != DBNull.Value ? r["contact"].ToString().Trim() : "Not Provided";
                                string city = r["city"] != DBNull.Value ? r["city"].ToString() : "Not Provided";
                                string role = r["role"] != DBNull.Value ? r["role"].ToString() : "Admin";

                                litAdminNameHeader.Text = name;
                                litAdminSubtitle.Text = role + " • " + userEmail;
                                litFullName.Text = name;
                                litEmail.Text = userEmail;
                                litContact.Text = contact;
                                litCity.Text = city;
                                litRole.Text = role;

                                if (!string.IsNullOrEmpty(name))
                                {
                                    string[] parts = name.Split(' ');
                                    if (parts.Length >= 2)
                                        litAvatarInitials.Text = (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
                                    else if (parts.Length == 1 && parts[0].Length >= 2)
                                        litAvatarInitials.Text = parts[0].Substring(0, 2).ToUpper();
                                    else
                                        litAvatarInitials.Text = "AD";
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "alert alert-danger mb-4";
                litAlertMsg.Text = "Error loading administrator details: " + ex.Message;
            }
        }

        protected void tabOverview_Click(object sender, EventArgs e)
        {
            SetTab(true, false, false, false);
            tabOverviewBtn.CssClass = "tab active";
            tabPermissionsBtn.CssClass = "tab";
            tabActivityBtn.CssClass = "tab";
            tabSecurityBtn.CssClass = "tab";
        }

        protected void tabPermissions_Click(object sender, EventArgs e)
        {
            SetTab(false, true, false, false);
            tabOverviewBtn.CssClass = "tab";
            tabPermissionsBtn.CssClass = "tab active";
            tabActivityBtn.CssClass = "tab";
            tabSecurityBtn.CssClass = "tab";
        }

        protected void tabActivity_Click(object sender, EventArgs e)
        {
            SetTab(false, false, true, false);
            tabOverviewBtn.CssClass = "tab";
            tabPermissionsBtn.CssClass = "tab";
            tabActivityBtn.CssClass = "tab active";
            tabSecurityBtn.CssClass = "tab";
        }

        protected void tabSecurity_Click(object sender, EventArgs e)
        {
            SetTab(false, false, false, true);
            tabOverviewBtn.CssClass = "tab";
            tabPermissionsBtn.CssClass = "tab";
            tabActivityBtn.CssClass = "tab";
            tabSecurityBtn.CssClass = "tab active";
        }

        private void SetTab(bool overview, bool permissions, bool activity, bool security)
        {
            pnlOverview.Visible = overview;
            pnlPermissions.Visible = permissions;
            pnlActivity.Visible = activity;
            pnlSecurity.Visible = security;
        }

        protected void btnResetPass_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-success alert-dismissible fade show mb-4";
            litAlertMsg.Text = "Password reset instructions generated for administrator: " + litEmail.Text;
        }
    }
}
