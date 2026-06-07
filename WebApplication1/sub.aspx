<%@ Page Title="Abonelik" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="sub.aspx.cs" Inherits="WebApplication1.sub" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    .plan-card { border-radius: 16px; border: 2px solid #e0e0e0; transition: transform .2s, box-shadow .2s; }
    .plan-card:hover { transform: translateY(-6px); box-shadow: 0 12px 28px rgba(0,0,0,.12); }
    .plan-card.popular { border-color: #3e2723; }
    .badge-popular { background:#3e2723; color:#fff; font-size:12px; padding:4px 12px; border-radius:20px; }
    .price-tag { font-size: 2.4rem; font-weight: 800; color: #3e2723; }
    .price-period { font-size: 14px; color: #888; }
    .feature-list li { padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size:15px; }
    .feature-list li:last-child { border-bottom: none; }
    .btn-abone { background: #3e2723; color: #fff; border: none; border-radius: 10px;
                 padding: 12px 0; font-size: 16px; font-weight: 600; width: 100%; transition: background .2s; }
    .btn-abone:hover { background: #5d4037; color:#fff; }
    .btn-abone:disabled { background: #aaa; cursor: not-allowed; }
    .current-badge { background:#e8f5e9; color:#2e7d32; padding:6px 14px; border-radius:20px;
                     font-weight:700; font-size:14px; display:inline-block; margin-top:6px; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container mt-5 mb-5">

    <div class="text-center mb-5">
        <h2 class="fw-bold" style="color:#3e2723;">Abonelik Planları</h2>
        <p class="text-muted">Size en uygun planı seçin, istediğiniz zaman iptal edin.</p>
    </div>

    <!-- Mevcut Abonelik Bantı -->
    <asp:Panel ID="pnlMevcutAbonelik" runat="server" Visible="false" CssClass="alert mb-4"
               style="background:#e8f5e9; border:1.5px solid #a5d6a7; border-radius:12px; padding:18px 24px;">
        <div class="d-flex align-items-center gap-3 flex-wrap">
            <span style="font-size:28px;">&#10003;</span>
            <div>
                <strong>Aktif Abonelik:</strong>
                <asp:Label ID="lblPlanAdi" runat="server" CssClass="ms-1 fw-bold" style="color:#2e7d32;"></asp:Label>
                &nbsp;&mdash;&nbsp;
                <asp:Label ID="lblDurum" runat="server"></asp:Label>
            </div>
            <div class="ms-auto">
                <small class="text-muted">Bitiş Tarihi: </small>
                <asp:Label ID="lblSonrakiFatura" runat="server" CssClass="fw-semibold"></asp:Label>
            </div>
        </div>
    </asp:Panel>

    <!-- Plan Kartları -->
    <div class="row justify-content-center g-4">
        <asp:Repeater ID="rptPlanlar" runat="server" OnItemCommand="rptPlanlar_ItemCommand">
            <ItemTemplate>
                <div class="col-md-4">
                    <div class="card plan-card h-100" style='<%# Convert.ToBoolean(Eval("Populer")) ? "border-color:#3e2723;" : "" %>'>
                        <div class="card-body d-flex flex-column p-4">
                            
                            <%# Convert.ToBoolean(Eval("Populer")) ? "<div class='text-center mb-2'><span class='badge-popular'>&#9733; En Popüler</span></div>" : "" %>

                            <h4 class="fw-bold text-center mb-1"><%# Eval("Ad") %></h4>
                            <div class="text-center my-3">
                                <span class="price-tag"><%# Eval("Fiyat", "{0:0}") %> ₺</span><br/>
                                <span class="price-period"><%# Eval("Periyot") %></span>
                            </div>

                            <p class="text-muted text-center small mb-3"><%# Eval("Aciklama") %></p>

                            <ul class="list-unstyled feature-list mb-4">
                                <%# Eval("OzelliklerHtml") %>
                            </ul>

                            <div class="mt-auto">
                                <asp:Button ID="btnAboneOl" runat="server"
                                    Text='<%# Eval("BtnText") %>'
                                    CssClass="btn-abone"
                                    CommandName="AboneOl"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Enabled='<%# !(bool)Eval("Mevcut") %>' />
                                <%# Convert.ToBoolean(Eval("Mevcut")) ? "<div class='text-center'><span class='current-badge'>&#10003; Mevcut Planınız</span></div>" : "" %>
                            </div>

                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Bilgi Kutusu -->
    <div class="text-center mt-5">
        <p class="text-muted small">
            Abonelik işlemleri demo modundadır. Gerçek ödeme entegrasyonu için İyzico / Stripe bağlanabilir.
        </p>
    </div>

    <!-- Mesaj -->
    <asp:Label ID="lblMesaj" runat="server" CssClass="d-block text-center mt-3 fw-semibold fs-5"></asp:Label>

</div>
</asp:Content>