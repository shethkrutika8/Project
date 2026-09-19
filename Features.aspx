<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Features.aspx.cs" Inherits="Project.Features" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />

    <!-- Features CSS -->
       <link href="content/Features.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!--main part upper part-->

        <section class="features-hero">

            <div class="features-container">

                <!-- LEFT CONTENT -->

                <div class="features-hero-content">

                    <h1>Our Features</h1>

                    <p>
                        Powerful tools and intelligent insights to
                        help you grow healthy plants effortlessly.
                    </p>

                    <asp:Button
                        ID="Explore_btn"
                        runat="server"
                        Text="Start Exploring"
                        CssClass="explore-btn" />

                </div>


                <!-- RIGHT IMAGE -->

                <div class="features-hero-image">

                    <asp:Image
                        ID="FeatureImage"
                        runat="server"
                        ImageUrl="~/image/about-plants.png"
                        CssClass="feature-main-image"
                        />

                </div>

            </div>

        </section>


    <!--features na card-->

        <section class="feature-cards-section">

            <div class="feature-cards-container">

<!--card 1-->

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


                <!--card 2-->

                <div class="feature-card">

                    <div class="feature-card-icon">
                        <i class="fa-regular fa-book-open"></i>
                    </div>

                    <h3>Care Guides</h3>

                    <p>
                        Step-by-step care instructions
                        customized for each plant you own.
                    </p>

                </div>


              <!--card 3-->

                <div class="feature-card">

                    <div class="feature-card-icon">
                        <i class="fa-regular fa-calendar"></i>
                    </div>

                    <h3>Smart Reminders</h3>

                    <p>
                        Get timely reminders for watering,
                        fertilizing, and other plant care tasks.
                    </p>

                </div>

<!--card 4-->

                <div class="feature-card">

                    <div class="feature-card-icon">
                        <i class="fa-solid fa-list-check"></i>
                    </div>

                    <h3>Garden Journal</h3>

                    <p>
                        Keep a personal journal with notes,
                        photos, and growth updates.
                    </p>

                </div>


               <!--card 5-->

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


                <!--card 6-->

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


               <!--card 7-->

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

<!--card 8-->

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


            <!--niche ni line-->

            <div class="feature-cta">

                <div class="cta-icon">

                    <i class="fa-solid fa-seedling"></i>

                </div>


                <div class="cta-content">

                    <h3>Everything You Need in One Place</h3>

                    <p>
                        From identification to care and tracking,
                        we make plant parenting simple and smart.
                    </p>

                </div>


            </div>

        </section>


    </div>
</asp:Content>
