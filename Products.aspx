<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site1.Master"
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
    <section class="prod-hero">
        <div class="prod-hero-inner">

            <div class="prod-hero-text">
                <h1>Our Products</h1>
                <p>Everything you need to nurture your plants<br />and grow a beautiful garden.</p>
            </div>

            <div class="prod-hero-image">
                <img src="image/about-plants.PNG" alt="Garden Products" />
            </div>

        </div>
    </section>


    <!-- =========================================
         CATEGORY TABS
    ========================================= -->
    <section class="prod-categories">
        <div class="prod-categories-inner">

            <div class="cat-item active" onclick="filterProducts('all', this)">
                <div class="cat-icon">&#127807;</div>
                <span>All Products</span>
            </div>

            <div class="cat-item" onclick="filterProducts('plants', this)">
                <div class="cat-icon">&#127793;</div>
                <span>Plants</span>
            </div>

            <div class="cat-item" onclick="filterProducts('seeds', this)">
                <div class="cat-icon">&#129748;</div>
                <span>Seeds</span>
            </div>

            <div class="cat-item" onclick="filterProducts('fertilizers', this)">
                <div class="cat-icon">&#127807;</div>
                <span>Fertilizers</span>
            </div>

            <div class="cat-item" onclick="filterProducts('pots', this)">
                <div class="cat-icon">&#127758;</div>
                <span>Pots &amp; Planters</span>
            </div>

            <div class="cat-item" onclick="filterProducts('tools', this)">
                <div class="cat-icon">&#129302;</div>
                <span>Tools</span>
            </div>

            <div class="cat-item" onclick="filterProducts('care', this)">
                <div class="cat-icon">&#128144;</div>
                <span>Plant Care</span>
            </div>

            <div class="cat-item" onclick="filterProducts('gifts', this)">
                <div class="cat-icon">&#127873;</div>
                <span>Gift Sets</span>
            </div>

        </div>
    </section>


    <!-- =========================================
         PRODUCTS GRID
    ========================================= -->
    <section class="prod-grid-section">
        <div class="prod-grid">

            <!-- Product 1: Tulsi -->
            <div class="prod-card" data-cat="plants">
                <div class="prod-img-box">
                    <img src="image/tulsi.jfif" alt="Tulsi Plant" />
                </div>
                <div class="prod-info">
                    <h3>Tulsi Plant</h3>
                    <p>Sacred herb with medicinal benefits</p>
                    <span class="prod-price">&#8377;149</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 2: Money Plant -->
            <div class="prod-card" data-cat="plants">
                <div class="prod-img-box">
                    <img src="image/money_well.jfif" alt="Money Plant" />
                </div>
                <div class="prod-info">
                    <h3>Money Plant</h3>
                    <p>Lucky indoor trailing plant</p>
                    <span class="prod-price">&#8377;199</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 3: Aloe Vera -->
            <div class="prod-card" data-cat="plants">
                <div class="prod-img-box">
                    <img src="image/images.jfif" alt="Aloe Vera" />
                </div>
                <div class="prod-info">
                    <h3>Aloe Vera</h3>
                    <p>Healing succulent, easy to grow</p>
                    <span class="prod-price">&#8377;249</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 4: Periwinkle -->
            <div class="prod-card" data-cat="plants">
                <div class="prod-img-box">
                    <img src="image/perivinkle.jfif" alt="Periwinkle Plant" />
                </div>
                <div class="prod-info">
                    <h3>Periwinkle Plant</h3>
                    <p>Colourful all-season bloomer</p>
                    <span class="prod-price">&#8377;99</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 5: Sunflower -->
            <div class="prod-card" data-cat="seeds">
                <div class="prod-img-box">
                    <img src="image/sunflower.jfif" alt="Sunflower Seeds" />
                </div>
                <div class="prod-info">
                    <h3>Sunflower Seeds</h3>
                    <p>Bright blooms, easy to grow</p>
                    <span class="prod-price">&#8377;79</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 6: Hellebore -->
            <div class="prod-card" data-cat="plants">
                <div class="prod-img-box">
                    <img src="image/flower.jfif" alt="Hellebore Flower" />
                </div>
                <div class="prod-info">
                    <h3>Hellebore Flower</h3>
                    <p>Elegant winter-blooming plant</p>
                    <span class="prod-price">&#8377;349</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 7: Organic Fertilizer -->
            <div class="prod-card" data-cat="fertilizers">
                <div class="prod-img-box">
                    <img src="image/about-plants.PNG" alt="Organic Fertilizer" />
                </div>
                <div class="prod-info">
                    <h3>Organic Fertilizer</h3>
                    <p>Nutrient rich, boosts growth</p>
                    <span class="prod-price">&#8377;299</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 8: Garden Tools Set -->
            <div class="prod-card" data-cat="tools">
                <div class="prod-img-box">
                    <img src="image/about-plants.PNG" alt="Garden Tools Set" />
                </div>
                <div class="prod-info">
                    <h3>Garden Tools Set</h3>
                    <p>5-piece essential tool kit</p>
                    <span class="prod-price">&#8377;599</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 9: Ceramic Pot -->
            <div class="prod-card" data-cat="pots">
                <div class="prod-img-box">
                    <img src="image/about-plants.PNG" alt="Ceramic Pot" />
                </div>
                <div class="prod-info">
                    <h3>Ceramic Pot</h3>
                    <p>8 inch elegant pot with drainage</p>
                    <span class="prod-price">&#8377;249</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

            <!-- Product 10: Plant Gift Set -->
            <div class="prod-card" data-cat="gifts">
                <div class="prod-img-box">
                    <img src="image/about-plants.PNG" alt="Plant Gift Set" />
                </div>
                <div class="prod-info">
                    <h3>Plant Gift Set</h3>
                    <p>Perfect gift for plant lovers</p>
                    <span class="prod-price">&#8377;799</span>
                    <button class="add-cart-btn">Add to Cart</button>
                </div>
            </div>

        </div>
    </section>


    <!-- =========================================
         NEED HELP SECTION  (no Talk to Expert btn)
    ========================================= -->
    <section class="prod-help">
        <div class="prod-help-inner">

            <div class="prod-help-icon">
                <i class="fa-solid fa-bag-shopping"></i>
            </div>

            <div class="prod-help-text">
                <h3>Need Help Choosing?</h3>
                <p>Our plant experts are here to help you find the perfect products for your garden.</p>
            </div>

        </div>
    </section>

</div>

<!-- Category Filter Script -->
<script type="text/javascript">
    function filterProducts(cat, el) {
        // Update active tab
        document.querySelectorAll('.cat-item').forEach(function (t) {
            t.classList.remove('active');
        });
        el.classList.add('active');

        // Show / hide cards
        document.querySelectorAll('.prod-card').forEach(function (c) {
            if (cat === 'all' || c.getAttribute('data-cat') === cat) {
                c.style.display = 'flex';
            } else {
                c.style.display = 'none';
            }
        });
    }
</script>

</asp:Content>
