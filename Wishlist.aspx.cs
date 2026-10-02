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
    public partial class Wishlist : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

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
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT WishlistId, UserEmail, ProductName, Price, ImageUrl, CreatedDate FROM Wishlist WHERE UserEmail = '" + email + "' ORDER BY WishlistId DESC", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                con.Close();

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

                    SqlConnection con = new SqlConnection(connectionString);
                    con.Open();
                    SqlCommand cmd = new SqlCommand("SELECT ProductName, Price, ImageUrl FROM Wishlist WHERE WishlistId = " + wishlistId + " AND UserEmail = '" + email + "'", con);
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        productName = r["ProductName"].ToString();
                        price = Convert.ToDecimal(r["Price"]);
                        imageUrl = r["ImageUrl"] != DBNull.Value ? r["ImageUrl"].ToString() : "";
                    }
                    r.Close();

                    if (!string.IsNullOrEmpty(productName))
                    {
                        // Add to cart
                        DbHelper.AddToCart(email, productName, price, 1, imageUrl);

                        // Remove from wishlist
                        SqlCommand delCmd = new SqlCommand("DELETE FROM Wishlist WHERE WishlistId = " + wishlistId + " AND UserEmail = '" + email + "'", con);
                        delCmd.ExecuteNonQuery();

                        Response.Write("<script>alert('" + productName + " moved to your shopping cart!');</script>");
                    }
                    con.Close();
                }
                else if (e.CommandName == "RemoveWish")
                {
                    SqlConnection con = new SqlConnection(connectionString);
                    con.Open();
                    SqlCommand delCmd = new SqlCommand("DELETE FROM Wishlist WHERE WishlistId = " + wishlistId + " AND UserEmail = '" + email + "'", con);
                    delCmd.ExecuteNonQuery();
                    con.Close();

                    Response.Write("<script>alert('Item removed from your wishlist.');</script>");
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
