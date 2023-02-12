unit FiltroRelItensVendas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TTFiltroRelItensVendas = class(TForm)
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    FiltroRelCliente: TPanel;
    rdOrdem: TRadioGroup;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edCodCliente: TEdit;
    edNomeCli: TEdit;
    btnPesquisaCliente: TBitBtn;
    btnLimpaC: TBitBtn;
    Label2: TLabel;
    edCodCompra: TEdit;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnLimpaCClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edCodCompraKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodCompraKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure chamatela;
  end;

var
  TFiltroRelItensVendas: TTFiltroRelItensVendas;

implementation

uses
 DMPrincipal, Compra, RelItensVendas, Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTFiltroRelItensVendas.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroRelItensVendas.btnImprimirClick(Sender: TObject);
begin
  if (edCodCliente.Text = '') or (edCodCompra.Text = '') then
  begin
    EnviaMensagem('Por favor seleciona a compra!','Aviso!', mtInformation, [mbOK]);
    if btnPesquisaCliente.CanFocus then
      btnPesquisaCliente.SetFocus;
    Exit;
  end
  else
  begin
    TRelItensVendas.chamatela(rdOrdem.ItemIndex, StrToInt(edCodCompra.Text));
  end;
end;

procedure TTFiltroRelItensVendas.btnLimpaCClick(Sender: TObject);
begin
  edCodCliente.Clear;
  edNomeCli.Clear;
  edCodCompra.Clear;
  edCodCompra.ReadOnly := False;
  btnPesquisaCliente.Enabled := True;
  if edCodCompra.CanFocus then
    edCodCompra.SetFocus;
  btnLimpaC.Enabled := False;
end;

procedure TTFiltroRelItensVendas.btnPesquisaClienteClick(Sender: TObject);
var codigo : integer;
begin
  Codigo := TCompra.ChamarTelaCompra(True);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.COD_COMPRA, P.COD_CLIENTE , C.NOME');
      SQL.Add('FROM COMPRA AS P');
      SQL.Add('INNER JOIN CLIENTE AS C ON C.COD_CLIENTE = P.COD_CLIENTE');
      SQL.Add('WHERE P.COD_COMPRA = '+ IntToStr(Codigo) );
      Open;

      edCodCliente.Text := FieldByName('COD_CLIENTE').AsString;
      edNomeCli.Text := FieldByName('NOME').AsString;
      edCodCompra.Text := FieldByName('COD_COMPRA').AsString;

      Close;
      //ExecSQL;
      btnPesquisaCliente.Enabled := False;
      btnLimpaC.Enabled := True;
    end;
  end;
  if  btnImprimir.CanFocus then
    btnImprimir.SetFocus;
end;

procedure TTFiltroRelItensVendas.chamatela;
begin
  TFiltroRelItensVendas := TTFiltroRelItensVendas.Create(Application);
  with TFiltroRelItensVendas do
  begin
    ShowModal;
  end;
  FreeAndNil(TFiltroRelItensVendas);
end;

procedure TTFiltroRelItensVendas.edCodCompraKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_F6:
    begin
      if (btnLimpaC.Enabled) and (btnLimpaC.Visible) then
        btnLimpaC.Click;
    end;
    VK_F3:
    begin
      if (btnPesquisaCliente.Enabled) and (btnPesquisaCliente.Visible) then
        btnPesquisaCliente.Click;
    end;
  end;
end;

procedure TTFiltroRelItensVendas.edCodCompraKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key= #13) and not Empty(edCodCompra.Text) then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.COD_CLIENTE, C.COD_COMPRA, A.NOME ');
      SQL.Add('FROM CLIENTE A ');
      SQL.Add('INNER JOIN COMPRA AS C ON C.COD_CLIENTE = A.COD_CLIENTE ');
      SQL.Add('WHERE C.COD_COMPRA = ' + StringTextSql(edCodCompra.Text));
      Open;

      edCodCliente.Text := FieldByName('COD_CLIENTE').AsString;
      edNomeCli.Text := FieldByName('NOME').AsString;

      if not IsEmpty then
      begin
        btnPesquisaCliente.Enabled := False;
        btnLimpaC.Enabled := True;
        edCodCompra.ReadOnly := True;
      end
      else
      begin
        EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbok]);
        btnLimpaC.Click;
        Exit;
      end;
    end;
  end;
end;

procedure TTFiltroRelItensVendas.FormKeyDown(Sender: TObject; var Key: Word;
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

end.
