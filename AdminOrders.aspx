<%@ Page Title="Order Management - AgriCulture Admin" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AdminOrders.aspx.cs"
    Inherits="Project.AdminOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-orders-wrap {
            max-width: 1200px;
            margin: 28px auto 40px auto;
            padding: 0 15px;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .admin-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e1ede0;
        }

        .admin-page-title {
            font-size: 24px;
            font-weight: 800;
            color: #1a3923;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Order Summary Stats */
        .order-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .order-stat-card {
            background: #ffffff;
            border: 1px solid #dce8db;
            border-radius: 10px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .stat-icon-all { background: #eaf5e7; color: #2fa13a; }
        .stat-icon-pending { background: #fff8e6; color: #d48b11; }
        .stat-icon-processing { background: #e8f4fd; color: #1976d2; }
        .stat-icon-delivered { background: #e6f7ec; color: #2e7d32; }

        .stat-num {
            font-size: 24px;
            font-weight: 800;
            color: #1a3923;
            line-height: 1.1;
        }

        .stat-lbl {
            font-size: 12px;
            color: #637667;
            margin-top: 3px;
            font-weight: 600;
        }

        /* Filter Toolbar */
        .order-filter-toolbar {
            background: #ffffff;
            border: 1px solid #dce8db;
            border-radius: 8px;
            padding: 12px 18px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }

        .filter-btn-group {
            display: flex;
            gap: 6px;
        }

        .filter-btn {
            border: 1px solid #cce2ca;
            background: #f7faf6;
            color: #2b4530;
            font-size: 12px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .filter-btn:hover, .filter-btn.active {
            background: #36a941;
            color: #ffffff;
            border-color: #36a941;
        }

        /* Order Table */
        .order-table-card {
            background: #ffffff;
            border: 1px solid #dce8db;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            overflow: hidden;
            margin-bottom: 24px;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12.5px;
            margin-bottom: 0;
        }

        .order-table th {
            background: #f4faf2;
            color: #233e27;
            font-weight: 700;
            padding: 12px 14px;
            border-bottom: 1px solid #d8eada;
            text-align: left;
        }

        .order-table td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf4ec;
            vertical-align: middle;
        }

        .order-table tr:hover {
            background: #fbfdfa;
        }

        .order-num-badge {
            font-family: monospace;
            font-weight: 700;
            color: #1a3923;
            background: #eef6ed;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11.5px;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: capitalize;
        }

        .status-pending { background: #fff8e6; color: #b7791f; border: 1px solid #fbd38d; }
        .status-processing { background: #ebf8ff; color: #2b6cb0; border: 1px solid #bee3f8; }
        .status-delivered, .status-deliverd { background: #f0fff4; color: #22543d; border: 1px solid #c6f6d5; }
        .status-cancelled { background: #fff5f5; color: #9b2c2c; border: 1px solid #fed7d7; }

        /* Action Buttons */
        .btn-action-group {
            display: flex;
            align-items: center;
            gap: 5px;
            flex-wrap: wrap;
        }

        .btn-status-action {
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-process {
            background: #3182ce;
            color: #ffffff;
        }
        .btn-process:hover { background: #2b6cb0; }

        .btn-deliver {
            background: #38a169;
            color: #ffffff;
        }
        .btn-deliver:hover { background: #2f855a; }

        .btn-cancel-ord {
            background: #e53e3e;
            color: #ffffff;
        }
        .btn-cancel-ord:hover { background: #c53030; }

        .btn-view-items {
            background: #edf2f7;
            color: #4a5568;
            border: 1px solid #cbd5e0;
        }
        .btn-view-items:hover { background: #e2e8f0; color: #2d3748; }

        /* Items Details Modal/Panel */
        .items-detail-card {
            background: #ffffff;
            border: 1.5px solid #36a941;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }

        .items-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2ebe0;
            padding-bottom: 10px;
            margin-bottom: 14px;
        }

        @media (max-width: 991px) {
            .order-stats-grid { grid-template-columns: repeat(2, 1fr); }
            .order-table { font-size: 11.5px; }
        }

        @media (max-width: 576px) {
            .order-stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="admin-orders-wrap">

    <!-- Page Title -->
    <div class="admin-page-header">
        <div>
            <h1 class="admin-page-title">
                <i class="fa-solid fa-boxes-packing text-success"></i>
                Order Management
            </h1>
            <small class="text-muted">Manage real-time customer orders, update shipping progress, and track deliveries</small>
        </div>
        <div>
            <a href="AdminDashboard.aspx" class="btn btn-sm btn-outline-success">
                <i class="fa-solid fa-gauge me-1"></i> Admin Dashboard
            </a>
        </div>
    </div>

    <!-- Alert / Feedback Notification -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center justify-content-between p-3 rounded-2 shadow-sm mb-3">
        <div class="d-flex align-items-center gap-2">
            <i class="fa-solid fa-circle-check fs-5"></i>
            <span><asp:Literal ID="litAlertMsg" runat="server"></asp:Literal></span>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="btn-close" CausesValidation="false"></asp:LinkButton>
    </asp:Panel>

    <!-- Order Summary Cards -->
    <div class="order-stats-grid">
        <div class="order-stat-card">
            <div class="stat-icon stat-icon-all">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div>
                <div class="stat-num"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Total Orders</div>
            </div>
        </div>

        <div class="order-stat-card">
            <div class="stat-icon stat-icon-pending">
                <i class="fa-solid fa-clock"></i>
            </div>
            <div>
                <div class="stat-num"><asp:Literal ID="litPendingOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Pending Orders</div>
            </div>
        </div>

        <div class="order-stat-card">
            <div class="stat-icon stat-icon-processing">
                <i class="fa-solid fa-spinner"></i>
            </div>
            <div>
                <div class="stat-num"><asp:Literal ID="litProcessingOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Processing Orders</div>
            </div>
        </div>

        <div class="order-stat-card">
            <div class="stat-icon stat-icon-delivered">
                <i class="fa-solid fa-truck-ramp-box"></i>
            </div>
            <div>
                <div class="stat-num"><asp:Literal ID="litDeliveredOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Delivered Orders</div>
            </div>
        </div>
    </div>

    <!-- Inspection of Order Items (shown when View Items clicked) -->
    <asp:Panel ID="pnlOrderItemsDetail" runat="server" Visible="false" CssClass="items-detail-card">
        <div class="items-header">
            <h5 class="m-0 fw-bold text-success">
                <i class="fa-solid fa-receipt me-2"></i>Items in Order: <asp:Literal ID="litSelectedOrderNum" runat="server"></asp:Literal>
            </h5>
            <asp:Button ID="btnCloseItems" runat="server" Text="&times; Close View" OnClick="btnCloseItems_Click" CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" />
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-sm align-middle mb-0" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                    <asp:BoundField DataField="Price" HeaderText="Unit Price (₹)" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                    <asp:BoundField DataField="SubTotal" HeaderText="SubTotal (₹)" DataFormatString="{0:N2}" />
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>

    <!-- Filter Toolbar -->
    <div class="order-filter-toolbar">
        <div class="filter-btn-group">
            <asp:Button ID="btnFilterAll" runat="server" Text="All Orders" OnClick="btnFilter_Click" CommandArgument="All" CssClass="filter-btn active" CausesValidation="false" />
            <asp:Button ID="btnFilterPending" runat="server" Text="Pending" OnClick="btnFilter_Click" CommandArgument="Pending" CssClass="filter-btn" CausesValidation="false" />
            <asp:Button ID="btnFilterProcessing" runat="server" Text="Processing" OnClick="btnFilter_Click" CommandArgument="Processing" CssClass="filter-btn" CausesValidation="false" />
            <asp:Button ID="btnFilterDelivered" runat="server" Text="Delivered" OnClick="btnFilter_Click" CommandArgument="Delivered" CssClass="filter-btn" CausesValidation="false" />
            <asp:Button ID="btnFilterCancelled" runat="server" Text="Cancelled" OnClick="btnFilter_Click" CommandArgument="Cancelled" CssClass="filter-btn" CausesValidation="false" />
        </div>
        <div class="text-muted small">
            <i class="fa-solid fa-database text-success me-1"></i> Live records from SQL Server Database
        </div>
    </div>

    <!-- Orders Table -->
    <div class="order-table-card">
        <div class="table-responsive">
            <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                <HeaderTemplate>
                    <table class="order-table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Date &amp; Time</th>
                                <th>Customer</th>
                                <th>Shipping Info</th>
                                <th>Total (₹)</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th style="min-width: 220px;">Manage Status Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <span class="order-num-badge">#<%# Eval("OrderNumber") %></span>
                        </td>
                        <td>
                            <div class="fw-semibold"><%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy") %></div>
                            <small class="text-muted"><%# Convert.ToDateTime(Eval("OrderDate")).ToString("hh:mm tt") %></small>
                        </td>
                        <td>
                            <div class="fw-bold text-dark"><%# Eval("CustomerName") %></div>
                            <small class="text-muted"><%# Eval("UserEmail") %></small><br />
                            <small class="text-muted"><i class="fa-solid fa-phone me-1"></i><%# Eval("ContactNumber") %></small>
                        </td>
                        <td>
                            <div class="text-truncate" style="max-width: 170px;" title='<%# Eval("ShippingAddress") %>'>
                                <%# Eval("ShippingAddress") %>
                            </div>
                            <small class="text-success fw-semibold"><i class="fa-solid fa-location-dot me-1"></i><%# Eval("City") %></small>
                        </td>
                        <td>
                            <strong class="text-dark">₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %></strong>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border"><%# Eval("PaymentMethod") %></span>
                        </td>
                        <td>
                            <span class='<%# "status-badge status-" + Eval("OrderStatus").ToString().ToLower() %>'>
                                <i class='<%# GetStatusIcon(Eval("OrderStatus").ToString()) %>'></i>
                                <%# Eval("OrderStatus") %>
                            </span>
                        </td>
                        <td>
                            <div class="btn-action-group">
                                <!-- Mark Processing Button -->
                                <asp:Button ID="btnSetProcessing" runat="server"
                                    Text="⚙ Processing"
                                    CommandName="SetProcessing"
                                    CommandArgument='<%# Eval("OrderId") %>'
                                    CssClass="btn-status-action btn-process"
                                    ToolTip="Change status to Processing"
                                    CausesValidation="false" />

                                <!-- Mark Delivered Button -->
                                <asp:Button ID="btnSetDelivered" runat="server"
                                    Text="✔ Delivered"
                                    CommandName="SetDelivered"
                                    CommandArgument='<%# Eval("OrderId") %>'
                                    CssClass="btn-status-action btn-deliver"
                                    ToolTip="Change status to Delivered"
                                    CausesValidation="false" />

                                <!-- View Details Button -->
                                <asp:Button ID="btnViewItems" runat="server"
                                    Text="👁 Items"
                                    CommandName="ViewItems"
                                    CommandArgument='<%# Eval("OrderId") %>'
                                    CssClass="btn-status-action btn-view-items"
                                    ToolTip="View Order Items"
                                    CausesValidation="false" />

                                <!-- Cancel Button -->
                                <asp:Button ID="btnSetCancelled" runat="server"
                                    Text="✖"
                                    CommandName="SetCancelled"
                                    CommandArgument='<%# Eval("OrderId") %>'
                                    CssClass="btn-status-action btn-cancel-ord"
                                    ToolTip="Cancel this order"
                                    OnClientClick="return confirm('Are you sure you want to cancel this order?');"
                                    CausesValidation="false" />
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
            <i class="fa-solid fa-inbox fs-1 mb-2"></i>
            <p>No orders found matching the selected filter criteria.</p>
        </asp:Panel>
    </div>

</div>
</asp:Content>
