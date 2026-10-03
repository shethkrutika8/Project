using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class Cart : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCartItems();
            }
        }

        private void LoadCartItems()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            DataTable dt = new DataTable();

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT CartId, UserEmail, ProductName, Price, Quantity, ImageUrl, CreatedDate FROM Cart WHERE UserEmail = '" + email + "' ORDER BY CartId DESC", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                con.Close();

                if (dt.Rows.Count == 0)
                {
                    pnlEmptyCart.Visible = true;
                    pnlCartContent.Visible = false;
                    litItemCountHeader.Text = "0";
                }
                else
                {
                    pnlEmptyCart.Visible = false;
                    pnlCartContent.Visible = true;

                    int totalQty = 0;
                    decimal subtotal = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        int q = Convert.ToInt32(row["Quantity"]);
                        decimal p = Convert.ToDecimal(row["Price"]);
                        totalQty += q;
                        subtotal += (q * p);
                    }

                    decimal tax = Math.Round(subtotal * 0.05m, 2);
                    decimal shipping = subtotal > 499m ? 0m : 40m;
                    decimal grandTotal = subtotal + tax + shipping;

                    litItemCountHeader.Text = totalQty.ToString();
                    litSummaryItemCount.Text = totalQty.ToString();
                    litSubTotal.Text = subtotal.ToString("N2");
                    litTax.Text = tax.ToString("N2");
                    litShipping.Text = shipping == 0m ? "FREE" : "&#8377;" + shipping.ToString("N2");
                    litGrandTotal.Text = grandTotal.ToString("N2");

                    rptCartItems.DataSource = dt;
                    rptCartItems.DataBind();
                }

                (Master as Site1)?.RefreshCartAndWishlistCounts();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading cart: " + ex.Message, false);
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int cartId = Convert.ToInt32(e.CommandArgument);
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                if (e.CommandName == "IncreaseQty")
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Cart SET Quantity = Quantity + 1 WHERE CartId = " + cartId + " AND UserEmail = '" + email + "'", con);
                    cmd.ExecuteNonQuery();
                }
                else if (e.CommandName == "DecreaseQty")
                {
                    SqlCommand checkCmd = new SqlCommand("SELECT Quantity FROM Cart WHERE CartId = " + cartId + " AND UserEmail = '" + email + "'", con);
                    int currentQty = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (currentQty > 1)
                    {
                        SqlCommand updateCmd = new SqlCommand("UPDATE Cart SET Quantity = Quantity - 1 WHERE CartId = " + cartId + " AND UserEmail = '" + email + "'", con);
                        updateCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        SqlCommand delCmd = new SqlCommand("DELETE FROM Cart WHERE CartId = " + cartId + " AND UserEmail = '" + email + "'", con);
                        delCmd.ExecuteNonQuery();
                    }
                }
                else if (e.CommandName == "RemoveItem")
                {
                    SqlCommand delCmd = new SqlCommand("DELETE FROM Cart WHERE CartId = " + cartId + " AND UserEmail = '" + email + "'", con);
                    delCmd.ExecuteNonQuery();
                    ShowAlert("Item removed from your cart.", true);
                }

                con.Close();
                LoadCartItems();
            }
            catch (Exception ex)
            {
                ShowAlert("Failed to update item: " + ex.Message, false);
            }
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Cart WHERE UserEmail = '" + email + "'", con);
                cmd.ExecuteNonQuery();
                con.Close();

                ShowAlert("Cart has been cleared.", true);
                LoadCartItems();
            }
            catch (Exception ex)
            {
                ShowAlert("Error clearing cart: " + ex.Message, false);
            }
        }

        protected void btnProceedCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("OrderPlaced.aspx");
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
            litAlertMsg.Text = msg;
        }
    }
}
