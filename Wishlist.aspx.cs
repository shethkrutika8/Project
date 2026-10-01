using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class Wishlist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadWishlist();
            }
        }

        private void LoadWishlist()
        {
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            DataTable dt = new DataTable();

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (var cmd = new SqlCommand("SELECT WishlistId, UserEmail, ProductName, Price, ImageUrl, CreatedDate FROM Wishlist WHERE UserEmail = @Email ORDER BY WishlistId DESC", con))
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
                    pnlEmptyWishlist.Visible = true;
                    pnlWishlistContent.Visible = false;
                    litWishlistCountHeader.Text = "0";
                }
                else
                {
                    pnlEmptyWishlist.Visible = false;
                    pnlWishlistContent.Visible = true;
                    litWishlistCountHeader.Text = dt.Rows.Count.ToString();

                    rptWishlist.DataSource = dt;
                    rptWishlist.DataBind();
                }

                (Master as Site1)?.RefreshCartAndWishlistCounts();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading wishlist: " + ex.Message, false);
            }
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int wishlistId = Convert.ToInt32(e.CommandArgument);
            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            try
            {
                if (e.CommandName == "MoveToCart")
                {
                    string productName = "";
                    decimal price = 0;
                    string imageUrl = "";

                    using (var con = DbHelper.GetConnection())
                    {
                        con.Open();
                        using (var cmd = new SqlCommand("SELECT ProductName, Price, ImageUrl FROM Wishlist WHERE WishlistId = @WishlistId AND UserEmail = @Email", con))
                        {
                            cmd.Parameters.AddWithValue("@WishlistId", wishlistId);
                            cmd.Parameters.AddWithValue("@Email", email);
                            using (var r = cmd.ExecuteReader())
                            {
                                if (r.Read())
                                {
                                    productName = r["ProductName"].ToString();
                                    price = Convert.ToDecimal(r["Price"]);
                                    imageUrl = r["ImageUrl"] != DBNull.Value ? r["ImageUrl"].ToString() : "";
                                }
                            }
                        }

                        if (!string.IsNullOrEmpty(productName))
                        {
                            // Add to cart
                            DbHelper.AddToCart(email, productName, price, 1, imageUrl);

                            // Remove from wishlist
                            using (var delCmd = new SqlCommand("DELETE FROM Wishlist WHERE WishlistId = @WishlistId AND UserEmail = @Email", con))
                            {
                                delCmd.Parameters.AddWithValue("@WishlistId", wishlistId);
                                delCmd.Parameters.AddWithValue("@Email", email);
                                delCmd.ExecuteNonQuery();
                            }

                            ShowAlert("'" + productName + "' moved to your shopping cart!", true);
                        }
                    }
                }
                else if (e.CommandName == "RemoveWish")
                {
                    using (var con = DbHelper.GetConnection())
                    {
                        con.Open();
                        using (var delCmd = new SqlCommand("DELETE FROM Wishlist WHERE WishlistId = @WishlistId AND UserEmail = @Email", con))
                        {
                            delCmd.Parameters.AddWithValue("@WishlistId", wishlistId);
                            delCmd.Parameters.AddWithValue("@Email", email);
                            delCmd.ExecuteNonQuery();
                        }
                    }
                    ShowAlert("Item removed from your wishlist.", true);
                }

                LoadWishlist();
            }
            catch (Exception ex)
            {
                ShowAlert("Action failed: " + ex.Message, false);
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
            litAlertMsg.Text = msg;
        }
    }
}
