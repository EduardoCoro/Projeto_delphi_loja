unit GraficoListProdutos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, TeEngine, Series, TeeProcs, Chart, DBChart, StdCtrls,
  Buttons, ExtCtrls;

type
  TTGraficoListProdutos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoProdutos: TDBChart;
    Series1: TPieSeries;
    QProduto: TADOQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GraficoProdutosPageChange(Sender: TObject);
  private
    { Private declarations }
    procedure Carregadados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TGraficoListProdutos: TTGraficoListProdutos;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoListProdutos.Chamatela;
begin
  TGraficoListProdutos := TTGraficoListProdutos.Create(Application);
  with TGraficoListProdutos do
  begin
    Carregadados;
    // trava botoes?
    if (GraficoProdutos.Page) = (GraficoProdutos.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;

    if QProduto.IsEmpty then
    begin
      EnviaMensagem('Registro n�o encontrado!','Informa��o', mtInformation,[mbOK]);
      exit;
    end
    else
      ShowModal;
  end;
  FreeAndNil(TGraficoListProdutos);
end;

procedure TTGraficoListProdutos.Carregadados;
begin
  with QProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ATIVO = 1 ');
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ATIVO = 0 ');
    Open;
    Label1.Caption := IntToStr(GraficoProdutos.Page) + '/' + IntToStr(GraficoProdutos.NumPages);
  end;
end;

procedure TTGraficoListProdutos.btnAntesClick(Sender: TObject);
begin
  if GraficoProdutos.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoProdutos.PreviousPage;
    if GraficoProdutos.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoListProdutos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoListProdutos.btnDepoisClick(Sender: TObject);
begin
  if GraficoProdutos.Page = GraficoProdutos.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoProdutos.NextPage;
    btnAntes.Enabled := True;
     if GraficoProdutos.Page = GraficoProdutos.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoListProdutos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTGraficoListProdutos.GraficoProdutosPageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoProdutos.Page) + '/' + IntToStr(GraficoProdutos.NumPages);
end;

end.
