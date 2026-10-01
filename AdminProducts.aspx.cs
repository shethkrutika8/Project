using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AdminProducts : Page
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
                LoadProductsGrid();
            }
        }

        private void LoadProductsGrid()
        {
            try
            {
                DataTable dt = DbHelper.GetAllProductsDataTable();
                gvProducts.DataSource = dt;
                gvProducts.DataBind();
                litProductCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message, "danger");
            }
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            pnlAlert.Visible = false;

            // Pure ASP.NET Server-Side Validation
            if (!Page.IsValid)
                return;

            string name = txtName.Text.Trim();
            string category = ddlCategory.SelectedValue;
            decimal price;
            int stock;
            string description = txtDescription.Text.Trim();
            string imageUrl = txtImageUrl.Text.Trim();

            if (string.IsNullOrEmpty(imageUrl))
                imageUrl = "image/product-snake-plant.png";

            if (!decimal.TryParse(txtPrice.Text.Trim(), out price) || price < 0)
            {
                ShowAlert("Price must be a valid non-negative number.", "danger");
                return;
            }

            if (!int.TryParse(txtStock.Text.Trim(), out stock) || stock < 0)
            {
                ShowAlert("Stock quantity must be a non-negative integer.", "danger");
                return;
            }

            int editId = 0;
            int.TryParse(hdnEditId.Value, out editId);

            try
            {
                using (var con = DbHelper.GetConnection())
                {
                    con.Open();
                    if (editId > 0)
                    {
                        // Update existing product
                        string updateSql = @"UPDATE Products 
                                             SET Name = @Name, Category = @Category, Price = @Price, 
                                                 Description = @Desc, StockQuantity = @Stock, ImageUrl = @Img 
                                             WHERE ProductId = @Id";
                        using (var cmd = new SqlCommand(updateSql, con))
                        {
                            cmd.Parameters.AddWithValue("@Name", name);
                            cmd.Parameters.AddWithValue("@Category", category);
                            cmd.Parameters.AddWithValue("@Price", price);
                            cmd.Parameters.AddWithValue("@Desc", description);
                            cmd.Parameters.AddWithValue("@Stock", stock);
                            cmd.Parameters.AddWithValue("@Img", imageUrl);
                            cmd.Parameters.AddWithValue("@Id", editId);
                            cmd.ExecuteNonQuery();
                        }
                        ShowAlert("Product '" + name + "' updated successfully in the database!", "success");
                    }
                    else
                    {
                        // Insert new product
                        string insertSql = @"INSERT INTO Products (Name, Category, Price, Description, StockQuantity, ImageUrl, IsActive, CreatedDate) 
                                             VALUES (@Name, @Category, @Price, @Desc, @Stock, @Img, 1, GETDATE())";
                        using (var cmd = new SqlCommand(insertSql, con))
                        {
                            cmd.Parameters.AddWithValue("@Name", name);
                            cmd.Parameters.AddWithValue("@Category", category);
                            cmd.Parameters.AddWithValue("@Price", price);
                            cmd.Parameters.AddWithValue("@Desc", description);
                            cmd.Parameters.AddWithValue("@Stock", stock);
                            cmd.Parameters.AddWithValue("@Img", imageUrl);
                            cmd.ExecuteNonQuery();
                        }
                        ShowAlert("New product '" + name + "' added successfully to database!", "success");
                    }
                }

                ResetForm();
                LoadProductsGrid();
            }
            catch (Exception ex)
            {
                ShowAlert("Database error saving product: " + ex.Message, "danger");
            }
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditProduct")
            {
                var prod = DbHelper.GetProductById(productId);
                if (prod != null)
                {
                    hdnEditId.Value = prod.Id.ToString();
                    txtName.Text = prod.Name;
                    if (ddlCategory.Items.FindByValue(prod.Category.ToLower()) != null)
                        ddlCategory.SelectedValue = prod.Category.ToLower();
                    txtPrice.Text = prod.Price.ToString("0.##");
                    txtDescription.Text = prod.Description;
                    txtStock.Text = prod.StockQuantity.ToString();
                    txtImageUrl.Text = prod.ImageUrl;

                    litFormTitle.Text = "Edit Product #" + prod.Id + " (" + prod.Name + ")";
                    btnSaveProduct.Text = "Update Product";
                    btnCancelEdit.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteProduct")
            {
                try
                {
                    using (var con = DbHelper.GetConnection())
                    {
                        con.Open();
                        using (var cmd = new SqlCommand("DELETE FROM Products WHERE ProductId = @Id", con))
                        {
                            cmd.Parameters.AddWithValue("@Id", productId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    ShowAlert("Product #" + productId + " removed from the database.", "info");
                    ResetForm();
                    LoadProductsGrid();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting product: " + ex.Message, "danger");
                }
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hdnEditId.Value = "0";
            txtName.Text = "";
            txtPrice.Text = "";
            txtDescription.Text = "";
            txtStock.Text = "100";
            txtImageUrl.Text = "";
            litFormTitle.Text = "Add New Product to Database";
            btnSaveProduct.Text = "Save Product to Database";
            btnCancelEdit.Visible = false;
        }

        private void ShowAlert(string msg, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert alert-" + type + " alert-dismissible fade show mb-4";
            litAlertMsg.Text = msg;
        }
    }
}
