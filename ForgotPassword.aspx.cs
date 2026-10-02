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
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Reset_btn_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = Email_txt.Text.Trim();

            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

            SqlConnection con = new SqlConnection(connectionString);
            string query = "select count(*) from Register where email = '" + email + "'";
            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();

            int count = Convert.ToInt32(cmd.ExecuteScalar());

            if (count > 0)
            {
                con.Close();
                Response.Write("<script>alert('Password reset link has been sent to your email.');window.location='Login.aspx';</script>");
            }
            else
            {
                con.Close();
                Response.Write("<script>alert('Email address not found in our records.');</script>");
            }
        }
    }
}