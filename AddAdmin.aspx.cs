using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AddAdmin : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
            }
        }

        protected void btnCreateAdmin_Click(object sender, EventArgs e)
        {
            // Server-side ASP.NET validation
            if (!Page.IsValid)
                return;

            string name = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string role = ddlRole.SelectedValue;
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text;

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Check if email already exists
                    string chkSql = "SELECT COUNT(*) FROM Register WHERE email = @Email";
                    using (SqlCommand chkCmd = new SqlCommand(chkSql, con))
                    {
                        chkCmd.Parameters.AddWithValue("@Email", email);
                        int count = Convert.ToInt32(chkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowAlert("An account with email '" + email + "' already exists!", false);
                            return;
                        }
                    }

                    // Insert into Register table
                    string insertSql = "INSERT INTO Register (name, email, password, gender, contact, city, role) VALUES (@Name, @Email, @Password, 'Other', @Phone, 'Admin Office', 'Admin')";
                    using (SqlCommand cmd = new SqlCommand(insertSql, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Phone", phone);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Admin account for '" + name + "' created successfully in the database!", true);

                // Clear input fields
                txtFullName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
                ddlRole.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to create admin: " + ex.Message, false);
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show mb-4" : "alert alert-danger alert-dismissible fade show mb-4";
            litAlertMsg.Text = msg;
        }
    }
}
