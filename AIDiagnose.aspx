<%@ Page Title="AI Plant Doctor - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AIDiagnose.aspx.cs"
    Inherits="Project.AIDiagnose" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific CSS matching Figma design pixel-perfectly -->
    <link href="Content/AIDiagnose.css" rel="stylesheet" />
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
         1. HERO SECTION (AI PLANT DOCTOR) - Exact Figma Layout
         ========================================================= -->
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

            <!-- CENTER COLUMN: Upload Plant Image Card -->
            <div class="doc-hero-center">
                <div class="upload-card">
                    <div class="upload-icon-circle">
                        <i class="fa-solid fa-arrow-up-from-bracket"></i>
                    </div>
                    <h3 class="upload-title">Upload Plant Image</h3>
                    <p class="upload-subtitle">Drag and drop an image here, or click to browse</p>
                    <p class="upload-formats">JPG, PNG, WEBP up to 10MB</p>

                    <!-- Plant selection from Database -->
                    <div class="upload-select-wrapper">
                        <asp:DropDownList ID="ddlPlant" runat="server" CssClass="form-select diagnosis-select" aria-label="Select Plant">
                        </asp:DropDownList>
                    </div>

                    <!-- File Upload Control -->
                    <div class="upload-input-wrapper">
                        <asp:FileUpload ID="fileUploadPlant" runat="server" CssClass="form-control diagnosis-file-input" />
                    </div>

                    <!-- Diagnose Action Button -->
                    <asp:Button ID="btnDiagnose" runat="server" Text="Choose Image"
                        OnClick="btnDiagnose_Click" CssClass="btn-choose-image" />
                </div>

                <div class="doc-security-note">
                    <i class="fa-solid fa-circle-check text-success"></i>
                    <span>Your images are secure and only used for analysis</span>
                </div>
            </div>

            <!-- RIGHT COLUMN: Plant Image -->
            <div class="doc-hero-right">
                <img src="image/ai-plant-doctor.png" alt="Healthy Potted Houseplant" class="doc-plant-img" />
            </div>

        </div>
    </section>

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
                    OnClick="btnCloseResult_Click"
                    CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" />
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
                    <div class="treatment-box">
                        <strong><i class="fa-solid fa-notes-medical me-1"></i> Step-by-Step Treatment &amp; Action Plan:</strong><br />
                        <asp:Literal ID="litTreatmentText" runat="server"></asp:Literal>
                    </div>

                    <!-- Recommended Medicine Product Card -->
                    <div class="medicine-card">
                        <div class="d-flex align-items-center gap-3">
                            <asp:Image ID="imgMedicine" runat="server" CssClass="medicine-thumb"
                                AlternateText="Prescribed Treatment Product" />
                            <div>
                                <div class="med-label">Recommended Treatment Product:</div>
                                <div class="med-name"><asp:Literal ID="litMedicineName" runat="server"></asp:Literal></div>
                                <div class="med-price">&#8377;<asp:Literal ID="litMedicinePrice" runat="server"></asp:Literal></div>
                            </div>
                        </div>

                        <!-- Hidden state for Cart / Wishlist actions -->
                        <asp:HiddenField ID="hfDiagnosedMedicineName" runat="server" />
                        <asp:HiddenField ID="hfDiagnosedMedicinePrice" runat="server" />
                        <asp:HiddenField ID="hfDiagnosedMedicineImage" runat="server" />

                        <div class="d-flex gap-2">
                            <asp:Button ID="btnAddToCart" runat="server" Text="ðŸ›’ Add to Cart"
                                OnClick="btnAddToCart_Click" CssClass="btn-cart-sm" CausesValidation="false" />
                            <asp:Button ID="btnAddToWishlist" runat="server" Text="â™¥ Wishlist"
                                OnClick="btnAddToWishlist_Click" CssClass="btn-wish-sm" CausesValidation="false" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- =========================================================
         2. HOW IT WORKS SECTION - 4 Steps Matching Figma
         ========================================================= -->
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

    <!-- =========================================================
         3. TIPS FOR BETTER RESULTS BAR - Exact Figma Match
         ========================================================= -->
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
                <asp:Button ID="btnToggleManual" runat="server" Text="âž• Add New Disease to Database"
                    OnClick="btnToggleManual_Click" CssClass="btn-outline-green" CausesValidation="false" />
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
                            <asp:ListItem Text="Tulsi / Herb" Value="image/tulsi.jfif"></asp:ListItem>
                            <asp:ListItem Text="Sunflower" Value="image/sunflower.jfif"></asp:ListItem>
                            <asp:ListItem Text="Snake Plant" Value="image/product-snake-plant.png"></asp:ListItem>
                            <asp:ListItem Text="Succulent" Value="image/product-succulent.png"></asp:ListItem>
                            <asp:ListItem Text="Garden Plants" Value="image/about-plants.PNG"></asp:ListItem>
                            <asp:ListItem Text="Flower" Value="image/flower.jfif"></asp:ListItem>
                            <asp:ListItem Text="Periwinkle" Value="image/perivinkle.jfif"></asp:ListItem>
                            <asp:ListItem Text="Money Plant" Value="image/money_well.jfif"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 d-flex gap-2 mt-3">
                        <asp:Button ID="btnSaveManual" runat="server" Text="ðŸ’¾ Save Record to Database"
                            OnClick="btnSaveManual_Click" ValidationGroup="vgManualDisease"
                            CssClass="btn btn-sm btn-success fw-bold px-3" />
                        <asp:Button ID="btnCancelManual" runat="server" Text="Cancel"
                            OnClick="btnCancelManual_Click" CausesValidation="false"
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
                                <asp:LinkButton ID="lnkDeleteRow" runat="server"
                                    CommandName="DeleteRow" CommandArgument='<%# Eval("DiseaseId") %>'
                                    CssClass="btn-del-pill"
                                    
                                    title="Delete from Database">
                                    <i class="fa-solid fa-trash"></i>
                                </asp:LinkButton>
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
</asp:Content>
