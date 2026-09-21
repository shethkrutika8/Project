using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

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
            if (Female_Btn.Checked)
            {
                gender = "Female";
            }
            else if (Male_Btn.Checked)
            {
                gender = "Male";
            }

            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            SqlConnection con = new SqlConnection(connectionString);
            string fullName = (FirstName_txt.Text.Trim() + " " + LastName_txt.Text.Trim()).Trim();
            string query = "insert into Register Values('" + fullName + "','" + Email_txt.Text + "','" + Password_txt.Text + "','" + gender + "','" + Mobile_txt.Text + "','" + CityDRPD.SelectedItem.ToString() + "')";
            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();

            cmd.ExecuteNonQuery();
            Response.Write("<Script> alert('Registered Successfully'); window.location='Login.aspx';</script>");

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