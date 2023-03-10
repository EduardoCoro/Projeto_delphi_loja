unit GraficoFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, DBChart, StdCtrls, Buttons,
  ExtCtrls, DB, ADODB;

type
  TTGraficoForneceProdutos = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoFornece: TDBChart;
    QFornecedor: TADOQuery;
    Series1: TBarSeries;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GraficoFornecePageChange(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaDados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TGraficoForneceProdutos: TTGraficoForneceProdutos;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoForneceProdutos.Chamatela;
begin
  TGraficoForneceProdutos := TTGraficoForneceProdutos.Create(Application);
  with TGraficoForneceProdutos do
  begin
    CarregaDados;
    // trava botoes
    if (GraficoFornece.Page) = (GraficoFornece.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;
    //
    if QFornecedor.IsEmpty then
    begin
      EnviaMensagem('Registro n?o encontrado!','Informa??o...', mtInformation, [mbOK]);
      Exit;
    end
    else
      ShowModal;
  end;
end;

procedure TTGraficoForneceProdutos.CarregaDados;
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(P.COD_PRODUTO) AS QUANTIDADE, P.COD_FORNECEDOR, F.NOME ');
    SQL.Add('FROM PRODUTO P ');
    SQL.Add( 'INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
    SQL.Add('WHERE P.ATIVO = 1 ');
    SQL.Add('GROUP BY P.COD_FORNECEDOR,F.NOME ');
    Open;
    Label1.Caption := IntToStr(GraficoFornece.Page) + '/' + IntToStr(GraficoFornece.NumPages);
  end;
end;

procedure TTGraficoForneceProdutos.btnAntesClick(Sender: TObject);
begin
  if GraficoFornece.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoFornece.PreviousPage;
    if GraficoFornece.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoForneceProdutos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoForneceProdutos.btnDepoisClick(Sender: TObject);
begin
  if GraficoFornece.Page = GraficoFornece.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoFornece.NextPage;
    btnAntes.Enabled := True;
     if GraficoFornece.Page = GraficoFornece.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoForneceProdutos.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TTGraficoForneceProdutos.GraficoFornecePageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoFornece.Page) + '/' + IntToStr(GraficoFornece.NumPages);
end;

end.
