using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using Project.Models;

namespace Project
{
    public partial class Register : System.Web.UI.Page
    {
        string gender = "Male";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Register_btn_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation must pass first — NO JavaScript
            if (!Page.IsValid)
                return;

            if (Female_Btn.Checked)
                gender = "Female";
            else
                gender = "Male";

            string fullName = (FirstName_txt.Text.Trim() + " " + LastName_txt.Text.Trim()).Trim();
            string email    = Email_txt.Text.Trim();
            string password = Password_txt.Text;
            string mobile   = Mobile_txt.Text.Trim();
            string city     = CityDRPD.SelectedItem != null ? CityDRPD.SelectedItem.ToString() : "";

            // Hide any previous messages
            pnlRegisterError.Visible = false;
            pnlRegisterSuccess.Visible = false;

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();

                    // Server-side uniqueness check (database) — no JavaScript
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email", con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (exists > 0)
                        {
                            pnlRegisterError.Visible = true;
                            litRegisterError.Text = "An account with this email address already exists. Please use a different email or sign in.";
                            return;
                        }
                    }

                    string query = "INSERT INTO Register (name, email, password, gender, contact, city) VALUES (@Name, @Email, @Password, @Gender, @Contact, @City)";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Name",     fullName);
                        cmd.Parameters.AddWithValue("@Email",    email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Gender",   gender);
                        cmd.Parameters.AddWithValue("@Contact",  mobile);
                        cmd.Parameters.AddWithValue("@City",     city);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Show success message then redirect to Login
                pnlRegisterSuccess.Visible = true;
                litRegisterSuccess.Text = "Account created successfully! Redirecting to login...";

                // Redirect to login after successful registration
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                pnlRegisterError.Visible = true;
                litRegisterError.Text = "Registration failed. Please try again later.";
                System.Diagnostics.Debug.WriteLine("Register error: " + ex.Message);
            }
        }

        protected void Female_Btn_CheckedChanged(object sender, EventArgs e)
        {
            gender = "Female";
        }

        protected void Male_Btn_CheckedChanged(object sender, EventArgs e)
        {
            gender = "Male";
        }
    }
}