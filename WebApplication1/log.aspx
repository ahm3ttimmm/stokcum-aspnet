<%@ Page Title="Giriş / Kayıt" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="log.aspx.cs" Inherits="WebApplication1.log" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

    <%-- =================== VIEW 0 — GİRİŞ =================== --%>
    <asp:View ID="View2" runat="server">
        <div class="login-container">
            <div class="card login-card shadow p-4">
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold">Lütfen Giriş Yapın</h1>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                        TextMode="Email" placeholder="E-posta Adresi"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control"
                        TextMode="Password" placeholder="Şifre"></asp:TextBox>
                </div>
                <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap"
                    CssClass="btn btn-login w-100 py-2 mt-2" OnClick="btnGiris_Click" />
                <asp:Button ID="btnKayit" runat="server" Text="Kayıt Ol"
                    CssClass="btn btn-login w-100 py-2 mt-2" OnClick="btnKayit_Click" />
                <p class="mt-5 mb-0 text-center fw-medium" style="font-size:14px;opacity:.8;">&copy; 2026 Stokcum.com</p>
            </div>
        </div>
    </asp:View>

    <%-- =================== VIEW 1 — KAYIT FORMU =================== --%>
    <asp:View ID="View1" runat="server">
        <div class="login-container">
            <div class="card login-card shadow p-4">
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold">Kayıt Ol</h1>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control"
                        placeholder="Ad Soyad"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtKayitEmail" runat="server" CssClass="form-control"
                        TextMode="Email" placeholder="E-posta Adresi"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtKayitSifre" runat="server" CssClass="form-control"
                        TextMode="Password" placeholder="Şifre"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtKayitSifreTekrar" runat="server" CssClass="form-control"
                        TextMode="Password" placeholder="Şifre Tekrar"></asp:TextBox>
                </div>
                <asp:CompareValidator ID="CompareValidator1" runat="server"
                    ControlToCompare="txtKayitSifre" ControlToValidate="txtKayitSifreTekrar"
                    Display="Dynamic" ErrorMessage="ŞİFRELER UYUŞMAMAKTADIR!"
                    ForeColor="Red" CssClass="small d-block mb-2"></asp:CompareValidator>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                    ConnectionString="<%$ ConnectionStrings:register %>"
                    SelectCommand="SELECT * FROM [Users]"></asp:SqlDataSource>
                <asp:Button ID="btnKaydet" runat="server"
                    Text="📧 Doğrulama Kodu Gönder"
                    CssClass="btn btn-login w-100 py-2 mt-2"
                    OnClick="btnKaydet_Click" />
                <div class="text-center mt-3">
                    <a href="log.aspx"
                       style="color:#3e2723;text-decoration:none;font-weight:600;font-size:14px;">
                        Zaten hesabınız var mı? Giriş yapın
                    </a>
                </div>
                <p class="mt-4 mb-0 text-center fw-medium" style="font-size:14px;opacity:.8;">&copy; 2026 Stokcum.com</p>
            </div>
        </div>
    </asp:View>

    <%-- =================== VIEW 2 — E-POSTA DOĞRULAMA =================== --%>
    <asp:View ID="ViewDogrulama" runat="server">
        <div class="login-container">
            <div class="card login-card shadow p-4">
                <div class="text-center mb-3">
                    <div style="font-size:54px;line-height:1;">📧</div>
                    <h1 class="h3 fw-bold mt-2">E-posta Doğrulama</h1>
                </div>
                <div class="mb-3 p-3 rounded-3"
                     style="background:#fff8e1;border:1px solid #ffe082;">
                    <div class="text-center" style="color:#5d4037;font-weight:600;font-size:15px;">
                        <asp:Label ID="lblDogrulaEposta" runat="server"></asp:Label>
                    </div>
                    <p class="text-center text-muted small mb-0 mt-1">
                        adresine 6 haneli doğrulama kodu gönderildi.<br />
                        <strong>10 dakika</strong> içinde giriniz.
                    </p>
                </div>
                <div class="mb-2">
                    <asp:TextBox ID="txtDogrulamaKodu" runat="server"
                        CssClass="form-control text-center"
                        placeholder="- - - - - -" MaxLength="6"
                        style="font-size:32px;font-weight:700;letter-spacing:14px;color:#3e2723;"></asp:TextBox>
                </div>
                <asp:Label ID="lblDogrulamaHata" runat="server"
                    CssClass="d-block text-center small mb-2" ForeColor="Red"></asp:Label>
                <asp:Button ID="btnDogrula" runat="server"
                    Text="✅ Doğrula ve Kayıt Ol"
                    CssClass="btn btn-login w-100 py-2 mt-1"
                    OnClick="btnDogrula_Click" />
                <div class="d-flex justify-content-between mt-3">
                    <asp:LinkButton ID="btnKodTekrar" runat="server"
                        OnClick="btnKodTekrar_Click"
                        style="color:#3e2723;font-size:13px;font-weight:600;text-decoration:none;">
                        🔄 Kodu Tekrar Gönder
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnGeriDon" runat="server"
                        OnClick="btnGeriDon_Click"
                        style="color:#888;font-size:13px;text-decoration:none;">
                        ← Geri Dön
                    </asp:LinkButton>
                </div>
                <p class="mt-4 mb-0 text-center fw-medium" style="font-size:14px;opacity:.8;">&copy; 2026 Stokcum.com</p>
            </div>
        </div>
    </asp:View>

    </asp:MultiView>
</asp:Content>
