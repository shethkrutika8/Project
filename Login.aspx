<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="Project.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Login.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="agri-login-page">

        <!-- =========== LOGIN SECTION =========== -->
        <section class="agri-login-main">
            <div class="agri-login-card">

                <!-- LEFT: IMAGE -->
                <div class="agri-login-image">
                    <asp:Image ID="Image1" runat="server"
                        ImageUrl="~/image/farmer.png"
                        CssClass="forgot-farmer-image"
                        AlternateText="Farmer" />
                </div>

                <!-- RIGHT: FORM (white box) -->
                <div class="agri-login-form">

                    <h1>Login To AgriConnect</h1>
                    <p class="agri-login-subtitle">Enter your credentials to access your account</p>

                    <!-- Email -->
                    <div class="agri-input-group">
                        <label>Email Address</label>
                        <div class="agri-input-wrapper">
                            <i class="fa-solid fa-envelope"></i>
                            <asp:TextBox ID="txtEmail" runat="server"
                                CssClass="agri-input"
                                placeholder="Enter your email address"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator
                            ID="RequiredFieldValidator1"
                            runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="** Enter Your Email **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator
                            ID="RegularExpressionValidator1"
                            runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="** Please Enter Valid Email **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                    </div>

                    <!-- Password -->
                    <div class="agri-input-group">
                        <label>Password</label>
                        <div class="agri-input-wrapper">
                            <i class="fa-solid fa-lock"></i>
                            <asp:TextBox ID="txtPassword" runat="server"
                                TextMode="Password"
                                CssClass="agri-input"
                                placeholder="Enter your password"></asp:TextBox>
                            <i class="fa-solid fa-lock agri-eye" title="Password"></i>
                        </div>
                        <asp:RequiredFieldValidator
                            ID="RequiredFieldValidator2"
                            runat="server"
                            ControlToValidate="txtPassword"
                            ErrorMessage="** Enter Password **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <!-- Remember Me / Forgot -->
                    <div class="agri-login-options">
                        <label class="agri-remember">
                            <asp:CheckBox ID="chkRemember" runat="server" />
                            <span>Remember Me</span>
                        </label>
                        <a href="ForgotPassword.aspx">Forgot Password ?</a>
                    </div>

                    <!-- ASP.NET Validation Summary (server-side, no JS) -->
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                        CssClass="validation-summary-errors alert alert-danger py-2 mb-2"
                        HeaderText="Please correct the following errors:"
                        DisplayMode="BulletList"
                        EnableClientScript="false"
                        ShowMessageBox="false"
                        ShowSummary="true" />

                    <!-- Server-side Error Panel (no JavaScript) -->
                    <asp:Panel ID="pnlLoginError" runat="server" Visible="false"
                        CssClass="alert alert-danger d-flex align-items-center gap-2 mb-3">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <asp:Literal ID="litLoginError" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- Login Button -->
                    <asp:Button ID="btnLogin" runat="server"
                        Text="Login"
                        CssClass="agri-login-button"
                        OnClick="btnLogin_Click" />

                    <!-- OR -->
                    <div class="agri-or"><span>OR</span></div>

                    <!-- Register link -->
                    <div class="agri-register">
                        Don't have an account ?
                        <a href="Register.aspx">Create Account</a>
                    </div>

                </div>
            </div>
        </section>


        <!-- =========== WELCOME BACK SECTION =========== -->
        <section class="agri-welcome">
            <div class="agri-welcome-inner">

                <!-- Text (left) -->
                <div class="agri-welcome-text">
                    <h2>Welcome Back !</h2>
                    <p>Login to continue your smart farming journey</p>
                    <p>Access personalized information track updates and stay connected with the latest farming resources</p>
                </div>

                <!-- Feature icons (right) -->
                <div class="agri-features">

                    <div class="agri-feature">
                        <div class="agri-feature-icon">
                            <i class="fa-solid fa-seedling"></i>
                        </div>
                        <strong>Personalized</strong>
                        <span>Dashboard</span>
                    </div>

                    <div class="agri-feature">
                        <div class="agri-feature-icon">
                            <i class="fa-regular fa-bell"></i>
                        </div>
                        <strong>Real - time</strong>
                        <span>Updates</span>
                    </div>

                    <div class="agri-feature">
                        <div class="agri-feature-icon">
                            <i class="fa-solid fa-chart-simple"></i>
                        </div>
                        <strong>Useful</strong>
                        <span>Insights</span>
                    </div>

                    <div class="agri-feature">
                        <div class="agri-feature-icon">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <strong>Community</strong>
                        <span>Support</span>
                    </div>

                </div>
            </div>
        </section>


        <!-- =========== TRUST SECTION =========== -->
        <section class="agri-trust">
            <div class="agri-trust-inner">

                <div class="agri-trust-item">
                    <div class="agri-trust-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <strong>Secure &amp; Safe</strong>
                        <span>Your data is protected</span>
                    </div>
                </div>

                <div class="agri-trust-item">
                    <div class="agri-trust-icon">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div>
                        <strong>Trusted Information</strong>
                        <span>Get accurate and reliable</span>
                    </div>
                </div>

                <div class="agri-trust-item">
                    <div class="agri-trust-icon">
                        <i class="fa-solid fa-hand-holding-heart"></i>
                    </div>
                    <div>
                        <strong>Better Decisions</strong>
                        <span>Make smarter farming</span>
                    </div>
                </div>

                <div class="agri-trust-item">
                    <div class="agri-trust-icon">
                        <i class="fa-solid fa-globe"></i>
                    </div>
                    <div>
                        <strong>Accessible Anywhere</strong>
                        <span>Access information anytime</span>
                    </div>
                </div>

            </div>
        </section>

    </div>

</asp:Content>
