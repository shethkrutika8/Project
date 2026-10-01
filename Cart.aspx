<%@ Page Title="Shopping Cart - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Project.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .cart-wrapper {
            max-width: 1140px;
            margin: 40px auto;
            padding: 0 15px;
        }
        .cart-header-title {
            font-size: 28px;
            font-weight: 700;
            color: #203520;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }
        .cart-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .cart-table th {
            background-color: #f7faf5;
            color: #436240;
            font-weight: 600;
            font-size: 14px;
            border-bottom: 2px solid #e1ebe0;
            padding: 14px 18px;
        }
        .cart-table td {
            padding: 16px 18px;
            vertical-align: middle;
            border-bottom: 1px solid #edf2ec;
        }
        .cart-item-img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e5eee3;
            background: #fbfdfa;
        }
        .cart-item-name {
            font-weight: 600;
            font-size: 16px;
            color: #213221;
            margin-bottom: 4px;
        }
        .cart-item-price {
            font-weight: 700;
            color: #2e8b38;
            font-size: 15px;
        }
        .qty-box {
            display: inline-flex;
            align-items: center;
            border: 1px solid #c9d8c6;
            border-radius: 6px;
            background: #fff;
        }
        .qty-btn {
            background: #eef5eb;
            border: none;
            color: #2e732e;
            font-weight: bold;
            width: 32px;
            height: 32px;
            cursor: pointer;
            transition: 0.2s;
        }
        .qty-btn:hover {
            background: #39a343;
            color: #fff;
        }
        .qty-num {
            width: 40px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
        }
        .btn-remove-item {
            color: #dc3545;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 15px;
            transition: 0.2s;
        }
        .btn-remove-item:hover {
            color: #a71d2a;
            transform: scale(1.1);
        }
        .summary-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            padding: 24px;
        }
        .summary-title {
            font-size: 19px;
            font-weight: 700;
            color: #213221;
            border-bottom: 2px solid #edf4eb;
            padding-bottom: 12px;
            margin-bottom: 18px;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
            color: #556653;
        }
        .summary-row.total-row {
            font-size: 18px;
            font-weight: 700;
            color: #1e381d;
            border-top: 1px solid #e1ede0;
            padding-top: 14px;
            margin-top: 14px;
        }
        .btn-checkout {
            width: 100%;
            background: #2ea339;
            color: #fff;
            border: none;
            padding: 13px;
            font-size: 16px;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 18px;
            display: block;
            text-align: center;
            text-decoration: none;
        }
        .btn-checkout:hover {
            background: #25872d;
            color: #fff;
        }
        .btn-continue-shopping {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #2e8b38;
            font-weight: 600;
            text-decoration: none;
            margin-top: 14px;
        }
        .btn-continue-shopping:hover {
            color: #1d6124;
            text-decoration: underline;
        }
        .empty-cart-box {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-cart-icon {
            font-size: 64px;
            color: #92b88f;
            margin-bottom: 18px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cart-wrapper">
        <div class="cart-header-title">
            <i class="fa-solid fa-cart-shopping text-success"></i>
            <span>Your Shopping Cart</span>
            <span class="fs-6 text-muted fw-normal ms-2">
                (<asp:Literal ID="litItemCountHeader" runat="server">0</asp:Literal> items)
            </span>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show" role="alert">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- EMPTY CART STATE -->
        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
            <div class="cart-card empty-cart-box">
                <i class="fa-solid fa-cart-arrow-down empty-cart-icon"></i>
                <h3 class="fw-bold text-dark">Your Cart is Currently Empty</h3>
                <p class="text-muted mb-4">Looks like you haven't added any agriculture products or plants yet.</p>
                <a href="Products.aspx" class="btn btn-success px-4 py-2 fw-semibold">
                    <i class="fa-solid fa-seedling me-2"></i> Browse Products
                </a>
            </div>
        </asp:Panel>

        <!-- CART ITEMS VIEW -->
        <asp:Panel ID="pnlCartContent" runat="server">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="cart-card">
                        <div class="table-responsive">
                            <table class="table cart-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src='<%# ResolveUrl(Eval("ImageUrl") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageUrl").ToString()) ? Eval("ImageUrl").ToString() : "image/product-snake-plant.png") %>'
                                                             alt='<%# Eval("ProductName") %>' class="cart-item-img" />
                                                        <div>
                                                            <div class="cart-item-name"><%# Eval("ProductName") %></div>
                                                            <small class="text-muted">Added: <%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="cart-item-price">
                                                    &#8377;<%# Eval("Price", "{0:N2}") %>
                                                </td>
                                                <td>
                                                    <div class="qty-box">
                                                        <asp:Button ID="btnMinus" runat="server" Text="-" CssClass="qty-btn"
                                                            CommandName="DecreaseQty" CommandArgument='<%# Eval("CartId") %>' />
                                                        <span class="qty-num"><%# Eval("Quantity") %></span>
                                                        <asp:Button ID="btnPlus" runat="server" Text="+" CssClass="qty-btn"
                                                            CommandName="IncreaseQty" CommandArgument='<%# Eval("CartId") %>' />
                                                    </div>
                                                </td>
                                                <td class="fw-bold text-dark">
                                                    &#8377;<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))).ToString("N2") %>
                                                </td>
                                                <td>
                                                    <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-item"
                                                        CommandName="RemoveItem" CommandArgument='<%# Eval("CartId") %>'
                                                        OnClientClick="return confirm('Remove this item from your cart?');"
                                                        ToolTip="Remove Item">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </asp:LinkButton>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <a href="Products.aspx" class="btn-continue-shopping">
                            <i class="fa-solid fa-arrow-left"></i> Continue Shopping
                        </a>
                        <asp:Button ID="btnClearCart" runat="server" Text="Clear Cart" CssClass="btn btn-outline-danger btn-sm"
                            OnClick="btnClearCart_Click" OnClientClick="return confirm('Are you sure you want to empty your entire cart?');" />
                    </div>
                </div>

                <!-- Order Summary Sidebar -->
                <div class="col-lg-4">
                    <div class="summary-card">
                        <h4 class="summary-title">Order Summary</h4>
                        <div class="summary-row">
                            <span>Subtotal (<asp:Literal ID="litSummaryItemCount" runat="server">0</asp:Literal> items)</span>
                            <span>&#8377;<asp:Literal ID="litSubTotal" runat="server">0.00</asp:Literal></span>
                        </div>
                        <div class="summary-row">
                            <span>Estimated GST (5%)</span>
                            <span>&#8377;<asp:Literal ID="litTax" runat="server">0.00</asp:Literal></span>
                        </div>
                        <div class="summary-row">
                            <span>Delivery Charges</span>
                            <span class="text-success fw-semibold"><asp:Literal ID="litShipping" runat="server">FREE</asp:Literal></span>
                        </div>
                        <div class="summary-row total-row">
                            <span>Grand Total</span>
                            <span class="text-success">&#8377;<asp:Literal ID="litGrandTotal" runat="server">0.00</asp:Literal></span>
                        </div>

                        <asp:Button ID="btnProceedCheckout" runat="server" Text="Proceed to Place Order"
                            CssClass="btn-checkout" OnClick="btnProceedCheckout_Click" />

                        <div class="mt-3 text-center">
                            <small class="text-muted">
                                <i class="fa-solid fa-shield-halved text-success me-1"></i> Secure 256-bit checkout guaranteed
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
