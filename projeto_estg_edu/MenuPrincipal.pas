unit MenuPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, Buttons, jpeg, RLReport, IniFiles, pngimage;

type
  TTMenuPrincipal = class(TForm)
    MainMenu: TMainMenu;
    m1: TMenuItem;
    Sair: TMenuItem;
    C1: TMenuItem;
    Produto1: TMenuItem;
    Compra1: TMenuItem;
    Panel1: TPanel;
    btnSair: TBitBtn;
    btnCliente: TBitBtn;
    btnProduto: TBitBtn;
    btnVenda: TBitBtn;
    Image1: TImage;
    btnCompra: TBitBtn;
    Fornecedor1: TMenuItem;
    btnESTOQUE: TMenuItem;
    RelatrioGerencial1: TMenuItem;
    Esconder1: TMenuItem;
    rocarUsurio1: TMenuItem;
    Fechar1: TMenuItem;
    Cliente1: TMenuItem;
    N2Produto1: TMenuItem;
    N3Fornecedores1: TMenuItem;
    N4Compra1: TMenuItem;
    N11Listagem1: TMenuItem;
    N12Top10quemaiscompraram1: TMenuItem;
    N21Listagem1: TMenuItem;
    N22Top10quemaiscompraram1: TMenuItem;
    N31Listagem1: TMenuItem;
    N32Top10quemaisvendeu1: TMenuItem;
    N33Produtosporfornecedores1: TMenuItem;
    N41PorPerodo1: TMenuItem;
    N42VendaDetalhada1: TMenuItem;
    Estoque1: TMenuItem;
    N42VendaDetalhada2: TMenuItem;
    N1Modelo1: TMenuItem;
    N2ModeloFornedor1: TMenuItem;
    Configuraes1: TMenuItem;
    Produto2: TMenuItem;
    procedure C1Click(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure Compra1Click(Sender: TObject);
    procedure Cliente1Click(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnClienteClick(Sender: TObject);
    procedure btnProdutoClick(Sender: TObject);
    procedure btnVendaClick(Sender: TObject);
    procedure btnCompraClick(Sender: TObject);
    procedure Fornecedor1Click(Sender: TObject);
    procedure btnESTOQUEClick(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure N11Listagem1Click(Sender: TObject);
    procedure N21Listagem1Click(Sender: TObject);
    procedure N31Listagem1Click(Sender: TObject);
    procedure N33Produtosporfornecedores1Click(Sender: TObject);
    procedure N41PorPerodo1Click(Sender: TObject);
    procedure N42VendaDetalhada1Click(Sender: TObject);
    procedure Estoque1Click(Sender: TObject);
    procedure N12Top10quemaiscompraram1Click(Sender: TObject);
    procedure N22Top10quemaiscompraram1Click(Sender: TObject);
    procedure N32Top10quemaisvendeu1Click(Sender: TObject);
    procedure N1Modelo1Click(Sender: TObject);
    procedure N2ModeloFornedor1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
     // config relatorio
    //cliente
    clilist : boolean;
    clitop : boolean;
  //Produto
    prodlist : Boolean;
    prodtop : Boolean;
    prodestoq : Boolean;
  //Fornecedor
    forlist : Boolean;
    fortop : Boolean;
    forprod : Boolean;

    CanClose : boolean;
    procedure Carregaconfig;
  public
    { Public declarations }

  end;

var
  TMenuPrincipal: TTMenuPrincipal;

implementation

uses Cliente, Produto, Compra, CompraC, FiltroRelCliente, Fornecedor, FiltroRelProduto, ProdutoEstoque, FiltroRelCompra, FiltroRelFornecedor, FiltroRelEstoque, FiltroRelItensVendas, RelTopCliente, FiltroRelTopCliente, FiltroRelTopProduto, FiltroRelTopFornecedor, FiltroRelCompraModel, FiltroRelCompraModelFornecedor, Configuracoes;

{$R *.dfm}

procedure TTMenuPrincipal.btnClienteClick(Sender: TObject);
begin
  TCliente.ChamaTela;
end;

procedure TTMenuPrincipal.btnCompraClick(Sender: TObject);
begin
  Compra.TCompra.ChamarTelaCompra;
end;

procedure TTMenuPrincipal.btnESTOQUEClick(Sender: TObject);
begin
  TEstoque.ChamaTela('',0);
end;

procedure TTMenuPrincipal.btnProdutoClick(Sender: TObject);
begin
  TProduto.ChamaTela('',0);
end;

procedure TTMenuPrincipal.btnVendaClick(Sender: TObject);
begin
  TCompraC.ChamaTela('I', 0);
end;

procedure TTMenuPrincipal.btnSairClick(Sender: TObject);
begin
  CanClose := False;
  if MessageBox(Handle,'Deseja realmente fechar o sistema?','Sair do sistema? ',MB_ICONQUESTION+MB_YESNO)=IDYES then
    Close
  else
    exit;
end;

procedure TTMenuPrincipal.C1Click(Sender: TObject);
begin
  TCliente.ChamaTela;
end;

procedure TTMenuPrincipal.Cliente1Click(Sender: TObject);
begin
//   TClienteC.ChamaTela('C');
end;

procedure TTMenuPrincipal.Compra1Click(Sender: TObject);
begin
  TCompra.ChamarTelaCompra;
end;

procedure TTMenuPrincipal.Configuraes1Click(Sender: TObject);
begin
  TConfig.Chamatela;
  Carregaconfig;
end;

procedure TTMenuPrincipal.Estoque1Click(Sender: TObject);
begin
  TFiltroRelEstoquePro.chamatela;
end;

procedure TTMenuPrincipal.Fechar1Click(Sender: TObject);
begin
  btnSair.Click;
end;

procedure TTMenuPrincipal.Carregaconfig;
var ini : TIniFile;
begin
  //carrega .ini
  ini := TIniFile.Create('D:\FOCUS\Ini\ConfigPrjEstagio.ini');
  //Carrega info de Relatórios
  //Cliente
  ini.ReadBool('Cliente','rellist', clilist);
  ini.ReadBool('Cliente','reltop', clitop);
  //Produto
  ini.ReadBool('Produto','rellist', prodlist);
  ini.ReadBool('Produto','reltop', prodtop);
  ini.ReadBool('Produto','relestoque', prodestoq);
  //fornecedor
  ini.ReadBool('Fornecedor','rellist', forlist);
  ini.ReadBool('Fornecedor','reltop', fortop);
  ini.ReadBool('Fornecedor','relforprod ', forprod);

  //habilitar ou desabilitar

  //Carrega info de Relatórios
  //Cliente
  if ini.ReadBool('Cliente','rellist', clilist) = True then
    N11Listagem1.Visible := False
  else
    N11Listagem1.Visible := True;

  if ini.ReadBool('Cliente','reltop', clitop) = True then
    N12Top10quemaiscompraram1.Visible := False
  else
    N12Top10quemaiscompraram1.Visible := True;
  //Produto
  if ini.ReadBool('Produto','rellist', prodlist) = True then
    N21Listagem1.Visible := False
  else
    N21Listagem1.Visible := True;

  if ini.ReadBool('Produto','reltop', prodtop) = True then
    N22Top10quemaiscompraram1.Visible := False
  else
    N22Top10quemaiscompraram1.Visible := True;

  if ini.ReadBool('Produto','relestoque', prodestoq) = True then
    Estoque1.Visible := False
  else
    Estoque1.Visible := True;
  //fornecedor
  if ini.ReadBool('Fornecedor','rellist', forlist) = True then
    N31Listagem1.Visible := False
  else
    N31Listagem1.Visible := True;

  if ini.ReadBool('Fornecedor','reltop', fortop) = True then
    N32Top10quemaisvendeu1.Visible := False
  else
    N32Top10quemaisvendeu1.Visible := True;

  if ini.ReadBool('Fornecedor','relforprod ', forprod) = True then
    N33Produtosporfornecedores1.Visible := False
  else
    N33Produtosporfornecedores1.Visible := True;

end;

procedure TTMenuPrincipal.FormCreate(Sender: TObject);
begin
  Carregaconfig;
end;

procedure TTMenuPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if (btnSair.Enabled) and (btnSair.Visible) then
        btnSair.Click;
    end;
   // ALT + VK_F4
  end;
end;

procedure TTMenuPrincipal.Fornecedor1Click(Sender: TObject);
begin
  TFornecedor.chamatela;
end;

procedure TTMenuPrincipal.N11Listagem1Click(Sender: TObject);
begin
  TFiltroRelCliente.chamatela;
end;

procedure TTMenuPrincipal.N12Top10quemaiscompraram1Click(Sender: TObject);
begin
  TFiltroRelTopCli.Chamatela;
end;

procedure TTMenuPrincipal.N1Modelo1Click(Sender: TObject);
begin
  TFiltroRelCompModel.Chamatela;
end;

procedure TTMenuPrincipal.N21Listagem1Click(Sender: TObject);
begin
  TFiltroRelProduto.chamatela('');
end;

procedure TTMenuPrincipal.N22Top10quemaiscompraram1Click(Sender: TObject);
begin
  TFiltroRelTopProduto.Chamatela;
end;

procedure TTMenuPrincipal.N2ModeloFornedor1Click(Sender: TObject);
begin
  TfiltroRelCompraModelFornecedor.Chamatela;
end;

procedure TTMenuPrincipal.N31Listagem1Click(Sender: TObject);
begin
  TFiltroRelFornecedor.chamatela;
end;

procedure TTMenuPrincipal.N32Top10quemaisvendeu1Click(Sender: TObject);
begin
  TFiltroRelTopFuncionario.Chamatela;
end;

procedure TTMenuPrincipal.N33Produtosporfornecedores1Click(Sender: TObject);
begin
  TFiltroRelProduto.chamatela('F');
end;

procedure TTMenuPrincipal.N41PorPerodo1Click(Sender: TObject);
begin
  TFiltroRelCompraCli.chamatela;
end;

procedure TTMenuPrincipal.N42VendaDetalhada1Click(Sender: TObject);
begin
  TFiltroRelItensVendas.chamatela;
end;

procedure TTMenuPrincipal.Produto1Click(Sender: TObject);
begin
  TProduto.ChamaTela('',0);
end;

end.
