<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" 
         CodeBehind="memberpanel.aspx.cs" Inherits="WebApplication1.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div>
        <h4>Yetkiniz: <b><%= Session["Yetki"] ?? "Ziyaretçi" %></b></h4>
        
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True"
            OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" 
            CssClass="form-select" style="max-width:300px;">
            <asp:ListItem Value="0">Şirketler</asp:ListItem>
            <asp:ListItem Value="1">Stoklar</asp:ListItem>
            <asp:ListItem Value="2">Yorum Yap</asp:ListItem>
        </asp:DropDownList>
    </div>

    <!-- ScriptManager -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"></asp:ScriptManager>

    <br />

    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        
        <!-- ====================== VIEW 1 - ŞİRKETLER ====================== -->
        <asp:View ID="View1" runat="server">
            
            <!-- Şirket Oluştur Butonu -->
            <button type="button" class="create" 
                    onclick="document.getElementById('<%= pnlSirketForm.ClientID %>').style.display='block';">
                ➕ Yeni Şirket Oluştur
            </button>

            <br /><br />

            <!-- Şirket Form Paneli -->
            <asp:Panel ID="pnlSirketForm" runat="server" Style="display: none;">
                <fieldset class="sirket-groupbox">
                    <legend>Yeni Şirket Bilgileri</legend>
                    <div class="groupbox-content">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="color:#3e2723;">Şirket ID:</label>
                            <input type="text" class="form-control" placeholder="Otomatik Atanacak" disabled="disabled" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="color:#3e2723;">Kayıt Tarihi:</label>
                            <asp:UpdatePanel ID="upCalendar" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Calendar ID="Calendar1" runat="server"
                                        OnSelectionChanged="Calendar1_SelectionChanged"
                                        BackColor="White" BorderColor="White" BorderWidth="1px"
                                        Font-Names="Verdana" Font-Size="9pt" ForeColor="Black"
                                        Height="190px" NextPrevFormat="FullMonth" Width="350px">
                                        <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
                                        <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" VerticalAlign="Bottom" />
                                        <OtherMonthDayStyle ForeColor="#999999" />
                                        <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                                        <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px" 
                                                    Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
                                        <TodayDayStyle BackColor="#CCCCCC" />
                                    </asp:Calendar>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>

                        <div class="mb-3">
                            <asp:TextBox ID="txtSirketAdi" runat="server" CssClass="form-control" placeholder="Şirket Adı"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <asp:TextBox ID="txtVergiNo" runat="server" CssClass="form-control" placeholder="Vergi Numarası"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <asp:DropDownList ID="ddlSirketTuru" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Şirket Türü Seçiniz</asp:ListItem>
                                <asp:ListItem Value="Limited">Limited Şirket (Ltd. Şti.)</asp:ListItem>
                                <asp:ListItem Value="Anonim">Anonim Şirket (A.Ş.)</asp:ListItem>
                                <asp:ListItem Value="Şahıs">Şahıs Şirketi</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <asp:TextBox ID="txtCalisanSayisi" runat="server" CssClass="form-control" 
                                placeholder="Çalışan Sayısı" TextMode="Number"></asp:TextBox>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:Comp. %>" DeleteCommand="DELETE FROM [companies] WHERE [id] = @id" InsertCommand="INSERT INTO [companies] ([companiesname], [adminid], [registrationdate], [TaxNumber], [Type], [numberofemployees]) VALUES (@companiesname, @adminid, @registrationdate, @TaxNumber, @Type, @numberofemployees)" SelectCommand="SELECT * FROM [companies]" UpdateCommand="UPDATE [companies] SET [companiesname] = @companiesname, [adminid] = @adminid, [registrationdate] = @registrationdate, [TaxNumber] = @TaxNumber, [Type] = @Type, [numberofemployees] = @numberofemployees WHERE [id] = @id">
                            <DeleteParameters>
                                <asp:Parameter Name="id" Type="Int32" />
                            </DeleteParameters>
                            <InsertParameters>
                                <asp:ControlParameter ControlID="txtSirketAdi" Name="companiesname" PropertyName="Text" Type="String" />
                                <asp:SessionParameter Name="adminid" SessionField="id" Type="String" />
                                <asp:ControlParameter ControlID="Calendar1" DbType="Date" Name="registrationdate" PropertyName="SelectedDate" />
                                <asp:ControlParameter ControlID="txtVergiNo" Name="TaxNumber" PropertyName="Text" Type="String" />
                                <asp:ControlParameter ControlID="ddlSirketTuru" Name="Type" PropertyName="SelectedValue" Type="String" />
                                <asp:ControlParameter ControlID="txtCalisanSayisi" Name="numberofemployees" PropertyName="Text" Type="String" />
                            </InsertParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="companiesname" Type="String" />
                                <asp:Parameter Name="adminid" Type="String" />
                                <asp:Parameter DbType="Date" Name="registrationdate" />
                                <asp:Parameter Name="TaxNumber" Type="String" />
                                <asp:Parameter Name="Type" Type="String" />
                                <asp:Parameter Name="numberofemployees" Type="String" />
                                <asp:Parameter Name="id" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                        <asp:Button ID="btnSirketKaydet" runat="server"
                            Text="Şirketi Veritabanına Kaydet"
                            CssClass="btn-login"
                            OnClick="btnSirketKaydet_Click"
                            Height="60px" />

                        <button type="button" class="btn btn-secondary" 
                                onclick="document.getElementById('<%= pnlSirketForm.ClientID %>').style.display='none';"
                                style="margin-top:10px; width:100%;">
                            Kapat
                        </button>

                    </div>
                </fieldset>
            </asp:Panel>

            <!-- Şirketler GridView -->
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                DataKeyNames="id" DataSourceID="SqlDataSource1" Width="100%" CssClass="table">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                    <asp:BoundField DataField="companiesname" HeaderText="companiesname" SortExpression="companiesname" />
                    <asp:BoundField DataField="registrationdate" HeaderText="registrationdate" SortExpression="registrationdate" />
                    <asp:BoundField DataField="TaxNumber" HeaderText="TaxNumber" SortExpression="TaxNumber" />
                    <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                    <asp:BoundField DataField="numberofemployees" HeaderText="numberofemployees" SortExpression="numberofemployees" />
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                ConnectionString="<%$ ConnectionStrings:Comp. %>"
                SelectCommand="SELECT [id], [companiesname], [registrationdate], [TaxNumber], [Type], [numberofemployees] FROM [companies] WHERE ([adminid] = @adminid) ORDER BY [registrationdate]" DeleteCommand="DELETE FROM [companies] WHERE [id] = @id" InsertCommand="INSERT INTO [companies] ([companiesname], [registrationdate], [TaxNumber], [Type], [numberofemployees]) VALUES (@companiesname, @registrationdate, @TaxNumber, @Type, @numberofemployees)" UpdateCommand="UPDATE [companies] SET [companiesname] = @companiesname, [registrationdate] = @registrationdate, [TaxNumber] = @TaxNumber, [Type] = @Type, [numberofemployees] = @numberofemployees WHERE [id] = @id">
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="companiesname" Type="String" />
                    <asp:Parameter DbType="Date" Name="registrationdate" />
                    <asp:Parameter Name="TaxNumber" Type="String" />
                    <asp:Parameter Name="Type" Type="String" />
                    <asp:Parameter Name="numberofemployees" Type="String" />
                </InsertParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="adminid" SessionField="id" Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="companiesname" Type="String" />
                    <asp:Parameter DbType="Date" Name="registrationdate" />
                    <asp:Parameter Name="TaxNumber" Type="String" />
                    <asp:Parameter Name="Type" Type="String" />
                    <asp:Parameter Name="numberofemployees" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </asp:View>

<!-- ====================== VIEW 2 - STOKLAR ====================== -->
<asp:View ID="View2" runat="server">
    
    <h3>Stok Yönetimi</h3>

    <!-- Şirket Seçimi -->
    <div class="mb-3">
        <label class="form-label fw-bold">Şirket Seçiniz:</label>
        <asp:DropDownList ID="ddlSirketSec" runat="server" CssClass="form-control" 
            AutoPostBack="true" OnSelectedIndexChanged="ddlSirketSec_SelectedIndexChanged">
        </asp:DropDownList>
    </div>

    <!-- Yeni Stok Ekle Butonu -->
    <button type="button" class="create" 
            onclick="document.getElementById('<%= pnlStokForm.ClientID %>').style.display='block';">
        ➕ Yeni Stok Ekle
    </button>

    <br /><br />

    <!-- ================== STOK EKLEME FORMU ================== -->
    <asp:Panel ID="pnlStokForm" runat="server" Style="display: none;">
        <fieldset class="sirket-groupbox">
            <legend>Yeni Stok / Ürün Bilgileri</legend>
            <div class="groupbox-content">
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Şirket *</label>
                    <asp:DropDownList ID="ddlStokSirket" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>

                <!-- Diğer form alanları aynı kalıyor... -->
                <div class="mb-3">
                    <asp:TextBox ID="txtStokAdi" runat="server" CssClass="form-control" 
                        placeholder="Stok / Ürün Adı"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtStokKodu" runat="server" CssClass="form-control" 
                        placeholder="Stok Kodu (SKU)"></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <asp:TextBox ID="txtMiktar" runat="server" CssClass="form-control" 
                            TextMode="Number" placeholder="Miktar" step="0.001"></asp:TextBox>
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:DropDownList ID="ddlBirim" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Birim Seçiniz</asp:ListItem>
                            <asp:ListItem Value="Adet">Adet</asp:ListItem>
                            <asp:ListItem Value="Kg">Kg</asp:ListItem>
                            <asp:ListItem Value="Lt">Lt</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:TextBox ID="txtMinStokSeviyesi" runat="server" CssClass="form-control" 
                            TextMode="Number" placeholder="Min. Stok"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:TextBox ID="txtAlisFiyati" runat="server" CssClass="form-control" 
                            TextMode="Number" placeholder="Alış Fiyatı" step="0.01"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:TextBox ID="txtSatisFiyati" runat="server" CssClass="form-control" 
                            TextMode="Number" placeholder="Satış Fiyatı" step="0.01"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtKategori" runat="server" CssClass="form-control" placeholder="Kategori"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control" 
                        TextMode="MultiLine" Rows="3" placeholder="Açıklama"></asp:TextBox>
                </div>

                <asp:Button ID="btnStokKaydet" runat="server" 
                    Text="Stoku Kaydet" 
                    CssClass="btn-login" Height="60px"
                    OnClick="btnStokKaydet_Click" />

                <button type="button" class="btn btn-secondary" 
                        onclick="document.getElementById('<%= pnlStokForm.ClientID %>').style.display='none';"
                        style="margin-top:10px; width:100%;">
                    Kapat<asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:Stok %>" DeleteCommand="DELETE FROM [Stoklar] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Stoklar] ([SirketID], [StokAdi], [StokKodu], [Miktar], [Birim], [AlisFiyati], [SatisFiyati], [Aciklama], [KayitTarihi]) VALUES (@SirketID, @StokAdi, @StokKodu, @Miktar, @Birim, @AlisFiyati, @SatisFiyati, @Aciklama, @KayitTarihi)" SelectCommand="SELECT * FROM [Stoklar]" UpdateCommand="UPDATE [Stoklar] SET [SirketID] = @SirketID, [StokAdi] = @StokAdi, [StokKodu] = @StokKodu, [Miktar] = @Miktar, [Birim] = @Birim, [AlisFiyati] = @AlisFiyati, [SatisFiyati] = @SatisFiyati, [Aciklama] = @Aciklama, [KayitTarihi] = @KayitTarihi WHERE [Id] = @Id">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:ControlParameter ControlID="ddlSirketSec" Name="SirketID" PropertyName="SelectedValue" Type="Int32" />
                            <asp:ControlParameter ControlID="txtStokAdi" Name="StokAdi" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="txtStokKodu" Name="StokKodu" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="txtMiktar" Name="Miktar" PropertyName="Text" Type="Decimal" />
                            <asp:ControlParameter ControlID="txtKategori" Name="Birim" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="txtAlisFiyati" Name="AlisFiyati" PropertyName="Text" Type="Decimal" />
                            <asp:ControlParameter ControlID="txtSatisFiyati" Name="SatisFiyati" PropertyName="Text" Type="Decimal" />
                            <asp:ControlParameter ControlID="txtAciklama" Name="Aciklama" PropertyName="Text" Type="String" />
                            <asp:Parameter Name="KayitTarihi" Type="DateTime" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="SirketID" Type="Int32" />
                            <asp:Parameter Name="StokAdi" Type="String" />
                            <asp:Parameter Name="StokKodu" Type="String" />
                            <asp:Parameter Name="Miktar" Type="Decimal" />
                            <asp:Parameter Name="Birim" Type="String" />
                            <asp:Parameter Name="AlisFiyati" Type="Decimal" />
                            <asp:Parameter Name="SatisFiyati" Type="Decimal" />
                            <asp:Parameter Name="Aciklama" Type="String" />
                            <asp:Parameter Name="KayitTarihi" Type="DateTime" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </button>

            </div>
        </fieldset>
    </asp:Panel>

    <br />

    <!-- Stok GridView -->
    <asp:GridView ID="GridViewStok" runat="server" AutoGenerateColumns="False"
        DataKeyNames="Id" Width="100%" CssClass="table table-striped" DataSourceID="SqlDataSourceStok">
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
            <asp:BoundField DataField="SirketID" HeaderText="SirketID" SortExpression="SirketID" />
            <asp:BoundField DataField="StokAdi" HeaderText="StokAdi" SortExpression="StokAdi" />
            <asp:BoundField DataField="StokKodu" HeaderText="StokKodu" SortExpression="StokKodu" />
            <asp:BoundField DataField="Miktar" HeaderText="Miktar" SortExpression="Miktar" />
            <asp:BoundField DataField="Birim" HeaderText="Birim" SortExpression="Birim" />
            <asp:BoundField DataField="AlisFiyati" HeaderText="AlisFiyati" SortExpression="AlisFiyati" />
            <asp:BoundField DataField="SatisFiyati" HeaderText="SatisFiyati" SortExpression="SatisFiyati" />
            <asp:BoundField DataField="Aciklama" HeaderText="Aciklama" SortExpression="Aciklama" />
            <asp:BoundField DataField="KayitTarihi" HeaderText="KayitTarihi" SortExpression="KayitTarihi" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSourceStok" runat="server"
        ConnectionString="<%$ ConnectionStrings:Stok %>"
        SelectCommand="SELECT * FROM [Stoklar]">
    </asp:SqlDataSource>

</asp:View>
        <!-- ====================== VIEW 3 - YORUM YAP ====================== -->
        <asp:View ID="View3" runat="server">
            <h3>Yorum ve Değerlendirme</h3>
            <p>Şirketler veya ürünler hakkında yorum yapabilirsiniz.</p>
            
            <div class="mb-3">
                <label class="form-label">Yorumunuz:</label>
                <asp:TextBox ID="txtYorum" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"></asp:TextBox>
            </div>
            
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:Comment %>" DeleteCommand="DELETE FROM [comment] WHERE [Id] = @Id" InsertCommand="INSERT INTO [comment] ([comment], [yazan]) VALUES (@comment, @yazan)" SelectCommand="SELECT * FROM [comment]" UpdateCommand="UPDATE [comment] SET [comment] = @comment, [yazan] = @yazan, [onay] = @onay WHERE [Id] = @Id">
                <DeleteParameters>
                    <asp:Parameter Name="Id" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="txtYorum" Name="comment" PropertyName="Text" Type="String" />
                    <asp:SessionParameter Name="yazan" SessionField="mail" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="comment" Type="String" />
                    <asp:Parameter Name="yazan" Type="String" />
                    <asp:Parameter Name="onay" Type="Boolean" />
                    <asp:Parameter Name="Id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            
            <asp:Button ID="btnYorumGonder" runat="server" Text="Yorum Gönder" CssClass="btn-login" OnClick="btnYorumGonder_Click" />
        </asp:View>

    </asp:MultiView>

</asp:Content>