<%@ Page Title="Manage Products - Admin" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true"
    CodeBehind="AdminProducts.aspx.cs"
    Inherits="Project.AdminProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-wrapper { max-width: 1200px; margin: 35px auto 60px; padding: 0 15px; }
        .admin-title { font-size: 26px; font-weight: 700; color: #1e3a1f; display: flex; align-items: center; gap: 12px; margin-bottom: 24px; }
        .admin-card { background: #fff; border: 1px solid #dce8db; border-radius: 12px; box-shadow: 0 3px 14px rgba(0,0,0,0.05); margin-bottom: 28px; overflow: hidden; }
        .admin-card-header { background: #f5faf4; padding: 16px 22px; border-bottom: 1px solid #e2ebe0; font-size: 16px; font-weight: 700; color: #1b351d; display: flex; align-items: center; gap: 10px; }
        .admin-card-body { padding: 22px; }
        .admin-table th { background: #f7faf5; color: #436240; font-weight: 600; font-size: 13px; padding: 12px 16px; }
        .admin-table td { padding: 13px 16px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid #edf2ec; }
        .prod-thumb { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #e2ebe0; }
        .form-label { font-size: 13px; font-weight: 600; color: #334432; margin-bottom: 5px; }
        .btn-save { background: #2ea339; color: #fff; border: none; padding: 9px 22px; border-radius: 7px; font-weight: 600; cursor: pointer; }
        .btn-save:hover { background: #22842c; color: #fff; }
        .btn-del { background: transparent; color: #dc3545; border: 1px solid #dc3545; padding: 5px 12px; border-radius: 6px; font-size: 13px; cursor: pointer; }
        .btn-del:hover { background: #dc3545; color: #fff; }
        .btn-back { display: inline-flex; align-items: center; gap: 6px; color: #2e8b38; font-weight: 600; text-decoration: none; margin-bottom: 16px; }
        .btn-back:hover { color: #1d6124; text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-wrapper">

        <a href="AdminDashboard.aspx" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>

        <h1 class="admin-title">
            <i class="fa-solid fa-box-open text-success"></i> Product Management
        </h1>

        <!-- Alert -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false"
            CssClass="alert alert-success alert-dismissible fade show mb-4">
            <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </asp:Panel>

        <!-- Add/Edit Product Form -->
        <div class="admin-card">
            <div class="admin-card-header">
                <i class="fa-solid fa-plus text-success"></i>
                <asp:Literal ID="litFormTitle" runat="server">Add New Product to Database</asp:Literal>
            </div>
            <div class="admin-card-body">

                <asp:HiddenField ID="hdnEditId" runat="server" Value="0" />

                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                    CssClass="alert alert-danger py-2 mb-3"
                    HeaderText="Please fix the following errors:"
                    EnableClientScript="false"
                    ShowMessageBox="false" ShowSummary="true" />

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Product Name *</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="e.g. Snake Plant"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtName" ErrorMessage="Product Name is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Category *</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Plants"      Value="plants"></asp:ListItem>
                            <asp:ListItem Text="Seeds"       Value="seeds"></asp:ListItem>
                            <asp:ListItem Text="Fertilizers" Value="fertilizers"></asp:ListItem>
                            <asp:ListItem Text="Pots"        Value="pots"></asp:ListItem>
                            <asp:ListItem Text="Tools"       Value="tools"></asp:ListItem>
                            <asp:ListItem Text="Plant Care"  Value="care"></asp:ListItem>
                            <asp:ListItem Text="Gift Sets"   Value="gifts"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Price (₹) *</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="e.g. 499"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                            ControlToValidate="txtPrice" ErrorMessage="Price is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPrice" runat="server"
                            ControlToValidate="txtPrice" ErrorMessage="Price must be a valid number."
                            ValidationExpression="^\d+(\.\d{1,2})?$"
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                            placeholder="Short product description" MaxLength="500"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Stock Quantity *</label>
                        <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" Text="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStock" runat="server"
                            ControlToValidate="txtStock" ErrorMessage="Stock quantity is required."
                            ForeColor="#FF3300" EnableClientScript="false" Display="Dynamic" />
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Image URL (relative to project root)</label>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control"
                            placeholder="e.g. image/product-snake-plant.png"></asp:TextBox>
                    </div>
                    <div class="col-md-4 d-flex align-items-end gap-2">
                        <asp:Button ID="btnSaveProduct" runat="server" Text="Save Product to Database"
                            CssClass="btn-save" OnClick="btnSaveProduct_Click" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" Visible="false"
                            CssClass="btn btn-outline-secondary" OnClick="btnCancelEdit_Click"
                            CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Table from DB -->
        <div class="admin-card">
            <div class="admin-card-header">
                <i class="fa-solid fa-list text-success"></i> All Products in Database
                (<asp:Literal ID="litProductCount" runat="server">0</asp:Literal> records)
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvProducts" runat="server"
                    CssClass="table admin-table mb-0"
                    AutoGenerateColumns="false"
                    EmptyDataText="No products found in the database."
                    GridLines="None"
                    OnRowCommand="gvProducts_RowCommand"
                    DataKeyNames="ProductId">
                    <Columns>
                        <asp:BoundField DataField="ProductId" HeaderText="ID" />
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' class="prod-thumb" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name"          HeaderText="Product Name" />
                        <asp:BoundField DataField="Category"      HeaderText="Category" />
                        <asp:BoundField DataField="Price"         HeaderText="Price (₹)" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="StockQuantity" HeaderText="Stock" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditProd" runat="server"
                                    CommandName="EditProduct" CommandArgument='<%# Eval("ProductId") %>'
                                    CssClass="btn btn-sm btn-outline-success me-1">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteProd" runat="server"
                                    CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductId") %>'
                                    CssClass="btn-del"
                                    OnClientClick="return confirm('Delete this product from the database?');">
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
