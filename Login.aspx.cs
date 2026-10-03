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
            string password = txtPassword.Text;

            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            SqlConnection con = new SqlConnection(connectionString);
            string query = "select role from Register where email = '" + email + "' and password = '" + password + "'";
            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();

            object roleObj = cmd.ExecuteScalar();

            if (roleObj != null)
            {
                string role = roleObj.ToString().Trim();

                string guestEmail = "guest_" + Session.SessionID.Substring(0, Math.Min(8, Session.SessionID.Length)) + "@agriculture.com";
                DbHelper.MigrateGuestItems(guestEmail, email);

                Session["UserEmail"] = email;
                con.Close();

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
                con.Close();
                pnlLoginError.Visible = true;
                litLoginError.Text = "Invalid Email or Password. Please try again.";
            }
        }
    }
}