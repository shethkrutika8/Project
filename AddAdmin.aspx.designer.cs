namespace Project
{
    public partial class AddAdmin
    {
        protected global::System.Web.UI.HtmlControls.HtmlForm form1;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Literal litAlertMsg;
        protected global::System.Web.UI.WebControls.ValidationSummary vsAddAdmin;
        protected global::System.Web.UI.WebControls.TextBox txtFullName;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvFullName;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvEmail;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator revEmail;
        protected global::System.Web.UI.WebControls.DropDownList ddlRole;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvRole;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvPhone;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator revPhone;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvPassword;
        protected global::System.Web.UI.WebControls.TextBox txtConfirmPassword;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvConfirmPassword;
        protected global::System.Web.UI.WebControls.CompareValidator cvConfirmPassword;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatus;
        protected global::System.Web.UI.WebControls.CheckBox chkPermDashboard;
        protected global::System.Web.UI.WebControls.CheckBox chkPermUsers;
        protected global::System.Web.UI.WebControls.CheckBox chkPermPlants;
        protected global::System.Web.UI.WebControls.CheckBox chkPermAI;
        protected global::System.Web.UI.WebControls.CheckBox chkPermContent;
        protected global::System.Web.UI.WebControls.CheckBox chkPermOrders;
        protected global::System.Web.UI.WebControls.CheckBox chkPermReports;
        protected global::System.Web.UI.WebControls.CheckBox chkPermSettings;
        protected global::System.Web.UI.WebControls.CheckBox chkPermNotifications;
        protected global::System.Web.UI.WebControls.CheckBox chkPermLogs;
        protected global::System.Web.UI.WebControls.Button btnCreateAdmin;
    }
}
