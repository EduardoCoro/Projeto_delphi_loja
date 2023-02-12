unit GraficoTopCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, DBChart, DB, ADODB, StdCtrls,
  Buttons, ExtCtrls;

type
  TTGraficoTopCliente = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    QCliente: TADOQuery;
    GraficoCli: TDBChart;
    Series1: TBarSeries;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure GraficoCliPageChange(Sender: TObject);
    procedure GraficoCliKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure CarregaDados(xDataIni: TDateTime; xDataFim: TDateTime);
  public
    { Public declarations }
    procedure Chamatela(xDataIni: TDateTime; xDataFim: TDateTime);
  end;

var
  TGraficoTopCliente: TTGraficoTopCliente;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoTopCliente.Chamatela(xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TGraficoTopCliente := TTGraficoTopCliente.Create(Application);
  with TGraficoTopCliente do
  begin
    TGraficoTopCliente.Caption :='Gráfico Top 10 de Clientes, de ' + DateToStr(xDataIni) + ' à ' +   DateToStr(xDataFim);
    CarregaDados(xDataIni,xDataFim);
    // trava botoes?
    if (GraficoCli.Page) = (GraficoCli.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;
    // tratamento de vazio
    if QCliente.IsEmpty then
    begin
      EnviaMensagem('Registro não encontrado!','',mtInformation, [mbOK]);
      exit;
    end
    else
      ShowModal;
  end;
  FreeAndNil(TGraficoTopCliente);
end;

procedure TTGraficoTopCliente.GraficoCliKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
      begin
        btnCancelar.Click;
      end;
    end;
  end;
end;

procedure TTGraficoTopCliente.GraficoCliPageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoCli.Page) + '/' + IntToStr(GraficoCli.NumPages);
end;

procedure TTGraficoTopCliente.btnAntesClick(Sender: TObject);
begin
  if GraficoCli.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoCli.PreviousPage;
    if GraficoCli.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoTopCliente.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoTopCliente.btnDepoisClick(Sender: TObject);
begin
  if GraficoCli.Page = GraficoCli.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoCli.NextPage;
    btnAntes.Enabled := True;
     if GraficoCli.Page = GraficoCli.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoTopCliente.CarregaDados(xDataIni: TDateTime; xDataFim: TDateTime);
begin
  with QCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT ymd ');
    SQL.Add('SELECT TOP 10 A.COD_CLIENTE, C.NOME , COUNT(*) AS COMPRAS ');
    SQL.Add('FROM COMPRA A ');
    SQL.Add('INNER JOIN CLIENTE C ON C.COD_CLIENTE = A.COD_CLIENTE ');
    //por data escolhida
    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add('WHERE A.DATA  '+ DataBetweenSQL(xDataIni, xDataFim));
    end
    else
    begin
      SQL.Add('WHERE A.DATA  = '+ DataSQL(xDataIni));
    end;
    SQL.Add('GROUP BY  A.COD_CLIENTE, C.NOME ');
    SQL.Add('ORDER BY  COUNT(*) DESC ');

    Open;
    Label1.Caption := IntToStr(GraficoCli.Page) + '/' + IntToStr(GraficoCli.NumPages);
  end;
end;

end.
