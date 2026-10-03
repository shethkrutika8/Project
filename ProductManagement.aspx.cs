using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class ProductManagement : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["AgriConnectDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductStats();
                LoadProducts();
            }
        }

        private void LoadProductStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total Products
                    SqlCommand cmdTotal = new SqlCommand("SELECT COUNT(*) FROM Products", con);
                    litTotalProducts.Text = cmdTotal.ExecuteScalar().ToString();

                    // In Stock (Stock > 10)
                    SqlCommand cmdInStock = new SqlCommand("SELECT COUNT(*) FROM Products WHERE Stock > 10", con);
                    litInStock.Text = cmdInStock.ExecuteScalar().ToString();

                    // Low Stock (Stock > 0 AND Stock <= 10)
                    SqlCommand cmdLowStock = new SqlCommand("SELECT COUNT(*) FROM Products WHERE Stock > 0 AND Stock <= 10", con);
                    litLowStock.Text = cmdLowStock.ExecuteScalar().ToString();

                    // Out of Stock (Stock = 0)
                    SqlCommand cmdOutOfStock = new SqlCommand("SELECT COUNT(*) FROM Products WHERE Stock = 0", con);
                    litOutOfStock.Text = cmdOutOfStock.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading product statistics: " + ex.Message, false);
            }
        }

        private void LoadProducts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT ProductId, ProductName, Description, Price, Stock, Category FROM Products";
                    
                    // Apply filters if selected
                    if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                    {
                        query += " WHERE Category = @Category";
                    }
                    
                    if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                    {
                        if (query.Contains("WHERE"))
                        {
                            query += " AND";
                        }
                        else
                        {
                            query += " WHERE";
                        }

                        if (ddlStatus.SelectedValue == "In Stock")
                        {
                            query += " Stock > 10";
                        }
                        else if (ddlStatus.SelectedValue == "Low Stock")
                        {
                            query += " Stock > 0 AND Stock <= 10";
                        }
                        else if (ddlStatus.SelectedValue == "Out of Stock")
                        {
                            query += " Stock = 0";
                        }
                    }

                    // Apply search filter
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        if (query.Contains("WHERE"))
                        {
                            query += " AND";
                        }
                        else
                        {
                            query += " WHERE";
                        }
                        query += " ProductName LIKE @Search OR Description LIKE @Search";
                    }

                    SqlCommand cmd = new SqlCommand(query, con);
                    
                    if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                    }
                    
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvProducts.DataSource = dt;
                    gvProducts.DataBind();

                    // Update pagination info
                    litTotalRecords.Text = dt.Rows.Count.ToString();
                    litShowingStart.Text = dt.Rows.Count > 0 ? "1" : "0";
                    litShowingEnd.Text = dt.Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message, false);
            }
        }

        protected string GetCategoryClass(object category)
        {
            if (category == null) return "plants";
            
            string cat = category.ToString().ToLower();
            switch (cat)
            {
                case "plants": return "plants";
                case "seeds": return "seeds";
                case "pots": return "pots";
                case "tools": return "tools";
                case "care": return "care";
                default: return "plants";
            }
        }

        protected string GetStatusClass(object stock)
        {
            if (stock == null) return "out";
            
            int stockValue;
            if (int.TryParse(stock.ToString(), out stockValue))
            {
                if (stockValue == 0) return "out";
                if (stockValue <= 10) return "low";
                return "instock";
            }
            return "out";
        }

        protected string GetStockStatus(object stock)
        {
            if (stock == null) return "Out of Stock";
            
            int stockValue;
            if (int.TryParse(stock.ToString(), out stockValue))
            {
                if (stockValue == 0) return "Out of Stock";
                if (stockValue <= 10) return "Low Stock";
                return "In Stock";
            }
            return "Out of Stock";
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            ShowAlert("Export functionality - Products data exported successfully!", true);
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            ShowAlert("Add Product form would open here for adding new products.", true);
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                ShowAlert($"Edit product with ID: {productId}", true);
            }
            else if (e.CommandName == "DeleteProduct")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                DeleteProduct(productId);
            }
        }

        private void DeleteProduct(int productId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE ProductId = @ProductId", con);
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    cmd.ExecuteNonQuery();
                }
                
                ShowAlert("Product deleted successfully!", true);
                LoadProductStats();
                LoadProducts();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting product: " + ex.Message, false);
            }
        }

        private void ShowAlert(string message, bool isSuccess)
        {
            pnlAlert.Visible = true;
            litAlertMsg.Text = message;
            
            if (isSuccess)
            {
                pnlAlert.CssClass = "alert alert-success alert-dismissible fade show mb-4";
            }
            else
            {
                pnlAlert.CssClass = "alert alert-danger alert-dismissible fade show mb-4";
            }
        }
    }
}
