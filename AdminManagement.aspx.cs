using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AdminManagement : Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Protect admin page: only Admin role allowed
            if (Session["UserEmail"] == null || Session["Role"] == null || !string.Equals(Session["Role"].ToString(), "Admin", StringComparison.OrdinalIgnoreCase))
            {
                if (Session["UserEmail"] != null)
                    Response.Redirect("Dashboard.aspx", false);
                else
                    Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                LoadUsersGrid();
            }
        }

        private void LoadUsersGrid()
        {
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                string query = "select Id, name, email, gender, contact, city, role from Register order by Id desc";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                con.Close();

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
                litUserCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading users: " + ex.Message, "danger");
            }
        }

        protected void btnCreateAdmin_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;

            // Pure ASP.NET Server-Side Validation
            if (!Page.IsValid)
                return;

            string name     = txtAdminName.Text.Trim();
            string email    = txtAdminEmail.Text.Trim();
            string contact  = txtAdminContact.Text.Trim();
            string city     = ddlAdminCity.SelectedValue;
            string role     = ddlAdminRole.SelectedValue;
            string password = txtAdminPassword.Text;

            SqlConnection con = new SqlConnection(connectionString);
            string chkQuery = "select count(*) from Register where email = '" + email + "'";
            SqlCommand chkCmd = new SqlCommand(chkQuery, con);
            con.Open();

            int count = Convert.ToInt32(chkCmd.ExecuteScalar());
            if (count > 0)
            {
                con.Close();
                ShowAlert("Account with this email already exists!", "danger");
                return;
            }

            string query = "insert into Register (name, email, password, gender, contact, city, role) values ('" + name + "','" + email + "','" + password + "','Other','" + contact + "','" + city + "','" + role + "')";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.ExecuteNonQuery();
            con.Close();
            ShowAlert("User Account Created Successfully", "success");

            txtAdminName.Text = "";
            txtAdminEmail.Text = "";
            txtAdminContact.Text = "";
            txtAdminPassword.Text = "";
            txtAdminConfirm.Text = "";
            LoadUsersGrid();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleRole")
            {
                string[] parts = e.CommandArgument.ToString().Split(';');
                if (parts.Length == 2 && int.TryParse(parts[0], out int userId))
                {
                    string currentRole = parts[1];
                    string newRole = currentRole.ToLower() == "admin" ? "User" : "Admin";

                    SqlConnection con = new SqlConnection(connectionString);
                    string query = "update Register set role = '" + newRole + "' where Id = " + userId;
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                    ShowAlert("User role updated to " + newRole, "success");
                    LoadUsersGrid();
                }
            }
            else if (e.CommandName == "DeleteUserRow")
            {
                int userId = Convert.ToInt32(e.CommandArgument);

                SqlConnection con = new SqlConnection(connectionString);
                string query = "delete from Register where Id = " + userId;
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                ShowAlert("User Deleted Successfully", "success");
                LoadUsersGrid();
            }
        }

        private void ShowAlert(string msg, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show mb-4";
            litAlertMsg.Text = msg;
        }
    }
}
