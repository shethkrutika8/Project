<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderPlaced.aspx.cs" Inherits="Project.OrderPlaced" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Order Placed - AgriCulture</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet" />

        <!-- Custom CSS -->
        <link href="Content/OrderPlaced.css" rel="stylesheet" />
    </head>

    <body>
        <form id="form1" runat="server">

            <!-- Store Navbar -->
            <header class="store-navbar">
                <a href="#" class="brand-logo">
                    <i class="fa-solid fa-leaf"></i> <span>AgriCulture</span>
                </a>

                <div class="nav-links">
                    <a href="#">Home</a>
                    <a href="#">Plants</a>
                    <a href="#">Seeds</a>
                    <a href="#">Pots & Planters</a>
                    <a href="#">Tools</a>
                    <a href="#">Plant Care</a>
                    <a href="#">Offers</a>
                </div>

                <div class="search-bar-container">
                    <input type="text" placeholder="Search plants, seeds..." />
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>

                <div class="nav-icons">
                    <a href="#" class="text-reset"><i class="fa-regular fa-heart"></i></a>
                    <a href="#" class="text-reset cart-icon">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <span class="badge">2</span>
                    </a>
                    <a href="#" class="text-reset"><i class="fa-regular fa-user"></i></a>
                </div>
            </header>

            <!-- Top Banner -->
            <div class="top-banner">
                <div class="banner-left">
                    <div class="success-icon-large">
                        <i class="fa-solid fa-check"></i>
                    </div>
                    <div class="banner-text">
                        <h1>Thank you! Your order has been placed.</h1>
                        <p>We've received your order and it is now being processed.<br />You will receive an order
                            confirmation email shortly.</p>
                        <div class="banner-buttons">
                            <a href="#" class="btn-custom btn-primary-custom">View Order Details</a>
                            <a href="#" class="btn-custom btn-outline-custom">Continue Shopping</a>
                        </div>
                    </div>
                </div>
                <div class="banner-right">
                    <div class="order-detail-row">
                        <i class="fa-regular fa-clipboard"></i>
                        <div>
                            <h6>Order Number</h6>
                            <p>#ORD-2024-05-16-001245</p>
                        </div>
                    </div>
                    <div class="order-detail-row">
                        <i class="fa-regular fa-calendar"></i>
                        <div>
                            <h6>Order Date</h6>
                            <p class="date">16 May 2024, 10:24 AM</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Grid Layout -->
            <div class="main-grid">

                <!-- Left Column -->
                <div class="col-left">

                    <!-- Order Tracking -->
                    <div class="content-card">
                        <h2 class="card-title">Order Tracking</h2>
                        <p class="card-subtitle">We will notify you at each step.</p>

                        <div class="stepper-container">
                            <div class="stepper-line"></div>
                            <div class="stepper-line-active"></div>

                            <div class="step active">
                                <div class="step-icon"><i class="fa-solid fa-check"></i></div>
                                <div class="step-title">Order Placed</div>
                                <div class="step-date">16 May, 10:24 AM</div>
                            </div>

                            <div class="step current">
                                <div class="step-icon"><i class="fa-solid fa-box-open"></i></div>
                                <div class="step-title">Confirmed</div>
                                <div class="step-date">16 May, 10:26 AM</div>
                            </div>

                            <div class="step">
                                <div class="step-icon"><i class="fa-solid fa-truck-fast"></i></div>
                                <div class="step-title">Shipped</div>
                                <div class="step-date">-</div>
                            </div>

                            <div class="step">
                                <div class="step-icon"><i class="fa-solid fa-box"></i></div>
                                <div class="step-title">Delivered</div>
                                <div class="step-date">-</div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="content-card items-list-card">
                        <h2 class="card-title">Order Items (3)</h2>

                        <div class="items-list">
                            <!-- Item 1 -->
                            <div class="item-row">
                                <div class="item-product">
                                    <div class="item-image">
                                        <i class="fa-solid fa-plant-wilt text-success fa-xl"></i>
                                    </div>
                                    <div class="item-details">
                                        <h6>Areca Palm</h6>
                                        <p>Air Purifying Plant</p>
                                    </div>
                                </div>
                                <div class="item-price-strikethrough">₹699</div>
                                <div class="item-qty">Qty: 1</div>
                                <div class="item-total">₹699</div>
                            </div>

                            <!-- Item 2 -->
                            <div class="item-row">
                                <div class="item-product">
                                    <div class="item-image">
                                        <i class="fa-solid fa-seedling text-success fa-xl"></i>
                                    </div>
                                    <div class="item-details">
                                        <h6>Succulent Mix (Pack of 3)</h6>
                                        <p>Low Maintenance</p>
                                    </div>
                                </div>
                                <div class="item-price-strikethrough">₹449</div>
                                <div class="item-qty">Qty: 1</div>
                                <div class="item-total">₹449</div>
                            </div>

                            <!-- Item 3 -->
                            <div class="item-row">
                                <div class="item-product">
                                    <div class="item-image">
                                        <i class="fa-solid fa-bucket text-secondary fa-xl"></i>
                                    </div>
                                    <div class="item-details">
                                        <h6>Self Watering Pot-White</h6>
                                        <p>Medium Size</p>
                                    </div>
                                </div>
                                <div class="item-price-strikethrough">₹299</div>
                                <div class="item-qty">Qty: 1</div>
                                <div class="item-total">₹299</div>
                            </div>
                        </div>

                        <div class="promise-widget border-top border-1 mt-3">
                            <div class="promise-icon">
                                <i class="fa-solid fa-shield-halved"></i>
                            </div>
                            <div class="promise-text">
                                <h6>Plant Protection Promise</h6>
                                <p>If your plant is damaged during delivery, we will replace it for free.</p>
                            </div>
                        </div>
                    </div>

                    <!-- What's Next -->
                    <div class="content-card">
                        <h2 class="card-title">What's Next?</h2>

                        <div class="whats-next-grid">
                            <div class="next-item border-end border-1 pe-3">
                                <i class="fa-regular fa-envelope next-icon"></i>
                                <h6>Order Confirmation</h6>
                                <p>We have sent you an email with order details.</p>
                            </div>
                            <div class="next-item border-end border-1 pe-3">
                                <i class="fa-solid fa-box-open next-icon"></i>
                                <h6>Order Processing</h6>
                                <p>We are packing your plants with care.</p>
                            </div>
                            <div class="next-item border-end border-1 pe-3">
                                <i class="fa-solid fa-truck-fast next-icon"></i>
                                <h6>Shipping Soon</h6>
                                <p>You will receive tracking details once shipped.</p>
                            </div>
                            <div class="next-item pe-3">
                                <i class="fa-solid fa-seedling next-icon"></i>
                                <h6>Enjoy Your Plants</h6>
                                <p>Unbox, plant and enjoy your new green friends!</p>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Right Column -->
                <div class="col-right">

                    <!-- Order Summary -->
                    <div class="content-card">
                        <h2 class="card-title mb-4">Order Summary</h2>

                        <div class="summary-row">
                            <span>Subtotal (3 items)</span>
                            <span>₹1,447</span>
                        </div>
                        <div class="summary-row free-shipping">
                            <span>Shipping Charges</span>
                            <span>FREE</span>
                        </div>
                        <div class="summary-row">
                            <span>Packaging Charges</span>
                            <span>₹49</span>
                        </div>
                        <div class="summary-row">
                            <span>Tax (Incl. of GST)</span>
                            <span>₹166</span>
                        </div>

                        <div class="summary-total">
                            <span>Total Amount</span>
                            <span class="total-amount">₹1,662</span>
                        </div>

                        <div class="savings-alert">
                            <div class="d-flex align-items-center gap-2">
                                <i class="fa-solid fa-circle-check"></i> <span>You saved ₹146 on this order</span>
                            </div>
                            <i class="fa-solid fa-tags"></i>
                        </div>

                        <!-- Sidebar Section: Shipping Address -->
                        <div class="sidebar-section">
                            <div class="sidebar-section-header">
                                <h6><i class="fa-solid fa-location-dot"></i> Shipping Address</h6>
                                <a href="#" class="btn-edit">Edit</a>
                            </div>
                            <div class="shipping-address">
                                <p class="name">Dipel Shah</p>
                                <p>2nd Floor, 24th Main, RR Nagar</p>
                                <p>Bangalore, Karnataka-560098</p>
                                <p>India</p>
                                <p class="mt-2">Phone: +91 98765 43210</p>
                            </div>
                        </div>

                        <!-- Sidebar Section: Payment Method -->
                        <div class="sidebar-section">
                            <div class="sidebar-section-header">
                                <h6><i class="fa-regular fa-credit-card"></i> Payment Method</h6>
                                <a href="#" class="btn-edit">Edit</a>
                            </div>
                            <div class="shipping-address d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="name mb-1">Paid Online</p>
                                    <p>Visa **** **** **** 4242</p>
                                </div>
                                <span style="font-weight: 600; color:#444;">₹1,662</span>
                            </div>
                        </div>
                    </div>

                    <!-- Help Desk Card -->
                    <div class="help-card">
                        <div class="help-card-header">
                            <i class="fa-solid fa-headset fa-xl"></i>
                            <h6>Need Help?</h6>
                        </div>
                        <p>Our support team is here to help you.</p>

                        <div class="help-contact-row">
                            <i class="fa-solid fa-phone"></i> +91 98765 43210
                        </div>
                        <div class="help-contact-row">
                            <i class="fa-solid fa-envelope"></i> support@agriculture.com
                        </div>

                        <div class="help-hours">
                            Mon - Sat: 9:00 AM to 6:00 PM
                        </div>
                    </div>

                </div>
            </div>

        </form>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>