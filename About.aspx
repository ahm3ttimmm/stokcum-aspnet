<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication1.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <link href="css/StyleSheet1.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center">
                
                <h2 class="fw-bold text-dark mb-4">Hakkımızda</h2>
                
                <div class="card shadow-sm border-0 rounded-4 bg-white p-5">
                    
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

                      <script src="about-script.js" type="text/javascript"></script>

</asp:Content>