<%@ Page Title="Reports & Analytics - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Reports.aspx.cs"
    Inherits="Project.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .reports-wrapper { max-width: 1200px; margin: 35px auto 60px; padding: 0 15px; }
        .page-header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; flex-wrap: wrap; gap: 15px; }
        .page-header-title { font-size: 26px; font-weight: 700; color: #1e3a1f; display: flex; align-items: center; gap: 12px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 28px; }
        .stat-box { background: #fff; border: 1px solid #dce8db; border-radius: 12px; padding: 22px; box-shadow: 0 3px 14px rgba(0,0,0,0.05); }
        .stat-number { font-size: 28px; font-weight: 800; color: #1e3a1f; margin-top: 6px; }
        .stat-sub { font-size: 13px; color: #627860; font-weight: 500; }
        .card-custom { background: #fff; border: 1px solid #dce8db; border-radius: 12px; box-shadow: 0 3px 14px rgba(0,0,0,0.05); margin-bottom: 28px; overflow: hidden; }
        .card-custom-header { background: #f5faf4; padding: 16px 22px; border-bottom: 1px solid #e2ebe0; font-size: 17px; font-weight: 700; color: #1b351d; display: flex; align-items: center; gap: 10px; }
        .admin-table th { background: #f7faf5; color: #436240; font-weight: 600; font-size: 13px; padding: 12px 16px; }
        .admin-table td { padding: 12px 16px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid #edf2ec; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="reports-wrapper">

        <div class="page-header-box">
            <h1 class="page-header-title">
                <i class="fa-solid fa-chart-line text-success"></i> Sales &amp; Activity Reports
            </h1>
            <a href="AdminDashboard.aspx" class="btn btn-outline-success btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>

        <!-- Analytical Stats Cards -->
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-sub"><i class="fa-solid fa-indian-rupee-sign text-success me-1"></i> Total Revenue</div>
                <div class="stat-number text-success">&#8377;<asp:Literal ID="litRevenue" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-box">
                <div class="stat-sub"><i class="fa-solid fa-box-open text-primary me-1"></i> Total Orders</div>
                <div class="stat-number"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-box">
                <div class="stat-sub"><i class="fa-solid fa-truck text-warning me-1"></i> Placed / In Progress</div>
                <div class="stat-number text-warning"><asp:Literal ID="litPlacedOrders" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-box">
                <div class="stat-sub"><i class="fa-solid fa-circle-check text-success me-1"></i> Delivered Orders</div>
                <div class="stat-number text-success"><asp:Literal ID="litDeliveredOrders" runat="server">0</asp:Literal></div>
            </div>
        </div>

        <!-- Orders Report -->
        <div class="card-custom">
            <div class="card-custom-header">
                <i class="fa-solid fa-receipt text-success"></i> Comprehensive Order Transactions (from SQL Database)
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvOrdersReport" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No orders recorded in database."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="OrderNumber"   HeaderText="Order #" />
                        <asp:BoundField DataField="CustomerName"  HeaderText="Customer" />
                        <asp:BoundField DataField="UserEmail"     HeaderText="Email" />
                        <asp:BoundField DataField="City"          HeaderText="City" />
                        <asp:BoundField DataField="TotalAmount"   HeaderText="Amount (₹)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                        <asp:BoundField DataField="OrderStatus"   HeaderText="Status" />
                        <asp:BoundField DataField="OrderDate"     HeaderText="Date" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Products Stock & Inventory Report -->
        <div class="card-custom">
            <div class="card-custom-header">
                <i class="fa-solid fa-warehouse text-success"></i> Inventory Stock &amp; Pricing Report
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvInventoryReport" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No inventory data."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ProductId"     HeaderText="ID" />
                        <asp:BoundField DataField="Name"          HeaderText="Product" />
                        <asp:BoundField DataField="Category"      HeaderText="Category" />
                        <asp:BoundField DataField="Price"         HeaderText="Price (₹)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="StockQuantity" HeaderText="Stock Level" />
                        <asp:BoundField DataField="CreatedDate"   HeaderText="Added Date" DataFormatString="{0:dd MMM yyyy}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>
