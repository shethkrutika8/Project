using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Project.Models;

namespace Project
{
    public partial class AIDiagnose : System.Web.UI.Page
    {
        private string connectionString = DbHelper.GetConnectionString();

        private class PlantDiseaseRecord
        {
            public int DiseaseId { get; set; }
            public string PlantName { get; set; }
            public string DiseaseName { get; set; }
            public string Symptoms { get; set; }
            public string Treatment { get; set; }
            public string MedicineName { get; set; }
            public decimal MedicinePrice { get; set; }
            public string ImageUrl { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            pnlAlert.Visible = false;

            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                PopulatePlantDropdown();
                CheckUserRole();

                if (IsAdminUser())
                {
                    LoadDiseaseCatalog();
                }

                pnlResultCard.Visible = false;
            }
        }

        private bool IsAdminUser()
        {
            return Session["Role"] != null &&
                   Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase);
        }

        private void CheckUserRole()
        {
            pnlAdminDatabaseManagement.Visible = IsAdminUser();
        }

        /// <summary>
        /// Populates the plant dropdown directly from the SQL Server PlantDiseases table
        /// </summary>
        private void PopulatePlantDropdown()
        {
            try
            {
                List<string> plants = GetAvailablePlantNamesFromDb();
                ddlPlant.Items.Clear();
                ddlPlant.Items.Add(new ListItem("-- Select from Existing Plants --", ""));

                foreach (string p in plants)
                {
                    ddlPlant.Items.Add(new ListItem(p, p));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("PopulatePlantDropdown error: " + ex.Message);
            }
        }

        /// <summary>
        /// Fetches all distinct plant names currently present in the database
        /// </summary>
        private List<string> GetAvailablePlantNamesFromDb()
        {
            List<string> list = new List<string>();
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string query = "SELECT DISTINCT PlantName FROM PlantDiseases ORDER BY PlantName ASC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                if (r["PlantName"] != DBNull.Value)
                                {
                                    list.Add(r["PlantName"].ToString());
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetAvailablePlantNamesFromDb error: " + ex.Message);
            }
            return list;
        }

        /// <summary>
        /// Diagnose Plant button handler: fetches matching record directly from database
        /// </summary>
        protected void btnDiagnose_Click(object sender, EventArgs e)
        {
            string plantInput = txtPlantName.Text.Trim();
            if (string.IsNullOrEmpty(plantInput))
            {
                plantInput = ddlPlant.SelectedValue.Trim();
            }

            string uploadedImagePath = "";

            // Handle file upload if present
            if (fileUploadPlant.HasFile)
            {
                string ext = Path.GetExtension(fileUploadPlant.FileName).ToLower();
                string[] allowed = { ".jpg", ".jpeg", ".png", ".webp" };
                if (Array.IndexOf(allowed, ext) < 0)
                {
                    lblError.Visible = true;
                    lblError.Text = "<div class='alert alert-danger py-2 mb-2'>Invalid image format. Only JPG, JPEG, PNG, and WEBP formats are allowed.</div>";
                    pnlResultCard.Visible = false;
                    return;
                }

                // 10MB maximum file size check
                if (fileUploadPlant.PostedFile.ContentLength > 10 * 1024 * 1024)
                {
                    lblError.Visible = true;
                    lblError.Text = "<div class='alert alert-danger py-2 mb-2'>File size exceeds 10MB maximum limit.</div>";
                    pnlResultCard.Visible = false;
                    return;
                }

                try
                {
                    string uploadDir = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadDir))
                        Directory.CreateDirectory(uploadDir);

                    string filename = "plant_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + ext;
                    string savePath = Path.Combine(uploadDir, filename);
                    fileUploadPlant.SaveAs(savePath);
                    uploadedImagePath = "Uploads/" + filename;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("File upload save error: " + ex.Message);
                }
            }

            // If user did not type or select a plant name, check if filename matches a plant
            if (string.IsNullOrEmpty(plantInput) && !string.IsNullOrEmpty(uploadedImagePath))
            {
                string baseFn = Path.GetFileNameWithoutExtension(fileUploadPlant.FileName);
                PlantDiseaseRecord guessed = FetchPlantDiseaseFromDb(baseFn);
                if (guessed != null)
                {
                    plantInput = guessed.PlantName;
                }
            }

            if (string.IsNullOrEmpty(plantInput))
            {
                lblError.Visible = true;
                lblError.Text = "<div class='alert alert-warning py-2 mb-2'><strong>Please enter or select a plant name</strong> (e.g. Rose Plant, Tulsi Plant, Aloe Vera, Neem Plant) to diagnose.</div>";
                pnlResultCard.Visible = false;
                return;
            }

            DiagnosePlant(plantInput, uploadedImagePath);
        }

        /// <summary>
        /// Retrieves matched plant record from database and binds all fields to UI
        /// </summary>
        private void DiagnosePlant(string inputPlant, string uploadedImagePath = "")
        {
            try
            {
                PlantDiseaseRecord record = FetchPlantDiseaseFromDb(inputPlant);

                if (record == null)
                {
                    // If plant name does not exist in the database, show error & hide result card
                    pnlResultCard.Visible = false;
                    lblError.Visible = true;

                    List<string> availablePlants = GetAvailablePlantNamesFromDb();
                    string plantsListHtml = string.Join(", ", availablePlants);

                    lblError.Text = $@"
                        <div class='not-found-card p-3 mb-3 bg-white rounded-3 border border-danger shadow-sm'>
                            <div class='d-flex align-items-center gap-2 mb-2 text-danger fw-bold fs-5'>
                                <i class='fa-solid fa-triangle-exclamation'></i>
                                <span>Plant not found in our database.</span>
                            </div>
                            <p class='text-muted mb-2' style='font-size:14px;'>
                                We could not find a diagnostic record matching <strong>&ldquo;{Server.HtmlEncode(inputPlant)}&rdquo;</strong> in our database.
                            </p>
                            <div class='available-plants-box p-2 bg-light rounded-2 border' style='font-size:13.5px;'>
                                <strong class='text-success d-block mb-1'><i class='fa-solid fa-leaf me-1'></i>Available plants in our database ({availablePlants.Count}):</strong>
                                <span class='text-secondary'>{Server.HtmlEncode(plantsListHtml)}</span>
                            </div>
                        </div>";
                    return;
                }

                // Plant found: display ONLY information belonging to this exact plant record
                lblError.Visible = false;

                // 1. Plant Name
                lblPlantTitle.Text = record.PlantName;
                txtPlantName.Text = record.PlantName;

                // 2. Disease / Condition
                lblDiseaseTitle.Text = record.DiseaseName;

                // 3. Observed Symptoms
                litSymptoms.Text = FormatSymptoms(record.Symptoms);

                // 4. Treatment Plan & Expert Care Tips
                litTreatmentText.Text = FormatTreatmentPlan(record.Treatment);
                litCareTips.Text = FormatCareTips(record.Treatment);

                // 5. Recommended Pesticides / Medicines
                litMedicineName.Text = record.MedicineName;
                litMedicinePrice.Text = record.MedicinePrice.ToString("N0");
                hfDiagnosedMedicineName.Value = record.MedicineName;
                hfDiagnosedMedicinePrice.Value = record.MedicinePrice.ToString();

                string medImg = GetProductImage(record.MedicineName);
                if (string.IsNullOrEmpty(medImg))
                    medImg = !string.IsNullOrEmpty(record.ImageUrl) ? record.ImageUrl : "image/product-snake-plant.png";
                imgMedicine.ImageUrl = "~/" + medImg.TrimStart('/');
                hfDiagnosedMedicineImage.Value = medImg;

                // 6. Plant Image: If user uploaded a photo, display user's photo; otherwise display database photo
                string plantImg = !string.IsNullOrEmpty(uploadedImagePath) ? uploadedImagePath : record.ImageUrl;
                if (string.IsNullOrEmpty(plantImg))
                    plantImg = "image/ai-plant-doctor.png";

                imgDiagnosed.ImageUrl = "~/" + plantImg.TrimStart('/');
                imgDiagnosed.AlternateText = record.PlantName;

                // Display result card
                pnlResultCard.Visible = true;

                // Log diagnostic history securely
                SaveToHistory(record.PlantName, record.DiseaseName, record.Treatment);
            }
            catch (Exception ex)
            {
                lblError.Visible = true;
                lblError.Text = "<div class='alert alert-danger py-2 mb-2'>Error loading diagnosis: " + Server.HtmlEncode(ex.Message) + "</div>";
                pnlResultCard.Visible = false;
            }
        }

        /// <summary>
        /// Robust, parameterized database query to fetch matching plant record.
        /// Performs case-insensitive, whitespace-trimmed, and flexible keyword matching.
        /// </summary>
        private PlantDiseaseRecord FetchPlantDiseaseFromDb(string inputPlant)
        {
            if (string.IsNullOrWhiteSpace(inputPlant))
                return null;

            string cleanInput = inputPlant.Trim();

            // Reject overly generic single words like "plant", "tree", "crop", "flower", "leaf"
            HashSet<string> genericTerms = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "plant", "plants", "tree", "trees", "crop", "crops", "flower", "flowers", "herb", "herbs", "bush", "bushes", "leaf", "leaves"
            };

            if (genericTerms.Contains(cleanInput))
                return null;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Exact match (case-insensitive & trimmed)
                string sqlExact = @"SELECT TOP 1 DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl
                                    FROM PlantDiseases
                                    WHERE LOWER(LTRIM(RTRIM(PlantName))) = LOWER(@ExactName)
                                    ORDER BY DiseaseId ASC";

                using (SqlCommand cmd = new SqlCommand(sqlExact, con))
                {
                    cmd.Parameters.AddWithValue("@ExactName", cleanInput);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            return ReadRecord(r);
                        }
                    }
                }

                // 2. Keyword match: Strip common plant suffixes like " plant", " tree", " palm", etc.
                string keyword = Regex.Replace(cleanInput, @"(?i)\s+(plant|tree|palm|crop|herb|bush|flower)$", "").Trim();
                keyword = Regex.Replace(keyword, @"\s*\([^)]*\)", "").Trim();

                if (keyword.Length >= 3 && !genericTerms.Contains(keyword))
                {
                    string sqlKeyword = @"
                        SELECT TOP 1 DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl,
                            CASE 
                                WHEN LOWER(PlantName) = LOWER(@Keyword) THEN 1
                                WHEN LOWER(PlantName) LIKE LOWER(@Keyword) + ' %' THEN 2
                                WHEN LOWER(PlantName) LIKE LOWER(@Keyword) + ' (%' THEN 3
                                WHEN LOWER(PlantName) LIKE '% ' + LOWER(@Keyword) + ' %' THEN 4
                                WHEN LOWER(PlantName) LIKE '%' + LOWER(@Keyword) + '%' THEN 5
                                ELSE 6
                            END as MatchPriority
                        FROM PlantDiseases
                        WHERE LOWER(PlantName) LIKE '%' + LOWER(@Keyword) + '%'
                        ORDER BY MatchPriority ASC, DiseaseId ASC";

                    using (SqlCommand cmd = new SqlCommand(sqlKeyword, con))
                    {
                        cmd.Parameters.AddWithValue("@Keyword", keyword);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                return ReadRecord(r);
                            }
                        }
                    }
                }

                // 3. Reverse match: If user entered a longer phrase like "My potted Tulsi Plant", check if PlantName is inside
                string sqlReverse = @"
                    SELECT TOP 1 DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl
                    FROM PlantDiseases
                    WHERE @FullInput LIKE '%' + LOWER(PlantName) + '%'
                       OR (CHARINDEX('(', PlantName) > 0 AND @FullInput LIKE '%' + LOWER(RTRIM(SUBSTRING(PlantName, 1, CHARINDEX('(', PlantName) - 1))) + '%')
                    ORDER BY LEN(PlantName) DESC, DiseaseId ASC";

                using (SqlCommand cmd = new SqlCommand(sqlReverse, con))
                {
                    cmd.Parameters.AddWithValue("@FullInput", cleanInput.ToLower());
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            return ReadRecord(r);
                        }
                    }
                }
            }

            return null;
        }

        private PlantDiseaseRecord ReadRecord(SqlDataReader r)
        {
            return new PlantDiseaseRecord
            {
                DiseaseId     = Convert.ToInt32(r["DiseaseId"]),
                PlantName     = r["PlantName"] != DBNull.Value ? r["PlantName"].ToString() : "",
                DiseaseName   = r["DiseaseName"] != DBNull.Value ? r["DiseaseName"].ToString() : "",
                Symptoms      = r["Symptoms"] != DBNull.Value ? r["Symptoms"].ToString() : "",
                Treatment     = r["Treatment"] != DBNull.Value ? r["Treatment"].ToString() : "",
                MedicineName  = r["MedicineName"] != DBNull.Value ? r["MedicineName"].ToString() : "",
                MedicinePrice = r["MedicinePrice"] != DBNull.Value ? Convert.ToDecimal(r["MedicinePrice"]) : 0,
                ImageUrl      = r["ImageUrl"] != DBNull.Value ? r["ImageUrl"].ToString() : ""
            };
        }

        private string FormatSymptoms(string symptoms)
        {
            if (string.IsNullOrWhiteSpace(symptoms))
                return "<p class='text-muted mb-0'>No specific symptoms recorded in database.</p>";

            string[] parts = symptoms.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);
            string html = "<ul style='margin:0; padding-left:18px;'>";
            foreach (string p in parts)
            {
                string clean = p.Trim();
                if (!string.IsNullOrEmpty(clean))
                {
                    html += $"<li style='margin-bottom:3px;'>{Server.HtmlEncode(clean)}</li>";
                }
            }
            html += "</ul>";
            return html;
        }

        private string FormatTreatmentPlan(string treatment)
        {
            if (string.IsNullOrWhiteSpace(treatment))
                return "<p class='text-muted mb-0'>No treatment steps recorded in database.</p>";

            string[] lines = treatment.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            List<string> planSteps = new List<string>();

            int maxPlan = lines.Length >= 3 ? 2 : 1;
            for (int i = 0; i < Math.Min(lines.Length, maxPlan); i++)
            {
                string cleaned = CleanStepText(lines[i]);
                if (!string.IsNullOrEmpty(cleaned))
                    planSteps.Add(cleaned);
            }

            string html = "<ol style='margin:6px 0 0; padding-left:20px;'>";
            foreach (string step in planSteps)
            {
                html += $"<li style='margin-bottom:4px;'>{Server.HtmlEncode(step)}</li>";
            }
            html += "</ol>";
            return html;
        }

        private string FormatCareTips(string treatment)
        {
            if (string.IsNullOrWhiteSpace(treatment))
                return "<p class='text-muted mb-0'>Ensure adequate sunlight and proper soil drainage.</p>";

            string[] lines = treatment.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            List<string> careTips = new List<string>();

            int startIndex = lines.Length >= 3 ? 2 : 1;
            for (int i = startIndex; i < lines.Length; i++)
            {
                string cleaned = CleanStepText(lines[i]);
                if (!string.IsNullOrEmpty(cleaned))
                    careTips.Add(cleaned);
            }

            if (careTips.Count == 0 && lines.Length > 0)
            {
                careTips.Add("Maintain optimal watering schedule and observe foliage regularly.");
            }

            string html = "<ul style='margin:6px 0 0; padding-left:18px;'>";
            foreach (string tip in careTips)
            {
                html += $"<li style='margin-bottom:4px;'>{Server.HtmlEncode(tip)}</li>";
            }
            html += "</ul>";
            return html;
        }

        private string CleanStepText(string step)
        {
            if (string.IsNullOrWhiteSpace(step)) return "";
            string s = step.Trim();
            return Regex.Replace(s, @"^\d+[\.\)]\s*", "").Trim();
        }

        private string GetProductImage(string productName)
        {
            if (string.IsNullOrWhiteSpace(productName)) return "";
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string sql = "SELECT TOP 1 ImageUrl FROM Products WHERE LOWER(Name) = LOWER(@Name) AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", productName.Trim());
                        object res = cmd.ExecuteScalar();
                        if (res != null && res != DBNull.Value)
                            return res.ToString();
                    }
                }
            }
            catch { }
            return "";
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string medName = hfDiagnosedMedicineName.Value;
            decimal medPrice = 0;
            decimal.TryParse(hfDiagnosedMedicinePrice.Value, out medPrice);
            string medImg = hfDiagnosedMedicineImage.Value;

            if (string.IsNullOrEmpty(medName))
                return;

            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            bool ok = DbHelper.AddToCart(email, medName, medPrice, 1, medImg);

            if (ok)
            {
                litAlertMsg.Text = $"<strong>Added to Cart!</strong> '{Server.HtmlEncode(medName)}' (&#8377;{medPrice:N0}) has been added to your cart.";
                pnlAlert.CssClass = "alert alert-success d-flex align-items-center justify-content-between p-3 mb-3 rounded-3 shadow-sm";
                pnlAlert.Visible = true;
                (Master as Site1)?.RefreshCartAndWishlistCounts();
            }
            else
            {
                lblError.Visible = true;
                lblError.Text = $"Failed to add '{Server.HtmlEncode(medName)}' to cart. Please try again.";
            }
        }

        protected void btnAddToWishlist_Click(object sender, EventArgs e)
        {
            string medName = hfDiagnosedMedicineName.Value;
            decimal medPrice = 0;
            decimal.TryParse(hfDiagnosedMedicinePrice.Value, out medPrice);
            string medImg = hfDiagnosedMedicineImage.Value;

            if (string.IsNullOrEmpty(medName))
                return;

            string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
            bool ok = DbHelper.AddToWishlist(email, medName, medPrice, medImg);

            if (ok)
            {
                litAlertMsg.Text = $"<strong>Added to Wishlist!</strong> '{Server.HtmlEncode(medName)}' has been saved to your wishlist.";
                pnlAlert.CssClass = "alert alert-info d-flex align-items-center justify-content-between p-3 mb-3 rounded-3 shadow-sm";
                pnlAlert.Visible = true;
                (Master as Site1)?.RefreshCartAndWishlistCounts();
            }
            else
            {
                lblError.Visible = true;
                lblError.Text = $"Failed to add '{Server.HtmlEncode(medName)}' to wishlist.";
            }
        }

        protected void btnCloseResult_Click(object sender, EventArgs e)
        {
            pnlResultCard.Visible = false;
            lblError.Visible = false;
        }

        private void SaveToHistory(string plantName, string diseaseName, string treatment)
        {
            try
            {
                string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string sql = @"INSERT INTO AIDiagnoseHistory (UserEmail, PlantName, DiseaseName, ConfidenceScore, TreatmentRecommendation, DiagnoseDate)
                                   VALUES (@Email, @Plant, @Disease, '95%', @Treatment, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Plant", plantName);
                        cmd.Parameters.AddWithValue("@Disease", diseaseName);
                        cmd.Parameters.AddWithValue("@Treatment", treatment);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch { /* History save is non-critical */ }
        }

        // =========================================================
        // ADMIN DATABASE MANAGEMENT METHODS (Preserved for Admin)
        // =========================================================

        private void LoadDiseaseCatalog()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string sql = "SELECT DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl FROM PlantDiseases ORDER BY DiseaseId DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptDiseaseCatalog.DataSource = dt;
                            rptDiseaseCatalog.DataBind();
                            litRecordCount.Text = dt.Rows.Count.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDiseaseCatalog error: " + ex.Message);
            }
        }

        protected void btnToggleManual_Click(object sender, EventArgs e)
        {
            pnlManualEntry.Visible = !pnlManualEntry.Visible;
            btnToggleManual.Text = pnlManualEntry.Visible ? "✕ Cancel Add Disease" : "➕ Add New Disease to Database";
        }

        protected void btnCancelManual_Click(object sender, EventArgs e)
        {
            pnlManualEntry.Visible = false;
            btnToggleManual.Text = "➕ Add New Disease to Database";
        }

        protected void btnSaveManual_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string plant = txtNewPlantName.Text.Trim();
            string disease = txtNewDiseaseName.Text.Trim();
            string symptoms = txtNewSymptoms.Text.Trim();
            string treatment = txtNewTreatment.Text.Trim();
            string medName = txtNewMedicineName.Text.Trim();
            decimal price = 199;
            decimal.TryParse(txtNewPrice.Text.Trim(), out price);
            string img = ddlNewImage.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
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

                LoadDiseaseCatalog();
                PopulatePlantDropdown();
            }
            catch (Exception ex)
            {
                lblError.Text = "Error saving disease record: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void rptDiseaseCatalog_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int diseaseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteRow")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
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
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string sel = "SELECT PlantName FROM PlantDiseases WHERE DiseaseId = @Id";
                        using (SqlCommand cmd = new SqlCommand(sel, conn))
                        {
                            cmd.Parameters.AddWithValue("@Id", diseaseId);
                            object pName = cmd.ExecuteScalar();
                            if (pName != null)
                            {
                                DiagnosePlant(pName.ToString());
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
