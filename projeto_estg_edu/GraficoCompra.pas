unit GraficoCompra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, DBChart, StdCtrls, Buttons,
  ExtCtrls, DB, ADODB;

type
  TTGraficoCompra = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoCompra: TDBChart;
    Series1: TBarSeries;
    QCompra: TADOQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
  private
    { Private declarations }
    procedure Carregadados(xordem : integer; xdataini, xdatafim : TDateTime);
  public
    { Public declarations }
    procedure Chamatela(xordem : integer; xdataini, xdatafim : TDateTime);
  end;

var
  TGraficoCompra: TTGraficoCompra;

implementation

uses
 DMPrincipal, Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoCompra.Chamatela(xordem: Integer; xdataini: TDateTime; xdatafim: TDateTime);
begin
  TGraficoCompra := TTGraficoCompra.Create(Application);
  with TGraficoCompra do
  begin
    Carregadados(xordem,xdataini,xdatafim);
    if QCompra.IsEmpty then
    begin
      EnviaMensagem('Nehum Registro encontrado!','',mtInformation,[mbok]);
      exit;
    end
    else
      ShowModal;
  end;
  FreeAndNil(TGraficoCompra);
end;

procedure TTGraficoCompra.Carregadados(xordem: Integer; xdataini: TDateTime; xdatafim: TDateTime);
begin
  with QCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT YMD ');
    SQL.Add('SELECT DATA , COUNT(COD_COMPRA) AS QUANTIDADE ');
    SQL.Add('FROM COMPRA ');
    SQL.Add('WHERE ');

    //entra data
    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add('DATA  '+ DataBetweenSQL(xDataIni,xDataFim));
    end
    else
    begin
      if (xDataIni <> 0) then
        SQL.Add('DATA  = '+ DataSQL(xDataIni))
      else
        SQL.Add('DATA  = '+ DataSQL(xDataFim));
    end;

    //AGRUPADO POR DATA
    SQL.Add('GROUP BY DATA ');

    //ordenar por...
    case xOrdem of
      0: SQL.Add('ORDER BY DATA DESC');   //Data maior
      1: SQL.Add('ORDER BY DATA ');         //Data menor
      2: SQL.Add('ORDER BY QUANTIDADE DESC');// MAIOR qtd Venda
      3: SQL.Add('ORDER BY QUANTIDADE ');    // MENOR qtd Venda
    end;

    Open;
  end;
end;

procedure TTGraficoCompra.btnAntesClick(Sender: TObject);
begin
  if GraficoCompra.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoCompra.PreviousPage;
    if GraficoCompra.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoCompra.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoCompra.btnDepoisClick(Sender: TObject);
begin
  if GraficoCompra.Page = GraficoCompra.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoCompra.NextPage;
    btnAntes.Enabled := True;
     if GraficoCompra.Page = GraficoCompra.NumPages then
       btnDepois.Enabled := False;
  end;
end;

end.
