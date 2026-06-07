<%@ Page Title="Admin Yönetimi" Language="C#" MasterPageFile="~/Site1.Master"
         AutoEventWireup="true" CodeBehind="Yonetim.aspx.cs" Inherits="WebApplication1.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="css/StyleSheet1.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">

        <!-- Başlık -->
        <div class="admin-header">
            <h3><i class="fas fa-user-shield"></i> Admin Yönetim Paneli</h3>
            <asp:Label ID="Label1" runat="server" CssClass="text-light" Text=""></asp:Label>
        </div>

        <!-- Menü -->
        <div class="admin-menu text-center mb-4">
            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True"
                OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
                CssClass="form-select admin-dropdown">
                <asp:ListItem Value="0">Üyeleri Listele &amp; Düzenle</asp:ListItem>
                <asp:ListItem Value="1">Soruları Yanıtla</asp:ListItem>
                <asp:ListItem Value="2">Yorumları Yönet &amp; Yayımla</asp:ListItem>
                <asp:ListItem Value="3">Şirketleri Yönet</asp:ListItem>
                <asp:ListItem Value="4">Sistem Ayarları (Mail vb.)</asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

            <!-- ====================== VIEW 1 - ÜYELER ====================== -->
            <asp:View ID="View1" runat="server">
                <h4 class="section-title">Üyeler Listesi</h4>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="uyeno" DataSourceID="SqlDataSource1"
                    CssClass="admin-grid table table-striped table-hover" PageSize="15"
                    OnRowUpdating="GridView1_RowUpdating">
                    <Columns>
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ShowSelectButton="True" />
                        <asp:BoundField DataField="uyeno"     HeaderText="#"       InsertVisible="False" ReadOnly="True" SortExpression="uyeno" />
                        <asp:BoundField DataField="name"      HeaderText="Ad Soyad"  SortExpression="name" />
                        <asp:BoundField DataField="authority" HeaderText="Yetki"    SortExpression="authority" />
                        <asp:TemplateField HeaderText="Şifre">
                            <ItemTemplate>********</ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                    CssClass="form-control" Width="200px"></asp:TextBox>
                                <small style="color:#888;">Boş bırakırsanız şifre değişmez.</small>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="email" HeaderText="E-posta" SortExpression="email" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConflictDetection="OverwriteChanges"
                    ConnectionString="<%$ ConnectionStrings:Userlist %>"
                    DeleteCommand="DELETE FROM [Users] WHERE [uyeno]=@uyeno"
                    InsertCommand="INSERT INTO [Users] ([name],[authority],[password],[email]) VALUES (@name,@authority,@password,@email)"
                    SelectCommand="SELECT * FROM [Users]"
                    UpdateCommand="UPDATE [Users] SET [name]=@name,[authority]=@authority,[password]=@password,[email]=@email WHERE [uyeno]=@uyeno">
                    <DeleteParameters><asp:Parameter Name="uyeno" Type="Int32" /></DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="name"      Type="String" />
                        <asp:Parameter Name="authority" Type="String" />
                        <asp:Parameter Name="password"  Type="String" />
                        <asp:Parameter Name="email"     Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="name"      Type="String" />
                        <asp:Parameter Name="authority" Type="String" />
                        <asp:Parameter Name="password"  Type="String" />
                        <asp:Parameter Name="email"     Type="String" />
                        <asp:Parameter Name="uyeno"     Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </asp:View>

            <!-- ====================== VIEW 2 - SORULAR ====================== -->
            <asp:View ID="View2" runat="server">
                <h4 class="section-title">Soru Yanıtlama Sistemi</h4>
                <asp:GridView ID="gvMesajlar" runat="server"
                    CssClass="admin-grid table table-striped table-hover"
                    AutoGenerateColumns="False" AllowSorting="True" DataKeyNames="Id"
                    DataSourceID="SqlDataSourceMesaj" OnRowCommand="gvMesajlar_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id"          HeaderText="ID"       ReadOnly="True" />
                        <asp:BoundField DataField="AdSoyad"     HeaderText="Ad Soyad" />
                        <asp:BoundField DataField="Eposta"      HeaderText="E-posta" />
                        <asp:BoundField DataField="Konu"        HeaderText="Konu" />
                        <asp:BoundField DataField="Mesaj"       HeaderText="Mesaj"    ItemStyle-Width="400px" />
                        <asp:BoundField DataField="KayitTarihi" HeaderText="Tarih"
                            DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                        <asp:TemplateField HeaderText="İşlemler">
                            <ItemTemplate>
                                <asp:Button ID="btnYanitla" runat="server" CommandName="Yanitla"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text="📧 Yanıtla" CssClass="btn btn-success btn-sm" />
                                <asp:Button ID="btnSil" runat="server" CommandName="Sil"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text="🗑 Sil" CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Bu mesajı silmek istediğinizden emin misiniz?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceMesaj" runat="server"
                    ConnectionString="<%$ ConnectionStrings:Userlist %>"
                    SelectCommand="SELECT Id,AdSoyad,Eposta,Konu,Mesaj,KayitTarihi FROM sorular ORDER BY KayitTarihi DESC">
                </asp:SqlDataSource>

                <!-- Yanıt Modalı -->
                <asp:Panel ID="pnlYanit" runat="server" Visible="false"
                    style="position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);
                           background:white;padding:25px;border:3px solid #007bff;
                           border-radius:10px;z-index:9999;box-shadow:0 0 25px rgba(0,0,0,.6);
                           max-width:650px;width:90%;">
                    <h4 style="margin-top:0;">📧 Mesaja Yanıt Ver</h4>
                    <asp:Label ID="lblMesajId"  runat="server" Visible="false"></asp:Label>
                    <p><strong><asp:Label ID="lblAdSoyad" runat="server"></asp:Label></strong></p>
                    <p><strong><asp:Label ID="lblKonu"    runat="server"></asp:Label></strong></p>
                    <b>Orijinal Mesaj:</b><br />
                    <asp:Label ID="lblMesaj" runat="server"
                        style="background:#f8f9fa;padding:12px;display:block;
                               margin:10px 0;border-left:4px solid #007bff;"></asp:Label>
                    <b>Cevabınız:</b><br />
                    <asp:TextBox ID="txtCevap" runat="server" TextMode="MultiLine"
                        Rows="8" Width="100%" CssClass="form-control"></asp:TextBox>
                    <br /><br />
                    <asp:Button ID="btnGonder" runat="server" Text="✅ Cevabı Gönder"
                        CssClass="btn btn-primary" OnClick="btnGonder_Click" />
                    <asp:Button ID="btnKapat"  runat="server" Text="❌ Kapat"
                        CssClass="btn btn-secondary" OnClick="btnKapat_Click" />
                </asp:Panel>
            </asp:View>

            <!-- ====================== VIEW 3 - YORUMLAR ====================== -->
            <asp:View ID="View3" runat="server">
                <h4 class="section-title">Yorumları Yönet &amp; Yayımla</h4>
                <asp:GridView ID="gvYorumlar" runat="server"
                    CssClass="admin-grid table table-striped table-hover"
                    AutoGenerateColumns="False" DataKeyNames="Id"
                    OnRowCommand="gvYorumlar_RowCommand"
                    AllowSorting="True" DataSourceID="SqlDataSource2">
                    <Columns>
                        <asp:BoundField DataField="Id"      HeaderText="ID"    ReadOnly="True" />
                        <asp:BoundField DataField="comment" HeaderText="Yorum" ItemStyle-Width="500px" />
                        <asp:BoundField DataField="yazan"   HeaderText="Yazan" />
                        <asp:CheckBoxField DataField="onay" HeaderText="Onay" />
                        <asp:TemplateField HeaderText="İşlemler">
                            <ItemTemplate>
                                <asp:Button ID="btnOnayla" runat="server" CommandName="Onayla"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text="✅ Onayla" CssClass="btn btn-success btn-sm" />
                                <asp:Button ID="btnReddet" runat="server" CommandName="Reddet"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text="❌ Reddet" CssClass="btn btn-danger btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                    ConnectionString="<%$ ConnectionStrings:Comment %>"
                    SelectCommand="SELECT * FROM [comment]">
                </asp:SqlDataSource>
            </asp:View>

            <!-- ====================== VIEW 4 - ŞİRKETLER ====================== -->
            <asp:View ID="View4" runat="server">
                <div class="d-flex align-items-center justify-content-between flex-wrap mb-3">
                    <h4 class="section-title mb-0">🏢 Şirket Yönetimi</h4>
                    <asp:Label ID="lblSirketSayisi" runat="server"
                        CssClass="badge rounded-pill px-3 py-2 fs-6"
                        style="background:#28467F;color:#84F8F9;border:1px solid rgba(132,248,249,.25);"></asp:Label>
                </div>

                <asp:GridView ID="gvSirketler" runat="server"
                    CssClass="admin-grid table table-striped table-hover"
                    AutoGenerateColumns="False" DataKeyNames="id"
                    DataSourceID="SqlDataSource3"
                    OnDataBound="gvSirketler_DataBound">
                    <Columns>
                        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True"
                            DeleteText="🗑" EditText="✏️"
                            ButtonType="Button" />
                        <asp:BoundField DataField="id"                 HeaderText="#"            InsertVisible="False" ReadOnly="True" SortExpression="id" />
                        <asp:BoundField DataField="companiesname"      HeaderText="Şirket Adı"   SortExpression="companiesname" />
                        <asp:BoundField DataField="sahipAdi"           HeaderText="Sahip Üye"    ReadOnly="True"       SortExpression="sahipAdi" />
                        <asp:BoundField DataField="registrationdate"   HeaderText="Kayıt Tarihi" SortExpression="registrationdate" DataFormatString="{0:dd.MM.yyyy}" />
                        <asp:BoundField DataField="TaxNumber"          HeaderText="Vergi No"     SortExpression="TaxNumber" />
                        <asp:BoundField DataField="Type"               HeaderText="Tür"          SortExpression="Type" />
                        <asp:BoundField DataField="numberofemployees"  HeaderText="Çalışan"      SortExpression="numberofemployees" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-4 text-muted">Kayıtlı şirket bulunamadı.</div>
                    </EmptyDataTemplate>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                    ConflictDetection="OverwriteChanges"
                    ConnectionString="<%$ ConnectionStrings:Comp. %>"
                    DeleteCommand="DELETE FROM [companies] WHERE [id]=@id"
                    SelectCommand="SELECT c.id,
                                          c.companiesname,
                                          c.adminid,
                                          ISNULL(u.name, 'Bilinmiyor') AS sahipAdi,
                                          c.registrationdate,
                                          c.TaxNumber,
                                          c.Type,
                                          c.numberofemployees
                                   FROM   companies c
                                   LEFT JOIN Users u ON c.adminid = u.uyeno
                                   ORDER BY c.registrationdate DESC"
                    UpdateCommand="UPDATE [companies] SET [companiesname]=@companiesname,[adminid]=@adminid,[registrationdate]=@registrationdate,[TaxNumber]=@TaxNumber,[Type]=@Type,[numberofemployees]=@numberofemployees WHERE [id]=@id">
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="companiesname"    Type="String" />
                        <asp:Parameter Name="adminid"          Type="Int32" />
                        <asp:Parameter Name="registrationdate" Type="DateTime" />
                        <asp:Parameter Name="TaxNumber"        Type="String" />
                        <asp:Parameter Name="Type"             Type="String" />
                        <asp:Parameter Name="numberofemployees" Type="Int32" />
                        <asp:Parameter Name="id"               Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </asp:View>

            <!-- ====================== VIEW 5 - SİSTEM AYARLARI ====================== -->
            <asp:View ID="View5" runat="server">
                <h4 class="section-title">Sistem Ayarları - SMTP Mail</h4>
                <div class="card p-4">
                    <div class="row">
                        <div class="col-md-6">
                            <label>SMTP Host</label>
                            <asp:TextBox ID="txtSmtpHost" runat="server" CssClass="form-control"
                                Text="smtp.gmail.com"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label>SMTP Port</label>
                            <asp:TextBox ID="txtSmtpPort" runat="server" CssClass="form-control"
                                Text="587"></asp:TextBox>
                        </div>
                    </div>
                    <label class="mt-3">Gönderen E-posta Adresi</label>
                    <asp:TextBox ID="txtFromEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    <label class="mt-3">Şifre</label>
                    <asp:TextBox ID="txtSmtpPassword" runat="server" TextMode="Password"
                        CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:Button ID="btnAyarlariKaydet" runat="server"
                        Text="💾 Ayarları Kaydet"
                        CssClass="btn btn-success" OnClick="btnAyarlariKaydet_Click" />
                    <asp:Label ID="lblAyarMesaj" runat="server"
                        CssClass="mt-3" ForeColor="Green"></asp:Label>
                </div>
            </asp:View>

        </asp:MultiView>
    </div>
</asp:Content>
