using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class Settings : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserSettings();
            }
        }

        private void LoadUserSettings()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            txtEmail.Text = email;

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                // Load from Register table
                SqlCommand cmd = new SqlCommand("SELECT name, contact, city FROM Register WHERE email = @Email", con);
                cmd.Parameters.AddWithValue("@Email", email);
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    if (r["name"] != DBNull.Value) txtFullName.Text = r["name"].ToString();
                    if (r["contact"] != DBNull.Value) txtContact.Text = r["contact"].ToString().Trim();
                    if (r["city"] != DBNull.Value) txtCity.Text = r["city"].ToString();
                }
                r.Close();

                // Load from UserSettings table
                SqlCommand cmdSettings = new SqlCommand("SELECT FullName, ContactNumber, ShippingAddress, City, EmailNotifications FROM UserSettings WHERE UserEmail = @Email", con);
                cmdSettings.Parameters.AddWithValue("@Email", email);
                SqlDataReader rSettings = cmdSettings.ExecuteReader();
                if (rSettings.Read())
                {
                    if (rSettings["FullName"] != DBNull.Value && !string.IsNullOrEmpty(rSettings["FullName"].ToString()))
                        txtFullName.Text = rSettings["FullName"].ToString();
                    if (rSettings["ContactNumber"] != DBNull.Value && !string.IsNullOrEmpty(rSettings["ContactNumber"].ToString()))
                        txtContact.Text = rSettings["ContactNumber"].ToString();
                    if (rSettings["City"] != DBNull.Value && !string.IsNullOrEmpty(rSettings["City"].ToString()))
                        txtCity.Text = rSettings["City"].ToString();
                    if (rSettings["ShippingAddress"] != DBNull.Value)
                        txtAddress.Text = rSettings["ShippingAddress"].ToString();
                    if (rSettings["EmailNotifications"] != DBNull.Value)
                        chkEmailAlerts.Checked = Convert.ToBoolean(rSettings["EmailNotifications"]);
                }
                rSettings.Close();
                con.Close();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading settings: " + ex.Message, false);
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation — validate only the profile group
            Page.Validate("vgProfile");
            if (!Page.IsValid)
                return;

            string oldEmail = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            string newEmail = txtEmail.Text.Trim();

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                // Check if new email already exists in Register table (if email is being changed)
                if (oldEmail.ToLower() != newEmail.ToLower())
                {
                    SqlCommand checkEmailCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email", con);
                    checkEmailCmd.Parameters.AddWithValue("@Email", newEmail);
                    int emailExists = Convert.ToInt32(checkEmailCmd.ExecuteScalar());
                    
                    if (emailExists > 0)
                    {
                        con.Close();
                        ShowAlert("This email address is already registered to another account.", false);
                        return;
                    }
                }

                // Update Register table with new email and other details
                SqlCommand regCmd = new SqlCommand("UPDATE Register SET email = @NewEmail, name = @Name, contact = @Contact, city = @City WHERE email = @OldEmail", con);
                regCmd.Parameters.AddWithValue("@NewEmail", newEmail);
                regCmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                regCmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                regCmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                regCmd.Parameters.AddWithValue("@OldEmail", oldEmail);
                regCmd.ExecuteNonQuery();

                // Update UserSettings table - handle email change
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = @OldEmail", con);
                checkCmd.Parameters.AddWithValue("@OldEmail", oldEmail);
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (exists > 0)
                {
                    // Update existing record with new email
                    string updateSql = "UPDATE UserSettings SET UserEmail = @NewEmail, FullName = @Name, ContactNumber = @Contact, ShippingAddress = @Address, City = @City, UpdatedDate = GETDATE() WHERE UserEmail = @OldEmail";
                    SqlCommand cmd = new SqlCommand(updateSql, con);
                    cmd.Parameters.AddWithValue("@NewEmail", newEmail);
                    cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                    cmd.Parameters.AddWithValue("@OldEmail", oldEmail);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    // Insert new record with new email
                    string insertSql = "INSERT INTO UserSettings (UserEmail, FullName, ContactNumber, ShippingAddress, City, UpdatedDate) VALUES (@NewEmail, @Name, @Contact, @Address, @City, GETDATE())";
                    SqlCommand cmd = new SqlCommand(insertSql, con);
                    cmd.Parameters.AddWithValue("@NewEmail", newEmail);
                    cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                    cmd.ExecuteNonQuery();
                }

                con.Close();

                // Update session/cookie with new email
                if (oldEmail.ToLower() != newEmail.ToLower())
                {
                    Session["UserEmail"] = newEmail;
                    if (Request.Cookies["UserEmail"] != null)
                    {
                        HttpCookie cookie = new HttpCookie("UserEmail");
                        cookie.Value = newEmail;
                        cookie.Expires = DateTime.Now.AddDays(30);
                        Response.Cookies.Add(cookie);
                    }
                }

                ShowAlert("Profile details updated successfully in the database!" + (oldEmail.ToLower() != newEmail.ToLower() ? " Your email address has been changed." : ""), true);
                
                // Reload settings to reflect changes
                LoadUserSettings();
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to save profile: " + ex.Message, false);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation — validate only the password group
            Page.Validate("vgPassword");
            if (!Page.IsValid)
                return;

            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            if (string.IsNullOrEmpty(txtCurrentPassword.Text) || string.IsNullOrEmpty(txtNewPassword.Text))
            {
                ShowAlert("Please fill in current and new password.", false);
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                ShowAlert("New password and confirmation password do not match.", false);
                return;
            }

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email AND password = @Password", con);
                checkCmd.Parameters.AddWithValue("@Email", email);
                checkCmd.Parameters.AddWithValue("@Password", txtCurrentPassword.Text);
                int valid = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (valid == 0)
                {
                    con.Close();
                    ShowAlert("Current password is incorrect.", false);
                    return;
                }

                SqlCommand updateCmd = new SqlCommand("UPDATE Register SET password = @Password WHERE email = @Email", con);
                updateCmd.Parameters.AddWithValue("@Password", txtNewPassword.Text);
                updateCmd.Parameters.AddWithValue("@Email", email);
                updateCmd.ExecuteNonQuery();
                con.Close();

                ShowAlert("Password changed successfully!", true);

                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to update password: " + ex.Message, false);
            }
        }

        protected void btnSavePreferences_Click(object sender, EventArgs e)
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = @Email", con);
                checkCmd.Parameters.AddWithValue("@Email", email);
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                int emailAlerts = chkEmailAlerts.Checked ? 1 : 0;

                if (exists > 0)
                {
                    SqlCommand cmd = new SqlCommand("UPDATE UserSettings SET EmailNotifications = @Alerts, UpdatedDate = GETDATE() WHERE UserEmail = @Email", con);
                    cmd.Parameters.AddWithValue("@Alerts", emailAlerts);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO UserSettings (UserEmail, EmailNotifications, UpdatedDate) VALUES (@Email, @Alerts, GETDATE())", con);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Alerts", emailAlerts);
                    cmd.ExecuteNonQuery();
                }

                con.Close();

                ShowAlert("Preferences saved successfully in database!", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to save preferences: " + ex.Message, false);
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
            litAlertMsg.Text = msg;
        }
    }
}
