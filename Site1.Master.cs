using System;
using System.Web;
using System.Web.UI;
using Project.Models;

namespace Project
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateNavUserState();
            // Always refresh dynamic counts from database
            RefreshCartAndWishlistCounts();
        }

        public void UpdateNavUserState()
        {
            if (Session["UserEmail"] != null && !string.IsNullOrEmpty(Session["UserEmail"].ToString()))
            {
                string email = Session["UserEmail"].ToString();
                bool isAdmin = Session["Role"] != null && Session["Role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase);
                string displayName = email.Contains("@") ? email.Split('@')[0] : email;
                litUserEmail.Text = isAdmin ? ("<span class='badge bg-warning text-dark me-1'>ADMIN</span> " + displayName) : displayName;
                pnlUser.Visible = true;
                pnlGuest.Visible = false;
            }
            else
            {
                pnlUser.Visible = false;
                pnlGuest.Visible = true;
            }
        }

        public void RefreshCartAndWishlistCounts()
        {
            try
            {
                string email = DbHelper.GetCurrentUserEmail(HttpContext.Current);
                int cartCount = DbHelper.GetCartCount(email);
                int wishCount = DbHelper.GetWishlistCount(email);

                litCartCount.Text = cartCount.ToString();
                litWishlistCount.Text = wishCount.ToString();
            }
            catch
            {
                litCartCount.Text = "0";
                litWishlistCount.Text = "0";
            }
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}