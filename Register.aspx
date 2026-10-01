<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Register.aspx.cs"
    Inherits="Project.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Register.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="register-page">

        <!-- =========================================
             MAIN REGISTER SECTION
        ========================================= -->
        <section class="register-main">
            <div class="register-container">

                <!-- LEFT SIDE -->
                <div class="register-image-section">

                    <!-- Farmer Image -->
                    <div class="register-image-box">
                        <asp:Image ID="RegisterImage" runat="server"
                            ImageUrl="~/image/farmer.png"
                            CssClass="register-farmer-image"
                            AlternateText="Farmer" />
                    </div>

                    <!-- Join AgriConnect info box -->
                    <div class="register-welcome">
                        <div class="welcome-icon">
                            <i class="fa-solid fa-seedling"></i>
                        </div>
                        <div class="welcome-text">
                            <h3>Join AgriConnect</h3>
                            <p class="welcome-heading">Create your account and grow with us</p>
                            <p>Get personalized farming information, expert advice and agricultural resources.</p>
                            <p>Stay connected with the AgriConnect community.</p>
                        </div>
                    </div>

                </div>


                <!-- RIGHT SIDE — white card form -->
                <div class="register-form-section">

                    <h1>Create Your Account</h1>
                    <p class="register-description">Join AgriConnect and get access to smart farming resources</p>

                    <!-- First Name + Last Name -->
                    <div class="form-row">

                        <div class="form-group">
                            <label>First Name</label>
                            <div class="input-box">
                                <i class="fa-regular fa-user"></i>
                                <asp:TextBox ID="FirstName_txt" runat="server"
                                    CssClass="register-input"
                                    placeholder="Enter first name"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator1"
                                runat="server"
                                ControlToValidate="FirstName_txt"
                                ErrorMessage="** Enter First Name **"
                                ForeColor="#FF3300"
                                EnableClientScript="false"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label>Last Name</label>
                            <div class="input-box">
                                <i class="fa-regular fa-user"></i>
                                <asp:TextBox ID="LastName_txt" runat="server"
                                    CssClass="register-input"
                                    placeholder="Enter last name"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator2"
                                runat="server"
                                ControlToValidate="LastName_txt"
                                ErrorMessage="** Enter Last Name **"
                                ForeColor="#FF3300"
                                EnableClientScript="false"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                    </div>

                    <!-- Email Address -->
                    <div class="form-group full-width">
                        <label>Email Address</label>
                        <div class="input-box">
                            <i class="fa-regular fa-envelope"></i>
                            <asp:TextBox ID="Email_txt" runat="server"
                                CssClass="register-input"
                                placeholder="Enter your email address"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator
                            ID="RequiredFieldValidator3"
                            runat="server"
                            ControlToValidate="Email_txt"
                            ErrorMessage="** Enter Your Email **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator
                            ID="RegularExpressionValidator1"
                            runat="server"
                            ControlToValidate="Email_txt"
                            ErrorMessage="** Please Enter Valid Email **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                    </div>

                    <!-- Mobile Number -->
                    <div class="form-group full-width">
                        <label>Mobile Number</label>
                        <div class="input-box">
                            <i class="fa-solid fa-phone"></i>
                            <asp:TextBox ID="Mobile_txt" runat="server"
                                CssClass="register-input"
                                placeholder="Enter your mobile number"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator
                            ID="RequiredFieldValidator4"
                            runat="server"
                            ControlToValidate="Mobile_txt"
                            ErrorMessage="** Enter 10 Digit Contact Number **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            Display="Dynamic">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator
                            ID="RegularExpressionValidator2"
                            runat="server"
                            ControlToValidate="Mobile_txt"
                            ErrorMessage="** Mobile Number is Invalid **"
                            ForeColor="#FF3300"
                            EnableClientScript="false"
                            ValidationExpression="\d{10}"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                    </div>

                    <!-- Gender + City -->
                    <div class="form-row">

                        <div class="form-group">
                            <label>Gender</label>
                            <div class="gender-radio-group">
                                <asp:RadioButton ID="Male_Btn" runat="server" GroupName="gender" Text="Male" Checked="true" OnCheckedChanged="Male_Btn_CheckedChanged" />
                                &nbsp;&nbsp;&nbsp;
                                <asp:RadioButton ID="Female_Btn" runat="server" GroupName="gender" Text="Female" OnCheckedChanged="Female_Btn_CheckedChanged" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label>City</label>
                            <div class="input-box">
                                <i class="fa-solid fa-location-dot"></i>
                                <asp:DropDownList ID="CityDRPD" runat="server" CssClass="register-input">
                                    <asp:ListItem>Ahmedabad</asp:ListItem>
                                    <asp:ListItem>Rajkot</asp:ListItem>
                                    <asp:ListItem>Surat</asp:ListItem>
                                    <asp:ListItem>Bhavnagar</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                    </div>

                    <!-- Password + Confirm Password -->
                    <div class="form-row">

                        <div class="form-group">
                            <label>Password</label>
                            <div class="input-box">
                                <i class="fa-solid fa-lock"></i>
                                <asp:TextBox ID="Password_txt" runat="server"
                                    TextMode="Password"
                                    CssClass="register-input"
                                    placeholder="Create password"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator5"
                                runat="server"
                                ControlToValidate="Password_txt"
                                ErrorMessage="** Enter Password **"
                                ForeColor="#FF3300"
                                EnableClientScript="false"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label>Confirm Password</label>
                            <div class="input-box">
                                <i class="fa-solid fa-lock"></i>
                                <asp:TextBox ID="ConfirmPassword_txt" runat="server"
                                    TextMode="Password"
                                    CssClass="register-input"
                                    placeholder="Confirm password"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator6"
                                runat="server"
                                ControlToValidate="ConfirmPassword_txt"
                                ErrorMessage="** Enter Same Password **"
                                ForeColor="#FF3300"
                                EnableClientScript="false"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                            <asp:CompareValidator
                                ID="CompareValidator1"
                                runat="server"
                                ControlToCompare="Password_txt"
                                ControlToValidate="ConfirmPassword_txt"
                                ErrorMessage="** Please Enter same password as above **"
                                ForeColor="#FF3300"
                                EnableClientScript="false"
                                Display="Dynamic">
                            </asp:CompareValidator>
                        </div>

                    </div>

                    <!-- ASP.NET Validation Summary (server-side, no JavaScript) -->
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                        CssClass="alert alert-danger py-2 mb-2"
                        HeaderText="Please fix the following errors:"
                        DisplayMode="BulletList"
                        EnableClientScript="false"
                        ShowMessageBox="false"
                        ShowSummary="true" />

                    <!-- Server-side Error Panel (no JavaScript) -->
                    <asp:Panel ID="pnlRegisterError" runat="server" Visible="false"
                        CssClass="alert alert-danger d-flex align-items-center gap-2 mb-3">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <asp:Literal ID="litRegisterError" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- Server-side Success Panel -->
                    <asp:Panel ID="pnlRegisterSuccess" runat="server" Visible="false"
                        CssClass="alert alert-success d-flex align-items-center gap-2 mb-3">
                        <i class="fa-solid fa-circle-check"></i>
                        <asp:Literal ID="litRegisterSuccess" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- Create Account Button -->
                    <asp:Button ID="Register_btn" runat="server"
                        Text="Create Account"
                        CssClass="register-button"
                        OnClick="Register_btn_Click" />


                    <!-- OR Divider -->
                    <div class="or-divider">
                        <span></span>
                        <label>OR</label>
                        <span></span>
                    </div>

                    <!-- Already have account -->
                    <div class="login-link">
                        Already have an account?
                        <a href="Login.aspx">Sign In</a>
                    </div>

                </div>

            </div>
        </section>


        <!-- =========================================
             BENEFITS SECTION  (white — feature icons)
        ========================================= -->
        <section class="benefits-section">
            <div class="benefits-container">

                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fa-solid fa-leaf"></i>
                    </div>
                    <div>
                        <h4>Personalized</h4>
                        <p>Farming information</p>
                    </div>
                </div>

                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fa-regular fa-bell"></i>
                    </div>
                    <div>
                        <h4>Real-time</h4>
                        <p>Agricultural updates</p>
                    </div>
                </div>

                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fa-solid fa-chart-column"></i>
                    </div>
                    <div>
                        <h4>Useful</h4>
                        <p>Market insights</p>
                    </div>
                </div>

                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div>
                        <h4>Community</h4>
                        <p>Farmer support</p>
                    </div>
                </div>

            </div>
        </section>


        <!-- =========================================
             SECURITY SECTION  (green — trust badges)
        ========================================= -->
        <section class="security-section">
            <div class="security-container">

                <div class="security-item">
                    <div class="security-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <h4>Secure &amp; Safe</h4>
                        <p>Your information is protected</p>
                    </div>
                </div>

                <div class="security-item">
                    <div class="security-icon">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div>
                        <h4>Trusted Information</h4>
                        <p>Get accurate information</p>
                    </div>
                </div>

                <div class="security-item">
                    <div class="security-icon">
                        <i class="fa-solid fa-hand-holding-heart"></i>
                    </div>
                    <div>
                        <h4>Better Decisions</h4>
                        <p>Make smarter farming choices</p>
                    </div>
                </div>

                <div class="security-item">
                    <div class="security-icon">
                        <i class="fa-solid fa-globe"></i>
                    </div>
                    <div>
                        <h4>Accessible Anywhere</h4>
                        <p>Access information anytime</p>
                    </div>
                </div>

            </div>
        </section>

    </div>

</asp:Content>
