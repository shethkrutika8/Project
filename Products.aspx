<%@ Page Title="Products - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Products.aspx.cs"
    Inherits="Project.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Products.css" rel="stylesheet" />
    <style>
        .prod-actions {
            display: flex;
            gap: 8px;
            margin-top: auto;
        }
        .btn-add-cart {
            flex: 1;
            background: #2e8b38;
            color: #ffffff !important;
            text-decoration: none;
            border: none;
            border-radius: 6px;
            padding: 8px 6px;
            font-size: 11.5px;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s ease, transform 0.1s ease;
        }
        .btn-add-cart:hover {
            background: #24702d;
            color: #ffffff !important;
        }
        .btn-add-wishlist {
            background: #fdf2f2;
            color: #dc3545 !important;
            text-decoration: none;
            border: 1px solid #f8d7da;
            border-radius: 6px;
            padding: 8px 10px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }
        .btn-add-wishlist:hover {
            background: #dc3545;
            color: #ffffff !important;
            border-color: #dc3545;
        }
        .cat-tab {
            text-decoration: none;
            color: inherit;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="products-page">

    <!-- =========================================
         HERO SECTION
    ========================================= -->
    <section class="prod-hero-section">
        <div class="prod-hero-wrapper">
            <div class="prod-hero-card">
                <div class="prod-hero-content">
                    <h1 class="prod-hero-title">Our Products</h1>
                    <p class="prod-hero-desc">Everything you need to nurture your plants<br />and grow a healthy, thriving garden.</p>
                    <a href="#productsGridSection" class="btn-shop-all">Explore All Products</a>
                </div>
                <div class="prod-hero-image-wrap">
                    <img src="image/products-hero-plants.png" alt="Our Products Banner" class="prod-hero-img" />
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         CATEGORY TABS (Server-side LinkButtons)
    ========================================= -->
    <section class="prod-categories-section">
        <div class="prod-categories-wrapper">
            <div class="prod-categories-list">

                <!-- 1. All Products -->
                <asp:LinkButton ID="btnCatAll" runat="server" CommandArgument="all" OnClick="FilterCategory_Click" CssClass="cat-tab active">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 20A7 7 0 0 1 4 13C4 7 11 3 20 3c0 9-4 16-11 17Z"></path>
                            <path d="M4 21c2-3 5-5 9-7"></path>
                        </svg>
                    </div>
                    <span class="cat-label">All Products</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 2. Plants -->
                <asp:LinkButton ID="btnCatPlants" runat="server" CommandArgument="plants" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M7 11h10l-1.5 10h-7L7 11Z"></path>
                            <path d="M12 11V4"></path>
                            <path d="M12 7c-2.2-2.2-4.5-1.5-5 0 .5 2 2.5 2.5 5 1"></path>
                            <path d="M12 5.5c2.2-2.2 4.5-1.5 5 0-.5 2-2.5 2.5-5 1"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Plants</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 3. Seeds -->
                <asp:LinkButton ID="btnCatSeeds" runat="server" CommandArgument="seeds" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 7l2.5-4h7L18 7v13a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2V7Z"></path>
                            <path d="M8 7h8"></path>
                            <path d="M12 17v-4"></path>
                            <path d="M12 14c-1.5-1-2.2-.2-2 1.2.8.8 2 .3 2 .3"></path>
                            <path d="M12 14c1.5-1 2.2-.2 2 1.2-.8.8-2 .3-2 .3"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Seeds</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 4. Fertilizers -->
                <asp:LinkButton ID="btnCatFertilizers" runat="server" CommandArgument="fertilizers" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M7 6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2l1.2 14a2 2 0 0 1-2 2H7.8a2 2 0 0 1-2-2L7 6Z"></path>
                            <path d="M9 4V2.5h6V4"></path>
                            <circle cx="12" cy="14" r="3.2"></circle>
                            <path d="M12 12.5v3"></path>
                            <path d="M10.5 14h3"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Fertilizers</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 5. Pots & Planters -->
                <asp:LinkButton ID="btnCatPots" runat="server" CommandArgument="pots" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 6h16v3H4z"></path>
                            <path d="M5.5 9l1.6 10.5a2 2 0 0 0 2 1.5h5.8a2 2 0 0 0 2-1.5L18.5 9"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Pots &amp; Planters</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 6. Tools -->
                <asp:LinkButton ID="btnCatTools" runat="server" CommandArgument="tools" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14.5 4.5l5 5"></path>
                            <path d="M18 8l-6 6"></path>
                            <path d="M8.5 11.5L3 17a4.2 4.2 0 0 0 6 6l5.5-5.5"></path>
                            <path d="M8.5 11.5l4 4"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Tools</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 7. Plant Care -->
                <asp:LinkButton ID="btnCatCare" runat="server" CommandArgument="care" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 7h6"></path>
                            <path d="M12 7V3h3"></path>
                            <path d="M9 5l-3 2"></path>
                            <path d="M9 7l-1 4h8l-1-4"></path>
                            <path d="M8 11l-1 9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l-1-9"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Plant Care</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

                <!-- 8. Gift Sets -->
                <asp:LinkButton ID="btnCatGifts" runat="server" CommandArgument="gifts" OnClick="FilterCategory_Click" CssClass="cat-tab">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="8" width="18" height="13" rx="2"></rect>
                            <path d="M12 8v13"></path>
                            <path d="M3 13h18"></path>
                            <path d="M8 8V6a2 2 0 0 1 4 0v2"></path>
                            <path d="M12 8V6a2 2 0 0 1 4 0v2"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Gift Sets</span>
                    <div class="cat-underline"></div>
                </asp:LinkButton>

            </div>
        </div>
    </section>

    <!-- =========================================
         FEEDBACK ALERT BANNER (Server-side)
    ========================================= -->
    <div class="container" style="max-width: 1080px; margin: 0 auto; padding: 0 15px;">
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center justify-content-between p-3 mb-3 rounded-3 shadow-sm">
            <div class="d-flex align-items-center gap-2">
                <i class="fa-solid fa-circle-check fs-5"></i>
                <span><asp:Literal ID="litAlertMsg" runat="server"></asp:Literal></span>
            </div>
            <div class="d-flex gap-2">
                <a href="Cart.aspx" class="btn btn-sm btn-success"><i class="fa-solid fa-cart-shopping me-1"></i>View Cart</a>
                <a href="Wishlist.aspx" class="btn btn-sm btn-outline-success"><i class="fa-solid fa-heart me-1"></i>View Wishlist</a>
            </div>
        </asp:Panel>
    </div>

    <!-- =========================================
         PRODUCTS GRID (Pure ASP.NET Repeater)
    ========================================= -->
    <section class="prod-grid-section" id="productsGridSection">
        <div class="prod-grid-wrapper">
            <div class="prod-grid">

                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="prod-card">
                            <div class="prod-card-img-wrap">
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' class="prod-card-img" />
                            </div>
                            <div class="prod-card-body">
                                <h3 class="prod-title"><%# Eval("Name") %></h3>
                                <p class="prod-desc"><%# Eval("Description") %></p>
                                <div class="prod-price">&#8377;<%# Eval("Price", "{0:N0}") %></div>
                                
                                <div class="prod-actions">
                                    <asp:LinkButton ID="btnAddToCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' CssClass="btn-add-cart">
                                        <i class="fa-solid fa-cart-plus me-1"></i> Add to Cart
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnAddToWishlist" runat="server" CommandName="AddToWishlist" CommandArgument='<%# Eval("Id") %>' CssClass="btn-add-wishlist" ToolTip="Save to Wishlist">
                                        <i class="fa-solid fa-heart"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>
        </div>
    </section>

    <!-- =========================================
         NEED HELP CHOOSING BANNER
    ========================================= -->
    <section class="prod-help-section">
        <div class="prod-help-wrapper">
            <div class="prod-help-card">
                <div class="prod-help-left">
                    <div class="prod-help-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 7a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2l1.5 13a2 2 0 0 1-2 2H6.5a2 2 0 0 1-2-2L6 7Z"></path>
                            <path d="M9 7V5a3 3 0 0 1 6 0v2"></path>
                            <path d="M10 13c0 1.5 1 2.5 2 2.5s2-1 2-2.5"></path>
                            <path d="M12 12v3.5"></path>
                        </svg>
                    </div>
                    <div class="prod-help-text">
                        <h3 class="prod-help-title">Need Help Choosing?</h3>
                        <p class="prod-help-desc">Our plant experts are here to help you find the perfect products for your garden.</p>
                    </div>
                </div>
                <div class="prod-help-right">
                    <a href="AIDiagnose.aspx" class="btn-expert text-decoration-none">
                        <i class="fa-solid fa-seedling me-1"></i> Try AI Plant Doctor
                    </a>
                </div>
            </div>
        </div>
    </section>

</div>

</asp:Content>
