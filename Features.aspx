<%@ Page Title="Our Features - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Features.aspx.cs" Inherits="Project.Features" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific CSS matching Figma design pixel-perfectly -->
    <link href="Content/Features.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="features-page">
<div class="features-wrapper">

    <!-- =========================================================
         1. HERO SECTION - Exact Figma Layout
         ========================================================= -->
    <section class="features-hero">
        <div class="features-hero-card">

            <!-- LEFT CONTENT -->
            <div class="features-hero-content">
                <h1 class="features-title">Our Features</h1>
                <p class="features-desc">
                    Powerful tools and intelligent insights to
                    help you grow healthy plants effortlessly.
                </p>
                <asp:Button
                    ID="Explore_btn"
                    runat="server"
                    Text="Start Exploring"
                    CssClass="explore-btn"
                    OnClick="Explore_btn_Click" />
            </div>

            <!-- RIGHT IMAGE -->
            <div class="features-hero-image">
                <asp:Image
                    ID="FeatureImage"
                    runat="server"
                    ImageUrl="~/image/about-plants.PNG"
                    CssClass="feature-main-image"
                    AlternateText="Indoor Healthy Plants" />
            </div>

        </div>
    </section>

    <!-- =========================================================
         2. FEATURE CARDS GRID (8 Cards - 4x2 Layout)
         ========================================================= -->
    <section class="feature-cards-section">
        <div class="feature-cards-grid">

            <!-- Card 1: Plant Identification -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-leaf"></i>
                </div>
                <h3>Plant Identification</h3>
                <p>
                    Identify plants instantly with
                    our advanced AI-powered recognition.
                </p>
            </div>

            <!-- Card 2: Care Guides -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-book-open"></i>
                </div>
                <h3>Care Guides</h3>
                <p>
                    Step-by-step care instructions
                    customized for each plant you own.
                </p>
            </div>

            <!-- Card 3: Smart Reminders -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-regular fa-calendar-check"></i>
                </div>
                <h3>Smart Reminders</h3>
                <p>
                    Get timely reminders for watering,
                    fertilizing, and other plant care tasks.
                </p>
            </div>

            <!-- Card 4: Garden Journal -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-regular fa-file-lines"></i>
                </div>
                <h3>Garden Journal</h3>
                <p>
                    Keep a personal journal with
                    notes, photos, and growth updates.
                </p>
            </div>

            <!-- Card 5: Growth Tracking -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-chart-column"></i>
                </div>
                <h3>Growth Tracking</h3>
                <p>
                    Track your plant's growth progress
                    and health over time.
                </p>
            </div>

            <!-- Card 6: Weather Insights -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-cloud-sun"></i>
                </div>
                <h3>Weather Insights</h3>
                <p>
                    Get local weather updates and tips
                    to protect your plants.
                </p>
            </div>

            <!-- Card 7: Community Support -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-users"></i>
                </div>
                <h3>Community Support</h3>
                <p>
                    Connect with fellow plant lovers
                    and get expert advice.
                </p>
            </div>

            <!-- Card 8: Plant Care Shop -->
            <div class="feature-card">
                <div class="feature-card-icon">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <h3>Plant Care Shop</h3>
                <p>
                    Find the best tools, seeds, and
                    fertilizers all in one place.
                </p>
            </div>

        </div>

        <!-- =========================================================
             3. BOTTOM CTA BANNER - Exact Figma Layout
             ========================================================= -->
        <div class="feature-cta-banner">
            <div class="cta-left-box">
                <div class="cta-sprout-icon">
                    <i class="fa-solid fa-seedling"></i>
                </div>
                <div class="cta-text-content">
                    <h4 class="cta-heading">Everything You Need in One Place</h4>
                    <p class="cta-subheading">
                        From identification to care and tracking,
                        we make plant parenting simple and smart.
                    </p>
                </div>
            </div>

            <div class="cta-right-box">
                <asp:Button
                    ID="btnGetStartedFree"
                    runat="server"
                    Text="Get Started Free"
                    CssClass="btn-getstarted-free"
                    OnClick="btnGetStartedFree_Click" />
            </div>
        </div>

    </section>

</div>
</div>
</asp:Content>
