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

            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            SqlConnection con = new SqlConnection(connectionString);

            // Check if user already exists
            string checkQuery = "select count(*) from Register where email = '" + email + "'";
            SqlCommand checkCmd = new SqlCommand(checkQuery, con);
            con.Open();
            int count = Convert.ToInt32(checkCmd.ExecuteScalar());
            if (count > 0)
            {
                con.Close();
                Response.Write("<script>alert('An account with this email already exists!');</script>");
                return;
            }

            string query = "insert into Register (name, email, password, gender, contact, city, role) values('" + fullName + "','" + email + "','" + password + "','" + gender + "','" + contact + "','" + city + "','User')";
            SqlCommand cmd = new SqlCommand(query, con);

            cmd.ExecuteNonQuery();
            Response.Write("<script>alert('Registered Successfully');window.location='Login.aspx';</script>");

            con.Close();
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