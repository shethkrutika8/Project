<%@ Page Title="My Wishlist | AgriConnect" Language="C#" MasterPageFile="~/Site1.master" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="Project.Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Wishlist.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <div class="wishlist-hero">
        <i class="fa-regular fa-heart bg-heart"></i>
        <div class="wishlist-hero-content">
            <h1>My Wishlist</h1>
            <p>Save the plants you love and plan to add to<br />your green space.</p>
        </div>
    </div>

    <!-- Main Container -->
    <div class="wishlist-container">
        <div class="wishlist-grid-layout">
            
            <!-- Sidebar -->
            <aside class="wishlist-sidebar">
                <!-- User card -->
                <div class="wishlist-sidebar-card">
                    <div class="sidebar-header">
                        <i class="fa-solid fa-heart"></i>
                        <h3>Your Green Dreams</h3>
                    </div>
                    <p class="sidebar-desc">Keep track of the plants you wish to add. Your garden, your way.</p>
                    
                    <ul class="wishlist-categories">
                        <a href="#" class="wishlist-cat-item active">
                            <span><i class="fa-regular fa-heart cat-icon"></i> All Wishlist</span>
                            <span class="badge">12</span>
                        </a>
                        <a href="#" class="wishlist-cat-item">
                            <span><i class="fa-solid fa-seedling cat-icon" style="color: #218838;"></i> Indoor Plants</span>
                            <span class="badge" style="background:transparent;color:#7b8e7e">7</span>
                        </a>
                        <a href="#" class="wishlist-cat-item">
                            <span><i class="fa-solid fa-tree cat-icon" style="color: #218838;"></i> Outdoor Plants</span>
                            <span class="badge" style="background:transparent;color:#7b8e7e">3</span>
                        </a>
                        <a href="#" class="wishlist-cat-item">
                            <span><i class="fa-solid fa-leaf cat-icon" style="color: #218838;"></i> Succulents</span>
                            <span class="badge" style="background:transparent;color:#7b8e7e">1</span>
                        </a>
                        <a href="#" class="wishlist-cat-item">
                            <span><i class="fa-solid fa-fan cat-icon" style="color: #218838;"></i> Flowering Plants</span>
                            <span class="badge" style="background:transparent;color:#7b8e7e">1</span>
                        </a>
                    </ul>
                </div>

                <!-- Call to action card -->
                <div class="sidebar-cta-card">
                    <div class="sidebar-cta-icon">
                        <img src="image/product-succulent.png" alt="Plant" style="width: 40px;" />
                    </div>
                    <div class="sidebar-cta-content">
                        <h4>Turn your wishlist into<br />a beautiful reality.</h4>
                        <button class="btn-explore-sidebar">Explore Plants</button>
                    </div>
                </div>
            </aside>

            <!-- Main Content Area -->
            <div class="wishlist-main">
                <!-- Controls -->
                <div class="wishlist-main-header">
                    <div class="title-count">
                        <strong>12</strong> Plants in Wishlist
                    </div>
                    <div class="wishlist-controls">
                        <select class="wishlist-sort">
                            <option>Sort by: Recently Added</option>
                            <option>Name (A-Z)</option>
                            <option>Name (Z-A)</option>
                        </select>
                        <div class="wishlist-view-toggle">
                            <button class="btn-view-toggle active"><i class="fa-solid fa-border-all"></i></button>
                            <button class="btn-view-toggle"><i class="fa-solid fa-list"></i></button>
                        </div>
                    </div>
                </div>

                <!-- Cards Grid -->
                <div class="wishlist-cards-grid">
                    
                    <!-- Card 1 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/products-hero-plants.png" alt="Monstera Deliciosa">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-indoor">Indoor Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Monstera Deliciosa</h3>
                            <p class="plant-card-subtitle">Swiss Cheese Plant</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright, Indirect Light
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/product-snake-plant.png" alt="Snake Plant">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-indoor">Indoor Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Snake Plant</h3>
                            <p class="plant-card-subtitle">Sansevieria Trifasciata</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Low to Bright Light
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 3 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/flower.jfif" style="object-fit:cover;" alt="Peace Lily">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-indoor">Indoor Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Peace Lily</h3>
                            <p class="plant-card-subtitle">Spathiphyllum</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Low to Medium Light
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 4 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/perivinkle.jfif" style="object-fit:cover;" alt="Lavender">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-outdoor">Outdoor Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Lavender</h3>
                            <p class="plant-card-subtitle">Lavandula</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright Sunlight
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 5 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/tulsi.jfif" style="object-fit:cover;" alt="Rose Plant">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-flowering">Flowering Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Rose Plant</h3>
                            <p class="plant-card-subtitle">Rosa</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright Sunlight
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 6 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/product-succulent.png" alt="Aloe Vera">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-succulent">Succulent</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Aloe Vera</h3>
                            <p class="plant-card-subtitle">Aloe Barbadensis</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright, Direct Sunlight
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 7 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/sunflower.jfif" style="object-fit:cover;" alt="Bonsai Tree">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-outdoor">Outdoor Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Bonsai Tree</h3>
                            <p class="plant-card-subtitle">Ficus Retusa</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright, Indirect Light
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Card 8 -->
                    <div class="plant-card">
                        <div class="plant-img-wrapper">
                            <img src="image/images.jfif" style="object-fit:cover;" alt="Jasmine Plant">
                            <button class="heart-btn" title="Remove from wishlist"><i class="fa-solid fa-heart"></i></button>
                            <span class="category-tag cat-flowering">Flowering Plant</span>
                        </div>
                        <div class="plant-card-body">
                            <h3 class="plant-card-title">Jasmine Plant</h3>
                            <p class="plant-card-subtitle">Jasminum Polyanthum</p>
                            <div class="plant-card-footer">
                                <div class="sunlight-req">
                                    <i class="fa-regular fa-sun" style="color:#f39c12"></i> Bright Sunlight
                                </div>
                                <button class="bookmark-btn"><i class="fa-regular fa-bookmark"></i></button>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Bottom Tip -->
                <div class="wishlist-tip">
                    <div class="tip-content">
                        <i class="fa-regular fa-lightbulb tip-icon"></i>
                        <div class="tip-text">
                            <h4>Tip</h4>
                            <p>See something you like? Add it to your wishlist and we'll help you take care of it when the time is right.</p>
                        </div>
                    </div>
                    <a href="Products.aspx" class="btn-explore-more">Explore More Plants</a>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
