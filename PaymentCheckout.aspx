<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentCheckout.aspx.cs" Inherits="Project.PaymentCheckout" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Payments & Checkout Settings - AgriCulture</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet" />

        <!-- Custom CSS -->
        <link href="Content/PaymentCheckout.css" rel="stylesheet" />
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="admin-layout">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="sidebar-header">
                        <a href="Dashboard.aspx" class="brand-logo">
                            <i class="fa-solid fa-leaf text-success"></i> <span>AgriCulture</span>
                        </a>
                    </div>

                    <div class="sidebar-content">
                        <div class="nav-group">
                            <div class="nav-group-title">MAIN MENU</div>
                            <ul class="nav-list">
                                <li><a href="#"><i class="fa-solid fa-house"></i> Dashboard</a></li>
                                <li><a href="#"><i class="fa-solid fa-box-open"></i> Orders</a></li>
                                <li><a href="#"><i class="fa-solid fa-seedling"></i> Products</a></li>
                                <li><a href="#"><i class="fa-solid fa-plant-wilt"></i> Plants</a></li>
                                <li><a href="#"><i class="fa-solid fa-users"></i> Customers</a></li>
                                <li><a href="#"><i class="fa-solid fa-star"></i> Reviews</a></li>
                                <li><a href="#"><i class="fa-solid fa-ticket"></i> Coupons & Offers</a></li>
                                <li><a href="#"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
                            </ul>
                        </div>

                        <div class="nav-group">
                            <div class="nav-group-title">STORE SETTINGS</div>
                            <ul class="nav-list">
                                <li><a href="#"><i class="fa-solid fa-gear"></i> General Settings</a></li>
                                <li><a href="#"><i class="fa-solid fa-truck"></i> Shipping Settings</a></li>
                                <li><a href="#"><i class="fa-solid fa-file-invoice-dollar"></i> Tax Settings</a></li>
                                <li><a href="#" class="active"><i class="fa-solid fa-credit-card"></i> Payment &
                                        Checkout</a></li>
                                <li><a href="#"><i class="fa-regular fa-envelope"></i> Email Templates</a></li>
                                <li><a href="#"><i class="fa-regular fa-bell"></i> Notifications</a></li>
                            </ul>
                        </div>

                        <div class="nav-group">
                            <div class="nav-group-title">MANAGEMENT</div>
                            <ul class="nav-list">
                                <li><a href="#"><i class="fa-solid fa-blog"></i> Blog Management</a></li>
                                <li><a href="#"><i class="fa-solid fa-circle-question"></i> FAQ Management</a></li>
                                <li><a href="#"><i class="fa-regular fa-images"></i> Banners</a></li>
                                <li><a href="#"><i class="fa-solid fa-user-shield"></i> Users & Roles</a></li>
                            </ul>
                        </div>

                        <div class="nav-group">
                            <div class="nav-group-title">SYSTEM</div>
                            <ul class="nav-list">
                                <li><a href="#"><i class="fa-solid fa-clock-rotate-left"></i> Activity Logs</a></li>
                                <li><a href="#"><i class="fa-solid fa-database"></i> Backup & Restore</a></li>
                            </ul>
                        </div>

                        <div class="help-card">
                            <h5>Need Help?</h5>
                            <p>Check our documentation or contact support.</p>
                            <a href="#" class="btn btn-success btn-sm w-100">Go to Docs <i
                                    class="fa-solid fa-arrow-right ms-1"></i></a>
                        </div>
                    </div>
                </aside>

                <!-- Main Content Area -->
                <main class="main-content">
                    <!-- Top Navbar -->
                    <header class="top-navbar">
                        <div class="nav-links">
                            <a href="#">Features</a>
                            <a href="#">About Us</a>
                            <a href="#">Orders</a>
                            <a href="#">Customers</a>
                            <a href="#">Reports</a>
                            <a href="#">Reviews</a>
                            <a href="#">Marketing</a>
                            <a href="#" class="active border-bottom border-success border-2">Settings</a>
                        </div>

                        <div class="user-controls">
                            <div class="notification-icon">
                                <i class="fa-regular fa-bell"></i>
                                <span class="badge">3</span>
                            </div>
                            <div class="user-profile">
                                <div class="user-info">
                                    <span class="user-name">Admin</span>
                                    <span class="user-role">Super Admin <i
                                            class="fa-solid fa-chevron-down ms-1"></i></span>
                                </div>
                                <div class="user-avatar">
                                    <i class="fa-solid fa-user"></i>
                                </div>
                            </div>
                        </div>
                    </header>

                    <!-- Page Content -->
                    <div class="page-container">
                        <div class="page-header d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="page-title">Payments & Checkout Settings</h1>
                                <div class="breadcrumb">
                                    <span>Home</span>
                                    <i class="fa-solid fa-chevron-right mx-2 text-muted" style="font-size:0.75rem;"></i>
                                    <span>Settings</span>
                                    <i class="fa-solid fa-chevron-right mx-2 text-muted" style="font-size:0.75rem;"></i>
                                    <span>Payments & Checkout</span>
                                </div>
                                <p class="page-subtitle mt-2">Manage payment methods and cart settings for your store.
                                </p>
                            </div>
                            <button type="submit" class="btn btn-success px-4 py-2"><i
                                    class="fa-regular fa-floppy-disk me-2"></i> Save Changes</button>
                        </div>

                        <!-- Tabs -->
                        <ul class="custom-tabs">
                            <li class="tab-item active">
                                <a href="#"><i class="fa-solid fa-cart-shopping me-2"></i> Add to Cart Settings</a>
                            </li>
                            <li class="tab-item text-muted ms-4">
                                <a href="#" style="color: #6c757d; text-decoration: none;"><i
                                        class="fa-regular fa-credit-card me-2"></i> Payment Methods</a>
                            </li>
                        </ul>

                        <div class="settings-grid mt-4">
                            <!-- Add to Cart Settings -->
                            <div class="settings-card p-0">
                                <div class="card-header border-0 bg-white pt-4 pb-0 px-4">
                                    <h5>Add to Cart Settings</h5>
                                    <p class="text-muted small">Configure cart behavior and order checkout preferences.
                                    </p>
                                </div>
                                <div class="card-body px-4">
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <h6>Enable Add to Cart</h6>
                                            <p>Allow customers to add products to cart</p>
                                        </div>
                                        <div class="form-check form-switch custom-switch">
                                            <input class="form-check-input" type="checkbox" checked="checked" />
                                        </div>
                                    </div>

                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <h6>Guest Checkout</h6>
                                            <p>Allow customers to checkout without login</p>
                                        </div>
                                        <div class="form-check form-switch custom-switch">
                                            <input class="form-check-input" type="checkbox" checked="checked" />
                                        </div>
                                    </div>

                                    <div class="setting-row align-items-center">
                                        <div class="setting-info">
                                            <h6>Cart Expiry</h6>
                                            <p>Items in cart will be removed after</p>
                                        </div>
                                        <div>
                                            <select class="form-select w-auto text-muted">
                                                <option>7 Days</option>
                                                <option>14 Days</option>
                                                <option>30 Days</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="setting-row align-items-center">
                                        <div class="setting-info">
                                            <h6>Minimum Order Amount</h6>
                                            <p>Set minimum order amount for checkout</p>
                                        </div>
                                        <div>
                                            <input type="text" class="form-control text-start text-muted" value="₹500"
                                                style="width: 120px;" />
                                        </div>
                                    </div>

                                    <div class="setting-row align-items-center">
                                        <div class="setting-info">
                                            <h6>Maximum Cart Items</h6>
                                            <p>Set maximum products allowed in cart</p>
                                        </div>
                                        <div>
                                            <input type="text" class="form-control text-start text-muted" value="50"
                                                style="width: 120px;" />
                                        </div>
                                    </div>

                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <h6>Stock Availability Check</h6>
                                            <p>Check stock availability before adding to cart</p>
                                        </div>
                                        <div class="form-check form-switch custom-switch">
                                            <input class="form-check-input" type="checkbox" checked="checked" />
                                        </div>
                                    </div>

                                    <div class="setting-row border-0 pb-0">
                                        <div class="setting-info">
                                            <h6>Show Cart on Header</h6>
                                            <p>Display cart icon with item count in header</p>
                                        </div>
                                        <div class="form-check form-switch custom-switch">
                                            <input class="form-check-input" type="checkbox" checked="checked" />
                                        </div>
                                    </div>

                                    <div class="alert alert-success bg-success-subtle text-success border-0 mt-3 d-flex align-items-center small"
                                        style="opacity: 0.85;">
                                        <i class="fa-solid fa-circle-info me-2"></i> Note: These settings will apply to
                                        all customers on your store
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Methods Section -->
                            <div class="settings-card p-0">
                                <div
                                    class="card-header border-0 bg-white pt-4 pb-0 px-4 d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5>Payment Methods</h5>
                                        <p class="text-muted small">Enable and manage payment methods for your
                                            customers.</p>
                                    </div>
                                    <button type="button" class="btn btn-outline-success btn-sm px-3"><i
                                            class="fa-solid fa-plus me-1"></i> Add New Method</button>
                                </div>
                                <div class="card-body px-4">
                                    <div class="table-responsive">
                                        <table class="table payment-table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Payment Method</th>
                                                    <th>Status</th>
                                                    <th>Processing Fee</th>
                                                    <th>Priority</th>
                                                    <th class="text-end">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Razorpay (Enabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i class="fa-brands fa-stripe-s fa-lg text-primary"></i>
                                                            </div>
                                                            <span class="fw-semibold">Razorpay <span
                                                                    class="text-muted fw-normal"
                                                                    style="font-size:10px;">(Cards, UPI,
                                                                    Netbanking)</span></span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Enabled</span>
                                                    </td>
                                                    <td class="text-muted">2.00%</td>
                                                    <td>1</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-danger border-danger-subtle"><i
                                                                class="fa-regular fa-trash-can"></i></button>
                                                    </td>
                                                </tr>
                                                <!-- PayPal (Enabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i class="fa-brands fa-paypal fa-lg text-primary"></i>
                                                            </div>
                                                            <span class="fw-semibold">PayPal</span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Enabled</span>
                                                    </td>
                                                    <td class="text-muted">2.90%</td>
                                                    <td>2</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-danger border-danger-subtle"><i
                                                                class="fa-regular fa-trash-can"></i></button>
                                                    </td>
                                                </tr>
                                                <!-- Cash on Delivery (Enabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i
                                                                    class="fa-solid fa-money-bill-wave fa-lg text-success"></i>
                                                            </div>
                                                            <span class="fw-semibold">Cash on Delivery (COD)</span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Enabled</span>
                                                    </td>
                                                    <td class="text-muted">₹40.00</td>
                                                    <td>3</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-danger border-danger-subtle"><i
                                                                class="fa-regular fa-trash-can"></i></button>
                                                    </td>
                                                </tr>
                                                <!-- PhonePe (Enabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i class="fa-solid fa-mobile-screen-button fa-lg"
                                                                    style="color: #6f42c1;"></i>
                                                            </div>
                                                            <span class="fw-semibold">PhonePe</span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Enabled</span>
                                                    </td>
                                                    <td class="text-muted">1.00%</td>
                                                    <td>4</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-danger border-danger-subtle"><i
                                                                class="fa-regular fa-trash-can"></i></button>
                                                    </td>
                                                </tr>
                                                <!-- Google Pay (Disabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i
                                                                    class="fa-brands fa-google-pay fa-xl text-primary"></i>
                                                            </div>
                                                            <span class="fw-semibold">Google Pay</span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Disabled</span>
                                                    </td>
                                                    <td class="text-muted">1.00%</td>
                                                    <td>5</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle"><i
                                                                class="fa-solid fa-play"></i></button>
                                                    </td>
                                                </tr>
                                                <!-- Amazon Pay (Disabled) -->
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="payment-icon">
                                                                <i class="fa-brands fa-amazon fa-lg"
                                                                    style="color: #000;"></i>
                                                            </div>
                                                            <span class="fw-semibold">Amazon Pay</span>
                                                        </div>
                                                    </td>
                                                    <td><span
                                                            class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Disabled</span>
                                                    </td>
                                                    <td class="text-muted">1.50%</td>
                                                    <td>6</td>
                                                    <td class="text-end">
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle me-1"><i
                                                                class="fa-solid fa-pen"></i></button>
                                                        <button type="button"
                                                            class="btn btn-sm btn-action text-success border-success-subtle"><i
                                                                class="fa-solid fa-play"></i></button>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div
                                        class="mt-4 mb-2 d-flex justify-content-between align-items-center text-muted small">
                                        <div class="d-flex gap-3">
                                            <span><i class="fa-solid fa-circle text-success"
                                                    style="font-size: 8px;"></i> Enabled</span>
                                            <span><i class="fa-solid fa-circle text-danger" style="font-size: 8px;"></i>
                                                Disabled</span>
                                        </div>
                                        <div><i class="fa-solid fa-bars pe-1"></i> Drag to reorder</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-5">
                            <h5 class="mb-1" style="font-size: 1rem; font-weight: 600;">Payment Method Configuration
                            </h5>
                            <p class="text-muted small mb-3">Configure the selected payment method details.</p>
                            <div class="settings-card pt-0 p-0">
                                <div class="card-body p-0 d-flex">
                                    <div class="config-sidebar p-3 border-end"
                                        style="width: 250px; background-color: #fcfcfc;">
                                        <!-- Razorpay Tab (Active) -->
                                        <div class="config-tab active bg-success-subtle text-success p-3 rounded mb-2 shadow-sm d-flex justify-content-between align-items-center"
                                            style="border-left: 4px solid #198754 !important;">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fa-brands fa-stripe-s fa-lg text-primary"></i>
                                                <div>
                                                    <div class="fw-semibold small" style="color: #333;">Razorpay</div>
                                                    <div class="text-muted" style="font-size: 10px;">Cards, UPI,
                                                        Netbanking</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-circle text-success" style="font-size: 8px;"></i>
                                        </div>

                                        <!-- PayPal Tab -->
                                        <div class="config-tab p-3 rounded mb-2 d-flex align-items-center gap-2">
                                            <i class="fa-brands fa-paypal fa-lg text-primary"></i>
                                            <div>
                                                <div class="fw-semibold small text-dark">PayPal</div>
                                                <div class="text-muted" style="font-size: 10px;">International Payments
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Cash on Delivery Tab -->
                                        <div class="config-tab p-3 rounded mb-2 d-flex align-items-center gap-2">
                                            <i class="fa-solid fa-money-bill-wave fa-lg text-success"></i>
                                            <div>
                                                <div class="fw-semibold small text-dark">Cash on Delivery</div>
                                                <div class="text-muted" style="font-size: 10px;">Pay when you receive
                                                </div>
                                            </div>
                                        </div>

                                        <!-- PhonePe Tab -->
                                        <div class="config-tab p-3 rounded mb-0 d-flex align-items-center gap-2">
                                            <i class="fa-solid fa-mobile-screen-button fa-lg"
                                                style="color: #6f42c1;"></i>
                                            <div>
                                                <div class="fw-semibold small text-dark">PhonePe</div>
                                                <div class="text-muted" style="font-size: 10px;">UPI Payment</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Config Main: Razorpay Configuration -->
                                    <div class="config-main p-4 flex-grow-1">
                                        <div class="d-flex justify-content-between mb-4">
                                            <div>
                                                <h6 class="mb-1 fw-bold">Razorpay Configuration</h6>
                                                <span class="text-muted small">Get your API keys from <a href="#"
                                                        class="text-success text-decoration-none">Razorpay Dashboard <i
                                                            class="fa-solid fa-arrow-up-right-from-square"
                                                            style="font-size:0.7rem;"></i></a></span>
                                            </div>
                                            <div>
                                                <button type="button"
                                                    class="btn border text-success fw-semibold bg-white btn-sm px-3"><i
                                                        class="fa-solid fa-wifi me-1"></i> Test Connection</button>
                                            </div>
                                        </div>

                                        <div class="row g-3 mb-4 mt-2">
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small mb-1">Key ID</label>
                                                <input type="text" class="form-control bg-light"
                                                    value="rzp_live_......" />
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small mb-1">Key Secret</label>
                                                <div class="position-relative">
                                                    <input type="password" class="form-control"
                                                        value="xxxxxxxxxxxxxxxxxxxx" />
                                                    <i
                                                        class="fa-regular fa-eye-slash position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small mb-1">Webhook Secret</label>
                                                <div class="position-relative">
                                                    <input type="password" class="form-control"
                                                        value="xxxxxxxxxxxxxxxxxxxx" />
                                                    <i
                                                        class="fa-regular fa-eye-slash position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row g-3 mb-4">
                                            <div class="col-md-3">
                                                <label class="form-label text-muted small mb-1">Currency</label>
                                                <select class="form-select text-muted">
                                                    <option>INR (₹)</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label text-muted small mb-1">Payment Capture</label>
                                                <select class="form-select text-muted">
                                                    <option>Automatic</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label text-muted small mb-1">Description</label>
                                                <input type="text" class="form-control text-muted"
                                                    value="Pay securely using Cards, UPI, Netbanking and more." />
                                            </div>
                                        </div>

                                        <div
                                            class="d-flex justify-content-between align-items-center pt-4 border-top mt-5">
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="form-check form-switch custom-switch">
                                                    <input class="form-check-input" type="checkbox" checked="checked" />
                                                </div>
                                                <span class="small text-muted">Enable Razorpay</span>
                                            </div>
                                            <button class="btn btn-success btn-sm px-4 py-2"><i
                                                    class="fa-regular fa-floppy-disk me-2"></i> Save
                                                Configuration</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </main>
            </div>
        </form>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>