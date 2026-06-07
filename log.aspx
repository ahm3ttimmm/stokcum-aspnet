<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="log.aspx.cs" Inherits="WebApplication1.log" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View ID="View2" runat="server">
        <div class="login-container">
            <div class="card login-card shadow p-4">
                
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold">Lütfen Giriş Yapın</h1>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="E-posta Adresi"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" TextMode="Password" placeholder="Şifre"></asp:TextBox>
                </div>

                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:login-register %>" DataSourceMode="DataReader" SelectCommand="SELECT [uyeno], [name], [password], [email], [authority] FROM [Users] WHERE (([email] = @email) AND ([password] = @password))">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtEmail" Name="email" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="txtSifre" Name="password" PropertyName="Text" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" CssClass="btn btn-login w-100 py-2 mt-2" OnClick="btnGiris_Click" />
                <asp:Button ID="btnKayit" runat="server" Text="Kayıt Ol" CssClass="btn btn-login w-100 py-2 mt-2" OnClick="btnKayit_Click" />

                <p class="mt-5 mb-0 text-center fw-medium" style="font-size: 14px; opacity: 0.8;">&copy; 2026 Stokcum.com</p>
            </div>
        </div>
    </asp:View>
    <asp:View ID="View1" runat="server">
        <div class="login-container">
            <div class="card login-card shadow p-4">
                
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold">Kayıt Ol</h1>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control" placeholder="Ad Soyad"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtKayitEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="E-posta Adresi"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtKayitSifre" runat="server" CssClass="form-control" TextMode="Password" placeholder="Şifre"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtKayitSifreTekrar" runat="server" CssClass="form-control" TextMode="Password" placeholder="Şifre Tekrar"></asp:TextBox>
                </div>

                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtKayitSifre" ControlToValidate="txtKayitSifreTekrar" Display="Dynamic" ErrorMessage="ŞİFRELER UYUŞMAMAKTADIR!"></asp:CompareValidator>

                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:register %>" DeleteCommand="DELETE FROM [Users] WHERE [uyeno] = @uyeno" InsertCommand="INSERT INTO [Users] ([name], [authority], [password], [email]) VALUES (@name, @authority, @password, @email)" ProviderName="<%$ ConnectionStrings:register.ProviderName %>" SelectCommand="SELECT * FROM [Users]" UpdateCommand="UPDATE [Users] SET [name] = @name, [authority] = @authority, [password] = @password, [email] = @email WHERE [uyeno] = @uyeno">
                    <DeleteParameters>
                        <asp:Parameter Name="uyeno" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="txtAdSoyad" Name="name" PropertyName="Text" Type="String" />
                        <asp:Parameter DefaultValue="member" Name="authority" Type="String" />
                        <asp:ControlParameter ControlID="txtKayitSifreTekrar" Name="password" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="txtKayitEmail" Name="email" PropertyName="Text" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="name" Type="String" />
                        <asp:Parameter Name="authority" Type="String" />
                        <asp:Parameter Name="password" Type="String" />
                        <asp:Parameter Name="email" Type="String" />
                        <asp:Parameter Name="uyeno" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>

                <asp:Button ID="btnKaydet" runat="server" Text="Kayıt Ol" CssClass="btn btn-login w-100 py-2 mt-2" OnClick="btnKaydet_Click" />
                
                <div class="text-center mt-3">
                    <a href="log.aspx" style="color: #3e2723; text-decoration: none; font-weight: 600; font-size: 14px;">Zaten hesabınız var mı? Giriş yapın</a>
                </div>

                <p class="mt-4 mb-0 text-center fw-medium" style="font-size: 14px; opacity: 0.8;">&copy; 2026 Stokcum.com</p>
            </div>
        </div>
    </asp:View>
</asp:MultiView>
</asp:Content>