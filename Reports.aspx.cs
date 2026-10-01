using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class Reports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Protect admin page
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
                LoadReports();
            }
        }

        private void LoadReports()
        {
            try
            {
                var analytics = DbHelper.GetReportsAnalytics();
                litRevenue.Text         = Convert.ToDecimal(analytics["TotalRevenue"]).ToString("N2");
                litTotalOrders.Text     = analytics["TotalOrders"].ToString();
                litPlacedOrders.Text    = analytics["PlacedOrders"].ToString();
                litDeliveredOrders.Text = analytics["DeliveredOrders"].ToString();

                // Load orders table
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT OrderNumber, CustomerName, UserEmail, City, TotalAmount, PaymentMethod, OrderStatus, OrderDate FROM Orders ORDER BY OrderId DESC", con))
                    {
                        DataTable dtOrders = new DataTable();
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dtOrders);
                        }
                        gvOrdersReport.DataSource = dtOrders;
                        gvOrdersReport.DataBind();
                    }

                    // Load products inventory
                    using (var cmdProd = new SqlCommand("SELECT ProductId, Name, Category, Price, StockQuantity, CreatedDate FROM Products WHERE IsActive = 1 ORDER BY StockQuantity ASC", con))
                    {
                        DataTable dtProd = new DataTable();
                        using (var da = new SqlDataAdapter(cmdProd))
                        {
                            da.Fill(dtProd);
                        }
                        gvInventoryReport.DataSource = dtProd;
                        gvInventoryReport.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Reports error: " + ex.Message);
            }
        }
    }
}
