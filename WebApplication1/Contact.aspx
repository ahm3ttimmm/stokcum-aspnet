<%@ Page Title="Iletisim & SSS" Language="C#" MasterPageFile="~/Site1.Master" 
         AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    .contact-wrapper { max-width: 860px; margin: 0 auto; padding: 20px; }

    /* SSS */
    .accordion-button:not(.collapsed) { background: linear-gradient(135deg,#150E40,#28467F); color: #84F8F9; box-shadow: none; }
    .accordion-button:focus            { box-shadow: none; }
    .accordion-button                  { font-weight: 600; color: #28467F; background:#0f1525; }
    .accordion-item                    { border: 1px solid rgba(132,248,249,.18); margin-bottom: 6px; border-radius: 10px !important; overflow: hidden; background:#141c30; }
    .accordion-body                    { background:#141c30; color:#c8d8f0; }

    /* Yorum kartlari */
    .yorum-card {
        background: #1a2035;
        border-left: 4px solid #28467F;
        border-radius: 10px;
        padding: 16px 20px;
        margin-bottom: 14px;
        box-shadow: 0 2px 8px rgba(21,14,64,.3);
    }
    .yorum-yazar  { font-weight: 700; color: #84F8F9; margin-bottom: 4px; font-size: 15px; }
    .yorum-metin  { color: #c8d8f0; font-size: 14.5px; line-height: 1.6; margin: 0; }
    .yorum-bos    { color: #666; font-style: italic; text-align: center; padding: 20px 0; }

    /* Iletisim formu */
    .form-card {
        background: linear-gradient(145deg, #1a2540, #28467F);
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 6px 20px rgba(21,14,64,.45);
        border: 1px solid rgba(132,248,249,.18);
    }
    .form-card h4      { color: #84F8F9; font-weight: 700; margin-bottom: 20px; }
    .form-card .form-control,
    .form-card .form-select {
        border: 1px solid rgba(132,248,249,.22);
        border-radius: 10px;
        background: rgba(18,23,35,.7);
        color: #dce6f5;
        padding: 10px 14px;
    }
    .form-card .form-control:focus,
    .form-card .form-select:focus { border-color: #84F8F9; box-shadow: 0 0 0 3px rgba(132,248,249,.15); outline: none; }
    .form-card .form-control::placeholder { color: rgba(132,248,249,.4); }
    .form-card .form-label { color: #84F8F9; font-weight: 600; margin-bottom: 5px; }
    .btn-gonder {
        background: #28467F; color: #84F8F9;
        border: 1px solid rgba(132,248,249,.28); border-radius: 10px;
        padding: 12px 0; font-size: 15px; font-weight: 600;
        width: 100%; margin-top: 8px;
        transition: all .25s;
    }
    .btn-gonder:hover { background: #84F8F9; color: #121723; border-color: transparent; }

    .section-label {
        color: #84F8F9; font-weight: 700;
        font-size: 1.15rem; margin-bottom: 16px;
        padding-bottom: 8px; border-bottom: 2px solid rgba(132,248,249,.3);
    }

    .baslik { color: #84F8F9; font-weight: 800; margin-bottom: 30px; }

    .alert-success-custom {
        background: rgba(40,70,127,.3); color: #84F8F9;
        border: 1px solid rgba(132,248,249,.3); border-radius: 10px;
        padding: 12px 18px; font-weight: 600;
        margin-top: 14px;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="contact-wrapper">

    <h2 class="baslik text-center">Iletisim &amp; SSS</h2>

    <!-- SSS -->
    <div class="mb-5">
        <div class="section-label">Sik Sorulan Sorular</div>
        <div class="accordion" id="faqAccordion">

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                        Sirket kaydi nasil yapilir?
                    </button>
                </h2>
                <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Uye paneline girip <strong>Sirketler</strong> sekmesinden yeni sirket olusturabilirsiniz.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                        Stok takibi nasil yapilir?
                    </button>
                </h2>
                <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <strong>Stok Yonetimi</strong> bolumunden stok ekleyebilir, miktar ve fiyat bilgilerini guncelleyebilirsiniz.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                        Aboneligimi nasil iptal ederim?
                    </button>
                </h2>
                <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Abonelik sayfasindan ucretsiz plana gecerek mevcut aboneliginizi sonlandirabilirsiniz.
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- YORUMLAR -->
    <div class="mb-5">
        <div class="section-label">Musteri Yorumlari <small style="font-weight:400;color:#999;font-size:13px;">(yalnizca onaylananlar)</small></div>

        <%-- OnDataBound markup'ta desteklenmez; olay Contact.aspx.cs Page_Load'da bağlanıyor --%>
        <asp:Repeater ID="rptYorumlar" runat="server" DataSourceID="SqlDataSource2">
            <ItemTemplate>
                <div class="yorum-card">
                    <div class="yorum-yazar"><%# Eval("yazan") %></div>
                    <p class="yorum-metin"><%# Eval("comment") %></p>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Label ID="lblYorumBos" runat="server" Visible="false"
            CssClass="yorum-bos d-block"
            Text="Henuz onaylanmis yorum bulunmuyor."></asp:Label>

        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
            ConnectionString="<%$ ConnectionStrings:Comment %>"
            SelectCommand="SELECT * FROM [comment] WHERE ([onay] = @onay) ORDER BY Id DESC">
            <SelectParameters>
                <asp:Parameter DefaultValue="True" Name="onay" Type="Boolean" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <!-- ILETISIM FORMU -->
    <div class="form-card mb-5">
        <h4>Bize Yazin</h4>

        <asp:Panel ID="divBasari" runat="server" Visible="false" CssClass="alert-success-custom">
            &#10003; Mesajiniz alindi, en kisa surede yanitlanacaktir.
        </asp:Panel>

        <asp:Label ID="lblHata" runat="server" ForeColor="Red" CssClass="d-block mb-2"></asp:Label>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Ad Soyad</label>
                <asp:TextBox ID="txtAd" runat="server" CssClass="form-control" placeholder="Adiniz Soyadiniz"></asp:TextBox>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">E-posta</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="ornek@mail.com"></asp:TextBox>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Konu</label>
            <asp:DropDownList ID="ddlKonu" runat="server" CssClass="form-control form-select">
                <asp:ListItem Value="">Konu Seciniz</asp:ListItem>
                <asp:ListItem>Genel Soru</asp:ListItem>
                <asp:ListItem>Sirket Kaydi</asp:ListItem>
                <asp:ListItem>Stok Sistemi</asp:ListItem>
                <asp:ListItem>Oneri ve Sikayet</asp:ListItem>
                <asp:ListItem>Diger</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="mb-3">
            <label class="form-label">Mesaj</label>
            <asp:TextBox ID="txtMesaj" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Mesajinizi buraya yazin..."></asp:TextBox>
        </div>

        <asp:Button ID="btnGonder" runat="server" Text="Gonder"
            CssClass="btn-gonder" OnClick="btnGonder_Click" />

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:question %>"
            InsertCommand="INSERT INTO [sorular] ([AdSoyad], [Eposta], [Konu], [Mesaj]) VALUES (@AdSoyad, @Eposta, @Konu, @Mesaj)"
            SelectCommand="SELECT * FROM [sorular]">
            <InsertParameters>
                <asp:ControlParameter ControlID="txtAd"    Name="AdSoyad" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtEmail" Name="Eposta"  PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="ddlKonu"  Name="Konu"    PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="txtMesaj" Name="Mesaj"   PropertyName="Text" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>

</div>
</asp:Content>
