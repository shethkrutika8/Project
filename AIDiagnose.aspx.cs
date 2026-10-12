using System;
using System.Web.UI;

namespace Project
{
    public partial class AIDiagnose : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Static representation of the AI Plant Doctor page.
            // All plant diseases, botanical remedies, and diagnosis history remain safely saved
            // in the SQL Server database (PlantDiseases and AIDiagnoseHistory tables).
            // Dynamic fetching from the database on this page is disabled as requested.
        }
    }
}
