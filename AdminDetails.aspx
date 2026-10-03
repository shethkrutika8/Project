<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDetails.aspx.cs" Inherits="Project.AdminDetails" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Details - AgriCulture</title>
    
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
            max-width: 1200px;
            margin: 0 auto;
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

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 32px;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .admin-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #198754 0%, #146c43 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: 700;
        }

        .admin-info h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 4px;
        }

        .admin-info p {
            font-size: 0.95rem;
            color: #666;
            margin: 0;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            text-decoration: none;
        }

        .btn-secondary {
            background-color: white;
            border: 1px solid #d0d7de;
            color: #555;
        }

        .btn-secondary:hover {
            background-color: #f5f7fa;
        }

        .btn-primary {
            background-color: #198754;
            color: white;
        }

        .btn-primary:hover {
            background-color: #146c43;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Tabs */
        .tabs {
            display: flex;
            gap: 4px;
            margin-bottom: 24px;
            border-bottom: 2px solid #eaeaea;
        }

        .tab {
            padding: 12px 24px;
            font-size: 0.95rem;
            font-weight: 500;
            color: #666;
            background: none;
            border: none;
            cursor: pointer;
            position: relative;
            transition: color 0.2s;
            text-decoration: none;
        }

        .tab:hover {
            color: #198754;
        }

        .tab.active {
            color: #198754;
        }

        .tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #198754;
        }

        /* Content Cards */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #eaeaea;
            overflow: hidden;
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #eaeaea;
        }

        .card-header h3 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #333;
            margin: 0;
        }

        .card-body {
            padding: 24px;
        }

        /* Info List */
        .info-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 16px;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .info-label {
            font-size: 0.9rem;
            color: #666;
            font-weight: 500;
        }

        .info-value {
            font-size: 0.95rem;
            color: #333;
            font-weight: 600;
        }

        /* Permissions */
        .permissions-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .permission-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .permission-item i {
            color: #198754;
            font-size: 1rem;
        }

        .permission-item span {
            font-size: 0.9rem;
            color: #333;
            font-weight: 500;
        }

        /* Activity Log */
        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            flex-shrink: 0;
        }

        .activity-icon.login {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .activity-icon.update {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .activity-icon.create {
            background-color: #e8f5e9;
            color: #198754;
        }

        .activity-icon.delete {
            background-color: #fee;
            color: #dc3545;
        }

        .activity-content {
            flex: 1;
        }

        .activity-content h4 {
            font-size: 0.9rem;
            font-weight: 600;
            color: #333;
            margin: 0 0 4px 0;
        }

        .activity-content p {
            font-size: 0.85rem;
            color: #888;
            margin: 0;
        }

        .activity-time {
            font-size: 0.75rem;
            color: #aaa;
        }

        /* Security Section */
        .security-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .security-info h4 {
            font-size: 0.95rem;
            font-weight: 600;
            color: #333;
            margin: 0 0 4px 0;
        }

        .security-info p {
            font-size: 0.85rem;
            color: #888;
            margin: 0;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 0.85rem;
        }

        @media (max-width: 992px) {
            .navbar {
                padding: 16px 20px;
            }

            .navbar-nav {
                display: none;
            }

            .main-content {
                padding: 20px;
            }

            .content-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                gap: 16px;
            }

            .header-actions {
                width: 100%;
                justify-content: flex-start;
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
                <span>Admin Details</span>
            </div>

            <!-- Server Alert Panel -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show mb-4">
                <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            </asp:Panel>

            <!-- Page Header -->
            <div class="page-header">
                <div class="admin-profile">
                    <div class="admin-avatar-large">
                        <asp:Literal ID="litAvatarInitials" runat="server">AD</asp:Literal>
                    </div>
                    <div class="admin-info">
                        <h1><asp:Literal ID="litAdminNameHeader" runat="server">Admin User</asp:Literal></h1>
                        <p><asp:Literal ID="litAdminSubtitle" runat="server">Administrator • admin@agriculture.com</asp:Literal></p>
                    </div>
                </div>
                <div class="header-actions">
                    <a href="AdminManagement.aspx" class="btn-action btn-secondary">
                        <i class="fa-solid fa-pen"></i>
                        Edit
                    </a>
                    <asp:LinkButton ID="btnResetPass" runat="server" CssClass="btn-action btn-primary" OnClick="btnResetPass_Click">
                        <i class="fa-solid fa-key"></i>
                        Reset Password
                    </asp:LinkButton>
                    <a href="AdminManagement.aspx" class="btn-action btn-danger">
                        <i class="fa-solid fa-users"></i>
                        Manage Users
                    </a>
                </div>
            </div>

            <!-- Pure C# Server-Side Tabs (No JavaScript) -->
            <div class="tabs">
                <asp:LinkButton ID="tabOverviewBtn" runat="server" CssClass="tab active" OnClick="tabOverview_Click">Overview</asp:LinkButton>
                <asp:LinkButton ID="tabPermissionsBtn" runat="server" CssClass="tab" OnClick="tabPermissions_Click">Permissions</asp:LinkButton>
                <asp:LinkButton ID="tabActivityBtn" runat="server" CssClass="tab" OnClick="tabActivity_Click">Activity Log</asp:LinkButton>
                <asp:LinkButton ID="tabSecurityBtn" runat="server" CssClass="tab" OnClick="tabSecurity_Click">Security</asp:LinkButton>
            </div>

            <!-- Overview Tab -->
            <asp:Panel ID="pnlOverview" runat="server" Visible="true">
                <div class="content-grid">
                    <div class="card">
                        <div class="card-header">
                            <h3>Personal Information</h3>
                        </div>
                        <div class="card-body">
                            <div class="info-list">
                                <div class="info-item">
                                    <span class="info-label">Full Name</span>
                                    <span class="info-value"><asp:Literal ID="litFullName" runat="server">-</asp:Literal></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Email Address</span>
                                    <span class="info-value"><asp:Literal ID="litEmail" runat="server">-</asp:Literal></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Phone Number</span>
                                    <span class="info-value"><asp:Literal ID="litContact" runat="server">-</asp:Literal></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">City</span>
                                    <span class="info-value"><asp:Literal ID="litCity" runat="server">-</asp:Literal></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Role</span>
                                    <span class="info-value"><asp:Literal ID="litRole" runat="server">Admin</asp:Literal></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Status</span>
                                    <span class="info-value" style="color: #198754;">Active</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3>Assigned Permissions</h3>
                        </div>
                        <div class="card-body">
                            <div class="permissions-list">
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>Dashboard Access</span>
                                </div>
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>User Management</span>
                                </div>
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>Plant Management</span>
                                </div>
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>AI Diagnose Access</span>
                                </div>
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>Order Management</span>
                                </div>
                                <div class="permission-item">
                                    <i class="fa-solid fa-check-circle"></i>
                                    <span>Reports Access</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Permissions Tab -->
            <asp:Panel ID="pnlPermissions" runat="server" Visible="false">
                <div class="card">
                    <div class="card-header">
                        <h3>All Permissions</h3>
                    </div>
                    <div class="card-body">
                        <div class="permissions-list">
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>Dashboard Access - Full access to analytical dashboards</span>
                            </div>
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>User Management - Add, edit and toggle roles of accounts</span>
                            </div>
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>Plant &amp; Products - Manage products catalog and database</span>
                            </div>
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>AI Diagnose - Manage plant disease models and treatments</span>
                            </div>
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>Orders Management - Update order statuses and tracking</span>
                            </div>
                            <div class="permission-item">
                                <i class="fa-solid fa-check-circle"></i>
                                <span>Reports Access - View financial reports, sales analytics</span>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Activity Log Tab -->
            <asp:Panel ID="pnlActivity" runat="server" Visible="false">
                <div class="card">
                    <div class="card-header">
                        <h3>Recent Activity</h3>
                    </div>
                    <div class="card-body">
                        <div class="activity-list">
                            <div class="activity-item">
                                <div class="activity-icon login">
                                    <i class="fa-solid fa-right-to-bracket"></i>
                                </div>
                                <div class="activity-content">
                                    <h4>Logged in to AgriCulture Dashboard</h4>
                                    <p>Active authenticated administrator session</p>
                                </div>
                                <span class="activity-time">Active now</span>
                            </div>
                            <div class="activity-item">
                                <div class="activity-icon update">
                                    <i class="fa-solid fa-pen"></i>
                                </div>
                                <div class="activity-content">
                                    <h4>System Database Verification</h4>
                                    <p>Connected to SQL Server LocalDB</p>
                                </div>
                                <span class="activity-time">Recently</span>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Security Tab -->
            <asp:Panel ID="pnlSecurity" runat="server" Visible="false">
                <div class="card">
                    <div class="card-header">
                        <h3>Security Settings</h3>
                    </div>
                    <div class="card-body">
                        <div class="security-item">
                            <div class="security-info">
                                <h4>Account Password</h4>
                                <p>Encrypted in SQL Server Register table</p>
                            </div>
                            <a href="Settings.aspx" class="btn-action btn-primary btn-sm">
                                <i class="fa-solid fa-key"></i>
                                Change in Settings
                            </a>
                        </div>
                        <div class="security-item">
                            <div class="security-info">
                                <h4>Account Role &amp; Access Level</h4>
                                <p>Access: Full System Administrator</p>
                            </div>
                            <a href="AdminManagement.aspx" class="btn-action btn-secondary btn-sm">
                                <i class="fa-solid fa-shield"></i>
                                Manage Roles
                            </a>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </main>
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
