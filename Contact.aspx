<%@ Page Title="İletişim & SSS" Language="C#" MasterPageFile="~/Site1.Master" 
         AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- CSS dosyasını buraya ekleyin (eğer MasterPage'te yoksa) -->
    <link href="css/StyleSheet1.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">
        <h2 class="text-center mb-5">İletişim & Sık Sorulan Sorular</h2>

        <!-- ====================== SSS BÖLÜMÜ ====================== -->
        <div class="mb-5">
            <h3 class="section-title mb-4">Sık Sorulan Sorular (SSS)</h3>
            
            <div class="accordion" id="faqAccordion">
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                            Şirket kaydı nasıl yapılır?
                        </button>
                    </h2>
                    <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Üye paneline girip "Şirketler" sekmesinden yeni şirket oluşturabilirsiniz.
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                            Stok takibi nasıl yapılır?
                        </button>
                    </h2>
                    <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Stok Yönetimi bölümünden stok ekleyebilir, miktar ve fiyat bilgilerini güncelleyebilirsiniz.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ====================== YORUMLAR BÖLÜMÜ ====================== -->
        <div class="mb-5">
            <h3 class="section-title mb-4">Müşteri Yorumları</h3>
            <h4 class="section-title mb-4">(Yalnızca Onaylı Yorumlar)</h4>
            
            <asp:Repeater ID="rptYorumlar" runat="server" DataSourceID="SqlDataSource2">
                <ItemTemplate>
                    <div class="comment-card mb-3">
                        <div class="card-body">
                            <h5 class="comment-author"><%# Eval("yazan") %></h5>
                            <p class="comment-text"><%# Eval("comment") %></p>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:Comment %>" SelectCommand="SELECT * FROM [comment] WHERE ([onay] = @onay)">
                <SelectParameters>
                    <asp:Parameter DefaultValue="True" Name="onay" Type="Boolean" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>

        <!-- ====================== MESAJ GÖNDERME FORMU ====================== -->
        <div class="contact-form-card">
            <div class="card-header">
                <h4>Bize Soru Sorun / Mesaj Gönderin</h4>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Adınız Soyadınız</label>
                        <asp:TextBox ID="txtAd" runat="server" CssClass="form-control" required></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">E-posta Adresiniz</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Konu</label>
                    <asp:DropDownList ID="ddlKonu" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Konu Seçiniz</asp:ListItem>
                        <asp:ListItem>Genel Soru</asp:ListItem>
                        <asp:ListItem>Şirket Kaydı</asp:ListItem>
                        <asp:ListItem>Stok Sistemi</asp:ListItem>
                        <asp:ListItem>Öneri ve Şikayet</asp:ListItem>
                        <asp:ListItem>Diğer</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mesajınız</label>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:question %>" InsertCommand="INSERT INTO [sorular] ([AdSoyad], [Eposta], [Konu], [Mesaj]) VALUES (@AdSoyad, @Eposta, @Konu, @Mesaj)" SelectCommand="SELECT * FROM [sorular]" ConflictDetection="CompareAllValues" DeleteCommand="DELETE FROM [sorular] WHERE [Id] = @original_Id AND [AdSoyad] = @original_AdSoyad AND [Eposta] = @original_Eposta AND [Konu] = @original_Konu AND [Mesaj] = @original_Mesaj AND (([KayitTarihi] = @original_KayitTarihi) OR ([KayitTarihi] IS NULL AND @original_KayitTarihi IS NULL))" OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [sorular] SET [AdSoyad] = @AdSoyad, [Eposta] = @Eposta, [Konu] = @Konu, [Mesaj] = @Mesaj, [KayitTarihi] = @KayitTarihi WHERE [Id] = @original_Id AND [AdSoyad] = @original_AdSoyad AND [Eposta] = @original_Eposta AND [Konu] = @original_Konu AND [Mesaj] = @original_Mesaj AND (([KayitTarihi] = @original_KayitTarihi) OR ([KayitTarihi] IS NULL AND @original_KayitTarihi IS NULL))">
                        <DeleteParameters>
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_AdSoyad" Type="String" />
                            <asp:Parameter Name="original_Eposta" Type="String" />
                            <asp:Parameter Name="original_Konu" Type="String" />
                            <asp:Parameter Name="original_Mesaj" Type="String" />
                            <asp:Parameter DbType="DateTime2" Name="original_KayitTarihi" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:ControlParameter ControlID="txtAd" Name="AdSoyad" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="txtEmail" Name="Eposta" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="ddlKonu" Name="Konu" PropertyName="SelectedValue" Type="String" />
                            <asp:ControlParameter ControlID="txtMesaj" Name="Mesaj" PropertyName="Text" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="AdSoyad" Type="String" />
                            <asp:Parameter Name="Eposta" Type="String" />
                            <asp:Parameter Name="Konu" Type="String" />
                            <asp:Parameter Name="Mesaj" Type="String" />
                            <asp:Parameter DbType="DateTime2" Name="KayitTarihi" />
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_AdSoyad" Type="String" />
                            <asp:Parameter Name="original_Eposta" Type="String" />
                            <asp:Parameter Name="original_Konu" Type="String" />
                            <asp:Parameter Name="original_Mesaj" Type="String" />
                            <asp:Parameter DbType="DateTime2" Name="original_KayitTarihi" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <asp:TextBox ID="txtMesaj" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" required></asp:TextBox>
                </div>

                <asp:Button ID="btnGonder" runat="server" Text="Mesajı Gönder" 
                    CssClass="btn btn-success btn-lg w-100" OnClick="btnGonder_Click" />
            </div>
        </div>
    </div>

</asp:Content>