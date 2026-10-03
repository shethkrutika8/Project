using System.Web;
using System.Web.Optimization;

namespace Project
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            // REMOVED: All JavaScript bundles - using only ASP.NET server-side validation
            // No JavaScript files in project - only ASP.NET, C#, and CSS

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css"));
        }
    }
}
