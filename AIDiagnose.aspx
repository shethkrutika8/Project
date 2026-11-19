<%@ Page Title="AI Plant Doctor - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AIDiagnose.aspx.cs"
    Inherits="Project.AIDiagnose" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific CSS matching Figma design pixel-perfectly -->
    <link href="Content/AIDiagnose.css" rel="stylesheet" />
    <style>
        /* =========================================================
           CLEAN SINGLE PLANT PHOTO UPLOAD BOX (COMPACT & BALANCED)
           ========================================================= */
        .plant-upload-box {
            width: 100%;
            min-height: 94px;
            background: #fbfdfb;
            border: 2px dashed #36a941;
            border-radius: 10px;
            padding: 10px 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
            position: relative;
            user-select: none;
        }

        .plant-upload-box:hover,
        .plant-upload-box.dragover {
            background: #edf7eb;
            border-color: #24702d;
            box-shadow: 0 3px 12px rgba(54, 169, 65, 0.16);
            transform: translateY(-1px);
        }

        .upload-prompt-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 2px;
            width: 100%;
        }

        .upload-icon-circle-custom {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #eaf5e6;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2fa13a;
            font-size: 15px;
            margin-bottom: 2px;
            transition: transform 0.2s ease;
        }

        .plant-upload-box:hover .upload-icon-circle-custom {
            transform: scale(1.08);
        }

        .upload-btn-text {
            font-size: 14px;
            font-weight: 700;
            color: #1a4a22;
            letter-spacing: -0.2px;
            line-height: 1.2;
        }

        .upload-subtext {
            font-size: 11.5px;
            color: #4f6852;
            margin: 1px 0 0;
        }

        .upload-formats-badge {
            display: inline-block;
            margin-top: 3px;
            font-size: 10px;
            font-weight: 600;
            color: #2e7d32;
            background: #e8f5e9;
            padding: 1px 7px;
            border-radius: 8px;
            border: 1px solid #c8e6c9;
        }

        /* Image Preview Box */
        .upload-preview-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 4px;
            width: 100%;
        }

        .upload-preview-img {
            max-width: 100px;
            max-height: 70px;
            object-fit: cover;
            border-radius: 6px;
            border: 2px solid #2fa13a;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .preview-filename {
            font-size: 11.5px;
            font-weight: 600;
            color: #1a3923;
            max-width: 240px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
        }

        .preview-filesize {
            font-size: 10.5px;
            color: #556b57;
            display: block;
        }

        .btn-change-photo {
            background: #ffffff;
            border: 1px solid #36a941;
            color: #2fa13a;
            font-size: 11px;
            font-weight: 600;
            padding: 2px 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 2px;
        }

        .btn-change-photo:hover {
            background: #36a941;
            color: #ffffff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="diagnose-page">
<div class="diagnose-container">

    <!-- =========================================================
         ALERT / NOTIFICATION PANEL (Server-side feedback)
         ========================================================= -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="diag-alert-box">
        <div class="d-flex align-items-center gap-2">
            <i class="fa-solid fa-circle-check text-success fs-5"></i>
            <span><asp:Literal ID="litAlertMsg" runat="server"></asp:Literal></span>
        </div>
        <div class="d-flex gap-2">
            <a href="Cart.aspx" class="btn btn-sm btn-success"><i class="fa-solid fa-cart-shopping me-1"></i>Cart</a>
            <a href="Wishlist.aspx" class="btn btn-sm btn-outline-success"><i class="fa-solid fa-heart me-1"></i>Wishlist</a>
        </div>
    </asp:Panel>

    <asp:Label ID="lblError" runat="server" Visible="false" CssClass="alert alert-danger d-block mt-3 mb-2 py-2 px-3 rounded-2 text-danger fw-semibold"></asp:Label>

    <!-- =========================================================
         1. HERO SECTION (AI PLANT DOCTOR) - Hidden for Admins
         ========================================================= -->
    <asp:Panel ID="pnlHeroSection" runat="server" Visible="true">
    <section class="doc-hero-section">
        <div class="doc-hero-card">

            <!-- LEFT COLUMN: Title, Description & Feature Points -->
            <div class="doc-hero-left">
                <div class="doc-title-row">
                    <h1 class="doc-title">AI Plant Doctor</h1>
                    <span class="badge-beta">Beta</span>
                </div>
                <p class="doc-desc">
                    Upload a photo of your plant and our AI will analyze the issue and recommend the best pesticide and care solutions.
                </p>

                <div class="doc-features-list">
                    <div class="doc-feature-row">
                        <div class="doc-feat-icon">
                            <i class="fa-solid fa-camera"></i>
                        </div>
                        <span class="doc-feat-text">Instant AI Analysis</span>
                    </div>
                    <div class="doc-feature-row">
                        <div class="doc-feat-icon">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <span class="doc-feat-text">Pesticide Recommendations</span>
                    </div>
                    <div class="doc-feature-row">
                        <div class="doc-feat-icon">
                            <i class="fa-solid fa-seedling"></i>
                        </div>
                        <span class="doc-feat-text">Expert Care Tips</span>
                    </div>
                </div>
            </div>

            <!-- CENTER COLUMN: Single Clean Plant Photo Upload Card -->
            <div class="doc-hero-center">
                <div class="upload-card">

                    <!-- Single Clean Plant Photo Upload Box with Drag-and-Drop & Preview -->
                    <div id="plantDropZone" class="plant-upload-box" onclick="triggerPhotoSelect()">
                        <!-- Hidden actual ASP.NET FileUpload (submits file with form postback) -->
                        <asp:FileUpload ID="fileUploadPlant" runat="server" 
                            style="display:none;" 
                            accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                            onchange="handlePhotoSelected(this)" />

                        <!-- Default View: Select Plant Photo -->
                        <div id="uploadPrompt" class="upload-prompt-content">
                            <div class="upload-icon-circle-custom">
                                <i class="fa-solid fa-cloud-arrow-up"></i>
                            </div>
                            <div class="upload-btn-text">
                                Select Plant Photo
                            </div>
                            <p class="upload-subtext">or drag and drop photo here</p>
                            <span class="upload-formats-badge">JPG, JPEG, PNG, WEBP (Max 10MB)</span>
                        </div>

                        <!-- Selected Image Preview View -->
                        <div id="uploadPreview" class="upload-preview-content d-none">
                            <img id="imgPreview" src="" alt="Selected Plant Preview" class="upload-preview-img" />
                            <div class="upload-preview-info">
                                <span id="lblFileName" class="preview-filename"></span>
                                <span id="lblFileSize" class="preview-filesize"></span>
                            </div>
                            <button type="button" class="btn-change-photo" onclick="event.stopPropagation(); triggerPhotoSelect();">
                                <i class="fa-solid fa-arrows-rotate me-1"></i>Change Photo
                            </button>
                        </div>
                    </div>

                    <!-- Plant Selection from Database ONLY (no text input field) -->
                    <div class="upload-select-wrapper mb-2 text-start">
                        <label for="<%= ddlPlant.ClientID %>" class="form-label-custom mb-1 d-block text-start" style="font-weight: 600; font-size: 12.5px; color: #1e3a22;">
                            <i class="fa-solid fa-leaf text-success me-1"></i>Select Plant from Database:
                        </label>
                        <asp:DropDownList ID="ddlPlant" runat="server"
                            CssClass="form-select diagnosis-select"
                            aria-label="Select Plant"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlPlant_SelectedIndexChanged">
                            <asp:ListItem Text="-- Select a Plant from Database --" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Diagnose Action Button (server-side postback, ASP.NET only) -->
                    <asp:Button ID="btnDiagnose" runat="server" Text="Diagnose Plant"
                        CssClass="btn-choose-image"
                        OnClick="btnDiagnose_Click"
                        CausesValidation="false" />
                </div>

                <div class="doc-security-note">
                    <i class="fa-solid fa-circle-check text-success"></i>
                    <span>Your images are secure and only used for analysis</span>
                </div>
            </div>

        </div>
    </section>
    </asp:Panel>

    <!-- =========================================================
         DIAGNOSIS RESULT CARD (Populated dynamically via ADO.NET)
         ========================================================= -->
    <asp:Panel ID="pnlResultCard" runat="server" Visible="false" CssClass="result-card-wrap">
        <div class="result-box">
            <div class="result-header-bar">
                <span class="result-badge">
                    <i class="fa-solid fa-circle-check"></i> Diagnosis Result &amp; Treatment Plan
                </span>
                <asp:Button ID="btnCloseResult" runat="server" Text="&times; Close Result"
                    CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" OnClick="btnCloseResult_Click" />
            </div>

            <div class="row g-3 align-items-start">
                <!-- Left: Diagnosed Plant Photo -->
                <div class="col-md-4">
                    <div class="result-img-box">
                        <asp:Image ID="imgDiagnosed" runat="server" AlternateText="Diagnosed Plant Leaf" />
                    </div>
                </div>

                <!-- Right: Disease Information & Treatment -->
                <div class="col-md-8">
                    <div class="result-label">Plant Name</div>
                    <div class="result-plant-name">
                        <asp:Label ID="lblPlantTitle" runat="server"></asp:Label>
                    </div>

                    <div class="result-label">Detected Disease / Condition</div>
                    <div class="result-disease-name">
                        <i class="fa-solid fa-virus"></i>
                        <asp:Label ID="lblDiseaseTitle" runat="server"></asp:Label>
                    </div>

                    <div class="result-label">Observed Symptoms</div>
                    <div class="result-symptoms">
                        <asp:Literal ID="litSymptoms" runat="server"></asp:Literal>
                    </div>

                    <!-- Recommended Treatment Steps -->
                    <div class="result-label">Treatment Plan</div>
                    <div class="treatment-box">
                        <strong><i class="fa-solid fa-notes-medical me-1"></i> Step-by-Step Treatment &amp; Action Plan:</strong><br />
                        <asp:Literal ID="litTreatmentText" runat="server"></asp:Literal>
                    </div>

                    <!-- Expert Care Tips -->
                    <div class="result-label">Expert Care Tips</div>
                    <div class="tips-box" style="background:#eef7ec; border-left:3px solid #288f32; border-radius:0 6px 6px 0; padding:14px 18px; font-size:15px; color:#1e3d23; line-height:1.7; margin-bottom:18px;">
                        <strong><i class="fa-solid fa-seedling me-1"></i> Care &amp; Prevention Advice:</strong><br />
                        <asp:Literal ID="litCareTips" runat="server"></asp:Literal>
                    </div>

                    <!-- Recommended Pesticide / Care Product Card -->
                    <div class="result-label">Recommended Pesticides / Medicines</div>
                    <div class="medicine-card">
                        <div class="d-flex align-items-center gap-3">
                            <asp:Image ID="imgMedicine" runat="server" CssClass="medicine-thumb" />
                            <div>
                                <div class="med-label">Recommended Solution</div>
                                <div class="med-name"><asp:Literal ID="litMedicineName" runat="server"></asp:Literal></div>
                                <div class="med-price">&#8377;<asp:Literal ID="litMedicinePrice" runat="server"></asp:Literal></div>
                            </div>
                        </div>

                        <asp:HiddenField ID="hfDiagnosedMedicineName" runat="server" />
                        <asp:HiddenField ID="hfDiagnosedMedicinePrice" runat="server" />
                        <asp:HiddenField ID="hfDiagnosedMedicineImage" runat="server" />

                        <div class="d-flex gap-2">
                            <asp:LinkButton ID="btnAddToCart" runat="server" OnClick="btnAddToCart_Click"
                                CssClass="btn-cart-sm text-decoration-none d-inline-flex align-items-center gap-1" CausesValidation="false">
                                <i class="fa-solid fa-cart-shopping"></i> Add to Cart
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnAddToWishlist" runat="server" OnClick="btnAddToWishlist_Click"
                                CssClass="btn-wish-sm text-decoration-none d-inline-flex align-items-center gap-1" CausesValidation="false">
                                <i class="fa-solid fa-heart"></i> Wishlist
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- =========================================================
         2. HOW IT WORKS SECTION - Hidden for Admins
         ========================================================= -->
    <asp:Panel ID="pnlHowItWorks" runat="server" Visible="true">
    <section class="how-section">
        <h2 class="how-title">How It Works</h2>

        <div class="how-grid">
            <!-- Step 1 -->
            <div class="how-card">
                <div class="how-icon-box">
                    <i class="fa-solid fa-arrow-up-from-bracket"></i>
                </div>
                <div class="how-step-header">
                    <span class="step-number">1</span>
                    <h4 class="step-title">Upload Image</h4>
                </div>
                <p class="step-desc">
                    Upload a clear photo of the affected plant.
                </p>
            </div>

            <div class="how-arrow">
                <i class="fa-solid fa-arrow-right"></i>
            </div>

            <!-- Step 2 -->
            <div class="how-card">
                <div class="how-icon-box">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </div>
                <div class="how-step-header">
                    <span class="step-number">2</span>
                    <h4 class="step-title">AI Analysis</h4>
                </div>
                <p class="step-desc">
                    Our AI analyzes the plant and detects the problem.
                </p>
            </div>

            <div class="how-arrow">
                <i class="fa-solid fa-arrow-right"></i>
            </div>

            <!-- Step 3 -->
            <div class="how-card">
                <div class="how-icon-box">
                    <i class="fa-solid fa-flask"></i>
                </div>
                <div class="how-step-header">
                    <span class="step-number">3</span>
                    <h4 class="step-title">Get Recommendations</h4>
                </div>
                <p class="step-desc">
                    Receive best pesticide and treatment options.
                </p>
            </div>

            <div class="how-arrow">
                <i class="fa-solid fa-arrow-right"></i>
            </div>

            <!-- Step 4 -->
            <div class="how-card">
                <div class="how-icon-box">
                    <i class="fa-solid fa-seedling"></i>
                </div>
                <div class="how-step-header">
                    <span class="step-number">4</span>
                    <h4 class="step-title">Care &amp; Protect</h4>
                </div>
                <p class="step-desc">
                    Follow the suggestions to protect your plant.
                </p>
            </div>
        </div>
    </section>
    </asp:Panel>

    <!-- =========================================================
         3. TIPS FOR BETTER RESULTS BAR - Hidden for Admins
         ========================================================= -->
    <asp:Panel ID="pnlTipsSection" runat="server" Visible="true">
    <section class="tips-section">
        <div class="tips-card">
            <div class="tips-title-box">
                <div class="tips-bulb-icon">
                    <i class="fa-regular fa-lightbulb"></i>
                </div>
                <h4 class="tips-heading">Tips for Better Results</h4>
            </div>

            <div class="tips-divider"></div>

            <div class="tips-items-row">
                <div class="tip-item">
                    <i class="fa-regular fa-sun text-success"></i>
                    <span class="tip-text">Use good lighting</span>
                </div>
                <div class="tip-item">
                    <i class="fa-solid fa-leaf text-success"></i>
                    <span class="tip-text">Show affected leaves clearly</span>
                </div>
                <div class="tip-item">
                    <i class="fa-solid fa-seedling text-success"></i>
                    <span class="tip-text">Capture from close range</span>
                </div>
                <div class="tip-item">
                    <i class="fa-regular fa-image text-success"></i>
                    <span class="tip-text">Avoid blurry images</span>
                </div>
            </div>
        </div>
    </section>
    </asp:Panel>

    <!-- =========================================================
         4. ADMIN DATABASE MANAGEMENT SECTION
         (Preserved strictly for Admin role; hidden from regular users)
         ========================================================= -->
    <asp:Panel ID="pnlAdminDatabaseManagement" runat="server" Visible="false" CssClass="admin-mgmt-section mt-4">
        <div class="diag-card">
            <div class="card-header-title">
                <span>
                    <i class="fa-solid fa-database text-success me-2"></i>Plant Disease Database Management
                    <span class="badge-info-pill ms-2">
                        <asp:Literal ID="litRecordCount" runat="server">0</asp:Literal> Records
                    </span>
                </span>
                <asp:Button ID="btnToggleManual" runat="server" Text="➕ Add New Disease to Database"
                    CssClass="btn-outline-green" CausesValidation="false" OnClick="btnToggleManual_Click" />
            </div>

            <!-- Collapsible Manual Entry Form with pure server-side .NET validation -->
            <asp:Panel ID="pnlManualEntry" runat="server" Visible="false" CssClass="mb-4 p-3 bg-light rounded-3 border border-success">
                <h6 class="fw-bold text-success mb-3">
                    <i class="fa-solid fa-plus-circle me-1"></i> Add Plant Disease into SQL Server Database
                </h6>

                <!-- ASP.NET Server-Side Validation Summary -->
                <asp:ValidationSummary ID="vsManualEntry" runat="server"
                    ValidationGroup="vgManualDisease"
                    CssClass="alert alert-danger py-2 mb-3"
                    HeaderText="Please fix the following validation errors:"
                    EnableClientScript="false"
                    ShowMessageBox="false" ShowSummary="true" />

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label-custom">Plant Name *</label>
                        <asp:TextBox ID="txtNewPlantName" runat="server" CssClass="form-control form-control-custom"
                            placeholder="e.g. Tulsi, Tomato, Cotton, Mango"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewPlant" runat="server"
                            ControlToValidate="txtNewPlantName" ValidationGroup="vgManualDisease"
                            ErrorMessage="Plant name is required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label-custom">Disease / Condition Name *</label>
                        <asp:TextBox ID="txtNewDiseaseName" runat="server" CssClass="form-control form-control-custom"
                            placeholder="e.g. Powdery Mildew, Leaf Blight"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewDisease" runat="server"
                            ControlToValidate="txtNewDiseaseName" ValidationGroup="vgManualDisease"
                            ErrorMessage="Disease name is required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-12">
                        <label class="form-label-custom">Symptoms Description *</label>
                        <asp:TextBox ID="txtNewSymptoms" runat="server" CssClass="form-control form-control-custom"
                            placeholder="e.g. White powder coating on leaves, curling, black spots"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewSymptoms" runat="server"
                            ControlToValidate="txtNewSymptoms" ValidationGroup="vgManualDisease"
                            ErrorMessage="Symptoms description is required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-12">
                        <label class="form-label-custom">Recommended Treatment &amp; Action Plan *</label>
                        <asp:TextBox ID="txtNewTreatment" runat="server" TextMode="MultiLine" Rows="3"
                            CssClass="form-control form-control-custom"
                            placeholder="Step-by-step treatment or care instructions"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewTreatment" runat="server"
                            ControlToValidate="txtNewTreatment" ValidationGroup="vgManualDisease"
                            ErrorMessage="Treatment instructions are required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label-custom">Prescribed Medicine / Care Product *</label>
                        <asp:TextBox ID="txtNewMedicineName" runat="server" CssClass="form-control form-control-custom"
                            placeholder="e.g. Neem Spray Care"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewMedicine" runat="server"
                            ControlToValidate="txtNewMedicineName" ValidationGroup="vgManualDisease"
                            ErrorMessage="Prescribed product is required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label-custom">Medicine Price (&#8377;) *</label>
                        <asp:TextBox ID="txtNewPrice" runat="server" TextMode="Number"
                            CssClass="form-control form-control-custom" Text="199"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewPrice" runat="server"
                            ControlToValidate="txtNewPrice" ValidationGroup="vgManualDisease"
                            ErrorMessage="Medicine price is required." CssClass="text-danger small"
                            EnableClientScript="false" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revNewPrice" runat="server"
                            ControlToValidate="txtNewPrice" ValidationGroup="vgManualDisease"
                            ErrorMessage="Price must be a valid positive number." CssClass="text-danger small"
                            EnableClientScript="false" ValidationExpression="^\d+(\.\d{1,2})?$" Display="Dynamic" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label-custom">Product Image</label>
                        <asp:DropDownList ID="ddlNewImage" runat="server" CssClass="form-select form-select-custom">
                            <asp:ListItem Text="Amla" Value="image/Amla.jfif"></asp:ListItem>
                            <asp:ListItem Text="Ashvagandha" Value="image/Ashvagandha.jfif"></asp:ListItem>
                            <asp:ListItem Text="Banana" Value="image/Banana.jfif"></asp:ListItem>
                            <asp:ListItem Text="Broguieanvilla" Value="image/Broguieanvilla.jfif"></asp:ListItem>
                            <asp:ListItem Text="Gauva" Value="image/Gauva.jfif"></asp:ListItem>
                            <asp:ListItem Text="Tulsi / Herb" Value="image/tulsi.jfif"></asp:ListItem>
                            <asp:ListItem Text="Chili" Value="image/chili.jfif"></asp:ListItem>
                            <asp:ListItem Text="Coconut" Value="image/coconut.jfif"></asp:ListItem>
                            <asp:ListItem Text="Coriander" Value="image/coriender.jfif"></asp:ListItem>
                            <asp:ListItem Text="Cotton" Value="image/cotton.jfif"></asp:ListItem>
                            <asp:ListItem Text="Curry" Value="image/curry.jfif"></asp:ListItem>
                            <asp:ListItem Text="Drumstick" Value="image/drumstick.jfif"></asp:ListItem>
                            <asp:ListItem Text="Fenugreek" Value="image/fenugreek.jfif"></asp:ListItem>
                            <asp:ListItem Text="Flower" Value="image/flower.jfif"></asp:ListItem>
                            <asp:ListItem Text="Hibiscus" Value="image/hibscous.jfif"></asp:ListItem>
                            <asp:ListItem Text="Jasmine" Value="image/jasmin.jfif"></asp:ListItem>
                            <asp:ListItem Text="Lavender" Value="image/lavender.jfif"></asp:ListItem>
                            <asp:ListItem Text="Lemon" Value="image/lemon.jfif"></asp:ListItem>
                            <asp:ListItem Text="Mango" Value="image/mango.jfif"></asp:ListItem>
                            <asp:ListItem Text="Marigold" Value="image/marigold.jfif"></asp:ListItem>
                            <asp:ListItem Text="Mint" Value="image/mint.jfif"></asp:ListItem>
                            <asp:ListItem Text="Money Plant" Value="image/money_well.jfif"></asp:ListItem>
                            <asp:ListItem Text="Neem" Value="image/neem.jfif"></asp:ListItem>
                            <asp:ListItem Text="Papaya" Value="image/papaya.jfif"></asp:ListItem>
                            <asp:ListItem Text="Periwinkle" Value="image/perivinkle.jfif"></asp:ListItem>
                            <asp:ListItem Text="Pomegranate" Value="image/pomegranets.jfif"></asp:ListItem>
                            <asp:ListItem Text="Rice" Value="image/rice.jfif"></asp:ListItem>
                            <asp:ListItem Text="Rose" Value="image/rose.jfif"></asp:ListItem>
                            <asp:ListItem Text="Snake Plant" Value="image/sanke.jfif"></asp:ListItem>
                            <asp:ListItem Text="Sunflower" Value="image/sunflower.jfif"></asp:ListItem>
                            <asp:ListItem Text="Brahmi" Value="image/brahmi.jfif"></asp:ListItem>
                            <asp:ListItem Text="Blooms" Value="image/blooms.jfif"></asp:ListItem>
                            <asp:ListItem Text="Garden Plants" Value="image/about-plants.PNG"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 d-flex gap-2 mt-3">
                        <asp:Button ID="btnSaveManual" runat="server" Text="💾 Save Record to Database"
                            ValidationGroup="vgManualDisease" OnClick="btnSaveManual_Click"
                            CssClass="btn btn-sm btn-success fw-bold px-3" />
                        <asp:Button ID="btnCancelManual" runat="server" Text="Cancel"
                            CausesValidation="false" OnClick="btnCancelManual_Click"
                            CssClass="btn btn-sm btn-outline-secondary px-3" />
                    </div>
                </div>
            </asp:Panel>

            <!-- Records Table -->
            <div class="table-responsive">
                <asp:Repeater ID="rptDiseaseCatalog" runat="server" OnItemCommand="rptDiseaseCatalog_ItemCommand">
                    <HeaderTemplate>
                        <table class="table records-table align-middle">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Plant Name</th>
                                    <th>Condition / Disease</th>
                                    <th>Symptoms</th>
                                    <th>Prescribed Product</th>
                                    <th>Price</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><span class="badge-id">#<%# Eval("DiseaseId") %></span></td>
                            <td><strong><%# Eval("PlantName") %></strong></td>
                            <td><span class="badge-disease"><%# Eval("DiseaseName") %></span></td>
                            <td><small class="text-muted"><%# Eval("Symptoms") %></small></td>
                            <td><span class="badge-med"><%# Eval("MedicineName") %></span></td>
                            <td><strong>&#8377;<%# Convert.ToDecimal(Eval("MedicinePrice")).ToString("N0") %></strong></td>
                            <td class="text-end">
                                <asp:LinkButton ID="lnkDiagnoseRow" runat="server"
                                    CommandName="DiagnoseRow" CommandArgument='<%# Eval("DiseaseId") %>'
                                    CssClass="btn-view-pill me-1" title="View Diagnosis">
                                    <i class="fa-solid fa-eye me-1"></i>View
                                </asp:LinkButton>
                                <asp:Panel ID="pnlDeleteButton" runat="server">
                                    <asp:LinkButton ID="lnkDeleteRow" runat="server"
                                        CommandName="DeleteRow" CommandArgument='<%# Eval("DiseaseId") %>'
                                        CssClass="btn-del-pill"
                                        title="Delete from Database">
                                        <i class="fa-solid fa-trash"></i>
                                    </asp:LinkButton>
                                </asp:Panel>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </asp:Panel>

</div>
</div>

<!-- =========================================================
     DRAG & DROP, BROWSE & PREVIEW JAVASCRIPT
     ========================================================= -->
<script type="text/javascript">
    function triggerPhotoSelect() {
        var fileInput = document.getElementById('<%= fileUploadPlant.ClientID %>');
        if (fileInput) {
            fileInput.click();
        }
    }

    function handlePhotoSelected(input) {
        if (input && input.files && input.files.length > 0) {
            validateAndPreviewPhoto(input.files[0]);
        }
    }

    function validateAndPreviewPhoto(file) {
        if (!file) return;

        // 1. Format validation: JPG, JPEG, PNG, WEBP
        var fileName = file.name;
        var dotIdx = fileName.lastIndexOf('.');
        if (dotIdx === -1) {
            alert("Invalid file format. Please select a JPG, JPEG, PNG, or WEBP plant photo.");
            clearPhotoInput();
            return;
        }

        var ext = fileName.substring(dotIdx).toLowerCase();
        var allowedExts = ['.jpg', '.jpeg', '.png', '.webp'];

        if (allowedExts.indexOf(ext) === -1) {
            alert("Invalid file format (" + ext + "). Please select a JPG, JPEG, PNG, or WEBP plant photo.");
            clearPhotoInput();
            return;
        }

        // 2. Size validation: max 10MB (10 * 1024 * 1024 bytes)
        var maxSize = 10 * 1024 * 1024;
        if (file.size > maxSize) {
            alert("File is too large. Maximum photo size is 10MB.");
            clearPhotoInput();
            return;
        }

        // 3. Show preview using FileReader
        var reader = new FileReader();
        reader.onload = function (e) {
            var imgPreview = document.getElementById('imgPreview');
            var uploadPrompt = document.getElementById('uploadPrompt');
            var uploadPreview = document.getElementById('uploadPreview');
            var lblFileName = document.getElementById('lblFileName');
            var lblFileSize = document.getElementById('lblFileSize');

            if (imgPreview) imgPreview.src = e.target.result;
            if (lblFileName) lblFileName.textContent = file.name;
            if (lblFileSize) {
                var sizeKB = (file.size / 1024).toFixed(1);
                var sizeStr = sizeKB > 1024 ? (sizeKB / 1024).toFixed(2) + " MB" : sizeKB + " KB";
                lblFileSize.textContent = sizeStr;
            }

            if (uploadPrompt) uploadPrompt.classList.add('d-none');
            if (uploadPreview) uploadPreview.classList.remove('d-none');
        };
        reader.readAsDataURL(file);
    }

    function clearPhotoInput() {
        var fileInput = document.getElementById('<%= fileUploadPlant.ClientID %>');
        if (fileInput) fileInput.value = '';
        var uploadPrompt = document.getElementById('uploadPrompt');
        var uploadPreview = document.getElementById('uploadPreview');
        if (uploadPrompt) uploadPrompt.classList.remove('d-none');
        if (uploadPreview) uploadPreview.classList.add('d-none');
    }

    // Initialize Drag and Drop Event Listeners
    document.addEventListener("DOMContentLoaded", function () {
        var dropZone = document.getElementById('plantDropZone');
        var fileInput = document.getElementById('<%= fileUploadPlant.ClientID %>');

        if (!dropZone || !fileInput) return;

        ['dragenter', 'dragover'].forEach(function (eventName) {
            dropZone.addEventListener(eventName, function (e) {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.add('dragover');
            }, false);
        });

        ['dragleave', 'drop'].forEach(function (eventName) {
            dropZone.addEventListener(eventName, function (e) {
                e.preventDefault();
                e.stopPropagation();
                dropZone.classList.remove('dragover');
            }, false);
        });

        dropZone.addEventListener('drop', function (e) {
            var dt = e.dataTransfer;
            if (dt && dt.files && dt.files.length > 0) {
                var droppedFile = dt.files[0];
                try {
                    fileInput.files = dt.files;
                } catch (err) {
                    var dataTransfer = new DataTransfer();
                    dataTransfer.items.add(droppedFile);
                    fileInput.files = dataTransfer.files;
                }
                validateAndPreviewPhoto(droppedFile);
            }
        }, false);
    });
</script>

</asp:Content>
