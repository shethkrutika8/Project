using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class AIDiagnosesManagement : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Krutika_24SOECE11036_.NET\\Project\\App_Data\\Database1.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DbHelper.EnsureDatabaseTablesExist();
                LoadDiagnosesData();
            }
        }

        private void LoadDiagnosesData()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Load stats
                    string countSql = "SELECT COUNT(*) FROM PlantDiseases";
                    using (SqlCommand countCmd = new SqlCommand(countSql, con))
                    {
                        int total = Convert.ToInt32(countCmd.ExecuteScalar());
                        litTotalDiagnoses.Text = total.ToString();
                        litHealthyCount.Text = "642";
                        litAttentionCount.Text = total.ToString();
                        litCriticalCount.Text = "23";
                    }

                    // Query records
                    string query = "SELECT DiseaseId, PlantName, DiseaseName, Symptoms, Treatment, MedicineName, MedicinePrice, MedicineImage FROM PlantDiseases WHERE 1=1";
                    string searchTerm = txtSearch.Text.Trim();
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        query += " AND (PlantName LIKE @Search OR DiseaseName LIKE @Search OR Symptoms LIKE @Search)";
                    }

                    query += " ORDER BY DiseaseId DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                        }

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvDiagnoses.DataSource = dt;
                        gvDiagnoses.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "alert alert-danger mb-4";
                litAlertMsg.Text = "Error loading diagnosis data: " + ex.Message;
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadDiagnosesData();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDiagnosesData();
        }
    }
}
