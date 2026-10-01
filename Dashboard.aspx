<%@ Page Title="Dashboard"
    Language="C#"
    MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="Project.Dashboard" %>

<asp:Content ID="DashboardContent"
    ContentPlaceHolderID="ContentPlaceHolder1"
    runat="server">

    <!-- Dashboard Stylesheets -->
    <link href="Content/Dashboard.css" rel="stylesheet" />
    <link href="Dashboard.css" rel="stylesheet" />

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <div class="dashboard-page">

        <!-- HERO SECTION -->
        <section class="hero-section">
            <div class="hero-container">
                <div class="hero-content">
                    <h1>
                        Empowering Farmers<br />
                        with Better Information
                    </h1>

                    <p>Agriconnect brings crop information, government</p>
                    <p>Schemes, market prices, weather, updates, and</p>
                    <p class="hero-p-last">Farming resources together in one simple plateform.</p>

                    <a href="Dashboard.aspx" class="explore-btn">
                        Explore Dashboard
                    </a>
                </div>

                <div class="hero-image">
                    <img src="image/farmer.png"
                         alt="Empowering Farmers with Better Information" />
                </div>
            </div>
        </section>


        <!-- STATISTICS SECTION -->
        <section class="stats-section">
            <div class="stats-container">

                <div class="stat-box">
                    <div class="stat-icon">
                        <i class="fa-solid fa-leaf"></i>
                    </div>
                    <div class="stat-content">
                        <h2>120+</h2>
                        <span>Crops Information</span>
                    </div>
                </div>

                <div class="stat-box">
                    <div class="stat-icon">
                        <i class="fa-solid fa-building-columns"></i>
                    </div>
                    <div class="stat-content">
                        <h2>35+</h2>
                        <span>Schemes Available</span>
                    </div>
                </div>

                <div class="stat-box">
                    <div class="stat-icon">
                        <i class="fa-solid fa-chart-simple"></i>
                    </div>
                    <div class="stat-content">
                        <h2>200+</h2>
                        <span>Market Prices</span>
                    </div>
                </div>

                <div class="stat-box">
                    <div class="stat-icon">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div class="stat-content">
                        <h2>10K+</h2>
                        <span>Farmers Connected</span>
                    </div>
                </div>

            </div>
        </section>


        <!-- FEATURES SECTION -->
        <section class="features-section">
            <div class="features-container">

                <h2 class="section-title">
                    Explore Key Features
                </h2>

                <div class="feature-grid">

                    <!-- Crops Information -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-solid fa-seedling"></i>
                        </div>
                        <h3>Crops Information</h3>
                        <p>
                            Get information about
                            crops, seasons, and
                            best practices.
                        </p>
                        <a href="Products.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Government Schemes -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-solid fa-building-columns"></i>
                        </div>
                        <h3>Government Schemes</h3>
                        <p>
                            Discover eligible
                            government schemes
                            and subsidies.
                        </p>
                        <a href="About.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Market Prices -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                        </div>
                        <h3>Market Prices</h3>
                        <p>
                            Check current crop
                            prices in your local
                            market.
                        </p>
                        <a href="Pricing.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Weather Updates -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-solid fa-cloud-sun"></i>
                        </div>
                        <h3>Weather Updates</h3>
                        <p>
                            Get accurate weather
                            forecasts for better
                            planning.
                        </p>
                        <a href="Features.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Farming Guides -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-solid fa-book-open"></i>
                        </div>
                        <h3>Farming Guides</h3>
                        <p>
                            Read expert articles
                            and farming
                            tips.
                        </p>
                        <a href="AIDiagnose.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Community -->
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fa-regular fa-comment-dots"></i>
                        </div>
                        <h3>Community</h3>
                        <p>
                            Connect with other
                            farmers and share
                            knowledge.
                        </p>
                        <a href="About.aspx" class="feature-link">
                            View More <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>

                </div>

            </div>
        </section>

    </div>

</asp:Content>