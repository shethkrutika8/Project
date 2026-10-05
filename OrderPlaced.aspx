<%@ Page Title="Orders - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="OrderPlaced.aspx.cs" Inherits="Project.OrderPlaced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .order-wrapper {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 15px;
        }
        .order-nav-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 25px;
            border-bottom: 2px solid #e2ebe0;
            padding-bottom: 12px;
        }
        .order-tab-btn {
            background: #fff;
            border: 1px solid #d4e2d2;
            padding: 9px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            color: #3b5038;
            cursor: pointer;
            transition: 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .order-tab-btn.active, .order-tab-btn:hover {
            background: #2ea339;
            color: #fff;
            border-color: #2ea339;
        }
        .order-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            padding: 28px;
            margin-bottom: 24px;
        }
        .form-section-title {
            font-size: 19px;
            font-weight: 700;
            color: #1e361d;
            border-bottom: 2px solid #edf4eb;
            padding-bottom: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .order-input-label {
            font-size: 13px;
            font-weight: 600;
            color: #334432;
            margin-bottom: 6px;
        }
        .form-control, .form-select {
            border: 1px solid #cad9c7;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #38a542;
            box-shadow: 0 0 0 0.2rem rgba(56, 165, 66, 0.15);
        }
        .btn-confirm-order {
            background: #2ea339;
            color: #fff;
            border: none;
            padding: 14px 28px;
            font-size: 16px;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.2s;
            width: 100%;
        }
        .btn-confirm-order:hover {
            background: #22842c;
            color: #fff;
        }
        .success-box {
            text-align: center;
            padding: 40px 20px;
        }
        .success-icon-wrap {
            width: 80px;
            height: 80px;
            background: #e8f7e7;
            color: #28a745;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin-bottom: 20px;
        }
        .order-badge-placed {
            background: #e1f5e2;
            color: #267a2e;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 12px;
            border: 1px solid #c2e8c4;
        }
        .history-order-card {
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid #e2ebe0;
            padding: 20px;
            margin-bottom: 18px;
            transition: box-shadow 0.2s;
        }
        .history-order-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }
        .history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eef3ed;
            padding-bottom: 12px;
            margin-bottom: 14px;
        }
        .history-item-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #4b5949;
            padding: 4px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="order-wrapper">
        <!-- Top Navigation between Checkout & Past Orders -->
        <div class="order-nav-tabs">
            <asp:LinkButton ID="tabCheckout" runat="server" CssClass="order-tab-btn active" OnClick="tabCheckout_Click">
                <i class="fa-solid fa-cart-shopping"></i> Place Order / Checkout
            </asp:LinkButton>
            <asp:LinkButton ID="tabHistory" runat="server" CssClass="order-tab-btn" OnClick="tabHistory_Click">
                <i class="fa-solid fa-clock-rotate-left"></i> My Orders History
            </asp:LinkButton>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- VIEW 1: PLACE ORDER (CHECKOUT FORM) -->
        <asp:Panel ID="pnlCheckoutView" runat="server">
            <div class="row g-4">
                <!-- Left: Shipping & Payment Form -->
                <div class="col-lg-7">
                    <div class="order-card">
                        <h4 class="form-section-title">
                            <i class="fa-solid fa-truck-fast text-success"></i> Delivery Address
                        </h4>

                        <!-- ASP.NET Server-Side Validation Summary (NO JavaScript) -->
                        <asp:ValidationSummary ID="vsOrderCheckout" runat="server"
                            ValidationGroup="vgCheckout"
                            CssClass="alert alert-danger py-2 mb-3"
                            HeaderText="Please fix the following validation errors:"
                            EnableClientScript="false"
                            ShowMessageBox="false" ShowSummary="true" />

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="order-input-label">Full Name *</label>
                                <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" placeholder="e.g. Krutika Sheth"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCustomerName" runat="server"
                                    ControlToValidate="txtCustomerName" ValidationGroup="vgCheckout"
                                    ErrorMessage="Full Name is required." ForeColor="#FF3300"
                                    EnableClientScript="false" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="order-input-label">Contact Phone *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                    ControlToValidate="txtPhone" ValidationGroup="vgCheckout"
                                    ErrorMessage="Contact Phone is required." ForeColor="#FF3300"
                                    EnableClientScript="false" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone" ValidationGroup="vgCheckout"
                                    ErrorMessage="Phone number must be exactly 10 digits." ForeColor="#FF3300"
                                    EnableClientScript="false" ValidationExpression="^\d{10}$" Display="Dynamic" />
                            </div>
                            <div class="col-12">
                                <label class="order-input-label">Delivery Address *</label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="House/Flat No, Street, Landmark"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                                    ControlToValidate="txtAddress" ValidationGroup="vgCheckout"
                                    ErrorMessage="Delivery Address is required." ForeColor="#FF3300"
                                    EnableClientScript="false" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="order-input-label">City *</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="e.g. Ahmedabad, Mumbai"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                                    ControlToValidate="txtCity" ValidationGroup="vgCheckout"
                                    ErrorMessage="City is required." ForeColor="#FF3300"
                                    EnableClientScript="false" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="order-input-label">Postal Code / PIN *</label>
                                <asp:TextBox ID="txtPinCode" runat="server" CssClass="form-control" placeholder="e.g. 380001"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPinCode" runat="server"
                                    ControlToValidate="txtPinCode" ValidationGroup="vgCheckout"
                                    ErrorMessage="Postal PIN Code is required." ForeColor="#FF3300"
                                    EnableClientScript="false" Display="Dynamic" />
                            </div>
                        </div>

                        <h4 class="form-section-title mt-4">
                            <i class="fa-solid fa-money-bill-wave text-success"></i> Payment Method
                        </h4>

                        <div class="mb-3">
                            <asp:RadioButtonList ID="rblPaymentMethod" runat="server" CssClass="form-check-group" RepeatLayout="Flow">
                                <asp:ListItem Text="&nbsp; Cash on Delivery (COD)" Value="Cash on Delivery" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                            <div class="alert alert-light border mt-2 py-2 px-3 small text-muted d-flex align-items-center gap-2">
                                <i class="fa-solid fa-circle-check text-success fs-6"></i>
                                <span><strong>Cash on Delivery:</strong> Currently, only Cash on Delivery is available. Please keep exact cash ready upon delivery.</span>
                            </div>
                        </div>

                        <asp:Button ID="btnPlaceOrder" runat="server" Text="Confirm & Place Order"
                            ValidationGroup="vgCheckout" CssClass="btn-confirm-order" OnClick="btnPlaceOrder_Click" />
                    </div>
                </div>

                <!-- Right: Order Items & Pricing Summary -->
                <div class="col-lg-5">
                    <div class="order-card">
                        <h4 class="form-section-title">
                            <i class="fa-solid fa-receipt text-success"></i> Items in Order
                        </h4>

                        <asp:Repeater ID="rptCheckoutItems" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                                    <div class="d-flex align-items-center gap-2">
                                        <img src='<%# ResolveUrl(Eval("ImageUrl") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageUrl").ToString()) ? Eval("ImageUrl").ToString() : "image/product-snake-plant.png") %>'
                                             alt="" style="width: 44px; height: 44px; object-fit: cover; border-radius: 6px;" />
                                        <div>
                                            <div class="fw-semibold text-dark fs-6"><%# Eval("ProductName") %></div>
                                            <small class="text-muted">Qty: <%# Eval("Quantity") %> &times; &#8377;<%# Eval("Price", "{0:N2}") %></small>
                                        </div>
                                    </div>
                                    <div class="fw-bold text-dark">
                                        &#8377;<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div class="d-flex justify-content-between mb-2 fs-6 text-muted">
                            <span>Subtotal</span>
                            <span>&#8377;<asp:Literal ID="litSubTotal" runat="server">0.00</asp:Literal></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 fs-6 text-muted">
                            <span>Estimated GST (5%)</span>
                            <span>&#8377;<asp:Literal ID="litTax" runat="server">0.00</asp:Literal></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 fs-6 text-muted">
                            <span>Delivery</span>
                            <span class="text-success fw-semibold"><asp:Literal ID="litDelivery" runat="server">FREE</asp:Literal></span>
                        </div>
                        <hr />
                        <div class="d-flex justify-content-between fs-5 fw-bold text-dark mb-3">
                            <span>Total Payable</span>
                            <span class="text-success">&#8377;<asp:Literal ID="litPayableAmount" runat="server">0.00</asp:Literal></span>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- VIEW 2: ORDER PLACED CONFIRMATION RECEIPT -->
        <asp:Panel ID="pnlSuccessReceipt" runat="server" Visible="false">
            <div class="order-card success-box">
                <div class="success-icon-wrap">
                    <i class="fa-solid fa-check"></i>
                </div>
                <h2 class="fw-bold text-dark mb-2">Order Placed Successfully!</h2>
                <p class="text-muted mb-4">
                    Thank you for ordering with AgriCulture. Your order has been placed and saved in the database.
                </p>

                <div class="card p-4 mx-auto text-start mb-4" style="max-width: 600px; background: #f9fbf8; border: 1px solid #dce8db;">
                    <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                        <span class="text-muted">Order Number:</span>
                        <span class="fw-bold text-dark"><asp:Literal ID="litSuccessOrderNo" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                        <span class="text-muted">Customer Name:</span>
                        <span class="fw-semibold text-dark"><asp:Literal ID="litSuccessCustomer" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                        <span class="text-muted">Delivery Address:</span>
                        <span class="fw-semibold text-dark text-end"><asp:Literal ID="litSuccessAddress" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between border-bottom pb-2 mb-2">
                        <span class="text-muted">Payment Mode:</span>
                        <span class="fw-semibold text-dark"><asp:Literal ID="litSuccessPayment" runat="server"></asp:Literal></span>
                    </div>
                    <div class="d-flex justify-content-between pt-1">
                        <span class="text-muted fw-bold">Total Amount Paid:</span>
                        <span class="fw-bold text-success fs-5">&#8377;<asp:Literal ID="litSuccessAmount" runat="server"></asp:Literal></span>
                    </div>
                </div>

                <div class="d-flex justify-content-center gap-3">
                    <asp:Button ID="btnViewOrders" runat="server" Text="View All Orders" CssClass="btn btn-outline-success px-4 py-2 fw-semibold" OnClick="tabHistory_Click" />
                    <a href="Products.aspx" class="btn btn-success px-4 py-2 fw-semibold">
                        <i class="fa-solid fa-seedling me-1"></i> Continue Shopping
                    </a>
                </div>
            </div>
        </asp:Panel>

        <!-- VIEW 3: MY ORDERS HISTORY -->
        <asp:Panel ID="pnlHistoryView" runat="server" Visible="false">
            <h3 class="fw-bold text-dark mb-4">
                <i class="fa-solid fa-clock-rotate-left text-success me-2"></i> My Order History
            </h3>

            <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
                <div class="order-card text-center py-5">
                    <i class="fa-solid fa-box-open fs-1 text-muted mb-3"></i>
                    <h4 class="fw-bold text-dark">No Orders Found</h4>
                    <p class="text-muted">You have not placed any orders yet.</p>
                    <a href="Products.aspx" class="btn btn-success px-4 py-2">Start Shopping</a>
                </div>
            </asp:Panel>

            <asp:Repeater ID="rptOrderHistory" runat="server" OnItemDataBound="rptOrderHistory_ItemDataBound">
                <ItemTemplate>
                    <div class="history-order-card">
                        <div class="history-header">
                            <div>
                                <span class="fw-bold text-dark fs-5">Order #<%# Eval("OrderNumber") %></span>
                                <span class="text-muted ms-3 fs-6"><%# Eval("OrderDate", "{0:dd MMM yyyy, hh:mm tt}") %></span>
                            </div>
                            <span class="order-badge-placed"><%# Eval("OrderStatus") %></span>
                        </div>
                        <div class="row">
                            <div class="col-md-7">
                                <div class="text-muted small mb-2"><strong>Ship To:</strong> <%# Eval("CustomerName") %> | <%# Eval("ShippingAddress") %>, <%# Eval("City") %> | Phone: <%# Eval("ContactNumber") %></div>
                                <div class="text-muted small mb-3"><strong>Payment Method:</strong> <%# Eval("PaymentMethod") %></div>
                                <h6 class="fw-bold text-dark mb-2">Ordered Items:</h6>
                                <asp:Repeater ID="rptOrderItems" runat="server">
                                    <ItemTemplate>
                                        <div class="history-item-row">
                                            <span><%# Eval("ProductName") %> (&times;<%# Eval("Quantity") %>)</span>
                                            <span>&#8377;<%# Eval("SubTotal", "{0:N2}") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="col-md-5 text-md-end d-flex flex-column justify-content-center border-start-md">
                                <div class="text-muted small">Total Paid Amount</div>
                                <div class="fs-4 fw-bold text-success">&#8377;<%# Eval("TotalAmount", "{0:N2}") %></div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>
    </div>
</asp:Content>
