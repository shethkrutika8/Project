<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AIDiagnosesManagement.aspx.cs" Inherits="Project.AIDiagnosesManagement" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AI Diagnoses - AgriCulture</title>
    
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
            background-color: #f5f7fa;
            color: #333;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #198754 0%, #146c43 100%);
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-brand {
            padding: 0 24px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .sidebar-brand h2 {
            font-size: 1.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-brand i {
            font-size: 1.8rem;
        }

        .sidebar-nav {
            padding: 0 16px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 4px;
            transition: all 0.2s;
        }

        .nav-item:hover,
        .nav-item.active {
            background-color: rgba(255, 255, 255, 0.15);
            color: white;
        }

        .nav-item i {
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #333;
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

        .btn-primary {
            background-color: #198754;
            color: white;
        }

        .btn-primary:hover {
            background-color: #146c43;
        }

        .btn-outline {
            background-color: white;
            border: 1px solid #d0d7de;
            color: #333;
        }

        .btn-outline:hover {
            background-color: #f5f7fa;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            border: 1px solid #eaeaea;
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }

        .stat-icon.total {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .stat-icon.healthy {
            background-color: #e8f5e9;
            color: #198754;
        }

        .stat-icon.attention {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .stat-icon.critical {
            background-color: #fee;
            color: #dc3545;
        }

        .stat-card h3 {
            font-size: 0.9rem;
            color: #666;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .stat-card .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
        }

        /* Diagnoses Table Card */
        .table-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            border: 1px solid #eaeaea;
            overflow: hidden;
        }

        .card-header {
            padding: 24px;
            border-bottom: 1px solid #eaeaea;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .search-box {
            position: relative;
            width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 40px 10px 16px;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            font-size: 0.9rem;
            outline: none;
        }

        .search-box input:focus {
            border-color: #198754;
            box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.1);
        }

        .search-box i {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .filter-group {
            display: flex;
            gap: 12px;
        }

        .filter-select {
            padding: 10px 16px;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #555;
            outline: none;
            background-color: white;
        }

        .filter-select:focus {
            border-color: #198754;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            font-size: 0.85rem;
            font-weight: 600;
            color: #666;
            border-bottom: 2px solid #eaeaea;
            padding: 16px;
            background-color: #f8f9fa;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table tbody td {
            font-size: 0.95rem;
            color: #333;
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .plant-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .plant-image {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .plant-image i {
            font-size: 1.5rem;
            color: #198754;
        }

        .plant-details h5 {
            font-size: 0.95rem;
            font-weight: 600;
            color: #333;
            margin: 0 0 2px 0;
        }

        .plant-details p {
            font-size: 0.85rem;
            color: #888;
            margin: 0;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-badge.healthy {
            background-color: #e8f5e9;
            color: #198754;
        }

        .status-badge.attention {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .status-badge.critical {
            background-color: #fee;
            color: #dc3545;
        }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            border: 1px solid #d0d7de;
            background: white;
            color: #555;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }

        .action-btn:hover {
            background-color: #f5f7fa;
            color: #198754;
            border-color: #198754;
        }

        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
                padding: 16px 8px;
            }

            .sidebar-brand h2 span,
            .nav-item span {
                display: none;
            }

            .main-content {
                margin-left: 70px;
                padding: 16px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <h2>
                        <i class="fa-solid fa-leaf"></i>
                        <span>AgriCulture</span>
                    </h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="AdminDashboard.aspx" class="nav-item">
                        <i class="fa-solid fa-gauge-high"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="AdminManagement.aspx" class="nav-item">
                        <i class="fa-solid fa-users"></i>
                        <span>Users</span>
                    </a>
                    <a href="AdminProducts.aspx" class="nav-item">
                        <i class="fa-solid fa-seedling"></i>
                        <span>Plants</span>
                    </a>
                    <a href="AIDiagnosesManagement.aspx" class="nav-item active">
                        <i class="fa-solid fa-robot"></i>
                        <span>AI Analyses</span>
                    </a>
                    <a href="Reports.aspx" class="nav-item">
                        <i class="fa-solid fa-chart-line"></i>
                        <span>Reports</span>
                    </a>
                    <a href="AdminOrders.aspx" class="nav-item">
                        <i class="fa-solid fa-box-open"></i>
                        <span>Orders</span>
                    </a>
                    <a href="Settings.aspx" class="nav-item">
                        <i class="fa-solid fa-gear"></i>
                        <span>Settings</span>
                    </a>
                    <a href="Dashboard.aspx" class="nav-item">
                        <i class="fa-solid fa-store"></i>
                        <span>View Store</span>
                    </a>
                </nav>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>AI Diagnoses Overview</h1>
                    <div class="header-actions">
                        <a href="AIDiagnose.aspx" class="btn-action btn-outline">
                            <i class="fa-solid fa-stethoscope"></i>
                            Run AI Scan
                        </a>
                        <a href="AIDiagnose.aspx" class="btn-action btn-primary">
                            <i class="fa-solid fa-plus"></i>
                            New Diagnosis
                        </a>
                    </div>
                </div>

                <!-- Server Alert Feedback -->
                <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show mb-4">
                    <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
                </asp:Panel>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-icon total">
                                <i class="fa-solid fa-robot"></i>
                            </div>
                        </div>
                        <h3>Total Conditions in DB</h3>
                        <div class="stat-value"><asp:Literal ID="litTotalDiagnoses" runat="server">0</asp:Literal></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-icon healthy">
                                <i class="fa-solid fa-circle-check"></i>
                            </div>
                        </div>
                        <h3>Healthy Records</h3>
                        <div class="stat-value"><asp:Literal ID="litHealthyCount" runat="server">0</asp:Literal></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-icon attention">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                            </div>
                        </div>
                        <h3>Treatable Conditions</h3>
                        <div class="stat-value"><asp:Literal ID="litAttentionCount" runat="server">0</asp:Literal></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-icon critical">
                                <i class="fa-solid fa-circle-exclamation"></i>
                            </div>
                        </div>
                        <h3>Critical Diseases</h3>
                        <div class="stat-value"><asp:Literal ID="litCriticalCount" runat="server">0</asp:Literal></div>
                    </div>
                </div>

                <!-- Diagnoses Table Card -->
                <div class="table-card">
                    <div class="card-header">
                        <div class="search-box">
                            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search plant or disease..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </div>
                        <div class="filter-group">
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                                <asp:ListItem Text="All Conditions" Value="All" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Mild / Moderate" Value="Mild"></asp:ListItem>
                                <asp:ListItem Text="Critical / Severe" Value="Critical"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <asp:GridView ID="gvDiagnoses" runat="server"
                            CssClass="table align-middle mb-0"
                            AutoGenerateColumns="false"
                            GridLines="None"
                            EmptyDataText="No disease records found in the database.">
                            <Columns>
                                <asp:BoundField DataField="DiseaseId" HeaderText="#" />
                                <asp:TemplateField HeaderText="Plant Name">
                                    <ItemTemplate>
                                        <div class="plant-info">
                                            <div class="plant-image">
                                                <i class="fa-solid fa-seedling"></i>
                                            </div>
                                            <div class="plant-details">
                                                <h5><%# Eval("PlantName") %></h5>
                                                <p>Botanical Specimen</p>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Condition / Diagnosis">
                                    <ItemTemplate>
                                        <span class="status-badge attention"><%# Eval("DiseaseName") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Symptoms" HeaderText="Symptoms" />
                                <asp:BoundField DataField="Treatment" HeaderText="Recommended Treatment" />
                                <asp:TemplateField HeaderText="Prescribed Medicine">
                                    <ItemTemplate>
                                        <strong><%# Eval("MedicineName") %></strong>
                                        <br /><small class="text-success">&#8377;<%# Convert.ToDecimal(Eval("MedicinePrice")).ToString("N0") %></small>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <a href='AIDiagnose.aspx' class="action-btn" title="View / Diagnose">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </main>
        </div>
    </form>

    <!-- No JavaScript - using only ASP.NET server-side validation -->
</body>
</html>
