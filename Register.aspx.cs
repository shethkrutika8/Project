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
    public partial class Register : System.Web.UI.Page
    {
        string gender;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
            }
        }

        protected void Register_btn_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (Female_Btn.Checked)
            {
                gender = "Female";
            }
            else
            {
                gender = "Male";
            }

            string fullName = (FirstName_txt.Text.Trim() + " " + LastName_txt.Text.Trim()).Trim();
            string email    = Email_txt.Text.Trim();
            string password = Password_txt.Text;
            string contact  = Mobile_txt.Text.Trim();
            string city     = CityDRPD.SelectedItem != null ? CityDRPD.SelectedItem.ToString() : "";

            string connectionString = DbHelper.GetConnectionString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Check if user already exists
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Register WHERE email = @Email", con);
                checkCmd.Parameters.AddWithValue("@Email", email);
                int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                if (count > 0)
                {
                    pnlRegisterError.Visible = true;
                    litRegisterError.Text = "An account with this email already exists!";
                    return;
                }

                string query = "INSERT INTO Register (name, email, password, gender, contact, city, role) VALUES (@Name, @Email, @Password, @Gender, @Contact, @City, 'User')";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);
                cmd.Parameters.AddWithValue("@Gender", gender);
                cmd.Parameters.AddWithValue("@Contact", contact);
                cmd.Parameters.AddWithValue("@City", city);
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Login.aspx", false);
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