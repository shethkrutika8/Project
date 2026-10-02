using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class OrderPlaced : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["view"] == "history")
                {
                    ShowHistoryView();
                }
                else
                {
                    ShowCheckoutView();
                }
            }
        }

        protected void tabCheckout_Click(object sender, EventArgs e)
        {
            ShowCheckoutView();
        }

        protected void tabHistory_Click(object sender, EventArgs e)
        {
            ShowHistoryView();
        }

        private void ShowCheckoutView()
        {
            tabCheckout.CssClass = "order-tab-btn active";
            tabHistory.CssClass = "order-tab-btn";
            pnlCheckoutView.Visible = true;
            pnlHistoryView.Visible = false;
            pnlSuccessReceipt.Visible = false;

            LoadCheckoutItems();
            PrefillUserData();
        }

        private void ShowHistoryView()
        {
            tabCheckout.CssClass = "order-tab-btn";
            tabHistory.CssClass = "order-tab-btn active";
            pnlCheckoutView.Visible = false;
            pnlHistoryView.Visible = true;
            pnlSuccessReceipt.Visible = false;

            LoadOrderHistory();
        }

        private void PrefillUserData()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    // First check Register table
                    using (var cmd = new SqlCommand("SELECT name, contact, city FROM Register WHERE email = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (string.IsNullOrEmpty(txtCustomerName.Text) && r["name"] != DBNull.Value)
                                    txtCustomerName.Text = r["name"].ToString();
                                if (string.IsNullOrEmpty(txtPhone.Text) && r["contact"] != DBNull.Value)
                                    txtPhone.Text = r["contact"].ToString().Trim();
                                if (string.IsNullOrEmpty(txtCity.Text) && r["city"] != DBNull.Value)
                                    txtCity.Text = r["city"].ToString();
                            }
                        }
                    }

                    // Check UserSettings table for address
                    using (var cmd = new SqlCommand("SELECT ShippingAddress, City, ContactNumber FROM UserSettings WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                if (r["ShippingAddress"] != DBNull.Value && !string.IsNullOrEmpty(r["ShippingAddress"].ToString()))
                                    txtAddress.Text = r["ShippingAddress"].ToString();
                                if (r["City"] != DBNull.Value && !string.IsNullOrEmpty(r["City"].ToString()))
                                    txtCity.Text = r["City"].ToString();
                                if (r["ContactNumber"] != DBNull.Value && !string.IsNullOrEmpty(r["ContactNumber"].ToString()))
                                    txtPhone.Text = r["ContactNumber"].ToString();
                            }
                        }
                    }
                }
            }
            catch
            {
                // Silently continue if prefill fails
            }
        }

        private void LoadCheckoutItems()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            DataTable dt = new DataTable();

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT ProductName, Price, Quantity, ImageUrl FROM Cart WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }

                if (dt.Rows.Count == 0)
                {
                    // Empty cart notice
                    pnlAlert.Visible = true;
                    litAlertMsg.Text = "Your shopping cart is empty! Please <a href='Products.aspx' class='alert-link'>add products</a> before placing an order.";
                    btnPlaceOrder.Enabled = false;
                }
                else
                {
                    pnlAlert.Visible = false;
                    btnPlaceOrder.Enabled = true;

                    decimal subtotal = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        subtotal += (Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]));
                    }

                    decimal tax = Math.Round(subtotal * 0.05m, 2);
                    decimal shipping = subtotal > 499m ? 0m : 40m;
                    decimal total = subtotal + tax + shipping;

                    litSubTotal.Text = subtotal.ToString("N2");
                    litTax.Text = tax.ToString("N2");
                    litDelivery.Text = shipping == 0m ? "FREE" : "&#8377;" + shipping.ToString("N2");
                    litPayableAmount.Text = total.ToString("N2");

                    rptCheckoutItems.DataSource = dt;
                    rptCheckoutItems.DataBind();
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Error loading checkout items: " + ex.Message;
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            // ASP.NET server-side validation must pass first
            if (!Page.IsValid)
                return;

            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            if (string.IsNullOrWhiteSpace(txtCustomerName.Text) ||
                string.IsNullOrWhiteSpace(txtPhone.Text) ||
                string.IsNullOrWhiteSpace(txtAddress.Text) ||
                string.IsNullOrWhiteSpace(txtCity.Text))
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Please fill in all required shipping address fields.";
                return;
            }

            try
            {
                DataTable cartDt = new DataTable();
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT ProductName, Price, Quantity FROM Cart WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(cartDt);
                        }
                    }

                    if (cartDt.Rows.Count == 0)
                    {
                        pnlAlert.Visible = true;
                        litAlertMsg.Text = "Your cart is empty. Cannot place an empty order.";
                        return;
                    }

                    decimal subtotal = 0;
                    foreach (DataRow row in cartDt.Rows)
                    {
                        subtotal += (Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]));
                    }
                    decimal tax = Math.Round(subtotal * 0.05m, 2);
                    decimal shipping = subtotal > 499m ? 0m : 40m;
                    decimal grandTotal = subtotal + tax + shipping;

                    string orderNumber = "AGRI-" + DateTime.Now.ToString("yyyyMMdd") + "-" + new Random().Next(1000, 9999);
                    string fullAddress = txtAddress.Text.Trim() + (!string.IsNullOrWhiteSpace(txtPinCode.Text) ? " - " + txtPinCode.Text.Trim() : "");
                    string paymentMode = rblPaymentMethod.SelectedValue;
                    if (string.IsNullOrEmpty(paymentMode)) paymentMode = "Cash on Delivery";

                    int newOrderId = 0;

                    // 1. Insert into Orders table
                    string insertOrderSql = @"INSERT INTO Orders 
                        (OrderNumber, UserEmail, CustomerName, ShippingAddress, City, ContactNumber, PaymentMethod, TotalAmount, OrderStatus, OrderDate)
                        OUTPUT INSERTED.OrderId
                        VALUES (@OrderNo, @Email, @Name, @Address, @City, @Phone, @Payment, @Total, 'Placed', GETDATE());";

                    using (var orderCmd = new SqlCommand(insertOrderSql, con))
                    {
                        orderCmd.Parameters.AddWithValue("@OrderNo", orderNumber);
                        orderCmd.Parameters.AddWithValue("@Email", email);
                        orderCmd.Parameters.AddWithValue("@Name", txtCustomerName.Text.Trim());
                        orderCmd.Parameters.AddWithValue("@Address", fullAddress);
                        orderCmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                        orderCmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        orderCmd.Parameters.AddWithValue("@Payment", paymentMode);
                        orderCmd.Parameters.AddWithValue("@Total", grandTotal);

                        newOrderId = Convert.ToInt32(orderCmd.ExecuteScalar());
                    }

                    // 2. Insert into OrderItems table
                    foreach (DataRow r in cartDt.Rows)
                    {
                        string pName = r["ProductName"].ToString();
                        decimal price = Convert.ToDecimal(r["Price"]);
                        int qty = Convert.ToInt32(r["Quantity"]);
                        decimal lineTotal = price * qty;

                        string itemSql = "INSERT INTO OrderItems (OrderId, ProductName, Price, Quantity, SubTotal) VALUES (@OrderId, @PName, @Price, @Qty, @SubTotal)";
                        using (var itemCmd = new SqlCommand(itemSql, con))
                        {
                            itemCmd.Parameters.AddWithValue("@OrderId", newOrderId);
                            itemCmd.Parameters.AddWithValue("@PName", pName);
                            itemCmd.Parameters.AddWithValue("@Price", price);
                            itemCmd.Parameters.AddWithValue("@Qty", qty);
                            itemCmd.Parameters.AddWithValue("@SubTotal", lineTotal);
                            itemCmd.ExecuteNonQuery();
                        }
                    }

                    // 3. Clear Cart in database
                    using (var clearCmd = new SqlCommand("DELETE FROM Cart WHERE UserEmail = @Email", con))
                    {
                        clearCmd.Parameters.AddWithValue("@Email", email);
                        clearCmd.ExecuteNonQuery();
                    }

                    // Display success receipt
                    pnlCheckoutView.Visible = false;
                    pnlHistoryView.Visible = false;
                    pnlSuccessReceipt.Visible = true;
                    pnlAlert.Visible = false;

                    litSuccessOrderNo.Text = orderNumber;
                    litSuccessCustomer.Text = txtCustomerName.Text.Trim();
                    litSuccessAddress.Text = fullAddress + ", " + txtCity.Text.Trim();
                    litSuccessPayment.Text = paymentMode;
                    litSuccessAmount.Text = grandTotal.ToString("N2");

                    (Master as Site1)?.RefreshCartAndWishlistCounts();
                    Response.Write("<script>alert('Order Placed Successfully! Order Number: " + orderNumber + "');</script>");
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Failed to place order: " + ex.Message;
            }
        }

        private void LoadOrderHistory()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            DataTable dt = new DataTable();

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT OrderId, OrderNumber, CustomerName, ShippingAddress, City, ContactNumber, PaymentMethod, TotalAmount, OrderStatus, OrderDate FROM Orders WHERE UserEmail = @Email ORDER BY OrderId DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }

                if (dt.Rows.Count == 0)
                {
                    pnlNoOrders.Visible = true;
                    rptOrderHistory.Visible = false;
                }
                else
                {
                    pnlNoOrders.Visible = false;
                    rptOrderHistory.Visible = true;
                    rptOrderHistory.DataSource = dt;
                    rptOrderHistory.DataBind();
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                litAlertMsg.Text = "Error loading order history: " + ex.Message;
            }
        }

        protected void rptOrderHistory_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                if (drv != null)
                {
                    int orderId = Convert.ToInt32(drv["OrderId"]);
                    Repeater rptItems = e.Item.FindControl("rptOrderItems") as Repeater;
                    if (rptItems != null)
                    {
                        DataTable dtItems = new DataTable();
                        using (var con = DbHelper.GetConnection())
                        {
                            con.Open();
                            using (var cmd = new SqlCommand("SELECT ProductName, Price, Quantity, SubTotal FROM OrderItems WHERE OrderId = @OrderId", con))
                            {
                                cmd.Parameters.AddWithValue("@OrderId", orderId);
                                using (var da = new SqlDataAdapter(cmd))
                                {
                                    da.Fill(dtItems);
                                }
                            }
                        }
                        rptItems.DataSource = dtItems;
                        rptItems.DataBind();
                    }
                }
            }
        }
    }
}
