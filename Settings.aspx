<%@ Page Title="Account Settings - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Project.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .settings-wrapper {
            max-width: 960px;
            margin: 40px auto;
            padding: 0 15px;
        }
        .settings-header-title {
            font-size: 28px;
            font-weight: 700;
            color: #203520;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }
        .settings-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.05);
            border: 1px solid #e2ebe0;
            padding: 28px;
            margin-bottom: 24px;
        }
        .settings-card-title {
            font-size: 19px;
            font-weight: 700;
            color: #1e361d;
            border-bottom: 2px solid #edf4eb;
            padding-bottom: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .settings-label {
            font-size: 13px;
            font-weight: 600;
            color: #334432;
            margin-bottom: 6px;
        }
        .form-control {
            border: 1px solid #cad9c7;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
        }
        .form-control:focus {
            border-color: #38a542;
            box-shadow: 0 0 0 0.2rem rgba(56, 165, 66, 0.15);
        }
        .btn-save-settings {
            background: #2ea339;
            color: #fff;
            border: none;
            padding: 10px 24px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-save-settings:hover {
            background: #22842c;
            color: #fff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="settings-wrapper">
        <div class="settings-header-title">
            <i class="fa-solid fa-gear text-secondary"></i>
            <span>Account & Application Settings</span>
        </div>

        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show" role="alert">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- 1. Profile Information -->
        <div class="settings-card">
            <h4 class="settings-card-title">
                <i class="fa-solid fa-user text-success"></i> Personal Profile & Delivery Defaults
            </h4>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="settings-label">Email Address (Account ID)</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="settings-label">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. John Doe"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="settings-label">Contact Phone Number</label>
                    <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label class="settings-label">City</label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="e.g. Ahmedabad"></asp:TextBox>
                </div>
                <div class="col-12">
                    <label class="settings-label">Default Delivery Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Your primary shipping address"></asp:TextBox>
                </div>
                <div class="col-12 text-end">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile Information" CssClass="btn-save-settings" OnClick="btnSaveProfile_Click" />
                </div>
            </div>
        </div>

        <!-- 2. Security & Password -->
        <div class="settings-card">
            <h4 class="settings-card-title">
                <i class="fa-solid fa-lock text-warning"></i> Change Password
            </h4>
            <div class="row g-3">
                <div class="col-12">
                    <asp:ValidationSummary ID="vsPassword" runat="server" ValidationGroup="vgPassword"
                        CssClass="alert alert-danger py-2 mb-2" HeaderText="Please fix the following errors:"
                        EnableClientScript="false" ShowMessageBox="false" ShowSummary="true" />
                </div>
                <div class="col-md-4">
                    <label class="settings-label">Current Password *</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                        ValidationGroup="vgPassword" ErrorMessage="Current password is required." ForeColor="#FF3300"
                        EnableClientScript="false" Display="Dynamic" />
                </div>
                <div class="col-md-4">
                    <label class="settings-label">New Password *</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword"
                        ValidationGroup="vgPassword" ErrorMessage="New password is required." ForeColor="#FF3300"
                        EnableClientScript="false" Display="Dynamic" />
                </div>
                <div class="col-md-4">
                    <label class="settings-label">Confirm New Password *</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ValidationGroup="vgPassword" ErrorMessage="Confirm password is required." ForeColor="#FF3300"
                        EnableClientScript="false" Display="Dynamic" />
                    <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtNewPassword" ValidationGroup="vgPassword" ErrorMessage="Passwords do not match."
                        ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                </div>
                <div class="col-12 text-end">
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" ValidationGroup="vgPassword" CssClass="btn-save-settings" OnClick="btnChangePassword_Click" />
                </div>
            </div>
        </div>

        <!-- 3. Preferences -->
        <div class="settings-card">
            <h4 class="settings-card-title">
                <i class="fa-solid fa-bell text-primary"></i> Notification Preferences
            </h4>
            <div class="form-check form-switch mb-3">
                <asp:CheckBox ID="chkEmailAlerts" runat="server" CssClass="form-check-input" Checked="true" />
                <label class="form-check-label ms-2" for="chkEmailAlerts">
                    <strong>Email Notifications:</strong> Receive order updates, invoice copies, and plant care reminders.
                </label>
            </div>
            <div class="form-check form-switch mb-3">
                <asp:CheckBox ID="chkSmsAlerts" runat="server" CssClass="form-check-input" />
                <label class="form-check-label ms-2" for="chkSmsAlerts">
                    <strong>SMS Updates:</strong> Receive instant shipment delivery tracking alerts via SMS.
                </label>
            </div>
            <div class="text-end">
                <asp:Button ID="btnSavePreferences" runat="server" Text="Save Preferences" CssClass="btn-save-settings" OnClick="btnSavePreferences_Click" />
            </div>
        </div>
    </div>
</asp:Content>
