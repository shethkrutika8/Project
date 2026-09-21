<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="ForgotPassword.aspx.cs"
    Inherits="Project.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/ForgotPassword.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="forgot-page">

        <!-- =========================================
             MAIN FORGOT PASSWORD SECTION
        ========================================= -->
        <section class="forgot-main">
            <div class="forgot-container">

                <!-- LEFT SIDE -->
                <div class="forgot-left">

                    <!-- Farmer Image -->
                    <div class="forgot-image-box">
                        <asp:Image ID="Image1" runat="server"
                            ImageUrl="~/image/farmer.png"
                            CssClass="forgot-farmer-image"
                            AlternateText="Farmer" />
                    </div>

                    <!-- Reset Password Info (lock icon + text) -->
                    <div class="reset-info">

                        <div class="reset-icon">
                            <i class="fa-solid fa-lock"></i>
                        </div>

                        <div class="reset-text">
                            <h3>Reset Your Password</h3>
                            <p class="reset-heading">We're here to help you get back to your account</p>
                            <p>Enter the email address associated with your AgriConnect account and we'll send you a link to reset your password .</p>
                        </div>

                    </div>

                </div>


                <!-- RIGHT SIDE  (white card) -->
                <div class="forgot-right">

                    <h1>Forgot Password ?</h1>

                    <p class="forgot-description">Don't worry ! Enter your email address and we'll send you</p>
                    <p class="forgot-description">instructions to reset your password</p>

                    <!-- Email Input -->
                    <div class="email-box">
                        <i class="fa-regular fa-envelope"></i>
                        <asp:TextBox ID="Email_txt" runat="server"
                            CssClass="email-input"
                            placeholder="Enter your email address"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator
                        ID="RequiredFieldValidator1"
                        runat="server"
                        ControlToValidate="Email_txt"
                        ErrorMessage="** Enter Your Email **"
                        ForeColor="#FF3300"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator
                        ID="RegularExpressionValidator1"
                        runat="server"
                        ControlToValidate="Email_txt"
                        ErrorMessage="** Please Enter Valid Email **"
                        ForeColor="#FF3300"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>

                    <!-- Info Message -->
                    <div class="email-info">
                        <div class="info-icon">
                            <i class="fa-solid fa-info"></i>
                        </div>
                        <div class="info-text">
                            <p>We will send you a password reset link to your email</p>
                            <p>address. Please check your inbox and spam folder</p>
                        </div>
                    </div>

                    <!-- Send Reset Link Button -->
                    <asp:Button ID="Reset_btn" runat="server"
                        Text="Send Reset Link"
                        CssClass="reset-button"
                        OnClick="Reset_btn_Click" />

                </div>

            </div>
        </section>


        <!-- =========================================
             NEED HELP SECTION
        ========================================= -->
        <section class="help-section">

            <div class="help-container">

                <!-- Need Help -->
                <div class="help-intro">
                    <h3>Need Help ?</h3>
                    <p>Contact our support team for further assistance</p>
                </div>

                <!-- Support Email -->
                <div class="support-item">
                    <div class="support-icon">
                        <i class="fa-solid fa-headphones"></i>
                    </div>
                    <div class="support-details">
                        <h4>Support Email</h4>
                        <a href="mailto:support@agriconnect.com">support@agriconnect.com</a>
                    </div>
                </div>

                <!-- Phone Support -->
                <div class="support-item">
                    <div class="support-icon">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div class="support-details">
                        <h4>Phone Support</h4>
                        <p>+91 12345 67890</p>
                    </div>
                </div>

                <!-- Support Hours -->
                <div class="support-item">
                    <div class="support-icon">
                        <i class="fa-regular fa-clock"></i>
                    </div>
                    <div class="support-details">
                        <h4>Support Hours</h4>
                        <p>Mon - Sat 9:00 AM - 6:00 PM</p>
                    </div>
                </div>

            </div>

        

        </section>

    </div>

</asp:Content>
