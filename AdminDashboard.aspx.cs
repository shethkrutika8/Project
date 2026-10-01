using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Restrict admin page to authenticated Admins only
            if (Session["UserEmail"] == null || Session["Role"] == null || !string.Equals(Session["Role"].ToString(), "Admin", StringComparison.OrdinalIgnoreCase))
            {
                if (Session["UserEmail"] != null)
                    Response.Redirect("Dashboard.aspx", false);
                else
                    Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                LoadDashboardStats();
                LoadRecentOrders();
                LoadRecentUsers();
            }
        }

        private void LoadDashboardStats()
        {
            try
            {
                var stats = DbHelper.GetDashboardStats();
                litTotalUsers.Text    = stats["TotalUsers"].ToString();
                litTotalProducts.Text = stats["TotalProducts"].ToString();
                litTotalOrders.Text   = stats["TotalOrders"].ToString();
                litTotalDiseases.Text = stats["TotalDiseaseRecords"].ToString();
            }
            catch (Exception ex)
            {
                pnlAlert.Visible  = true;
                litAlertMsg.Text  = "Error loading stats from database: " + ex.Message;
            }
        }

        private void LoadRecentOrders()
        {
            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    string sql = "SELECT TOP 10 OrderNumber, UserEmail, CustomerName, TotalAmount, PaymentMethod, OrderStatus, OrderDate FROM Orders ORDER BY OrderId DESC";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        DataTable dt = new DataTable();
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                        gvRecentOrders.DataSource = dt;
                        gvRecentOrders.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadRecentOrders error: " + ex.Message);
            }
        }

        private void LoadRecentUsers()
        {
            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    string sql = "SELECT TOP 10 Id, name, email, gender, contact, city FROM Register ORDER BY Id DESC";
                    using (var cmd = new SqlCommand(sql, con))
                    {
                        DataTable dt = new DataTable();
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                        gvRecentUsers.DataSource = dt;
                        gvRecentUsers.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadRecentUsers error: " + ex.Message);
            }
        }
    }
}
