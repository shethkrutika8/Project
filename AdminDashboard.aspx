<%@ Page Title="Admin Dashboard - AgriConnect" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AdminDashboard.aspx.cs"
    Inherits="Project.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-wrapper {
            max-width: 1200px;
            margin: 35px auto 60px;
            padding: 0 15px;
        }
        .admin-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .admin-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e3a1f;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .admin-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid #dce8db;
            border-radius: 12px;
            padding: 22px 24px;
            display: flex;
            align-items: center;
            gap: 18px;
            box-shadow: 0 3px 14px rgba(0,0,0,0.05);
        }
        .stat-icon-box {
            width: 54px;
            height: 54px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }
        .stat-icon-green  { background: #edf7eb; color: #2e8b38; }
        .stat-icon-blue   { background: #e8f3ff; color: #1d73c2; }
        .stat-icon-orange { background: #fff5e6; color: #c97320; }
        .stat-icon-red    { background: #fdf0f0; color: #c93434; }
        .stat-value {
            font-size: 30px;
            font-weight: 800;
            color: #1e2e1f;
            line-height: 1;
        }
        .stat-label {
            font-size: 13px;
            color: #556b54;
            margin-top: 4px;
        }
        .admin-section-card {
            background: #fff;
            border: 1px solid #dce8db;
            border-radius: 12px;
            box-shadow: 0 3px 14px rgba(0,0,0,0.05);
            margin-bottom: 28px;
            overflow: hidden;
        }
        .admin-section-header {
            background: #f5faf4;
            padding: 16px 22px;
            border-bottom: 1px solid #e2ebe0;
            font-size: 17px;
            font-weight: 700;
            color: #1b351d;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .admin-table th {
            background: #f7faf5;
            color: #436240;
            font-weight: 600;
            font-size: 13px;
            padding: 12px 16px;
        }
        .admin-table td {
            padding: 13px 16px;
            vertical-align: middle;
            font-size: 14px;
            border-bottom: 1px solid #edf2ec;
        }
        .admin-nav-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .admin-nav-card {
            background: #fff;
            border: 1px solid #dce8db;
            border-radius: 10px;
            padding: 20px 16px;
            text-align: center;
            text-decoration: none;
            color: #1e3a1f;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .admin-nav-card:hover {
            background: #f0faf0;
            border-color: #2e8b38;
            color: #1e3a1f;
            transform: translateY(-2px);
        }
        .admin-nav-card i {
            font-size: 28px;
            margin-bottom: 10px;
            display: block;
            color: #2e8b38;
        }
        .admin-nav-card span {
            font-size: 13px;
            font-weight: 600;
        }
        .badge-status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-placed   { background: #e8f3ff; color: #1d73c2; }
        .badge-confirm  { background: #edf7eb; color: #2e8b38; }
        .badge-shipped  { background: #fff5e6; color: #c97320; }
        .badge-deliver  { background: #d4edda; color: #155724; }
        @media (max-width: 768px) {
            .admin-stats-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 480px) {
            .admin-stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-wrapper">

        <!-- Header -->
        <div class="admin-header">
            <h1 class="admin-title">
                <i class="fa-solid fa-gauge-high text-success"></i>
                Admin Dashboard
            </h1>
            <small class="text-muted">AgriConnect Administration Panel</small>
        </div>

        <!-- Alert Panel -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false"
            CssClass="alert alert-info d-flex align-items-center gap-2 mb-4">
            <i class="fa-solid fa-circle-info"></i>
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Stats Grid (from real database) -->
        <div class="admin-stats-grid">
            <div class="stat-card">
                <div class="stat-icon-box stat-icon-green">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Registered Users</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-box stat-icon-blue">
                    <i class="fa-solid fa-box-open"></i>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotalProducts" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Active Products</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-box stat-icon-orange">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Total Orders</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-box stat-icon-red">
                    <i class="fa-solid fa-seedling"></i>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotalDiseases" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-label">Disease Records</div>
                </div>
            </div>
        </div>

        <!-- Quick Navigation -->
        <div class="admin-nav-cards">
            <a href="AdminOrders.aspx" class="admin-nav-card">
                <i class="fa-solid fa-boxes-packing" style="color: #1976d2;"></i>
                <span>Manage Orders</span>
            </a>
            <a href="AdminManagement.aspx" class="admin-nav-card">
                <i class="fa-solid fa-users"></i>
                <span>Manage Users</span>
            </a>
            <a href="AdminProducts.aspx" class="admin-nav-card">
                <i class="fa-solid fa-seedling"></i>
                <span>Manage Products</span>
            </a>
            <a href="Reports.aspx" class="admin-nav-card">
                <i class="fa-solid fa-receipt"></i>
                <span>View Reports</span>
            </a>
            <a href="AIDiagnose.aspx" class="admin-nav-card">
                <i class="fa-solid fa-leaf"></i>
                <span>AI Diagnose DB</span>
            </a>
            <a href="Products.aspx" class="admin-nav-card">
                <i class="fa-solid fa-shop"></i>
                <span>View Store</span>
            </a>
        </div>

        <!-- Recent Orders -->
        <div class="admin-section-card">
            <div class="admin-section-header d-flex justify-content-between align-items-center">
                <div>
                    <i class="fa-solid fa-receipt text-success me-2"></i> Recent Orders (from SQL Server)
                </div>
                <a href="AdminOrders.aspx" class="btn btn-sm btn-success text-white px-3 fw-bold" style="font-size: 12px;">
                    <i class="fa-solid fa-boxes-packing me-1"></i> Open Order Manager &rarr;
                </a>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvRecentOrders" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No orders placed yet."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="OrderNumber"   HeaderText="Order #"   />
                        <asp:BoundField DataField="UserEmail"     HeaderText="Customer"  />
                        <asp:BoundField DataField="CustomerName"  HeaderText="Name"      />
                        <asp:BoundField DataField="TotalAmount"   HeaderText="Amount (₹)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment"   />
                        <asp:BoundField DataField="OrderStatus"   HeaderText="Status"    />
                        <asp:BoundField DataField="OrderDate"     HeaderText="Date"      DataFormatString="{0:dd MMM yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Recent Users -->
        <div class="admin-section-card">
            <div class="admin-section-header">
                <i class="fa-solid fa-users text-success"></i> Recent Registered Users
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvRecentUsers" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No registered users yet."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Id"      HeaderText="ID"     />
                        <asp:BoundField DataField="name"    HeaderText="Name"   />
                        <asp:BoundField DataField="email"   HeaderText="Email"  />
                        <asp:BoundField DataField="gender"  HeaderText="Gender" />
                        <asp:BoundField DataField="contact" HeaderText="Phone"  />
                        <asp:BoundField DataField="city"    HeaderText="City"   />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>
