<%@ Page Title="Product Management - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="ProductManagement.aspx.cs"
    Inherits="Project.ProductManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        .main-content {
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2rem;
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

        .stat-icon.instock {
            background-color: #e8f5e9;
            color: #198754;
        }

        .stat-icon.low {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .stat-icon.out {
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

        /* Product Card */
        .product-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            border: 1px solid #eaeaea;
            overflow: hidden;
        }

        /* Search and Filter */
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

        /* Table */
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

        .product-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .product-image {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-image i {
            font-size: 1.5rem;
            color: #198754;
        }

        .product-details h5 {
            font-size: 0.95rem;
            font-weight: 600;
            color: #333;
            margin: 0 0 2px 0;
        }

        .product-details p {
            font-size: 0.85rem;
            color: #888;
            margin: 0;
        }

        .category-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .category-badge.plants {
            background-color: #e8f5e9;
            color: #198754;
        }

        .category-badge.seeds {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .category-badge.pots {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .category-badge.tools {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }

        .category-badge.care {
            background-color: #fce4ec;
            color: #c2185b;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-badge.instock {
            background-color: #e8f5e9;
            color: #198754;
        }

        .status-badge.low {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .status-badge.out {
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
            margin-right: 8px;
        }

        .action-btn:hover {
            background-color: #f5f7fa;
            border-color: #198754;
            color: #198754;
        }

        .action-btn.delete:hover {
            border-color: #dc3545;
            color: #dc3545;
        }

        /* Pagination */
        .card-footer {
            padding: 20px 24px;
            border-top: 1px solid #eaeaea;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .pagination-info {
            font-size: 0.9rem;
            color: #666;
        }

        .pagination {
            margin: 0;
        }

        .page-link {
            color: #555;
            border: 1px solid #d0d7de;
            padding: 8px 14px;
            margin: 0 4px;
            border-radius: 6px;
        }

        .page-link:hover {
            background-color: #f5f7fa;
            border-color: #198754;
            color: #198754;
        }

        .page-item.active .page-link {
            background-color: #198754;
            border-color: #198754;
            color: white;
        }

        @media (max-width: 992px) {
            .main-content {
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .card-header {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                width: 100%;
            }

            .filter-group {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="main-content">
        <div class="page-header">
            <h1>Product Management</h1>
            <div class="header-actions">
                <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn-action btn-outline" OnClick="btnExport_Click" />
                <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CssClass="btn-action btn-primary" OnClick="btnAddProduct_Click" />
            </div>
        </div>

        <!-- Server Alert Panel -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show mb-4">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon total">
                        <i class="fa-solid fa-box"></i>
                    </div>
                </div>
                <h3>Total Products</h3>
                <div class="stat-value">
                    <asp:Literal ID="litTotalProducts" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon instock">
                        <i class="fa-solid fa-check-circle"></i>
                    </div>
                </div>
                <h3>In Stock</h3>
                <div class="stat-value">
                    <asp:Literal ID="litInStock" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon low">
                        <i class="fa-solid fa-exclamation-triangle"></i>
                    </div>
                </div>
                <h3>Low Stock</h3>
                <div class="stat-value">
                    <asp:Literal ID="litLowStock" runat="server">0</asp:Literal>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <div class="stat-icon out">
                        <i class="fa-solid fa-times-circle"></i>
                    </div>
                </div>
                <h3>Out of Stock</h3>
                <div class="stat-value">
                    <asp:Literal ID="litOutOfStock" runat="server">0</asp:Literal>
                </div>
            </div>
        </div>

        <!-- Product Card -->
        <div class="product-card">
            <div class="card-header">
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search products..."></asp:TextBox>
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>
                <div class="filter-group">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="filter-select">
                        <asp:ListItem Text="All Categories" Value=""></asp:ListItem>
                        <asp:ListItem Text="Plants" Value="Plants"></asp:ListItem>
                        <asp:ListItem Text="Seeds" Value="Seeds"></asp:ListItem>
                        <asp:ListItem Text="Pots & Planters" Value="Pots"></asp:ListItem>
                        <asp:ListItem Text="Tools" Value="Tools"></asp:ListItem>
                        <asp:ListItem Text="Plant Care" Value="Care"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-select">
                        <asp:ListItem Text="All Status" Value=""></asp:ListItem>
                        <asp:ListItem Text="In Stock" Value="In Stock"></asp:ListItem>
                        <asp:ListItem Text="Low Stock" Value="Low Stock"></asp:ListItem>
                        <asp:ListItem Text="Out of Stock" Value="Out of Stock"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-sm btn-success" OnClick="btnFilter_Click" />
                </div>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="gvProducts" runat="server"
                    CssClass="table"
                    AutoGenerateColumns="false"
                    EmptyDataText="No products found."
                    GridLines="None"
                    OnRowCommand="gvProducts_RowCommand"
                    DataKeyNames="ProductId">
                    <Columns>
                        <asp:TemplateField HeaderText="Product">
                            <ItemTemplate>
                                <div class="product-info">
                                    <div class="product-image">
                                        <i class="fa-solid fa-plant-wilt"></i>
                                    </div>
                                    <div class="product-details">
                                        <h5><%# Eval("ProductName") %></h5>
                                        <p><%# Eval("Description") %></p>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Category">
                            <ItemTemplate>
                                <span class='category-badge <%# GetCategoryClass(Eval("Category")) %>'>
                                    <%# Eval("Category") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="₹{0:N2}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge <%# GetStatusClass(Eval("Stock")) %>'>
                                    <%# GetStockStatus(Eval("Stock")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    CommandName="EditProduct" CommandArgument='<%# Eval("ProductId") %>'
                                    CssClass="action-btn" ToolTip="Edit">
                                    <i class="fa-solid fa-pen"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductId") %>'
                                    CssClass="action-btn delete" ToolTip="Delete"
                                    OnClientClick="return confirm('Are you sure you want to delete this product?');">
                                    <i class="fa-solid fa-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="card-footer">
                <div class="pagination-info">
                    Showing <asp:Literal ID="litShowingStart" runat="server">0</asp:Literal>-<asp:Literal ID="litShowingEnd" runat="server">0</asp:Literal> of <asp:Literal ID="litTotalRecords" runat="server">0</asp:Literal> products
                </div>
                <ul class="pagination">
                    <li class="page-item disabled">
                        <a class="page-link" href="#">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item active">
                        <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">2</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">3</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
