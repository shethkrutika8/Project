using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AdminManagement : Page
    {
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
                DataTable dt = DbHelper.GetAllUsersDataTable();
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

            bool success = DbHelper.AddAdminUser(name, email, password, contact, city, role);
            if (success)
            {
                ShowAlert("Account for <strong>" + name + "</strong> (" + role + ") was created successfully in the database!", "success");
                txtAdminName.Text = "";
                txtAdminEmail.Text = "";
                txtAdminContact.Text = "";
                txtAdminPassword.Text = "";
                txtAdminConfirm.Text = "";
                LoadUsersGrid();
            }
            else
            {
                ShowAlert("Failed to create account. An account with email <strong>" + email + "</strong> may already exist.", "danger");
            }
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

                    bool updated = DbHelper.UpdateUserRole(userId, newRole);
                    if (updated)
                    {
                        ShowAlert("User #" + userId + " role updated to <strong>" + newRole + "</strong>.", "info");
                        LoadUsersGrid();
                    }
                    else
                    {
                        ShowAlert("Could not update user role.", "danger");
                    }
                }
            }
            else if (e.CommandName == "DeleteUserRow")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                bool deleted = DbHelper.DeleteUser(userId);
                if (deleted)
                {
                    ShowAlert("User #" + userId + " was deleted from the database.", "info");
                    LoadUsersGrid();
                }
                else
                {
                    ShowAlert("Failed to delete user.", "danger");
                }
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
