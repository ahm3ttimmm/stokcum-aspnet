<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" 
         CodeBehind="memberpanel.aspx.cs" Inherits="WebApplication1.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
/* ===== MODAL OVERLAY ===== */
.modal-overlay {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.55);
    z-index: 9999;
    display: none;
    align-items: center;
    justify-content: center;
    overflow-y: auto;
    padding: 20px;
    box-sizing: border-box;
}
.modal-overlay.open {
    display: flex;
}
.modal-box {
    background: #fff;
    border-radius: 16px;
    padding: 32px;
    width: 100%;
    max-width: 560px;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    position: relative;
}
.modal-box legend {
    font-weight: 700;
    color: #84F8F9;
    font-size: 1.1rem;
    padding: 0 8px;
}
.modal-close-btn {
    position: absolute;
    top: 14px; right: 16px;
    background: none;
    border: none;
    font-size: 22px;
    color: #888;
    cursor: pointer;
    line-height: 1;
}
.modal-close-btn:hover { color: #333; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="member-header p-4 mb-4 rounded-4 shadow-sm"
         style="background:linear-gradient(135deg,#150E40 0%,#28467F 100%);color:white;">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div>
                <h3 class="fw-bold mb-1">👤 Üye Paneli</h3>
                <p class="mb-0" style="opacity:.8;">
                    Hoş geldiniz, <b><%= Session["ad"] ?? "Kullanıcı" %></b>
                    — Yetki: <span class="badge" style="background:rgba(255,255,255,.2);">
                        <%= Session["Yetki"] ?? "Ziyaretçi" %>
                    </span>
                </p>
            </div>
            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True"
                OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
                CssClass="form-select"
                style="max-width:220px;background:rgba(18,23,35,.6);color:#84F8F9;font-weight:600;border:1px solid rgba(132,248,249,.25);border-radius:12px;">
                <asp:ListItem Value="0">🏢 Şirketlerim</asp:ListItem>
                <asp:ListItem Value="1">📦 Stok Yönetimi</asp:ListItem>
                <asp:ListItem Value="2">💬 Yorum Yap</asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"></asp:ScriptManager>

    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

        <!-- ====================== VIEW 1 - ŞİRKETLER ====================== -->
        <asp:View ID="View1" runat="server">

            <button type="button" class="create"
                    onclick="openModal('modalSirket')">
                ➕ Yeni Şirket Oluştur
            </button>

            <br /><br />
            <asp:Label ID="lblSirketMesaj" runat="server" CssClass="d-block mb-2 fw-semibold"></asp:Label>

            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                DataKeyNames="id" DataSourceID="SqlDataSource1"
                Width="100%" CssClass="table table-striped table-hover"
                OnRowDeleted="GridView1_RowDeleted"
                EmptyDataText="Henüz kayıtlı şirketiniz bulunmuyor.">
                <Columns>
                    <asp:BoundField DataField="id"                HeaderText="#"            InsertVisible="False" ReadOnly="True" SortExpression="id" />
                    <asp:BoundField DataField="companiesname"     HeaderText="Şirket Adı"   SortExpression="companiesname" />
                    <asp:BoundField DataField="registrationdate"  HeaderText="Kayıt Tarihi" SortExpression="registrationdate" DataFormatString="{0:dd.MM.yyyy}" />
                    <asp:BoundField DataField="TaxNumber"         HeaderText="Vergi No"     SortExpression="TaxNumber" />
                    <asp:BoundField DataField="Type"              HeaderText="Tür"          SortExpression="Type" />
                    <asp:BoundField DataField="numberofemployees" HeaderText="Çalışan"      SortExpression="numberofemployees" />
                    <asp:TemplateField HeaderText="İşlem">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbSirketSil" runat="server"
                                CommandName="Delete"
                                OnClientClick="return confirm('Bu şirketi silmek istediğinizden emin misiniz?');"
                                CssClass="btn btn-outline-danger btn-sm">
                                🗑 Sil
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                ConnectionString="<%$ ConnectionStrings:Comp. %>"
                SelectCommand="SELECT [id],[companiesname],[registrationdate],[TaxNumber],[Type],[numberofemployees] FROM [companies] WHERE ([adminid]=@adminid) ORDER BY [registrationdate] DESC"
                DeleteCommand="DELETE FROM [companies] WHERE [id]=@id">
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="adminid" SessionField="id" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>

        </asp:View>

        <!-- ====================== VIEW 2 - STOKLAR ====================== -->
        <asp:View ID="View2" runat="server">

            <h3>Stok Yönetimi</h3>

            <div class="mb-3">
                <label class="form-label fw-bold">Şirket Seçiniz:</label>
                <asp:DropDownList ID="ddlSirketSec" runat="server" CssClass="form-control"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlSirketSec_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <button type="button" class="create"
                    onclick="openModal('modalStok')">
                ➕ Yeni Stok Ekle
            </button>

            <br /><br />

            <asp:GridView ID="GridViewStok" runat="server" AutoGenerateColumns="False"
                DataKeyNames="Id" Width="100%" CssClass="table table-striped"
                DataSourceID="SqlDataSourceStok"
                EmptyDataText="Bu şirkete ait kayıtlı stok bulunamadı.">
                <Columns>
                    <asp:BoundField DataField="Id"           HeaderText="#"            InsertVisible="False" ReadOnly="True" />
                    <asp:BoundField DataField="StokAdi"      HeaderText="Ürün Adı"     SortExpression="StokAdi" />
                    <asp:BoundField DataField="StokKodu"     HeaderText="SKU / Kod"    SortExpression="StokKodu" />
                    <asp:BoundField DataField="Miktar"       HeaderText="Miktar"       SortExpression="Miktar"      DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="Birim"        HeaderText="Birim"        SortExpression="Birim" />
                    <asp:BoundField DataField="AlisFiyati"   HeaderText="Alış ₺"       SortExpression="AlisFiyati"  DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="SatisFiyati"  HeaderText="Satış ₺"      SortExpression="SatisFiyati" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="KayitTarihi"  HeaderText="Kayıt Tarihi" SortExpression="KayitTarihi" DataFormatString="{0:dd.MM.yyyy}" />
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSourceStok" runat="server"
                ConnectionString="<%$ ConnectionStrings:Stok %>"
                SelectCommand="SELECT * FROM [Stoklar] WHERE [SirketID]=@SirketID ORDER BY [KayitTarihi] DESC">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlSirketSec" Name="SirketID"
                        PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>

        </asp:View>

        <!-- ====================== VIEW 3 - YORUM ====================== -->
        <asp:View ID="View3" runat="server">
            <h4 class="section-title">💬 Yorum ve Değerlendirme</h4>
            <p class="text-muted">Stokcum.com hakkındaki deneyimlerinizi paylaşın. Yorumunuz admin onayından sonra yayımlanacaktır.</p>
            <div class="mb-3">
                <label class="form-label">Yorumunuz:</label>
                <asp:TextBox ID="txtYorum" runat="server" CssClass="form-control"
                    TextMode="MultiLine" Rows="6"></asp:TextBox>
            </div>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server"
                ConnectionString="<%$ ConnectionStrings:Comment %>"
                InsertCommand="INSERT INTO [comment] ([comment],[yazan]) VALUES (@comment,@yazan)"
                SelectCommand="SELECT * FROM [comment]">
                <InsertParameters>
                    <asp:ControlParameter ControlID="txtYorum" Name="comment" PropertyName="Text" Type="String" />
                    <asp:SessionParameter Name="yazan" SessionField="mail" Type="String" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:Button ID="btnYorumGonder" runat="server"
                Text="Yorum Gönder" CssClass="btn-login" OnClick="btnYorumGonder_Click" />
        </asp:View>

    </asp:MultiView>

    <!-- ====================== MODAL: YENİ ŞİRKET ====================== -->
    <div id="modalSirket" class="modal-overlay">
        <asp:Panel ID="pnlSirketForm" runat="server" CssClass="modal-box">
            <button type="button" class="modal-close-btn" onclick="closeModal('modalSirket')">✕</button>
            <fieldset style="border:none;padding:0;">
                <legend>🏢 Yeni Şirket Bilgileri</legend>
                <hr class="mb-3" />

                <div class="mb-3">
                    <label class="form-label fw-bold" style="color:#84F8F9;">Kayıt Tarihi:</label>
                    <asp:UpdatePanel ID="upCalendar" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Calendar ID="Calendar1" runat="server"
                                OnSelectionChanged="Calendar1_SelectionChanged"
                                BackColor="White" BorderColor="White" BorderWidth="1px"
                                Font-Names="Verdana" Font-Size="9pt" ForeColor="Black"
                                Height="190px" NextPrevFormat="FullMonth" Width="100%">
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
                        <asp:ListItem Value="Sahis">Şahıs Şirketi</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtCalisanSayisi" runat="server" CssClass="form-control"
                        placeholder="Çalışan Sayısı" TextMode="Number"></asp:TextBox>
                </div>

                <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                    ConnectionString="<%$ ConnectionStrings:Comp. %>"
                    InsertCommand="INSERT INTO [companies] ([companiesname],[adminid],[registrationdate],[TaxNumber],[Type],[numberofemployees]) VALUES (@companiesname,@adminid,@registrationdate,@TaxNumber,@Type,@numberofemployees)"
                    SelectCommand="SELECT * FROM [companies]">
                    <InsertParameters>
                        <asp:ControlParameter ControlID="txtSirketAdi"     Name="companiesname"     PropertyName="Text"          Type="String" />
                        <asp:SessionParameter  SessionField="id"            Name="adminid"                                        Type="String" />
                        <asp:ControlParameter ControlID="Calendar1"         Name="registrationdate"  PropertyName="SelectedDate"  DbType="Date" />
                        <asp:ControlParameter ControlID="txtVergiNo"        Name="TaxNumber"         PropertyName="Text"          Type="String" />
                        <asp:ControlParameter ControlID="ddlSirketTuru"     Name="Type"              PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="txtCalisanSayisi"  Name="numberofemployees" PropertyName="Text"          Type="String" />
                    </InsertParameters>
                </asp:SqlDataSource>

                <asp:Button ID="btnSirketKaydet" runat="server"
                    Text="Şirketi Kaydet" CssClass="btn-login w-100 mt-2"
                    OnClick="btnSirketKaydet_Click" Height="50px" />
            </fieldset>
        </asp:Panel>
    </div>

    <!-- ====================== MODAL: YENİ STOK ====================== -->
    <div id="modalStok" class="modal-overlay">
        <div class="modal-box">
            <button type="button" class="modal-close-btn" onclick="closeModal('modalStok')">✕</button>
            <fieldset style="border:none;padding:0;">
                <legend>📦 Yeni Stok / Ürün Bilgileri</legend>
                <hr class="mb-3" />

                <div class="mb-3">
                    <label class="form-label fw-bold">Şirket</label>
                    <asp:DropDownList ID="ddlStokSirket" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtStokAdi" runat="server" CssClass="form-control" placeholder="Stok / Ürün Adı"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:TextBox ID="txtStokKodu" runat="server" CssClass="form-control" placeholder="Stok Kodu (SKU)"></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-6 mb-3">
                        <asp:TextBox ID="txtMiktar" runat="server" CssClass="form-control"
                            TextMode="Number" placeholder="Miktar" step="0.001"></asp:TextBox>
                    </div>
                    <div class="col-6 mb-3">
                        <asp:DropDownList ID="ddlBirim" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Birim Seçiniz</asp:ListItem>
                            <asp:ListItem Value="Adet">Adet</asp:ListItem>
                            <asp:ListItem Value="Kg">Kg</asp:ListItem>
                            <asp:ListItem Value="Lt">Lt</asp:ListItem>
                            <asp:ListItem Value="Koli">Koli</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6 mb-3">
                        <asp:TextBox ID="txtAlisFiyati" runat="server" CssClass="form-control"
                            TextMode="Number" placeholder="Alış Fiyatı" step="0.01"></asp:TextBox>
                    </div>
                    <div class="col-6 mb-3">
                        <asp:TextBox ID="txtSatisFiyati" runat="server" CssClass="form-control"
                            TextMode="Number" placeholder="Satış Fiyatı" step="0.01"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control"
                        TextMode="MultiLine" Rows="3" placeholder="Açıklama"></asp:TextBox>
                </div>

                <asp:Button ID="btnStokKaydet" runat="server"
                    Text="Stoku Kaydet" CssClass="btn-login w-100 mt-2" Height="50px"
                    OnClick="btnStokKaydet_Click" />
            </fieldset>
        </div>
    </div>

    <script type="text/javascript">
        function openModal(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
        function closeModal(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'none';
            document.body.style.overflow = '';
        }
        // Overlay'e tıklanınca kapat (modal-box dışı)
        document.addEventListener('click', function (e) {
            if (e.target && e.target.classList.contains('modal-overlay')) {
                e.target.style.display = 'none';
                document.body.style.overflow = '';
            }
        });
    </script>

</asp:Content>
