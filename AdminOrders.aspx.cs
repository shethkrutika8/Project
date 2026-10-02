using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AdminOrders : System.Web.UI.Page
    {
        private string CurrentFilter
        {
            get
            {
                return ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "All";
            }
            set
            {
                ViewState["CurrentFilter"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security check: only authenticated Administrators can access this page
            if (Session["UserEmail"] == null || Session["Role"] == null ||
                !string.Equals(Session["Role"].ToString(), "Admin", StringComparison.OrdinalIgnoreCase))
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
                LoadOrderStats();
                LoadOrders("All");
            }
        }

        private string GetConnectionString()
        {
            return DbHelper.GetConnectionString();
        }

        /// <summary>
        /// Loads summary metrics from SQL Server database using pure ADO.NET
        /// </summary>
        private void LoadOrderStats()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string statsSql = @"SELECT 
                        COUNT(*) AS TotalOrders,
                        ISNULL(SUM(CASE WHEN LOWER(OrderStatus) = 'pending' THEN 1 ELSE 0 END), 0) AS PendingOrders,
                        ISNULL(SUM(CASE WHEN LOWER(OrderStatus) = 'processing' THEN 1 ELSE 0 END), 0) AS ProcessingOrders,
                        ISNULL(SUM(CASE WHEN LOWER(OrderStatus) IN ('delivered', 'deliverd') THEN 1 ELSE 0 END), 0) AS DeliveredOrders
                        FROM Orders";

                    using (SqlCommand cmd = new SqlCommand(statsSql, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litTotalOrders.Text = reader["TotalOrders"].ToString();
                                litPendingOrders.Text = reader["PendingOrders"].ToString();
                                litProcessingOrders.Text = reader["ProcessingOrders"].ToString();
                                litDeliveredOrders.Text = reader["DeliveredOrders"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadOrderStats error: " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieves orders from SQL Server with parameterized filter
        /// </summary>
        private void LoadOrders(string filter)
        {
            CurrentFilter = filter;
            UpdateFilterButtonStyles(filter);

            DataTable dt = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string query = @"SELECT OrderId, OrderNumber, CustomerName, UserEmail, ContactNumber, 
                                            ShippingAddress, City, TotalAmount, PaymentMethod, OrderStatus, OrderDate 
                                     FROM Orders ";

                    if (filter.Equals("Pending", StringComparison.OrdinalIgnoreCase))
                    {
                        query += " WHERE LOWER(OrderStatus) = 'pending' ";
                    }
                    else if (filter.Equals("Processing", StringComparison.OrdinalIgnoreCase))
                    {
                        query += " WHERE LOWER(OrderStatus) = 'processing' ";
                    }
                    else if (filter.Equals("Delivered", StringComparison.OrdinalIgnoreCase))
                    {
                        query += " WHERE LOWER(OrderStatus) IN ('delivered', 'deliverd') ";
                    }
                    else if (filter.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
                    {
                        query += " WHERE LOWER(OrderStatus) = 'cancelled' ";
                    }

                    query += " ORDER BY OrderId DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    rptOrders.DataSource = dt;
                    rptOrders.DataBind();
                    rptOrders.Visible = true;
                    pnlNoOrders.Visible = false;
                }
                else
                {
                    rptOrders.Visible = false;
                    pnlNoOrders.Visible = true;
                }
            }
            catch (Exception ex)
            {
                litAlertMsg.Text = "Error loading orders from database: " + ex.Message;
                pnlAlert.CssClass = "alert alert-danger d-flex align-items-center justify-content-between p-3 rounded-2 shadow-sm mb-3";
                pnlAlert.Visible = true;
            }
        }

        private void UpdateFilterButtonStyles(string activeFilter)
        {
            btnFilterAll.CssClass = "filter-btn" + (activeFilter.Equals("All", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnFilterPending.CssClass = "filter-btn" + (activeFilter.Equals("Pending", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnFilterProcessing.CssClass = "filter-btn" + (activeFilter.Equals("Processing", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnFilterDelivered.CssClass = "filter-btn" + (activeFilter.Equals("Delivered", StringComparison.OrdinalIgnoreCase) ? " active" : "");
            btnFilterCancelled.CssClass = "filter-btn" + (activeFilter.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) ? " active" : "");
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filter = btn.CommandArgument;
            LoadOrders(filter);
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int orderId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SetProcessing")
            {
                UpdateOrderStatus(orderId, "Processing");
            }
            else if (e.CommandName == "SetDelivered")
            {
                UpdateOrderStatus(orderId, "Delivered");
            }
            else if (e.CommandName == "SetCancelled")
            {
                UpdateOrderStatus(orderId, "Cancelled");
            }
            else if (e.CommandName == "ViewItems")
            {
                LoadOrderItems(orderId);
            }
        }

        /// <summary>
        /// Updates the order status in the SQL Server Orders table using parameterized ADO.NET
        /// </summary>
        private void UpdateOrderStatus(int orderId, string newStatus)
        {
            try
            {
                string orderNumber = "";

                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    // 1. Get Order Number for clear user notification
                    using (SqlCommand numCmd = new SqlCommand("SELECT OrderNumber FROM Orders WHERE OrderId = @Id", conn))
                    {
                        numCmd.Parameters.AddWithValue("@Id", orderId);
                        object result = numCmd.ExecuteScalar();
                        if (result != null)
                        {
                            orderNumber = result.ToString();
                        }
                    }

                    // 2. Parameterized UPDATE query to update OrderStatus
                    string updateSql = "UPDATE Orders SET OrderStatus = @Status WHERE OrderId = @Id";
                    using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@Status", newStatus);
                        updateCmd.Parameters.AddWithValue("@Id", orderId);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                // Show feedback alert
                pnlAlert.CssClass = "alert alert-success d-flex align-items-center justify-content-between p-3 rounded-2 shadow-sm mb-3";
                litAlertMsg.Text = "Order <strong>#" + HttpUtility.HtmlEncode(orderNumber) + "</strong> status has been updated to <strong>" + newStatus + "</strong> in the database!";
                pnlAlert.Visible = true;

                // Refresh metrics and current orders view
                LoadOrderStats();
                LoadOrders(CurrentFilter);
            }
            catch (Exception ex)
            {
                pnlAlert.CssClass = "alert alert-danger d-flex align-items-center justify-content-between p-3 rounded-2 shadow-sm mb-3";
                litAlertMsg.Text = "Error updating order status: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        /// <summary>
        /// Loads line items for a specific order from OrderItems table
        /// </summary>
        private void LoadOrderItems(int orderId)
        {
            DataTable dtItems = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    // Get Order Number
                    using (SqlCommand numCmd = new SqlCommand("SELECT OrderNumber FROM Orders WHERE OrderId = @Id", conn))
                    {
                        numCmd.Parameters.AddWithValue("@Id", orderId);
                        object result = numCmd.ExecuteScalar();
                        litSelectedOrderNum.Text = result != null ? "#" + result.ToString() : "#" + orderId;
                    }

                    // Get Items
                    string itemsSql = "SELECT ProductName, Price, Quantity, SubTotal FROM OrderItems WHERE OrderId = @Id";
                    using (SqlCommand itemsCmd = new SqlCommand(itemsSql, conn))
                    {
                        itemsCmd.Parameters.AddWithValue("@Id", orderId);
                        using (SqlDataAdapter da = new SqlDataAdapter(itemsCmd))
                        {
                            da.Fill(dtItems);
                        }
                    }
                }

                gvOrderItems.DataSource = dtItems;
                gvOrderItems.DataBind();
                pnlOrderItemsDetail.Visible = true;
            }
            catch (Exception ex)
            {
                litAlertMsg.Text = "Error loading order items: " + ex.Message;
                pnlAlert.Visible = true;
            }
        }

        protected void btnCloseItems_Click(object sender, EventArgs e)
        {
            pnlOrderItemsDetail.Visible = false;
        }

        protected void btnCloseAlert_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;
        }

        public string GetStatusIcon(string status)
        {
            if (string.IsNullOrEmpty(status)) return "fa-solid fa-clock";
            string lower = status.ToLower();
            if (lower == "pending") return "fa-solid fa-clock";
            if (lower == "processing") return "fa-solid fa-spinner fa-spin";
            if (lower == "delivered" || lower == "deliverd") return "fa-solid fa-circle-check";
            if (lower == "cancelled") return "fa-solid fa-circle-xmark";
            return "fa-solid fa-clock";
        }
    }
}
