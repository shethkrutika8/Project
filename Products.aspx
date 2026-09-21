<%@ Page Title="Products - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Products.aspx.cs"
    Inherits="Project.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Products.css" rel="stylesheet" />
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
                    <p class="prod-hero-desc">Everything you need to nurture your plants<br />and grow a beautiful garden.</p>
                    <button type="button" class="btn-shop-all" onclick="scrollToProducts()">Shop All Products</button>
                </div>
                <div class="prod-hero-image-wrap">
                    <img src="image/products-hero-plants.png" alt="Our Products Banner" class="prod-hero-img" />
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         CATEGORY TABS
    ========================================= -->
    <section class="prod-categories-section">
        <div class="prod-categories-wrapper">
            <div class="prod-categories-list">

                <!-- 1. All Products -->
                <div class="cat-tab active" onclick="filterProducts('all', this)">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 20A7 7 0 0 1 4 13C4 7 11 3 20 3c0 9-4 16-11 17Z"></path>
                            <path d="M4 21c2-3 5-5 9-7"></path>
                        </svg>
                    </div>
                    <span class="cat-label">All Products</span>
                    <div class="cat-underline"></div>
                </div>

                <!-- 2. Plants -->
                <div class="cat-tab" onclick="filterProducts('plants', this)">
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
                </div>

                <!-- 3. Seeds -->
                <div class="cat-tab" onclick="filterProducts('seeds', this)">
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
                </div>

                <!-- 4. Fertilizers -->
                <div class="cat-tab" onclick="filterProducts('fertilizers', this)">
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
                </div>

                <!-- 5. Pots & Planters -->
                <div class="cat-tab" onclick="filterProducts('pots', this)">
                    <div class="cat-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 6h16v3H4z"></path>
                            <path d="M5.5 9l1.6 10.5a2 2 0 0 0 2 1.5h5.8a2 2 0 0 0 2-1.5L18.5 9"></path>
                        </svg>
                    </div>
                    <span class="cat-label">Pots &amp; Planters</span>
                    <div class="cat-underline"></div>
                </div>

                <!-- 6. Tools -->
                <div class="cat-tab" onclick="filterProducts('tools', this)">
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
                </div>

                <!-- 7. Plant Care -->
                <div class="cat-tab" onclick="filterProducts('care', this)">
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
                </div>

                <!-- 8. Gift Sets -->
                <div class="cat-tab" onclick="filterProducts('gifts', this)">
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
                </div>

            </div>
        </div>
    </section>

    <!-- =========================================
         PRODUCTS GRID
    ========================================= -->
    <section class="prod-grid-section" id="productsGridSection">
        <div class="prod-grid-wrapper">
            <div class="prod-grid">

                <!-- 1. Snake Plant -->
                <div class="prod-card" data-category="plants" data-show-on-all="true">
                    <div class="prod-card-img-wrap">
                        <img src="image/product-snake-plant.png" alt="Snake Plant" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Snake Plant</h3>
                        <p class="prod-desc">Air purifying indoor plant</p>
                        <div class="prod-price">&#8377;499</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Snake Plant', 499, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- 2. Succulent Plant -->
                <div class="prod-card" data-category="plants" data-show-on-all="true">
                    <div class="prod-card-img-wrap">
                        <img src="image/product-succulent.png" alt="Succulent Plant" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Succulent Plant</h3>
                        <p class="prod-desc">Low maintenance beauty</p>
                        <div class="prod-price">&#8377;349</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Succulent Plant', 349, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- 3. Organic PottingMix -->
                <div class="prod-card" data-category="fertilizers" data-show-on-all="true">
                    <div class="prod-card-img-wrap">
                        <img src="image/product-potting-mix.png" alt="Organic PottingMix" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Organic PottingMix</h3>
                        <p class="prod-desc">Nutrient rich soil for plants</p>
                        <div class="prod-price">&#8377;299</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Organic PottingMix', 299, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- 4. Watering Can -->
                <div class="prod-card" data-category="tools" data-show-on-all="true">
                    <div class="prod-card-img-wrap">
                        <img src="image/product-watering-can.png" alt="Watering Can" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Watering Can</h3>
                        <p class="prod-desc">1.5L capacity, easy to use</p>
                        <div class="prod-price">&#8377;399</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Watering Can', 399, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- 5. Pruning Shears -->
                <div class="prod-card" data-category="tools" data-show-on-all="true">
                    <div class="prod-card-img-wrap">
                        <img src="image/product-pruning-shears.png" alt="Pruning Shears" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Pruning Shears</h3>
                        <p class="prod-desc">Sharp &amp; durable for clean cuts</p>
                        <div class="prod-price">&#8377;349</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Pruning Shears', 349, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- Supplemental Category Products (Visible when respective tabs clicked) -->
                <!-- Seeds -->
                <div class="prod-card supplemental" data-category="seeds" data-show-on-all="false" style="display: none;">
                    <div class="prod-card-img-wrap">
                        <img src="image/sunflower.jfif" alt="Sunflower Seeds" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Sunflower Seeds</h3>
                        <p class="prod-desc">Bright &amp; cheerful garden blooms</p>
                        <div class="prod-price">&#8377;149</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Sunflower Seeds', 149, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- Pots & Planters -->
                <div class="prod-card supplemental" data-category="pots" data-show-on-all="false" style="display: none;">
                    <div class="prod-card-img-wrap">
                        <img src="image/about-plants.PNG" alt="Ceramic Planter Pot" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Ceramic Planter Pot</h3>
                        <p class="prod-desc">Modern ribbed matte finish 6"</p>
                        <div class="prod-price">&#8377;279</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Ceramic Planter Pot', 279, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- Plant Care -->
                <div class="prod-card supplemental" data-category="care" data-show-on-all="false" style="display: none;">
                    <div class="prod-card-img-wrap">
                        <img src="image/tulsi.jfif" alt="Neem Spray Plant Care" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Neem Spray Care</h3>
                        <p class="prod-desc">Organic pest protection spray</p>
                        <div class="prod-price">&#8377;199</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Neem Spray Care', 199, this)">Add to Cart</button>
                    </div>
                </div>

                <!-- Gift Sets -->
                <div class="prod-card supplemental" data-category="gifts" data-show-on-all="false" style="display: none;">
                    <div class="prod-card-img-wrap">
                        <img src="image/about-story.PNG" alt="Plant Lovers Gift Set" class="prod-card-img" />
                    </div>
                    <div class="prod-card-body">
                        <h3 class="prod-title">Plant Lovers Gift Set</h3>
                        <p class="prod-desc">Curated gardening starter kit</p>
                        <div class="prod-price">&#8377;699</div>
                        <button type="button" class="btn-add-cart" onclick="addToCart('Plant Lovers Gift Set', 699, this)">Add to Cart</button>
                    </div>
                </div>

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
                    <button type="button" class="btn-expert" onclick="openExpertHelp()">Talk to an Expert</button>
                </div>
            </div>
        </div>
    </section>

</div>

<!-- Cart Toast Notification -->
<div id="cartToast" class="cart-toast">
    <div class="cart-toast-content">
        <span class="cart-toast-icon">&#10003;</span>
        <span id="cartToastMsg">Added to Cart!</span>
    </div>
</div>

<!-- Category Filtering & Interaction Script -->
<script type="text/javascript">
    function filterProducts(cat, el) {
        // Update active tab styling
        var tabs = document.querySelectorAll('.cat-tab');
        tabs.forEach(function (tab) {
            tab.classList.remove('active');
        });
        el.classList.add('active');

        // Filter cards
        var cards = document.querySelectorAll('.prod-card');
        cards.forEach(function (card) {
            var cardCat = card.getAttribute('data-category');
            var showOnAll = card.getAttribute('data-show-on-all') === 'true';

            if (cat === 'all') {
                if (showOnAll) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            } else {
                if (cardCat === cat) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            }
        });
    }

    function scrollToProducts() {
        var el = document.getElementById('productsGridSection');
        if (el) {
            el.scrollIntoView({ behavior: 'smooth' });
        }
    }

    function addToCart(productName, price, btn) {
        // Button feedback
        var origText = btn.innerText;
        btn.innerText = 'Added \u2713';
        btn.style.background = '#258d34';

        setTimeout(function () {
            btn.innerText = origText;
            btn.style.background = '';
        }, 1200);

        // Toast feedback
        var toast = document.getElementById('cartToast');
        var msg = document.getElementById('cartToastMsg');
        if (toast && msg) {
            msg.innerText = productName + ' (\u20B9' + price + ') added to Cart!';
            toast.classList.add('show');
            setTimeout(function () {
                toast.classList.remove('show');
            }, 2500);
        }
    }

    function openExpertHelp() {
        alert('Thank you for reaching out! An AgriCulture plant expert will be happy to assist you.\n\nHelpline: +91 1800-AGRI-CARE\nEmail: support@agriculture.com');
    }
</script>

</asp:Content>
