unit FiltroRelProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, DBCtrls, ExtCtrls, Buttons;

type
  TTFiltroRelProduto = class(TForm)
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    FiltroRelCliente: TPanel;
    rgOrdem: TRadioGroup;
    rgFiltro: TRadioGroup;
    rgSemValidade: TRadioGroup;
    rgTipo: TRadioGroup;
    gFornecedor: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    btnPesquisaFornecedor: TBitBtn;
    btnLimpaF: TBitBtn;
    edCodFornecedor: TEdit;
    edNomeFornecedor: TEdit;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure DCombNomeKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgTipoClick(Sender: TObject);
    procedure btnLimpaFClick(Sender: TObject);
    procedure edCodFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure edCodFornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    Xacao : String;
  public
    { Public declarations }
    procedure chamatela(pAcao : string);
  end;

var
  TFiltroRelProduto: TTFiltroRelProduto;

implementation

uses
 DMPrincipal, RelProduto, RelFornecedorProduto, RelProdutoS, Funcoes, Funcoesdb, Fornecedor, GraficoFornecedor, GraficoListProdutos, RelFornecedorProdutoS;

{$R *.dfm}

procedure TTFiltroRelProduto.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroRelProduto.btnImprimirClick(Sender: TObject);
begin
  if Xacao = 'F' then
  begin
    //Fornecerdor por produto
    case rgTipo.ItemIndex of // analítico
      0: TRelFornecedorProd.Chamatela(rgFiltro.ItemIndex, rgSemValidade.ItemIndex ,rgOrdem.ItemIndex, edCodFornecedor.Text);
      1: TRelFornecedorProdutoS.ChamaRelatorio(edCodFornecedor.Text); //Sintético
      2: TGraficoForneceProdutos.Chamatela; // grafico
    end;
  end
  else
  begin
    // Listagem produto  por tipo de Relatorio
    case rgTipo.ItemIndex of
      0:  TRelProduto.chamatela(rgFiltro.ItemIndex, rgSemValidade.ItemIndex ,rgOrdem.ItemIndex, edCodFornecedor.Text);
      1:  TRelProdutoS.Chamatela; //sintético
      2:  TGraficoListProdutos.Chamatela; //grafico
    end;
  end;
end;

procedure TTFiltroRelProduto.btnLimpaFClick(Sender: TObject);
begin
  edCodFornecedor.Clear;
  edNomeFornecedor.Clear;
  btnPesquisaFornecedor.Enabled := True;
  btnPesquisaFornecedor.Focused;
  btnLimpaF.Enabled := False;
  btnPesquisaFornecedor.SetFocus;
  edCodFornecedor.ReadOnly := False;
  if edCodFornecedor.CanFocus then
    edCodFornecedor.SetFocus;
end;

procedure TTFiltroRelProduto.btnPesquisaFornecedorClick(Sender: TObject);
var Codigo : Integer;
begin
  Codigo := TFornecedor.ChamaTela(True);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR, NOME');
      SQL.Add('FROM FORNECEDOR');
      SQL.Add('WHERE COD_FORNECEDOR = '+ IntToStr(Codigo) );
      Open;

      edCodFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;
      edNomeFornecedor.Text := FieldByName('NOME').AsString;

      Close;
      //ExecSQL;
      btnPesquisaFornecedor.Enabled := False;
      btnLimpaF.Enabled := True;
      edCodFornecedor.ReadOnly := True;

      if  edCodFornecedor.CanFocus then
        edCodFornecedor.SetFocus;
    end;
  end;
end;

procedure TTFiltroRelProduto.chamatela(pAcao : string);
begin
  TFiltroRelProduto := TTFiltroRelProduto.Create(Application);
  with TFiltroRelProduto do
  begin
    Xacao := pAcao;
    if pAcao = 'F' then
    begin
      // .Caption :='Relatório de Fornecedor por produto';
      TFiltroRelProduto.Caption := 'Filtro do Relatório de Fornecedor por produto';
    end;
    ShowModal;
  end;
  FreeAndNil(TFiltroRelProduto);
end;

procedure TTFiltroRelProduto.DCombNomeKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=#0;
end;

procedure TTFiltroRelProduto.edCodFornecedorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_F3:
    begin
      if (btnPesquisaFornecedor.Enabled) and (btnPesquisaFornecedor.Visible) then
        btnPesquisaFornecedor.Click;
    end;
    VK_F6:
    begin
      if (btnLimpaF.Enabled) and (btnLimpaF.Visible) then
        btnLimpaF.Click;
    end;
  end;
end;

procedure TTFiltroRelProduto.edCodFornecedorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = #13) and not Empty(edCodFornecedor.Text) then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR ,NOME');
      SQL.Add('FROM FORNECEDOR ');
      SQL.Add('WHERE COD_FORNECEDOR = ' + StringTextSql(edCodFornecedor.Text));
      Open;

      edNomeFornecedor.Text := FieldByName('NOME').AsString;
      edCodFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;

      if not IsEmpty then
      begin
        {passa os valores}
        edCodFornecedor.ReadOnly := True;
        btnPesquisaFornecedor.Enabled := False;
        btnLimpaF.Enabled := True;
        btnPesquisaFornecedor.Enabled := False;
      end
      else
      begin
        EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbok]);
        btnLimpaF.Click;
        Exit;
      end;
    end;
  end;
end;

procedure TTFiltroRelProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F5:
    begin
      if (btnImprimir.Enabled) and (btnImprimir.Visible) then
        btnImprimir.Click;
    end;
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTFiltroRelProduto.rgTipoClick(Sender: TObject);
begin
  case rgTipo.ItemIndex of
    0:
    begin
      //ZERAR GROUPS
//      gFornecedor.Visible := False;
//      rgOrdem.Visible := False;
//      rgFiltro.Visible := False;
//      rgSemValidade.Visible := False;
      //APARECER GROUPS
      rgOrdem.Visible := True;
      rgSemValidade.Visible := True;
      rgFiltro.Visible := True;
      gFornecedor.Visible := True;
    end;
    1:
    begin
      gFornecedor.Visible := True;
      rgOrdem.Visible := False;
      rgFiltro.Visible := False;
      rgSemValidade.Visible := False;
    end;
    2:
    begin
      gFornecedor.Visible := False;
      rgOrdem.Visible := False;
      rgFiltro.Visible := False;
      rgSemValidade.Visible := False;
    end;
  end;
end;

end.
