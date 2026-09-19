<%@ Page Title="AgriConnect Dashboard"
    Language="C#"
    MasterPageFile="~/Site1.master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="Project.Dashboard" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">
    <link href="Content/Dashboard.css" rel="stylesheet" />
    <title>AgriConnect Dashboard</title>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="ContentPlaceHolder1"
    runat="server">

    <!-- ================= HERO SECTION ================= -->
    <section class="hero">
        <div class="hero-content">
            <h1>Empowering Farmers<br />with Better Information</h1>
            <p>Agriconnect brings crop information, government schemes, market prices, weather, updates, and farming resources together in one simple platform.</p>
            <a href="#" class="explore-btn">Explore Dashboard</a>
        </div>
        <div class="hero-image">
            <img src="image/farmer.png" alt="Farmer using mobile phone" />
        </div>
    </section>

    <!-- ================= STATISTICS ================= -->
    <section class="statistics">
        <div class="stat">
            <div class="stat-icon">&#127807;</div>
            <div class="stat-text">
                <h2>120+</h2>
                <p>Crops Information</p>
            </div>
        </div>
        <div class="stat">
            <div class="stat-icon">&#127963;</div>
            <div class="stat-text">
                <h2>35+</h2>
                <p>Schemes Available</p>
            </div>
        </div>
        <div class="stat">
            <div class="stat-icon">&#8377;</div>
            <div class="stat-text">
                <h2>200+</h2>
                <p>Market Prices</p>
            </div>
        </div>
        <div class="stat">
            <div class="stat-icon">&#128101;</div>
            <div class="stat-text">
                <h2>10K+</h2>
                <p>Farmers Connected</p>
            </div>
        </div>
    </section>

    <!-- ================= FEATURES ================= -->
    <section class="dash-features-section">
        <h2 class="section-title">Explore Key Features</h2>
        <div class="dash-features-grid">
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#127809;</div>
                <h3>Crops Information</h3>
                <p>Get information about crops, seasons, and best practices.</p>

            </div>
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#127963;</div>
                <h3>Government Schemes</h3>
                <p>Discover eligible government schemes and subsidies.</p>

            </div>
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#8377;</div>
                <h3>Market Prices</h3>
                <p>Check current crop prices in your local market.</p>

            </div>
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#9728;</div>
                <h3>Weather Updates</h3>
                <p>Get accurate weather forecasts for better planning.</p>
               

            </div>
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#128218;</div>
                <h3>Farming Guides</h3>
                <p>Read expert articles and farming tips.</p>
              

            </div>
            <div class="dash-feature-card">
                <div class="dash-feature-icon">&#128172;</div>
                <h3>Community</h3>
                <p>Connect with other farmers and share knowledge.</p>
                

            </div>
        </div>
    </section>

</asp:Content>
