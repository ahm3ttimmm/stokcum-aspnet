<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true"
         CodeBehind="Default.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    /* ---- Ziyaretçi hero ---- */
    .hero-section { background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:white; }
    .counter-card  { transition:transform .2s; }
    .counter-card:hover { transform:translateY(-5px); }

    /* ---- Hoş Geldin kutusu ---- */
    .hosgeldin-box {
        background: linear-gradient(135deg,#11998e 0%,#38ef7d 100%);
        border-radius: 24px;
        overflow: hidden;
        position: relative;
        transition: opacity 1.5s ease, margin-bottom 1.5s ease, max-height 1.5s ease;
    }
    .hosgeldin-box.fade-out {
        opacity: 0 !important;
        max-height: 0 !important;
        margin-bottom: 0 !important;
        padding: 0 !important;
    }
    /* Geri sayım çubuğu */
    @keyframes countdown90 { from { width:100%; } to { width:0%; } }
    .countdown-bar {
        position: absolute;
        bottom: 0; left: 0;
        height: 5px;
        background: rgba(255,255,255,.55);
        animation: countdown90 90s linear forwards;
        border-radius: 0 0 0 24px;
    }

    /* ---- Dashboard kartları ---- */
    .stat-card {
        border: none;
        border-radius: 18px;
        padding: 26px 22px;
        color: white;
        box-shadow: 0 6px 20px rgba(0,0,0,.12);
        transition: transform .2s, box-shadow .2s;
        cursor: default;
        height: 100%;
    }
    .stat-card:hover { transform: translateY(-4px); box-shadow: 0 12px 28px rgba(0,0,0,.18); }
    .stat-card .stat-icon  { font-size: 2.4rem; line-height: 1; margin-bottom: 12px; }
    .stat-card .stat-label { font-size: 13px; font-weight: 600; opacity: .75; text-transform: uppercase; letter-spacing: .5px; }
    .stat-card .stat-value { font-size: 2.6rem; font-weight: 800; line-height: 1.1; margin: 6px 0 0; }

    .card-sirket  { background: linear-gradient(135deg,#3e2723,#6d4c41); }
    .card-urun    { background: linear-gradient(135deg,#1565c0,#42a5f5); }
    .card-kritik  { background: linear-gradient(135deg,#b71c1c,#ef5350); }
    .card-deger   { background: linear-gradient(135deg,#1b5e20,#43a047); }

    /* ---- Arama kutusu ---- */
    .search-card {
        background: #1a2035;
        border-radius: 18px;
        padding: 28px 30px;
        box-shadow: 0 4px 14px rgba(0,0,0,.25);
        border: 1px solid rgba(132,248,249,.15);
    }
    .search-card h5 { color: #84F8F9; font-weight: 700; }
    .search-card p  { color: #8da4d0; }

    /* ---- Son ürünler tablosu ---- */
    .recent-table { border-radius: 18px; overflow: hidden; box-shadow: 0 4px 14px rgba(21,14,64,.4); }
    .recent-table thead th { background: linear-gradient(135deg,#150E40,#28467F); color: #84F8F9; border: none; font-weight: 600; }
    .recent-table tbody tr:hover { background: rgba(132,248,249,.06); }
    .recent-table td, .recent-table th { border-color: rgba(132,248,249,.1); padding: 12px 16px; color: #c8d8f0; }

    .kritik-badge  { background:#ffeaea;color:#c62828;border-radius:6px;padding:3px 9px;font-size:12px;font-weight:700; }
    .normal-badge  { background:#e8f5e9;color:#2e7d32;border-radius:6px;padding:3px 9px;font-size:12px;font-weight:700; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- ============================================================
         ZİYARETÇİ PANELİ
    ============================================================ --%>
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
                        <p class="text-muted mb-0 fw-semibold">Uptime</p>
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

    <%-- ============================================================
         ÜYE DASHBOARD
    ============================================================ --%>
    <asp:Panel ID="pnlUyeDashboard" runat="server" Visible="false">
    <div class="container-fluid px-4 py-4">

        <%-- ---- HOŞ GELDİN KUTUSU (90 sn sonra kaybolur) ---- --%>
        <div id="hosgeldinBox" class="hosgeldin-box p-4 p-md-5 mb-4 text-white shadow-sm">
            <div class="countdown-bar" id="countdownBar"></div>
            <div class="row align-items-center">
                <div class="col-md-9">
                    <h2 class="fw-bold mb-2">Hoş Geldiniz, <asp:Label ID="lblAdSoyad" runat="server"></asp:Label>! 👋</h2>
                    <p class="mb-1 fs-5" style="opacity:.9;">
                        Stokcum.com envanteriniz hazır. Aşağıdaki panelden anlık durumunuzu takip edebilirsiniz.
                    </p>
                    <small style="opacity:.65;">Bu mesaj 90 saniye sonra otomatik olarak kapanacaktır.</small>
                </div>
                <div class="col-md-3 text-center d-none d-md-flex align-items-center justify-content-center">
                    <span style="font-size:5rem;line-height:1;">💼</span>
                </div>
            </div>
        </div>

        <%-- ---- BAŞLIK ---- --%>
        <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
        <h4 class="fw-bold mb-0" style="color:#84F8F9;">📊 Anlık Envanter Paneliniz</h4>
        <small style="color:#8da4d0;">Son güncelleme: <asp:Label ID="lblSonGuncelleme" runat="server"></asp:Label></small>
        </div>
            <a href="memberpanel.aspx" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                ➕ Yeni Stok Ekle
            </a>
        </div>

        <%-- ---- 4 İSTATİSTİK KARTI ---- --%>
        <div class="row g-3 mb-4">

            <div class="col-xl-3 col-md-6">
                <div class="stat-card card-sirket">
                    <div class="stat-icon">🏢</div>
                    <div class="stat-label">Kayıtlı Şirket</div>
                    <div class="stat-value"><asp:Label ID="lblToplamSirket" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card card-urun">
                    <div class="stat-icon">📦</div>
                    <div class="stat-label">Toplam Ürün Çeşidi</div>
                    <div class="stat-value"><asp:Label ID="lblToplamUrun" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card card-kritik">
                    <div class="stat-icon">⚠️</div>
                    <div class="stat-label">Kritik Stok Uyarısı</div>
                    <div class="stat-value"><asp:Label ID="lblKritikStok" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card card-deger">
                    <div class="stat-icon">💰</div>
                    <div class="stat-label">Toplam Stok Değeri (₺)</div>
                    <div class="stat-value" style="font-size:2rem;">
                        <asp:Label ID="lblStokDegeri" runat="server" Text="0"></asp:Label>
                    </div>
                </div>
            </div>

        </div>

        <%-- ---- ARAMA + SON EKLENEN ÜRÜNLER ---- --%>
        <div class="row g-3 mb-4">

            <%-- Hızlı arama --%>
            <div class="col-lg-4">
                <div class="search-card h-100">
                    <h5>🔍 Hızlı Stok Sorgulama</h5>
                    <p class="text-muted small mb-3">Barkod veya ürün adı ile anlık sorgulama yapın.</p>
                    <div class="input-group mb-2">
                        <asp:TextBox ID="txtAra" runat="server" CssClass="form-control"
                            placeholder="Ürün adı veya barkod..." style="border-radius:10px 0 0 10px;"></asp:TextBox>
                        <asp:Button ID="btnAra" runat="server" Text="Sorgula"
                            CssClass="btn btn-dark px-4" OnClick="btnAra_Click"
                            style="border-radius:0 10px 10px 0;" />
                    </div>
                    <asp:Label ID="lblAramaHata" runat="server" CssClass="small text-danger"></asp:Label>

                    <asp:GridView ID="gvArama" runat="server" Visible="false"
                        CssClass="table table-sm mt-3" AutoGenerateColumns="False"
                        EmptyDataText="Ürün bulunamadı.">
                        <Columns>
                            <asp:BoundField DataField="StokAdi"     HeaderText="Ürün"    />
                            <asp:BoundField DataField="Miktar"      HeaderText="Miktar"  DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Birim"       HeaderText="Birim"   />
                            <asp:BoundField DataField="SatisFiyati" HeaderText="Fiyat ₺" DataFormatString="{0:N2}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <%-- Son eklenen ürünler --%>
            <div class="col-lg-8">
                <div class="search-card h-100">
                    <h5>🕐 Son Eklenen Ürünler</h5>
                    <p class="text-muted small mb-3">Sisteminize en son eklenen 8 kayıt.</p>
                    <div style="overflow-x:auto;">
                        <asp:GridView ID="gvSonUrunler" runat="server"
                            CssClass="table recent-table mb-0"
                            AutoGenerateColumns="False"
                            EmptyDataText="Henüz stok ürünü eklenmemiş.">
                            <Columns>
                                <asp:BoundField DataField="StokAdi"      HeaderText="Ürün Adı"  />
                                <asp:BoundField DataField="companiesname" HeaderText="Şirket"   />
                                <asp:BoundField DataField="Miktar"       HeaderText="Miktar"    DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Birim"        HeaderText="Birim"     />
                                <asp:TemplateField HeaderText="Durum">
                                    <ItemTemplate>
                                        <%# (decimal)Eval("Miktar") <= (decimal)Eval("MinStokSeviyesi")
                                            ? "<span class='kritik-badge'>⚠ Kritik</span>"
                                            : "<span class='normal-badge'>✓ Normal</span>" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

        </div>

    </div>
    </asp:Panel>

    <%-- ---- 90 SANİYE FADE-OUT SCRIPT ---- --%>
    <script>
        (function () {
            var box = document.getElementById('hosgeldinBox');
            if (!box) return;
            var el = /** @type {HTMLElement} */ (box);

            setTimeout(function () {
                el.style.transition     = 'opacity 1.5s ease, max-height 1.5s ease, margin-bottom 1.5s ease, padding 1.5s ease';
                el.style.opacity        = '0';
                el.style.maxHeight      = '0';
                el.style.overflow       = 'hidden';
                el.style.marginBottom   = '0';
                el.style.paddingTop     = '0';
                el.style.paddingBottom  = '0';
            }, 90000);
        })();
    </script>

</asp:Content>
