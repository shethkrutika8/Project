<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Project.About" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />
    <link href="content/About.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="about-page">

        <!--About-->

        <section class="about-hero">

            <div class="about-container">

                <!-- LEFT CONTENT -->

                <div class="about-content">

                    <h1>About Us</h1>

                    <h3>Our Mission</h3>

                    <p>
                        At AgriCulture, we believe every plant has a story
                        and every gardener deserves the right guidance.
                        Our platform combines technology and nature
                        to help you grow healthier plants with
                        confidence and ease.
                    </p>

                   
                </div>


                <!-- RIGHT IMAGE -->

                <div class="about-image-box">

                    <asp:Image
                        ID="AboutImage"
                        runat="server"
                        ImageUrl="~/image/about-plants.png"
                        CssClass="about-main-image"
                         />

                </div>

            </div>

        </section>

        <!--feature i entered-->

        <section class="about-features">

            <div class="features-container">

               

                <div class="feature-item">

                    <div class="feature-icon">
                        <i class="fa-solid fa-leaf"></i>
                    </div>

                    <h4>Plant-Centric</h4>

                    <p>
                        Everything we do is
                        designed for plant lovers.
                    </p>

                </div>



                <div class="feature-item">

                    <div class="feature-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>

                    <h4>Trusted Information</h4>

                    <p>
                        Accurate, scientific, and
                        reliable plant care data.
                    </p>

                </div>



                <div class="feature-item">

                    <div class="feature-icon">
                        <i class="fa-solid fa-users"></i>
                    </div>

                    <h4>Community Focused</h4>

                    <p>
                        Building a community of
                        gardeners and growers.
                    </p>

                </div>



                <div class="feature-item">

                    <div class="feature-icon">
                        <i class="fa-solid fa-globe"></i>
                    </div>

                    <h4>Sustainable Future</h4>

                    <p>
                        Promoting green living for
                        a better tomorrow.
                    </p>

                </div>

            </div>

        </section>

<!--story-->

        <section class="story-section">

            <div class="story-container">


                <div class="story-content">

                    <h3>Our Story</h3>

                    <p>
                        AgriCulture was born out of a passion for plants
                        and the desire to make plant care simple,
                        accessible, and enjoyable for everyone.
                    </p>

                </div>


                <!-- RIGHT IMAGE -->

                <div class="story-image-box">

                    <asp:Image
                        ID="StoryImage"
                        runat="server"
                        ImageUrl="~/image/about-story.png"
                        CssClass="story-image"
                         />

                </div>

            </div>

        </section>

    </div>

</asp:Content>
