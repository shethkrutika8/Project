<%@ Page Title="Pricing - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="Pricing.aspx.cs"
    Inherits="Project.Pricing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Pricing.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="pricing-page">

    <!-- =========================================
         HERO SECTION
    ========================================= -->
    <section class="pricing-hero-section">
        <div class="pricing-hero-wrapper">
            <div class="pricing-hero-card">
                <div class="pricing-hero-content">
                    <h1 class="pricing-hero-title">Simple, Transparent Pricing</h1>
                    <p class="pricing-hero-desc">
                        Choose the perfect plan to grow your plants smarter. No hidden fees, cancel anytime.
                    </p>
                    <a href="#planSection" class="btn-start-free">Start Free Today</a>
                </div>
                <div class="pricing-hero-image-wrap">
                    <img src="image/products-hero-plants.png" alt="Pricing Banner Plants" class="pricing-hero-img" />
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================
         PRICING CARD SECTION (BASIC 0 RS)
    ========================================= -->
    <section class="pricing-card-section" id="planSection">
        <div class="pricing-card-wrapper">

            <div class="single-plan-card">
                <div class="plan-header">
                    <span class="plan-tag">Free Forever</span>
                    <h2 class="plan-name">Basic</h2>
                    <p class="plan-target">For Beginners &amp; Plant Lovers</p>
                </div>

                <div class="plan-price-wrap">
                    <span class="plan-currency">&#8377;</span>
                    <span class="plan-amount">0</span>
                </div>
                <div class="plan-period">Free Forever</div>

                <div class="plan-divider"></div>

                <div class="plan-features">
                    <div class="feature-item">
                        <div class="feature-check">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="12" cy="12" r="10" stroke="#2fa13a" stroke-width="2" fill="#edf7eb" />
                                <path d="M8 12.5l2.5 2.5 5.5-5.5" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <span class="feature-text">Identify up to 5 plants/month</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-check">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="12" cy="12" r="10" stroke="#2fa13a" stroke-width="2" fill="#edf7eb" />
                                <path d="M8 12.5l2.5 2.5 5.5-5.5" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <span class="feature-text">Basic care guides</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-check">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="12" cy="12" r="10" stroke="#2fa13a" stroke-width="2" fill="#edf7eb" />
                                <path d="M8 12.5l2.5 2.5 5.5-5.5" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <span class="feature-text">Watering reminders</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-check">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="12" cy="12" r="10" stroke="#2fa13a" stroke-width="2" fill="#edf7eb" />
                                <path d="M8 12.5l2.5 2.5 5.5-5.5" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <span class="feature-text">Community access</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-check">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="12" cy="12" r="10" stroke="#2fa13a" stroke-width="2" fill="#edf7eb" />
                                <path d="M8 12.5l2.5 2.5 5.5-5.5" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <span class="feature-text">No credit card required</span>
                    </div>
                </div>

                <div class="plan-action">
                    <a href="Register.aspx" class="btn-get-started-plan">Get Started Free</a>
                </div>
            </div>

        </div>
    </section>

    <!-- =========================================
         TRUST & GUARANTEES BANNER
    ========================================= -->
    <section class="pricing-trust-section">
        <div class="pricing-trust-wrapper">
            <div class="pricing-trust-card">

                <!-- 1. Secure & Safe -->
                <div class="trust-item">
                    <div class="trust-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"></path>
                            <path d="m9 12 2 2 4-4"></path>
                        </svg>
                    </div>
                    <div class="trust-text">
                        <h4 class="trust-title">Secure &amp; Safe</h4>
                        <p class="trust-desc">Your data is safe and encrypted.</p>
                    </div>
                </div>

                <!-- 2. Cancel Anytime -->
                <div class="trust-item">
                    <div class="trust-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21.5 2v6h-6"></path>
                            <path d="M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.19"></path>
                        </svg>
                    </div>
                    <div class="trust-text">
                        <h4 class="trust-title">Cancel Anytime</h4>
                        <p class="trust-desc">No commitments. Cancel anytime.</p>
                    </div>
                </div>

                <!-- 3. Free Forever Guarantee -->
                <div class="trust-item">
                    <div class="trust-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="8" r="6"></circle>
                            <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path>
                        </svg>
                    </div>
                    <div class="trust-text">
                        <h4 class="trust-title">Free Forever</h4>
                        <p class="trust-desc">100% free plan, zero hidden charges.</p>
                    </div>
                </div>

                <!-- 4. Always Here -->
                <div class="trust-item">
                    <div class="trust-icon-box">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 18 0v7a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3"></path>
                        </svg>
                    </div>
                    <div class="trust-text">
                        <h4 class="trust-title">Always Here</h4>
                        <p class="trust-desc">Our support team is always ready to help.</p>
                    </div>
                </div>

            </div>
        </div>
    </section>

</div>

</asp:Content>
