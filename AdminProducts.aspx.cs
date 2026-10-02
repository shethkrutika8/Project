using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AdminProducts : Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

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
                SqlConnection con = new SqlConnection(connectionString);
                string query = "select ProductId, Name, Category, Price, ImageUrl, Description, StockQuantity, IsActive, CreatedDate from Products order by ProductId desc";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                con.Close();

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
                Response.Write("<script>alert('Price must be a valid non-negative number.');</script>");
                return;
            }

            if (!int.TryParse(txtStock.Text.Trim(), out stock) || stock < 0)
            {
                Response.Write("<script>alert('Stock quantity must be a non-negative integer.');</script>");
                return;
            }

            int editId = 0;
            int.TryParse(hdnEditId.Value, out editId);

            try
            {
                SqlConnection con = new SqlConnection(connectionString);
                con.Open();

                if (editId > 0)
                {
                    // Update existing product
                    string updateSql = "update Products set Name='" + name + "', Category='" + category + "', Price=" + price + ", Description='" + description + "', StockQuantity=" + stock + ", ImageUrl='" + imageUrl + "' where ProductId=" + editId;
                    SqlCommand cmd = new SqlCommand(updateSql, con);
                    cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Write("<script>alert('Product updated successfully!');</script>");
                }
                else
                {
                    // Insert new product
                    string insertSql = "insert into Products (Name, Category, Price, Description, StockQuantity, ImageUrl, IsActive, CreatedDate) values ('" + name + "','" + category + "'," + price + ",'" + description + "'," + stock + ",'" + imageUrl + "', 1, GETDATE())";
                    SqlCommand cmd = new SqlCommand(insertSql, con);
                    cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Write("<script>alert('Product added successfully!');</script>");
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
                    SqlConnection con = new SqlConnection(connectionString);
                    string query = "delete from Products where ProductId=" + productId;
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Write("<script>alert('Product deleted successfully!');</script>");
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
