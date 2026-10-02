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
                SqlCommand cmd = new SqlCommand("SELECT name, contact, city FROM Register WHERE email = '" + email + "'", con);
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    if (r["name"] != DBNull.Value) txtFullName.Text = r["name"].ToString();
                    if (r["contact"] != DBNull.Value) txtContact.Text = r["contact"].ToString().Trim();
                    if (r["city"] != DBNull.Value) txtCity.Text = r["city"].ToString();
                }
                r.Close();

                // Load from UserSettings table
                SqlCommand cmdSettings = new SqlCommand("SELECT FullName, ContactNumber, ShippingAddress, City, EmailNotifications, SmsAlerts FROM UserSettings WHERE UserEmail = '" + email + "'", con);
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
                    if (rSettings["SmsAlerts"] != DBNull.Value)
                        chkSmsAlerts.Checked = Convert.ToBoolean(rSettings["SmsAlerts"]);
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
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                // Update Register table
                SqlCommand regCmd = new SqlCommand("UPDATE Register SET name = '" + txtFullName.Text.Trim() + "', contact = '" + txtContact.Text.Trim() + "', city = '" + txtCity.Text.Trim() + "' WHERE email = '" + email + "'", con);
                regCmd.ExecuteNonQuery();

                // Upsert UserSettings table
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = '" + email + "'", con);
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (exists > 0)
                {
                    string updateSql = "UPDATE UserSettings SET FullName = '" + txtFullName.Text.Trim() + "', ContactNumber = '" + txtContact.Text.Trim() + "', ShippingAddress = '" + txtAddress.Text.Trim() + "', City = '" + txtCity.Text.Trim() + "', UpdatedDate = GETDATE() WHERE UserEmail = '" + email + "'";
                    SqlCommand cmd = new SqlCommand(updateSql, con);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    string insertSql = "INSERT INTO UserSettings (UserEmail, FullName, ContactNumber, ShippingAddress, City, UpdatedDate) VALUES ('" + email + "', '" + txtFullName.Text.Trim() + "', '" + txtContact.Text.Trim() + "', '" + txtAddress.Text.Trim() + "', '" + txtCity.Text.Trim() + "', GETDATE())";
                    SqlCommand cmd = new SqlCommand(insertSql, con);
                    cmd.ExecuteNonQuery();
                }

                con.Close();

                ShowAlert("Profile details updated successfully in the database!", true);
                Response.Write("<script>alert('Profile details updated successfully!');</script>");
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to save profile: " + ex.Message, false);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation must pass first
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

                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = '" + email + "' AND password = '" + txtCurrentPassword.Text + "'", con);
                int valid = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (valid == 0)
                {
                    con.Close();
                    ShowAlert("Current password is incorrect.", false);
                    Response.Write("<script>alert('Current password is incorrect.');</script>");
                    return;
                }

                SqlCommand updateCmd = new SqlCommand("UPDATE Register SET password = '" + txtNewPassword.Text + "' WHERE email = '" + email + "'", con);
                updateCmd.ExecuteNonQuery();
                con.Close();

                ShowAlert("Password changed successfully!", true);
                Response.Write("<script>alert('Password changed successfully!');</script>");

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

                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = '" + email + "'", con);
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                int emailAlerts = chkEmailAlerts.Checked ? 1 : 0;
                int smsAlerts = chkSmsAlerts.Checked ? 1 : 0;

                if (exists > 0)
                {
                    SqlCommand cmd = new SqlCommand("UPDATE UserSettings SET EmailNotifications = " + emailAlerts + ", SmsAlerts = " + smsAlerts + ", UpdatedDate = GETDATE() WHERE UserEmail = '" + email + "'", con);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO UserSettings (UserEmail, EmailNotifications, SmsAlerts, UpdatedDate) VALUES ('" + email + "', " + emailAlerts + ", " + smsAlerts + ", GETDATE())", con);
                    cmd.ExecuteNonQuery();
                }

                con.Close();

                ShowAlert("Preferences saved successfully in database!", true);
                Response.Write("<script>alert('Preferences saved successfully!');</script>");
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
