<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAdmin.aspx.cs" Inherits="Project.AddAdmin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add New Admin - AgriCulture</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        /* Navbar */
        .navbar {
            background-color: white;
            padding: 16px 40px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            border-bottom: 1px solid #eaeaea;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 700;
            color: #198754;
            text-decoration: none;
        }

        .navbar-brand i {
            font-size: 1.8rem;
        }

        .navbar-nav {
            display: flex;
            gap: 32px;
            align-items: center;
        }

        .nav-link {
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            color: #555;
            transition: color 0.2s;
        }

        .nav-link:hover,
        .nav-link.active {
            color: #198754;
        }

        .nav-link.sign-out {
            color: #dc3545;
        }

        .btn-get-started {
            background-color: #198754;
            color: white;
            padding: 10px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: background-color 0.2s;
        }

        .btn-get-started:hover {
            background-color: #146c43;
            color: white;
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 32px;
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .page-header p {
            font-size: 1rem;
            color: #666;
            margin: 0;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
        }

        .breadcrumb a {
            color: #198754;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb span {
            color: #999;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #eaeaea;
            overflow: hidden;
        }

        .card-header {
            padding: 24px;
            border-bottom: 1px solid #eaeaea;
        }

        .card-header h3 {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
            margin: 0;
        }

        .card-body {
            padding: 32px;
        }

        .form-section {
            margin-bottom: 32px;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #eaeaea;
        }

        .form-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .form-control {
            padding: 12px 16px;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            font-size: 0.95rem;
            color: #333;
        }

        .form-control:focus {
            border-color: #198754;
            box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.1);
        }

        .form-control::placeholder {
            color: #aaa;
        }

        .form-select {
            padding: 12px 16px;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            font-size: 0.95rem;
            color: #333;
        }

        .form-select:focus {
            border-color: #198754;
            box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        /* Permissions */
        .permissions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .permission-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border: 1px solid #eaeaea;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .permission-item:hover {
            background-color: #f8f9fa;
            border-color: #198754;
        }

        .permission-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #198754;
            cursor: pointer;
        }

        .permission-item label {
            font-size: 0.9rem;
            color: #555;
            cursor: pointer;
            margin: 0;
            flex: 1;
        }

        /* Buttons */
        .card-footer {
            padding: 24px 32px;
            border-top: 1px solid #eaeaea;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background-color: #f8f9fa;
        }

        .btn-cancel {
            background-color: white;
            color: #555;
            padding: 12px 32px;
            border-radius: 8px;
            border: 1px solid #d0d7de;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            line-height: normal;
        }

        .btn-cancel:hover {
            background-color: #f5f7fa;
            border-color: #999;
            color: #333;
        }

        .btn-create {
            background-color: #198754;
            color: white;
            padding: 12px 32px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-create:hover {
            background-color: #146c43;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 16px 20px;
            }

            .navbar-nav {
                display: none;
            }

            .main-content {
                padding: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .permissions-grid {
                grid-template-columns: 1fr;
            }

            .card-footer {
                flex-direction: column;
            }

            .btn-cancel,
            .btn-create {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <nav class="navbar">
            <div class="d-flex align-items-center justify-content-between w-100">
                <a href="Dashboard.aspx" class="navbar-brand">
                    <i class="fa-solid fa-leaf"></i>
                    <span>AgriCulture</span>
                </a>
                
                <div class="navbar-nav">
                    <a href="AdminDashboard.aspx" class="nav-link">Dashboard</a>
                    <a href="AdminProducts.aspx" class="nav-link">Plants</a>
                    <a href="AIDiagnose.aspx" class="nav-link">AI Diagnose</a>
                    <a href="AdminManagement.aspx" class="nav-link">Users</a>
                    <a href="AdminOrders.aspx" class="nav-link">Orders</a>
                    <a href="AdminManagement.aspx" class="nav-link active">Admin</a>
                    <a href="Login.aspx?logout=1" class="nav-link sign-out">Sign Out</a>
                </div>

                <a href="AdminDashboard.aspx" class="btn-get-started">Admin Portal</a>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="breadcrumb">
                <a href="AdminDashboard.aspx">Admin</a>
                <span>/</span>
                <a href="AdminManagement.aspx">Manage Admins</a>
                <span>/</span>
                <span>Add New Admin</span>
            </div>

            <div class="page-header">
                <h1>Add New Admin</h1>
                <p>Fill in the details below to create a new admin account</p>
            </div>

            <!-- Server-Side Alert Feedback Panel -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show mb-4">
                <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            </asp:Panel>

            <!-- ASP.NET Server-Side Validation Summary (NO JavaScript) -->
            <asp:ValidationSummary ID="vsAddAdmin" runat="server"
                ValidationGroup="vgAddAdmin"
                CssClass="alert alert-danger py-2 mb-4"
                HeaderText="Please correct the following errors:"
                EnableClientScript="false"
                ShowMessageBox="false"
                ShowSummary="true" />

            <!-- Form Card -->
            <div class="form-card">
                <div class="card-header">
                    <h3>Admin Information</h3>
                </div>

                <div class="card-body">
                    <!-- Admin Information Section -->
                    <div class="form-section">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Full Name *</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter full name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                    ControlToValidate="txtFullName"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Full Name is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email address"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Email Address is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Please enter a valid email address."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Role *</label>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select role" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Super Admin" Value="Super Admin"></asp:ListItem>
                                    <asp:ListItem Text="Admin" Value="Admin" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Moderator" Value="Moderator"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvRole" runat="server"
                                    ControlToValidate="ddlRole"
                                    InitialValue=""
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Role selection is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter 10-digit phone number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Phone number is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Phone number must be exactly 10 digits."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    ValidationExpression="^\d{10}$"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Password *</label>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                    ControlToValidate="txtPassword"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Password is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Confirm Password *</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Confirm Password is required."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                                <asp:CompareValidator ID="cvConfirmPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ControlToCompare="txtPassword"
                                    ValidationGroup="vgAddAdmin"
                                    ErrorMessage="Passwords do not match."
                                    ForeColor="#FF3300"
                                    EnableClientScript="false"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Active" Value="active" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="inactive"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <!-- Permissions Section -->
                    <div class="form-section">
                        <h4 class="section-title">Permissions</h4>
                        <div class="permissions-grid">
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermDashboard" runat="server" Checked="true" Text="Dashboard Access" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermUsers" runat="server" Checked="true" Text="User Management" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermPlants" runat="server" Checked="true" Text="Plant Management" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermAI" runat="server" Text="AI Diagnose Access" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermContent" runat="server" Text="Content Management" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermOrders" runat="server" Text="Order Management" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermReports" runat="server" Text="Reports Access" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermSettings" runat="server" Text="Settings Access" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermNotifications" runat="server" Text="Send Notifications" />
                            </div>
                            <div class="permission-item">
                                <asp:CheckBox ID="chkPermLogs" runat="server" Text="View System Logs" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <a href="AdminManagement.aspx" class="btn-cancel">Cancel</a>
                    <asp:Button ID="btnCreateAdmin" runat="server"
                        Text="Create Admin"
                        ValidationGroup="vgAddAdmin"
                        CssClass="btn-create"
                        OnClick="btnCreateAdmin_Click" />
                </div>
            </div>
        </main>
    </form>

    <!-- No JavaScript - using only ASP.NET server-side validation -->
</body>
</html>
