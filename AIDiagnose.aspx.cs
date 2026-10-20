using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class AIDiagnose : System.Web.UI.Page
    {
        string connectionString = DbHelper.GetConnectionString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                // Hide result card on first load
                pnlResultCard.Visible = false;
            }
        }

        // Fires when user selects a plant from the dropdown (AutoPostBack)
        protected void ddlPlant_SelectedIndexChanged(object sender, EventArgs e)
        {
            string plantName = ddlPlant.SelectedValue;
            if (!string.IsNullOrEmpty(plantName))
            {
                LoadDiagnosisResult(plantName);
            }
            else
            {
                pnlResultCard.Visible = false;
            }
        }

        // Fires when user clicks "Diagnose Plant" button
        protected void btnDiagnose_Click(object sender, EventArgs e)
        {
            string plantName = ddlPlant.SelectedValue;
            if (string.IsNullOrEmpty(plantName))
            {
                lblError.Visible = true;
                lblError.Text = "Please select a plant from the dropdown to diagnose.";
                pnlResultCard.Visible = false;
                return;
            }
            lblError.Visible = false;
            LoadDiagnosisResult(plantName);
        }

        private void LoadDiagnosisResult(string plantName)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Query PlantDiseases table for the selected plant
                    string sql = @"SELECT TOP 1 PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, ImageUrl
                                   FROM PlantDiseases
                                   WHERE LOWER(PlantName) LIKE @Plant
                                   ORDER BY DiseaseId ASC";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Plant", "%" + plantName.ToLower().Split('(')[0].Trim() + "%");

                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string disease = r["DiseaseName"] != DBNull.Value ? r["DiseaseName"].ToString() : "No disease detected";
                                string symptoms = r["Symptoms"] != DBNull.Value ? r["Symptoms"].ToString() : "No symptoms recorded";
                                string treatment = r["Treatment"] != DBNull.Value ? r["Treatment"].ToString() : "No treatment data";
                                string medicine = r["MedicineName"] != DBNull.Value ? r["MedicineName"].ToString() : "";
                                string imageUrl = r["ImageUrl"] != DBNull.Value ? r["ImageUrl"].ToString() : "";
                                decimal price = r["MedicinePrice"] != DBNull.Value ? Convert.ToDecimal(r["MedicinePrice"]) : 0;

                                // Populate result card labels
                                lblPlantTitle.Text = r["PlantName"].ToString();
                                lblDiseaseTitle.Text = disease;

                                // Format symptoms as list items
                                string[] symptomParts = symptoms.Split(',');
                                string symptomsHtml = "<ul style='margin:0; padding-left:16px;'>";
                                foreach (string s in symptomParts)
                                    if (!string.IsNullOrWhiteSpace(s))
                                        symptomsHtml += "<li>" + s.Trim() + "</li>";
                                symptomsHtml += "</ul>";
                                litSymptoms.Text = symptomsHtml;

                                // Format treatment as numbered steps
                                string[] steps = treatment.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries);
                                string treatHtml = "<ol style='margin:6px 0 0; padding-left:18px;'>";
                                foreach (string step in steps)
                                {
                                    string cleaned = step.Trim().TrimStart('1', '2', '3', '4', '5', '6', '7', '8', '9', '.', ' ');
                                    if (!string.IsNullOrWhiteSpace(cleaned))
                                        treatHtml += "<li style='margin-bottom:4px;'>" + cleaned + "</li>";
                                }
                                treatHtml += "</ol>";

                                // Add medicine info at bottom of treatment
                                if (!string.IsNullOrEmpty(medicine))
                                {
                                    treatHtml += "<div style='margin-top:10px; padding:8px 12px; background:#f0faf0; border-radius:6px; border:1px solid #b8dbb5;'>"
                                               + "<strong style='color:#218c2b;'>&#128200; Recommended Product:</strong> "
                                               + medicine + " &mdash; <strong>&#8377;" + price.ToString("N0") + "</strong>"
                                               + "</div>";
                                }

                                litTreatmentText.Text = treatHtml;

                                // Set plant image
                                if (!string.IsNullOrEmpty(imageUrl))
                                {
                                    imgDiagnosed.ImageUrl = "~/" + imageUrl.TrimStart('/');
                                    imgDiagnosed.AlternateText = r["PlantName"].ToString();
                                }
                                else
                                {
                                    imgDiagnosed.ImageUrl = "~/image/ai-plant-doctor.png";
                                }

                                pnlResultCard.Visible = true;

                                // Save to AIDiagnoseHistory
                                SaveToHistory(plantName, disease, treatment);
                            }
                            else
                            {
                                // No record found — show friendly message
                                lblPlantTitle.Text = plantName;
                                lblDiseaseTitle.Text = "No disease record found";
                                litSymptoms.Text = "<p style='color:#637667;'>No disease data available for this plant yet. The admin can add records via the Disease Database.</p>";
                                litTreatmentText.Text = "<p style='color:#637667;'>Please consult your local agriculture expert or check back after the database is updated.</p>";
                                imgDiagnosed.ImageUrl = "~/image/ai-plant-doctor.png";
                                imgDiagnosed.AlternateText = plantName;
                                pnlResultCard.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Visible = true;
                lblError.Text = "Error loading diagnosis: " + ex.Message;
                pnlResultCard.Visible = false;
            }
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
    }
}
