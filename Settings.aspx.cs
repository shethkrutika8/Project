using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class Settings : System.Web.UI.Page
    {
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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();

                    // Load from Register table
                    using (var cmd = new SqlCommand("SELECT name, contact, city FROM Register WHERE email = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (r["name"] != DBNull.Value) txtFullName.Text = r["name"].ToString();
                                if (r["contact"] != DBNull.Value) txtContact.Text = r["contact"].ToString().Trim();
                                if (r["city"] != DBNull.Value) txtCity.Text = r["city"].ToString();
                            }
                        }
                    }

                    // Load from UserSettings table
                    using (var cmd = new SqlCommand("SELECT FullName, ContactNumber, ShippingAddress, City, EmailNotifications, SmsAlerts FROM UserSettings WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (r["FullName"] != DBNull.Value && !string.IsNullOrEmpty(r["FullName"].ToString()))
                                    txtFullName.Text = r["FullName"].ToString();
                                if (r["ContactNumber"] != DBNull.Value && !string.IsNullOrEmpty(r["ContactNumber"].ToString()))
                                    txtContact.Text = r["ContactNumber"].ToString();
                                if (r["City"] != DBNull.Value && !string.IsNullOrEmpty(r["City"].ToString()))
                                    txtCity.Text = r["City"].ToString();
                                if (r["ShippingAddress"] != DBNull.Value)
                                    txtAddress.Text = r["ShippingAddress"].ToString();
                                if (r["EmailNotifications"] != DBNull.Value)
                                    chkEmailAlerts.Checked = Convert.ToBoolean(r["EmailNotifications"]);
                                if (r["SmsAlerts"] != DBNull.Value)
                                    chkSmsAlerts.Checked = Convert.ToBoolean(r["SmsAlerts"]);
                            }
                        }
                    }
                }
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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();

                    // Update Register table if user exists
                    using (var regCmd = new SqlCommand("UPDATE Register SET name = @Name, contact = @Contact, city = @City WHERE email = @Email", con))
                    {
                        regCmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                        regCmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                        regCmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                        regCmd.Parameters.AddWithValue("@Email", email);
                        regCmd.ExecuteNonQuery();
                    }

                    // Upsert UserSettings table
                    int exists = 0;
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = @Email", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                    }

                    if (exists > 0)
                    {
                        string updateSql = "UPDATE UserSettings SET FullName = @Name, ContactNumber = @Contact, ShippingAddress = @Address, City = @City, UpdatedDate = GETDATE() WHERE UserEmail = @Email";
                        using (var cmd = new SqlCommand(updateSql, con))
                        {
                            cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                            cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertSql = "INSERT INTO UserSettings (UserEmail, FullName, ContactNumber, ShippingAddress, City, UpdatedDate) VALUES (@Email, @Name, @Contact, @Address, @City, GETDATE())";
                        using (var cmd = new SqlCommand(insertSql, con))
                        {
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                            cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                ShowAlert("Profile details updated successfully in the database!", true);
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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email AND password = @Password", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        checkCmd.Parameters.AddWithValue("@Password", txtCurrentPassword.Text);
                        int valid = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (valid == 0)
                        {
                            ShowAlert("Current password is incorrect.", false);
                            return;
                        }
                    }

                    using (var updateCmd = new SqlCommand("UPDATE Register SET password = @NewPass WHERE email = @Email", con))
                    {
                        updateCmd.Parameters.AddWithValue("@NewPass", txtNewPassword.Text);
                        updateCmd.Parameters.AddWithValue("@Email", email);
                        updateCmd.ExecuteNonQuery();
                    }
                }

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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    int exists = 0;
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserSettings WHERE UserEmail = @Email", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                    }

                    if (exists > 0)
                    {
                        using (var cmd = new SqlCommand("UPDATE UserSettings SET EmailNotifications = @EmailAlerts, SmsAlerts = @SmsAlerts, UpdatedDate = GETDATE() WHERE UserEmail = @Email", con))
                        {
                            cmd.Parameters.AddWithValue("@EmailAlerts", chkEmailAlerts.Checked);
                            cmd.Parameters.AddWithValue("@SmsAlerts", chkSmsAlerts.Checked);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        using (var cmd = new SqlCommand("INSERT INTO UserSettings (UserEmail, EmailNotifications, SmsAlerts, UpdatedDate) VALUES (@Email, @EmailAlerts, @SmsAlerts, GETDATE())", con))
                        {
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@EmailAlerts", chkEmailAlerts.Checked);
                            cmd.Parameters.AddWithValue("@SmsAlerts", chkSmsAlerts.Checked);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

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
