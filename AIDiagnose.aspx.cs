using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AIDiagnose : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        private string GetConnectionString()
        {
            return connectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Reset notifications on each load
            lblError.Visible = false;
            pnlAlert.Visible = false;

            // Only run data retrieval on initial GET request, not on subsequent postbacks
            if (!IsPostBack)
            {
                CheckUserRole();
                PopulatePlantDropdown();

                if (IsAdminUser())
                {
                    LoadDiseaseCatalog();
                }
            }
        }

        private bool IsAdminUser()
        {
            return Session["Role"] != null &&
                   Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase);
        }

        private void CheckUserRole()
        {
            // Only show the administrative database section if the logged in user is an Admin
            pnlAdminDatabaseManagement.Visible = IsAdminUser();
        }

        /// <summary>
        /// Populates the plant dropdown using ADO.NET from the SQL Server PlantDiseases table
        /// </summary>
        private void PopulatePlantDropdown()
        {
            DataTable dtPlants = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string query = "SELECT DISTINCT PlantName FROM PlantDiseases ORDER BY PlantName ASC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dtPlants);
                        }
                    }
                }

                ddlPlant.Items.Clear();
                ddlPlant.Items.Add(new ListItem("-- Select a Plant (or auto-detect from upload) --", ""));

                foreach (DataRow row in dtPlants.Rows)
                {
                    string plantName = row["PlantName"].ToString();
                    ddlPlant.Items.Add(new ListItem(plantName, plantName));
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Unable to load plant directory. Please try again later.";
                lblError.Visible = true;
                System.Diagnostics.Debug.WriteLine("PopulatePlantDropdown error: " + ex.Message);
            }
        }

        /// <summary>
        /// Diagnosis trigger: validates upload / selection, queries database via ADO.NET,
        /// records to AIDiagnoseHistory, and displays diagnosis result card.
        /// </summary>
        protected void btnDiagnose_Click(object sender, EventArgs e)
        {
            string selectedPlant = ddlPlant.SelectedValue;
            string uploadedImagePath = "";
            string detectedPlantName = "";

            // 1. Server-side validation of inputs
            bool hasFile = fileUploadPlant.HasFile;
            bool hasSelection = !string.IsNullOrWhiteSpace(selectedPlant);

            if (!hasFile && !hasSelection)
            {
                lblError.Text = "Please choose a plant image to upload or select a plant from the dropdown.";
                lblError.Visible = true;
                return;
            }

            // 2. Handle Image Upload if provided
            if (hasFile)
            {
                string fileExtension = Path.GetExtension(fileUploadPlant.FileName).ToLower();
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".webp" };

                bool isAllowed = false;
                foreach (string ext in allowedExtensions)
                {
                    if (fileExtension == ext)
                    {
                        isAllowed = true;
                        break;
                    }
                }

                if (!isAllowed)
                {
                    lblError.Text = "Invalid file type. Only JPG, PNG, and WEBP images are supported.";
                    lblError.Visible = true;
                    return;
                }

                // Check file size (max 10MB = 10 * 1024 * 1024 bytes)
                if (fileUploadPlant.PostedFile.ContentLength > 10 * 1024 * 1024)
                {
                    lblError.Text = "File size exceeds 10MB limit. Please upload a smaller image.";
                    lblError.Visible = true;
                    return;
                }

                try
                {
                    string uploadFolder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    string uniqueFileName = "leaf_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + Path.GetFileName(fileUploadPlant.FileName);
                    string fullSavePath = Path.Combine(uploadFolder, uniqueFileName);
                    fileUploadPlant.SaveAs(fullSavePath);

                    uploadedImagePath = "Uploads/" + uniqueFileName;
                }
                catch (Exception ex)
                {
                    lblError.Text = "Error saving uploaded image. Please try again.";
                    lblError.Visible = true;
                    System.Diagnostics.Debug.WriteLine("Upload error: " + ex.Message);
                    return;
                }
            }

            // 3. Determine target plant for database query
            if (hasSelection)
            {
                detectedPlantName = selectedPlant;
            }
            else if (hasFile)
            {
                // Match based on filename keywords or fallback to popular database species
                string fileNameLower = Path.GetFileNameWithoutExtension(fileUploadPlant.FileName).ToLower();
                detectedPlantName = MatchPlantFromFileName(fileNameLower);
            }

            // 4. Query SQL Server PlantDiseases via ADO.NET with Parameterized Query
            ExecutePlantDiagnosis(detectedPlantName, uploadedImagePath);
        }

        private string MatchPlantFromFileName(string name)
        {
            if (name.Contains("tulsi") || name.Contains("basil")) return "Tulsi (Holy Basil)";
            if (name.Contains("sunflower")) return "Sunflower";
            if (name.Contains("snake")) return "Snake Plant";
            if (name.Contains("succulent")) return "Succulent Plant";
            if (name.Contains("tomato")) return "Tomato Plant";
            if (name.Contains("rose")) return "Rose Plant";
            if (name.Contains("money")) return "Money Plant";
            if (name.Contains("aloe")) return "Aloe Vera";
            if (name.Contains("mango")) return "Mango Tree";
            if (name.Contains("cotton")) return "Cotton Plant";
            if (name.Contains("wheat")) return "Wheat Plant";
            if (name.Contains("rice")) return "Rice Plant";
            if (name.Contains("chili") || name.Contains("chilli")) return "Chili Plant";
            if (name.Contains("lemon")) return "Lemon Tree";
            if (name.Contains("pudina") || name.Contains("mint")) return "Mint (Pudina)";
            return "Tulsi (Holy Basil)"; // default verified botanical record
        }

        private void ExecutePlantDiagnosis(string plantName, string userUploadedImagePath)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    string selectQuery = @"SELECT TOP 1 DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, 
                                                 MedicineName, MedicinePrice, ImageUrl 
                                          FROM PlantDiseases 
                                          WHERE PlantName LIKE @PlantName 
                                          ORDER BY DiseaseId ASC";

                    using (SqlCommand cmd = new SqlCommand(selectQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@PlantName", "%" + plantName + "%");

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string dbPlant = reader["PlantName"].ToString();
                                string disease = reader["DiseaseName"].ToString();
                                string symptoms = reader["Symptoms"].ToString();
                                string treatment = reader["Treatment"].ToString();
                                string medName = reader["MedicineName"].ToString();
                                decimal medPrice = Convert.ToDecimal(reader["MedicinePrice"]);
                                string dbImage = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : "image/about-plants.PNG";

                                // Populate Result Controls
                                lblPlantTitle.Text = dbPlant;
                                lblDiseaseTitle.Text = disease;
                                litSymptoms.Text = HttpUtility.HtmlEncode(symptoms);
                                litTreatmentText.Text = HttpUtility.HtmlEncode(treatment).Replace("\n", "<br />");
                                litMedicineName.Text = medName;
                                litMedicinePrice.Text = medPrice.ToString("N0");

                                // Set medicine thumbnail
                                imgMedicine.ImageUrl = ResolveMedicineImage(medName);

                                // Set diagnosed plant image
                                if (!string.IsNullOrEmpty(userUploadedImagePath))
                                {
                                    imgDiagnosed.ImageUrl = userUploadedImagePath;
                                }
                                else
                                {
                                    imgDiagnosed.ImageUrl = dbImage;
                                }

                                // Store state for Cart / Wishlist
                                hfDiagnosedMedicineName.Value = medName;
                                hfDiagnosedMedicinePrice.Value = medPrice.ToString();
                                hfDiagnosedMedicineImage.Value = imgMedicine.ImageUrl;

                                pnlResultCard.Visible = true;

                                // Close reader before logging history
                                reader.Close();

                                // Log Diagnosis History into SQL Server
                                LogDiagnosisHistory(conn, dbPlant, disease, treatment, userUploadedImagePath);
                            }
                            else
                            {
                                lblError.Text = "No diagnosis records found for the specified plant in database.";
                                lblError.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred during diagnosis. Please check database connection.";
                lblError.Visible = true;
                System.Diagnostics.Debug.WriteLine("ExecutePlantDiagnosis error: " + ex.Message);
            }
        }

        private string ResolveMedicineImage(string medicineName)
        {
            if (string.IsNullOrEmpty(medicineName)) return "image/product-potting-mix.png";
            string lower = medicineName.ToLower();
            if (lower.Contains("potting") || lower.Contains("mix")) return "image/product-potting-mix.png";
            if (lower.Contains("shear") || lower.Contains("pruning")) return "image/product-pruning-shears.png";
            if (lower.Contains("water") || lower.Contains("can")) return "image/product-watering-can.png";
            return "image/tulsi.jfif"; // Organic Neem spray product representation
        }

        private void LogDiagnosisHistory(SqlConnection conn, string plantName, string diseaseName, string treatment, string imagePath)
        {
            try
            {
                string currentUserEmail = GetCurrentUserEmail();
                string insertHistory = @"INSERT INTO AIDiagnoseHistory 
                                        (PlantName, DiseaseName, TreatmentRecommendation, ConfidenceScore, ImagePath, UserEmail, DiagnoseDate) 
                                        VALUES (@PlantName, @DiseaseName, @Treatment, @Confidence, @ImagePath, @UserEmail, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(insertHistory, conn))
                {
                    cmd.Parameters.AddWithValue("@PlantName", plantName);
                    cmd.Parameters.AddWithValue("@DiseaseName", diseaseName);
                    cmd.Parameters.AddWithValue("@Treatment", treatment.Length > 500 ? treatment.Substring(0, 500) : treatment);
                    cmd.Parameters.AddWithValue("@Confidence", "98.4%");
                    cmd.Parameters.AddWithValue("@ImagePath", string.IsNullOrEmpty(imagePath) ? "image/ai-plant-doctor.png" : imagePath);
                    cmd.Parameters.AddWithValue("@UserEmail", currentUserEmail);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LogDiagnosisHistory error: " + ex.Message);
            }
        }

        private string GetCurrentUserEmail()
        {
            if (Session["UserEmail"] != null && !string.IsNullOrEmpty(Session["UserEmail"].ToString()))
            {
                return Session["UserEmail"].ToString();
            }
            return DbHelper.GetCurrentUserEmail(HttpContext.Current);
        }

        protected void btnCloseResult_Click(object sender, EventArgs e)
        {
            pnlResultCard.Visible = false;
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string medName = hfDiagnosedMedicineName.Value;
            string medPriceStr = hfDiagnosedMedicinePrice.Value;
            string medImg = hfDiagnosedMedicineImage.Value;

            if (string.IsNullOrEmpty(medName))
            {
                medName = "Neem Spray Care";
                medPriceStr = "199";
                medImg = "image/tulsi.jfif";
            }

            decimal price = 199m;
            decimal.TryParse(medPriceStr, out price);

            string userEmail = GetCurrentUserEmail();

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    // Check if already in cart
                    string checkSql = "SELECT CartId, Quantity FROM Cart WHERE UserEmail = @Email AND ProductName = @Product";
                    int existingCartId = 0;
                    int existingQty = 0;

                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", userEmail);
                        checkCmd.Parameters.AddWithValue("@Product", medName);
                        using (SqlDataReader r = checkCmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                existingCartId = Convert.ToInt32(r["CartId"]);
                                existingQty = Convert.ToInt32(r["Quantity"]);
                            }
                        }
                    }

                    if (existingCartId > 0)
                    {
                        string updateSql = "UPDATE Cart SET Quantity = @Qty WHERE CartId = @CartId";
                        using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@Qty", existingQty + 1);
                            updateCmd.Parameters.AddWithValue("@CartId", existingCartId);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertSql = @"INSERT INTO Cart (UserEmail, ProductName, Price, Quantity, ImageUrl, CreatedDate) 
                                            VALUES (@Email, @Product, @Price, 1, @Image, GETDATE())";
                        using (SqlCommand insertCmd = new SqlCommand(insertSql, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@Email", userEmail);
                            insertCmd.Parameters.AddWithValue("@Product", medName);
                            insertCmd.Parameters.AddWithValue("@Price", price);
                            insertCmd.Parameters.AddWithValue("@Image", string.IsNullOrEmpty(medImg) ? "image/tulsi.jfif" : medImg);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                }

                litAlertMsg.Text = "<strong>" + HttpUtility.HtmlEncode(medName) + "</strong> has been added to your Cart!";
                pnlAlert.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "Could not add treatment product to cart: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnAddToWishlist_Click(object sender, EventArgs e)
        {
            string medName = hfDiagnosedMedicineName.Value;
            string medPriceStr = hfDiagnosedMedicinePrice.Value;
            string medImg = hfDiagnosedMedicineImage.Value;

            if (string.IsNullOrEmpty(medName))
            {
                medName = "Neem Spray Care";
                medPriceStr = "199";
                medImg = "image/tulsi.jfif";
            }

            decimal price = 199m;
            decimal.TryParse(medPriceStr, out price);

            string userEmail = GetCurrentUserEmail();

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    string checkSql = "SELECT COUNT(*) FROM Wishlist WHERE UserEmail = @Email AND ProductName = @Product";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", userEmail);
                        checkCmd.Parameters.AddWithValue("@Product", medName);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (count == 0)
                        {
                            string insertSql = @"INSERT INTO Wishlist (UserEmail, ProductName, Price, ImageUrl, CreatedDate) 
                                                VALUES (@Email, @Product, @Price, @Image, GETDATE())";
                            using (SqlCommand insertCmd = new SqlCommand(insertSql, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@Email", userEmail);
                                insertCmd.Parameters.AddWithValue("@Product", medName);
                                insertCmd.Parameters.AddWithValue("@Price", price);
                                insertCmd.Parameters.AddWithValue("@Image", string.IsNullOrEmpty(medImg) ? "image/tulsi.jfif" : medImg);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                litAlertMsg.Text = "<strong>" + HttpUtility.HtmlEncode(medName) + "</strong> has been saved to your Wishlist!";
                pnlAlert.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "Could not save to wishlist: " + ex.Message;
                lblError.Visible = true;
            }
        }

        // =========================================================
        // ADMIN DATABASE MANAGEMENT METHODS (CRUD)
        // =========================================================

        private void LoadDiseaseCatalog()
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string sql = @"SELECT DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, 
                                          MedicineName, MedicinePrice, ImageUrl, CreatedDate 
                                   FROM PlantDiseases 
                                   ORDER BY DiseaseId DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }

                litRecordCount.Text = dt.Rows.Count.ToString();
                rptDiseaseCatalog.DataSource = dt;
                rptDiseaseCatalog.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDiseaseCatalog error: " + ex.Message);
            }
        }

        protected void btnToggleManual_Click(object sender, EventArgs e)
        {
            pnlManualEntry.Visible = !pnlManualEntry.Visible;
            if (pnlManualEntry.Visible)
            {
                btnToggleManual.Text = "✖ Cancel Manual Form";
            }
            else
            {
                btnToggleManual.Text = "➕ Add New Disease to Database";
            }
        }

        protected void btnSaveManual_Click(object sender, EventArgs e)
        {
            // Server-side validation check
            if (!Page.IsValid)
            {
                return;
            }

            string plant = txtNewPlantName.Text.Trim();
            string disease = txtNewDiseaseName.Text.Trim();
            string symptoms = txtNewSymptoms.Text.Trim();
            string treatment = txtNewTreatment.Text.Trim();
            string medName = txtNewMedicineName.Text.Trim();
            decimal price = 199m;
            decimal.TryParse(txtNewPrice.Text.Trim(), out price);
            string img = ddlNewImage.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string insertSql = @"INSERT INTO PlantDiseases 
                                        (PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl, CreatedDate) 
                                        VALUES (@Plant, @Disease, @Symptoms, @Treatment, @MedName, @Price, @Img, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Plant", plant);
                        cmd.Parameters.AddWithValue("@Disease", disease);
                        cmd.Parameters.AddWithValue("@Symptoms", symptoms);
                        cmd.Parameters.AddWithValue("@Treatment", treatment);
                        cmd.Parameters.AddWithValue("@MedName", medName);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Img", img);

                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear input controls
                txtNewPlantName.Text = "";
                txtNewDiseaseName.Text = "";
                txtNewSymptoms.Text = "";
                txtNewTreatment.Text = "";
                txtNewMedicineName.Text = "";
                txtNewPrice.Text = "199";

                pnlManualEntry.Visible = false;
                btnToggleManual.Text = "➕ Add New Disease to Database";

                litAlertMsg.Text = "New plant disease condition added to SQL Server database successfully!";
                pnlAlert.Visible = true;
                Response.Write("<script>alert('Plant disease record saved successfully!');</script>");

                LoadDiseaseCatalog();
                PopulatePlantDropdown();
            }
            catch (Exception ex)
            {
                lblError.Text = "Error saving disease record: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnCancelManual_Click(object sender, EventArgs e)
        {
            pnlManualEntry.Visible = false;
            btnToggleManual.Text = "➕ Add New Disease to Database";
        }

        protected void rptDiseaseCatalog_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int diseaseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteRow")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                    {
                        conn.Open();
                        string deleteSql = "DELETE FROM PlantDiseases WHERE DiseaseId = @Id";
                        using (SqlCommand cmd = new SqlCommand(deleteSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@Id", diseaseId);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    litAlertMsg.Text = "Plant disease record #" + diseaseId + " removed from database.";
                    pnlAlert.Visible = true;
                    Response.Write("<script>alert('Plant disease record deleted successfully!');</script>");

                    LoadDiseaseCatalog();
                    PopulatePlantDropdown();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Failed to delete record: " + ex.Message;
                    lblError.Visible = true;
                }
            }
            else if (e.CommandName == "DiagnoseRow")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                    {
                        conn.Open();
                        string sel = "SELECT PlantName, ImageUrl FROM PlantDiseases WHERE DiseaseId = @Id";
                        using (SqlCommand cmd = new SqlCommand(sel, conn))
                        {
                            cmd.Parameters.AddWithValue("@Id", diseaseId);
                            using (SqlDataReader r = cmd.ExecuteReader())
                            {
                                if (r.Read())
                                {
                                    string pName = r["PlantName"].ToString();
                                    string pImg = r["ImageUrl"] != DBNull.Value ? r["ImageUrl"].ToString() : "";
                                    r.Close();
                                    ExecutePlantDiagnosis(pName, pImg);
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = "Error diagnosing row: " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }
    }
}
