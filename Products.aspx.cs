using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class Products : Page
    {
        public string SelectedCategory
        {
            get => ViewState["SelectedCategory"] != null ? ViewState["SelectedCategory"].ToString() : "all";
            set => ViewState["SelectedCategory"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure Products table exists and is seeded on first run
            DbHelper.EnsureDatabaseTablesExist();

            if (!IsPostBack)
            {
                if (Request.QueryString["cat"] != null)
                    SelectedCategory = Request.QueryString["cat"].ToLower().Trim();

                HighlightCategoryTab();
                BindProducts();
            }
        }

        private void HighlightCategoryTab()
        {
            string cat = SelectedCategory.ToLower();
            btnCatAll.CssClass = "cat-tab" + (cat == "all" ? " active" : "");
            btnCatPlants.CssClass = "cat-tab" + (cat == "plants" ? " active" : "");
            btnCatSeeds.CssClass = "cat-tab" + (cat == "seeds" ? " active" : "");
            btnCatFertilizers.CssClass = "cat-tab" + (cat == "fertilizers" ? " active" : "");
            btnCatPots.CssClass = "cat-tab" + (cat == "pots" ? " active" : "");
            btnCatTools.CssClass = "cat-tab" + (cat == "tools" ? " active" : "");
            btnCatCare.CssClass = "cat-tab" + (cat == "care" ? " active" : "");
            btnCatGifts.CssClass = "cat-tab" + (cat == "gifts" ? " active" : "");
        }

        private void BindProducts()
        {
            // Fetch products from the actual SQL Server database — NOT hardcoded
            string cat = SelectedCategory;
            List<ProductItem> products = DbHelper.GetProductsFromDB(cat);

            if (products.Count == 0)
            {
                // Show empty state message if no products in DB for selected category
                pnlAlert.CssClass = "alert alert-info d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                litAlertMsg.Text = "No products found for the selected category. Please select a different category or check back later.";
                pnlAlert.Visible = true;
            }
                
            rptProducts.DataSource = products;
            rptProducts.DataBind();
        }

        protected void FilterCategory_Click(object sender, EventArgs e)
        {
            if (sender is LinkButton btn)
            {
                SelectedCategory = btn.CommandArgument;
                pnlAlert.Visible = false;
                HighlightCategoryTab();
                BindProducts();
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            // Fetch product from SQL Server database by ID — not hardcoded
            ProductItem product = DbHelper.GetProductById(productId);
            if (product == null)
            {
                pnlAlert.CssClass = "alert alert-danger d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                litAlertMsg.Text = "Product not found in the database. Please refresh the page.";
                pnlAlert.Visible = true;
                return;
            }

            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);

            if (e.CommandName == "AddToCart")
            {
                bool success = DbHelper.AddToCart(email, product.Name, product.Price, 1, product.ImageUrl);
                if (success)
                {
                    pnlAlert.CssClass = "alert alert-success d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                    litAlertMsg.Text = $"<strong>Added to Cart!</strong> '{product.Name}' (&#8377;{product.Price:N0}) has been added to your cart.";
                    pnlAlert.Visible = true;
                    (Master as Site1)?.RefreshCartAndWishlistCounts();
                    Response.Write("<script>alert('Added to Cart Successfully');</script>");
                }
                else
                {
                    pnlAlert.CssClass = "alert alert-danger d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                    litAlertMsg.Text = $"Failed to add '{product.Name}' to cart. Please try again.";
                    pnlAlert.Visible = true;
                }
            }
            else if (e.CommandName == "AddToWishlist")
            {
                bool success = DbHelper.AddToWishlist(email, product.Name, product.Price, product.ImageUrl);
                if (success)
                {
                    pnlAlert.CssClass = "alert alert-info d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                    litAlertMsg.Text = $"<strong>Added to Wishlist!</strong> '{product.Name}' has been saved to your wishlist.";
                    pnlAlert.Visible = true;
                    (Master as Site1)?.RefreshCartAndWishlistCounts();
                    Response.Write("<script>alert('Added to Wishlist Successfully');</script>");
                }
                else
                {
                    pnlAlert.CssClass = "alert alert-danger d-flex align-items-center justify-content-between p-3 mb-4 rounded-3 shadow-sm";
                    litAlertMsg.Text = $"Failed to add '{product.Name}' to wishlist.";
                    pnlAlert.Visible = true;
                }
            }
        }
}
}
