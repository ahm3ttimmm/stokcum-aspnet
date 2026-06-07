<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication1.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<%-- StyleSheet1.css zaten Site1.Master tarafından yükleniyor --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center">
                
                <h2 class="fw-bold mb-4" style="color:#84F8F9;">Hakkımızda</h2>
                
                <div class="card shadow-sm border-0 rounded-4 p-5" style="background:#1a2035;">
                    
                    <div id="section-misyon" class="about-card">
                        <span class="fs-1 mb-3">🎯</span>
                        <h3 class="fw-bold text-primary mb-3">Misyonumuz</h3>
                        <p class="lead text-muted px-4">
                            Stokcum.com olarak misyonumuz; her ölçekteki işletmenin karmaşık envanter ve depo süreçlerini en basit, hızlı ve güvenilir dijital altyapıya kavuşturmaktır. Gelişmiş bulut teknolojilerimizle süreçleri otomatize ederek, işletmelerin zaman ve maliyet kayıplarını sıfıra indirmeyi hedefliyoruz.
                        </p>
                    </div>

                    <div id="section-vizyon" class="about-card" style="display: none;">
                        <span class="fs-1 mb-3">🚀</span>
                        <h3 class="fw-bold text-success mb-3">Vizyonumuz</h3>
                        <p class="lead text-muted px-4">
                            Yenilikçi teknolojilerimiz ve kullanıcı dostu arayüzümüz ile yerel ve küresel pazarda en çok tercih edilen bulut tabanlı stok yönetim ekosistemi olmak. Yapay zeka destekli stok tahminleme modellerimizle, geleceğin envanter yönetim standartlarını bugünden inşa etmektir.
                        </p>
                    </div>

                    <div class="progress-bar-custom mt-4 rounded">
                        <div id="progressBar" class="progress-fill"></div>
                    </div>

                </div>

            </div>
        </div>
    </div>

                      <script type="text/javascript">
    // Misyon/Vizyon animasyonu
    (function () {
        var sections = ['section-misyon', 'section-vizyon'];
        var current = 0;
        var bar = document.getElementById('progressBar');

        function show(idx) {
            sections.forEach(function (id, i) {
                var el = document.getElementById(id);
                if (el) el.style.display = i === idx ? '' : 'none';
            });
            if (bar) bar.style.width = ((idx + 1) / sections.length * 100) + '%';
        }

        show(0);
        setInterval(function () {
            current = (current + 1) % sections.length;
            show(current);
        }, 4000);
    })();
</script>

</asp:Content>