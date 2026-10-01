using System;
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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT CartId, UserEmail, ProductName, Price, Quantity, ImageUrl, CreatedDate FROM Cart WHERE UserEmail = @Email ORDER BY CartId DESC", con))
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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    if (e.CommandName == "IncreaseQty")
                    {
                        using (var cmd = new SqlCommand("UPDATE Cart SET Quantity = Quantity + 1 WHERE CartId = @CartId AND UserEmail = @Email", con))
                        {
                            cmd.Parameters.AddWithValue("@CartId", cartId);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else if (e.CommandName == "DecreaseQty")
                    {
                        using (var checkCmd = new SqlCommand("SELECT Quantity FROM Cart WHERE CartId = @CartId AND UserEmail = @Email", con))
                        {
                            checkCmd.Parameters.AddWithValue("@CartId", cartId);
                            checkCmd.Parameters.AddWithValue("@Email", email);
                            int currentQty = Convert.ToInt32(checkCmd.ExecuteScalar());

                            if (currentQty > 1)
                            {
                                using (var updateCmd = new SqlCommand("UPDATE Cart SET Quantity = Quantity - 1 WHERE CartId = @CartId AND UserEmail = @Email", con))
                                {
                                    updateCmd.Parameters.AddWithValue("@CartId", cartId);
                                    updateCmd.Parameters.AddWithValue("@Email", email);
                                    updateCmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                using (var delCmd = new SqlCommand("DELETE FROM Cart WHERE CartId = @CartId AND UserEmail = @Email", con))
                                {
                                    delCmd.Parameters.AddWithValue("@CartId", cartId);
                                    delCmd.Parameters.AddWithValue("@Email", email);
                                    delCmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }
                    else if (e.CommandName == "RemoveItem")
                    {
                        using (var delCmd = new SqlCommand("DELETE FROM Cart WHERE CartId = @CartId AND UserEmail = @Email", con))
                        {
                            delCmd.Parameters.AddWithValue("@CartId", cartId);
                            delCmd.Parameters.AddWithValue("@Email", email);
                            delCmd.ExecuteNonQuery();
                        }
                        ShowAlert("Item removed from your cart.", true);
                    }
                }

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
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("DELETE FROM Cart WHERE UserEmail = @Email", con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.ExecuteNonQuery();
                    }
                }
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
