<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
        }
        .counter-card {
            transition: transform 0.2s;
        }
        .counter-card:hover {
            transform: translateY(-5px);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Panel ID="pnlZiyaretci" runat="server" Visible="true">
        
        <div class="container text-center my-5 py-5 rounded-5 shadow-sm hero-section">
            <h1 class="display-4 fw-bold">Bulut Tabanlı Yeni Nesil Stok Yönetimi</h1>
            <p class="lead mt-3 text-white-50">Stokcum.com ile envanterinizi anlık olarak takip edin, kritik stok alarmları ile işinizi asla şansa bırakmayın.</p>
            <div class="mt-4">
                <a href="log.aspx" class="btn btn-warning btn-lg px-5 fw-bold text-dark shadow">Hemen Ücretsiz Dene</a>
            </div>
        </div>

        <div class="container my-5">
            <div class="row g-4 text-center">
                
                <div class="col-md-3 col-sm-6">
                    <div class="p-4 bg-white border rounded-4 shadow-sm h-100 counter-card">
                        <h2 class="display-5 fw-bold text-primary">15.420+</h2>
                        <p class="text-muted mb-0 fw-semibold">Aktif Kullanıcı</p>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="p-4 bg-white border rounded-4 shadow-sm h-100 counter-card">
                        <h2 class="display-5 fw-bold text-success">2.840.000+</h2>
                        <p class="text-muted mb-0 fw-semibold">Takip Edilen Ürün</p>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="p-4 bg-white border rounded-4 shadow-sm h-100 counter-card">
                        <h2 class="display-5 fw-bold text-warning">94+</h2>
                        <p class="text-muted mb-0 fw-semibold">Desteklenen Sektör</p>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="p-4 bg-white border rounded-4 shadow-sm h-100 counter-card">
                        <h2 class="display-5 fw-bold text-info">%99.9</h2>
                        <p class="text-muted mb-0 fw-semibold">Uptime / Çalışma Süresi</p>
                    </div>
                </div>

            </div>
        </div>

        <div class="container my-5 py-4">
            <div class="row g-5 align-items-center">
                <div class="col-md-6">
                    <h3 class="fw-bold text-dark">Neden Stokcum.com?</h3>
                    <p class="text-muted">Karmakarışık Excel tablolarından kurtulun. Deponuzda ne var, ne yok, hangisi bitmek üzere tek ekrandan canlı izleyin.</p>
                    
                    <ul class="list-unstyled mt-4">
                        <li class="mb-3"><strong class="text-primary">✓ Gelişmiş Barkod Desteği:</strong> Ürünlerinizi hızlıca arayın ve güncelleyin.</li>
                        <li class="mb-3"><strong class="text-success">✓ Akıllı Bildirimler:</strong> Kritik limitin altına düşen ürünler için anında uyarı alın.</li>
                        <li class="mb-3"><strong class="text-danger">✓ Sıfır Veri Kaybı:</strong> Verileriniz veri tabanında güvenle yedeklenir.</li>
                    </ul>
                </div>
                <div class="col-md-6 text-center">
                    <div class="p-5 bg-light rounded-4 border d-inline-block shadow-sm w-100">
                        <span class="fs-1">📊</span>
                        <h5 class="mt-3 text-secondary fw-bold">Yönetim Paneli</h5>
                        <p class="text-muted small">Giriş yaptıktan sonra gerçek envanter verileriniz bu alanda aktif olacaktır.</p>
                    </div>
                </div>
            </div>
        </div>

    </asp:Panel>

<asp:Panel ID="pnlUyeDashboard" runat="server" Visible="false">
        <div class="container mt-5">
            
            <div class="p-5 mb-5 text-white rounded-5 shadow-sm" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="display-5 fw-bold">Teşekkür Ederiz! 🎉</h1>
                        <p class="lead fs-4 mt-2">
                            Sayın <b><%= Session["ad"] %></b>, Stokcum.com altyapısını tercih ettiğiniz ve ailemize katıldığınız için teşekkür ederiz.
                        </p>
                        <hr class="my-3 text-white-50">
                        <p class="mb-0 text-white-50">İşletmenizin envanter kontrolü ve dijital stok yönetimi artık tamamen güvende. Aşağıdaki panelden anlık durumunuzu takip edebilir ve hızlı işlemlerinizi gerçekleştirebilirsiniz.</p>
                    </div>
                    <div class="col-md-4 text-center d-none d-md-block">
                        <span style="font-size: 6rem;">💼</span>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-12">
                    <h3 class="fw-bold text-dark">Anlık Envanter Özetiniz</h3>
                    <p class="text-muted">Sisteminizde kayıtlı olan güncel stok verileri.</p>
                </div>
            </div>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card text-white bg-dark mb-3 shadow-sm border-0 rounded-4">
                        <div class="card-body p-4">
                            <h5 class="card-title text-white-50">Toplam Ürün Çeşidi</h5>
                            <p class="card-text display-6 fw-bold"><asp:Label ID="lblToplamUrun" runat="server" Text="0"></asp:Label></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-danger mb-3 shadow-sm border-0 rounded-4">
                        <div class="card-body p-4">
                            <h5 class="card-title text-white-50">Kritik Stok Uyarısı</h5>
                            <p class="card-text display-6 fw-bold"><asp:Label ID="lblKritikStok" runat="server" Text="0"></asp:Label></p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4 mb-5">
                <div class="col-12">
                    <div class="p-4 bg-white border rounded-4 shadow-sm">
                        <h4 class="fw-bold text-secondary">Hızlı Stok Sorgulama</h4>
                        <p class="text-muted small">Aramak istediğiniz ürünün adını veya barkod numarasını girin.</p>
                        <div class="input-group mt-3" style="max-width: 500px;">
                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control" Placeholder="Barkod veya Ürün Adı..."></asp:TextBox>
                            <asp:Button ID="btnAra" runat="server" Text="Sorgula" CssClass="btn btn-primary px-4" />
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </asp:Panel>
</asp:Content>