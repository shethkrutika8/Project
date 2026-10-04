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
            if (!Page.IsValid)
                return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // First check if user exists
                string checkUserQuery = "SELECT COUNT(*) FROM Register WHERE email = '" + email + "'";
                SqlCommand checkCmd = new SqlCommand(checkUserQuery, con);
                int userExists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (userExists == 0)
                {
                    con.Close();
                    pnlLoginError.Visible = true;
                    litLoginError.Text = "Email address not found in database. Please register first.";
                    return;
                }

                // Now check password
                string query = "SELECT role, name FROM Register WHERE email = '" + email + "' AND password = '" + password + "'";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string role = reader["role"].ToString().Trim();
                    string name = reader["name"].ToString().Trim();
                    reader.Close();

                    string guestEmail = "guest_" + Session.SessionID.Substring(0, Math.Min(8, Session.SessionID.Length)) + "@agriculture.com";
                    DbHelper.MigrateGuestItems(guestEmail, email);

                    Session["UserEmail"] = email;
                    Session["UserName"] = name;

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
                }
                else
                {
                    reader.Close();
                    con.Close();
                    pnlLoginError.Visible = true;
                    litLoginError.Text = "Invalid Password. Please check your password and try again.";
                }
            }
        }
    }
}