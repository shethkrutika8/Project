<%@ Page Title="My Wishlist - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="Project.Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .wishlist-wrapper {
            max-width: 1140px;
            margin: 40px auto;
            padding: 0 15px;
        }
        .wishlist-header-title {
            font-size: 28px;
            font-weight: 700;
            color: #203520;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 22px;
        }
        .wish-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .wish-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(46, 139, 56, 0.12);
        }
        .wish-img-wrap {
            height: 200px;
            background: #fbfdfa;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
            border-bottom: 1px solid #edf4ec;
        }
        .wish-img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }
        .wish-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .wish-title {
            font-size: 17px;
            font-weight: 700;
            color: #213221;
            margin-bottom: 6px;
        }
        .wish-price {
            font-size: 18px;
            font-weight: 700;
            color: #2e8b38;
            margin-bottom: 14px;
        }
        .btn-move-cart {
            background: #2ea339;
            color: #fff;
            border: none;
            padding: 10px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.2s;
            width: 100%;
            margin-bottom: 8px;
        }
        .btn-move-cart:hover {
            background: #23842c;
            color: #fff;
        }
        .btn-remove-wish {
            background: #fff;
            color: #dc3545;
            border: 1px solid #f5c2c7;
            padding: 8px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.2s;
            width: 100%;
        }
        .btn-remove-wish:hover {
            background: #f8d7da;
            color: #842029;
        }
        .empty-wish-box {
            text-align: center;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            padding: 60px 20px;
        }
        .empty-wish-icon {
            font-size: 64px;
            color: #ea969d;
            margin-bottom: 18px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="wishlist-wrapper">
        <div class="wishlist-header-title">
            <i class="fa-solid fa-heart text-danger"></i>
            <span>My Wishlist</span>
            <span class="fs-6 text-muted fw-normal ms-2">
                (<asp:Literal ID="litWishlistCountHeader" runat="server">0</asp:Literal> items)
            </span>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show" role="alert">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- EMPTY STATE -->
        <asp:Panel ID="pnlEmptyWishlist" runat="server" Visible="false">
            <div class="empty-wish-box">
                <i class="fa-regular fa-heart empty-wish-icon"></i>
                <h3 class="fw-bold text-dark">Your Wishlist is Empty</h3>
                <p class="text-muted mb-4">Explore our plants, seeds, fertilizers, and add your favorite items here.</p>
                <a href="Products.aspx" class="btn btn-success px-4 py-2 fw-semibold">
                    <i class="fa-solid fa-seedling me-2"></i> Browse Products
                </a>
            </div>
        </asp:Panel>

        <!-- WISHLIST GRID -->
        <asp:Panel ID="pnlWishlistContent" runat="server">
            <div class="wishlist-grid">
                <asp:Repeater ID="rptWishlist" runat="server" OnItemCommand="rptWishlist_ItemCommand">
                    <ItemTemplate>
                        <div class="wish-card">
                            <div class="wish-img-wrap">
                                <img src='<%# ResolveUrl(Eval("ImageUrl") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageUrl").ToString()) ? Eval("ImageUrl").ToString() : "image/product-snake-plant.png") %>'
                                     alt='<%# Eval("ProductName") %>' class="wish-img" />
                            </div>
                            <div class="wish-body">
                                <h3 class="wish-title"><%# Eval("ProductName") %></h3>
                                <div class="wish-price">&#8377;<%# Eval("Price", "{0:N2}") %></div>
                                <div class="mt-auto">
                                    <asp:Button ID="btnMoveToCart" runat="server" Text="Move to Cart" CssClass="btn-move-cart"
                                        CommandName="MoveToCart" CommandArgument='<%# Eval("WishlistId") %>' />
                                    <asp:Button ID="btnRemoveWish" runat="server" Text="Remove" CssClass="btn-remove-wish"
                                        CommandName="RemoveWish" CommandArgument='<%# Eval("WishlistId") %>'
                                        OnClientClick="return confirm('Remove from wishlist?');" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
