<%@ Page Title="AI Plant Doctor - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AIDiagnose.aspx.cs"
    Inherits="Project.AIDiagnose" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/AIDiagnose.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="diagnose-page">

    <!-- =========================================
         HERO SECTION / AI PLANT DOCTOR
    ========================================= -->
    <section class="doc-hero-section">
        <div class="doc-hero-wrapper">
            <div class="doc-hero-card">

                <!-- Left Column: Title & Key Features -->
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
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                    <circle cx="12" cy="13" r="4"></circle>
                                </svg>
                            </div>
                            <span class="doc-feat-text">Instant AI Analysis</span>
                        </div>

                        <div class="doc-feature-row">
                            <div class="doc-feat-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"></path>
                                    <path d="m9 12 2 2 4-4"></path>
                                </svg>
                            </div>
                            <span class="doc-feat-text">Pesticide Recommendations</span>
                        </div>

                        <div class="doc-feature-row">
                            <div class="doc-feat-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22V8"></path>
                                    <path d="M12 12c-2.5-2.5-5-2-6 0 .5 2.5 3.5 3 6 1"></path>
                                    <path d="M12 10c2.5-2.5 5-2 6 0-.5 2.5-3.5 3-6 1"></path>
                                    <circle cx="12" cy="5" r="2.5"></circle>
                                </svg>
                            </div>
                            <span class="doc-feat-text">Expert Care Tips</span>
                        </div>
                    </div>
                </div>

                <!-- Center Column: Upload Card -->
                <div class="doc-hero-center">
                    <div class="upload-card" id="dropArea" onclick="triggerFileInput()">
                        <div class="upload-icon-circle">
                            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                <polyline points="17 8 12 3 7 8"></polyline>
                                <line x1="12" y1="3" x2="12" y2="15"></line>
                            </svg>
                        </div>
                        <h3 class="upload-title">Upload Plant Image</h3>
                        <p class="upload-subtitle">Drag and drop an image here, or click to browse</p>
                        <span class="upload-hint">JPG, PNG, WEBP up to 10MB</span>

                        <input type="file" id="plantFileInput" accept="image/*" style="display:none;" onchange="handleFileSelected(event)" />

                        <button type="button" class="btn-choose-img" onclick="event.stopPropagation(); triggerFileInput();">
                            Choose Image
                        </button>
                    </div>

                    <!-- Security Note -->
                    <div class="doc-security-note">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"></path>
                            <path d="m9 12 2 2 4-4"></path>
                        </svg>
                        <span>Your images are secure and only used for analysis</span>
                    </div>

                    <!-- Scan Analysis State / Results Card (Hidden initially) -->
                    <div id="analysisBox" class="analysis-result-box" style="display:none;">
                        <div id="scanningState" class="scanning-state">
                            <div class="scan-spinner"></div>
                            <h4 id="scanStatusText">Scanning plant leaves...</h4>
                            <div class="scan-bar"><div class="scan-progress" id="scanProgress"></div></div>
                        </div>

                        <div id="resultsState" class="results-state" style="display:none;">
                            <div class="result-header">
                                <span class="result-badge-safe" id="healthBadge">&#10003; Analyzed</span>
                                <h4 id="diseaseTitle" class="disease-name">Early Blight (Alternaria solani)</h4>
                                <span id="confidenceText" class="conf-score">96% Confidence</span>
                            </div>
                            <p id="treatmentText" class="treatment-text">
                                Recommended Action: Apply copper-based fungicide or organic neem spray weekly. Prune lower infected foliage to enhance airflow.
                            </p>
                            <button type="button" class="btn-scan-again" onclick="resetScanner()">Scan Another Plant</button>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Potted Plant Photo -->
                <div class="doc-hero-right">
                    <img src="image/ai-plant-doctor.png" alt="AI Plant Doctor Plant" class="doc-plant-img" />
                </div>

            </div>
        </div>
    </section>

    <!-- =========================================
         HOW IT WORKS SECTION
    ========================================= -->
    <section class="how-section">
        <div class="how-wrapper">
            <h2 class="how-title">How It Works</h2>

            <div class="how-grid">

                <!-- Step 1 -->
                <div class="how-card">
                    <div class="how-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="17 8 12 3 7 8"></polyline>
                            <line x1="12" y1="3" x2="12" y2="15"></line>
                        </svg>
                    </div>
                    <div class="how-step-header">
                        <span class="step-number">1</span>
                        <h3 class="step-title">Upload Image</h3>
                    </div>
                    <p class="step-desc">Upload a clear photo of the affected plant.</p>
                </div>

                <!-- Arrow 1 -->
                <div class="how-arrow">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </div>

                <!-- Step 2 -->
                <div class="how-card">
                    <div class="how-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m12 3-1.9 5.8a2 2 0 0 1-1.3 1.3L3 12l5.8 1.9a2 2 0 0 1 1.3 1.3L12 21l1.9-5.8a2 2 0 0 1 1.3-1.3L21 12l-5.8-1.9a2 2 0 0 1-1.3-1.3Z"></path>
                        </svg>
                    </div>
                    <div class="how-step-header">
                        <span class="step-number">2</span>
                        <h3 class="step-title">AI Analysis</h3>
                    </div>
                    <p class="step-desc">Our AI analyzes the plant and detects the problem.</p>
                </div>

                <!-- Arrow 2 -->
                <div class="how-arrow">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </div>

                <!-- Step 3 -->
                <div class="how-card">
                    <div class="how-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M10 2v7.31L4.2 19.46A2 2 0 0 0 5.8 22h12.4a2 2 0 0 0 1.6-2.54L14 9.31V2"></path>
                            <line x1="8.5" y1="2" x2="15.5" y2="2"></line>
                            <line x1="6" y1="17" x2="18" y2="17"></line>
                        </svg>
                    </div>
                    <div class="how-step-header">
                        <span class="step-number">3</span>
                        <h3 class="step-title">Get Recommendations</h3>
                    </div>
                    <p class="step-desc">Receive best pesticide and treatment options.</p>
                </div>

                <!-- Arrow 3 -->
                <div class="how-arrow">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </div>

                <!-- Step 4 -->
                <div class="how-card">
                    <div class="how-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22V8"></path>
                            <path d="M12 12c-2.5-2.5-5-2-6 0 .5 2.5 3.5 3 6 1"></path>
                            <path d="M12 10c2.5-2.5 5-2 6 0-.5 2.5-3.5 3-6 1"></path>
                        </svg>
                    </div>
                    <div class="how-step-header">
                        <span class="step-number">4</span>
                        <h3 class="step-title">Care &amp; Protect</h3>
                    </div>
                    <p class="step-desc">Follow the suggestions to protect your plant.</p>
                </div>

            </div>
        </div>
    </section>

    <!-- =========================================
         TIPS FOR BETTER RESULTS BANNER
    ========================================= -->
    <section class="tips-section">
        <div class="tips-wrapper">
            <div class="tips-card">

                <!-- Title on Left -->
                <div class="tips-title-box">
                    <div class="tips-bulb-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 18h6"></path>
                            <path d="M10 22h4"></path>
                            <path d="M12 2a7 7 0 0 0-7 7c0 2.5 1.5 4.5 3 6h8c1.5-1.5 3-3.5 3-6a7 7 0 0 0-7-7z"></path>
                        </svg>
                    </div>
                    <h4 class="tips-heading">Tips for Better Results</h4>
                </div>

                <div class="tips-divider"></div>

                <!-- 4 Tips -->
                <div class="tips-items-row">
                    <!-- Tip 1 -->
                    <div class="tip-item">
                        <div class="tip-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="5"></circle>
                                <line x1="12" y1="1" x2="12" y2="3"></line>
                                <line x1="12" y1="21" x2="12" y2="23"></line>
                                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                                <line x1="1" y1="12" x2="3" y2="12"></line>
                                <line x1="21" y1="12" x2="23" y2="12"></line>
                                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                            </svg>
                        </div>
                        <span class="tip-text">Use good lighting</span>
                    </div>

                    <!-- Tip 2 -->
                    <div class="tip-item">
                        <div class="tip-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M11 20A7 7 0 0 1 4 13C4 7 11 3 20 3c0 9-4 16-11 17Z"></path>
                                <path d="M4 21c2-3 5-5 9-7"></path>
                            </svg>
                        </div>
                        <span class="tip-text">Show affected leaves clearly</span>
                    </div>

                    <!-- Tip 3 -->
                    <div class="tip-item">
                        <div class="tip-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 22v-9"></path>
                                <path d="M9 13a4 4 0 0 1 3-3.87"></path>
                                <path d="M15 13a4 4 0 0 0-3-3.87"></path>
                                <path d="M8 9a4 4 0 0 1 4-4 4 4 0 0 1 4 4"></path>
                            </svg>
                        </div>
                        <span class="tip-text">Capture from close range</span>
                    </div>

                    <!-- Tip 4 -->
                    <div class="tip-item">
                        <div class="tip-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2fa13a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </div>
                        <span class="tip-text">Avoid blurry images</span>
                    </div>
                </div>

            </div>
        </div>
    </section>

</div>

<!-- Interactive Client-side Script -->
<script type="text/javascript">
    function triggerFileInput() {
        var input = document.getElementById('plantFileInput');
        if (input) {
            input.click();
        }
    }

    function handleFileSelected(event) {
        var files = event.target.files;
        if (files && files.length > 0) {
            simulateAIDiagnosis(files[0].name);
        }
    }

    // Drag and Drop
    var dropArea = document.getElementById('dropArea');
    if (dropArea) {
        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropArea.classList.add('drag-active');
            }, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropArea.classList.remove('drag-active');
            }, false);
        });

        dropArea.addEventListener('drop', (e) => {
            var dt = e.dataTransfer;
            var files = dt.files;
            if (files && files.length > 0) {
                simulateAIDiagnosis(files[0].name);
            }
        });
    }

    function simulateAIDiagnosis(filename) {
        var box = document.getElementById('analysisBox');
        var scanning = document.getElementById('scanningState');
        var results = document.getElementById('resultsState');
        var progress = document.getElementById('scanProgress');
        var statusText = document.getElementById('scanStatusText');

        box.style.display = 'block';
        scanning.style.display = 'block';
        results.style.display = 'none';
        progress.style.width = '10%';

        statusText.innerText = 'Scanning ' + filename + '...';

        setTimeout(() => {
            progress.style.width = '45%';
            statusText.innerText = 'Detecting leaf discoloration & pattern symptoms...';
        }, 800);

        setTimeout(() => {
            progress.style.width = '85%';
            statusText.innerText = 'Generating pesticide & treatment recommendations...';
        }, 1600);

        setTimeout(() => {
            progress.style.width = '100%';
            scanning.style.display = 'none';
            results.style.display = 'block';
        }, 2400);
    }

    function resetScanner() {
        var box = document.getElementById('analysisBox');
        box.style.display = 'none';
        var input = document.getElementById('plantFileInput');
        if (input) input.value = '';
    }
</script>

</asp:Content>
