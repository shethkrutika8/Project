using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class Features : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Page loaded successfully without unnecessary reloads
            }
        }

        protected void Explore_btn_Click(object sender, EventArgs e)
        {
            // Redirect user to explore products / diagnosis tools
            Response.Redirect("Products.aspx");
        }

        protected void btnGetStartedFree_Click(object sender, EventArgs e)
        {
            // Direct to registration flow
            Response.Redirect("Register.aspx");
        }
    }
}