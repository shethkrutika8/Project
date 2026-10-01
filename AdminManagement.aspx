<%@ Page Title="Admins & Users Management - AgriCulture" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AdminManagement.aspx.cs"
    Inherits="Project.AdminManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-mgmt-wrapper { max-width: 1200px; margin: 35px auto 60px; padding: 0 15px; }
        .page-header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; flex-wrap: wrap; gap: 15px; }
        .page-header-title { font-size: 26px; font-weight: 700; color: #1e3a1f; display: flex; align-items: center; gap: 12px; }
        .card-custom { background: #fff; border: 1px solid #dce8db; border-radius: 12px; box-shadow: 0 3px 14px rgba(0,0,0,0.05); margin-bottom: 28px; overflow: hidden; }
        .card-custom-header { background: #f5faf4; padding: 16px 22px; border-bottom: 1px solid #e2ebe0; font-size: 17px; font-weight: 700; color: #1b351d; display: flex; align-items: center; gap: 10px; }
        .card-custom-body { padding: 24px; }
        .form-label { font-size: 13px; font-weight: 600; color: #334432; margin-bottom: 5px; }
        .btn-green { background: #2ea339; color: #fff; border: none; padding: 10px 24px; border-radius: 7px; font-weight: 600; cursor: pointer; }
        .btn-green:hover { background: #22842c; color: #fff; }
        .badge-role-admin { background: #ffeaa7; color: #d63031; font-weight: 700; padding: 4px 10px; border-radius: 20px; font-size: 12px; border: 1px solid #fdcb6e; }
        .badge-role-user { background: #e8f5e9; color: #2e7d32; font-weight: 600; padding: 4px 10px; border-radius: 20px; font-size: 12px; border: 1px solid #c8e6c9; }
        .admin-table th { background: #f7faf5; color: #436240; font-weight: 600; font-size: 13px; padding: 12px 16px; }
        .admin-table td { padding: 12px 16px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid #edf2ec; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-mgmt-wrapper">

        <div class="page-header-box">
            <h1 class="page-header-title">
                <i class="fa-solid fa-user-shield text-success"></i> Administrators &amp; Users Management
            </h1>
            <a href="AdminDashboard.aspx" class="btn btn-outline-success btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>

        <!-- Alert Notification -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show mb-4">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- Form: Add New Administrator -->
        <div class="card-custom">
            <div class="card-custom-header">
                <i class="fa-solid fa-user-plus text-success"></i> Add New Administrator / User to Database
            </div>
            <div class="card-custom-body">

                <!-- ASP.NET Server-Side Validation Summary (NO JavaScript) -->
                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                    CssClass="alert alert-danger py-2 mb-3"
                    HeaderText="Please fix the following validation errors:"
                    EnableClientScript="false"
                    ShowMessageBox="false"
                    ShowSummary="true" />

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Full Name *</label>
                        <asp:TextBox ID="txtAdminName" runat="server" CssClass="form-control" placeholder="e.g. Rahul Sharma"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAdminName" runat="server"
                            ControlToValidate="txtAdminName" ErrorMessage="Full Name is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Email Address *</label>
                        <asp:TextBox ID="txtAdminEmail" runat="server" CssClass="form-control" placeholder="e.g. admin@agriculture.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAdminEmail" runat="server"
                            ControlToValidate="txtAdminEmail" ErrorMessage="Email address is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revAdminEmail" runat="server"
                            ControlToValidate="txtAdminEmail" ErrorMessage="Please enter a valid email address."
                            ForeColor="#FF3300" EnableClientScript="false"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Contact Phone (10 digits) *</label>
                        <asp:TextBox ID="txtAdminContact" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAdminContact" runat="server"
                            ControlToValidate="txtAdminContact" ErrorMessage="Contact number is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revAdminContact" runat="server"
                            ControlToValidate="txtAdminContact" ErrorMessage="Contact number must be exactly 10 digits."
                            ForeColor="#FF3300" EnableClientScript="false"
                            ValidationExpression="^\d{10}$" Display="Dynamic" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">City *</label>
                        <asp:DropDownList ID="ddlAdminCity" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Ahmedabad" Value="Ahmedabad"></asp:ListItem>
                            <asp:ListItem Text="Rajkot" Value="Rajkot"></asp:ListItem>
                            <asp:ListItem Text="Surat" Value="Surat"></asp:ListItem>
                            <asp:ListItem Text="Bhavnagar" Value="Bhavnagar"></asp:ListItem>
                            <asp:ListItem Text="Vadodara" Value="Vadodara"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">System Role *</label>
                        <asp:DropDownList ID="ddlAdminRole" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Administrator (Full Admin Access)" Value="Admin"></asp:ListItem>
                            <asp:ListItem Text="Customer / Farmer (User Access)" Value="User"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <!-- Spacing column -->
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Password *</label>
                        <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAdminPassword" runat="server"
                            ControlToValidate="txtAdminPassword" ErrorMessage="Password is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Confirm Password *</label>
                        <asp:TextBox ID="txtAdminConfirm" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAdminConfirm" runat="server"
                            ControlToValidate="txtAdminConfirm" ErrorMessage="Confirm Password is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                        <asp:CompareValidator ID="cvAdminConfirm" runat="server"
                            ControlToValidate="txtAdminConfirm" ControlToCompare="txtAdminPassword"
                            ErrorMessage="Passwords do not match."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>

                    <div class="col-md-4 d-flex align-items-end">
                        <asp:Button ID="btnCreateAdmin" runat="server" Text="➕ Create User Account"
                            CssClass="btn-green w-100" OnClick="btnCreateAdmin_Click" />
                    </div>
                </div>

            </div>
        </div>

        <!-- Table: Existing Admins & Users from Database -->
        <div class="card-custom">
            <div class="card-custom-header justify-content-between">
                <div>
                    <i class="fa-solid fa-users text-success"></i> All Registered Accounts in Database
                    (<asp:Literal ID="litUserCount" runat="server">0</asp:Literal> users)
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvUsers" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No accounts found in the database."
                    GridLines="None"
                    OnRowCommand="gvUsers_RowCommand"
                    DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" />
                        <asp:BoundField DataField="name" HeaderText="Full Name" />
                        <asp:BoundField DataField="email" HeaderText="Email Address" />
                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <span class='<%# Eval("role") != null && Eval("role").ToString().ToLower() == "admin" ? "badge-role-admin" : "badge-role-user" %>'>
                                    <%# Eval("role") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="contact" HeaderText="Contact" />
                        <asp:BoundField DataField="city" HeaderText="City" />
                        <asp:TemplateField HeaderText="Role Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnToggleRole" runat="server"
                                    CommandName="ToggleRole" CommandArgument='<%# Eval("Id") + ";" + Eval("role") %>'
                                    CssClass="btn btn-sm btn-outline-primary me-1">
                                    <i class="fa-solid fa-arrows-rotate me-1"></i>
                                    <%# Eval("role") != null && Eval("role").ToString().ToLower() == "admin" ? "Make User" : "Make Admin" %>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteUser" runat="server"
                                    CommandName="DeleteUserRow" CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn btn-sm btn-outline-danger"
                                    OnClientClick="return confirm('Delete this user account from the database?');">
                                    <i class="fa-solid fa-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>
