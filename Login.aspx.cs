using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace Project
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            SqlConnection con = new SqlConnection(connectionString);
            string query = "select count(*) from Register where email='" + txtEmail.Text.Trim() + "' and password='" + txtPassword.Text + "'";
            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();

            int count = Convert.ToInt32(cmd.ExecuteScalar());
            if (count > 0)
            {
                Session["UserEmail"] = txtEmail.Text.Trim();
                Response.Write("<Script> alert('Login Successful'); window.location='Dashboard.aspx';</script>");
            }
            else
            {
                Response.Write("<Script> alert('Invalid Email or Password');</script>");
            }

            con.Close();
        }
    }
}