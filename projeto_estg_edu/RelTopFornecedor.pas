unit RelTopFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RLReport, pngimage;

type
  TTRelTopFornecedor = class(TForm)
    rlpFornecedor: TRLReport;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel2: TRLPanel;
    V: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLBand3: TRLBand;
    RLPanel4: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel5: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel6: TRLPanel;
    RLDBText3: TRLDBText;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand7: TRLBand;
    RLPanel10: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand8: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    QFornecedor: TADOQuery;
    dtsFornecedor: TDataSource;
    RLPanel7: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel11: TRLPanel;
    RLDBResult2: TRLDBResult;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    lbltitulo: TRLLabel;
  private
    { Private declarations }
    procedure CarregaDados( xDataIni, xDataFim : TDateTime);
  public
    { Public declarations }
    procedure Chamatela( xDataIni, xDataFim : TDateTime);
  end;

var
  TRelTopFornecedor: TTRelTopFornecedor;

implementation

uses
 Funcoesdb, Funcoes;

{$R *.dfm}

procedure  TTRelTopFornecedor.Chamatela( xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TRelTopFornecedor := TTRelTopFornecedor.Create(Application);
  with TRelTopFornecedor do
  begin
    // data
    lbltitulo.Caption := 'Por data: ' + DateToStr(xDataIni) + ' a ' + DateToStr(xDataFim) ;

    CarregaDados(xDataIni,xDataFim);
    if QFornecedor.IsEmpty then
    begin
      EnviaMensagem('Nenhum registro encontrado','',mtInformation,[mbOK]);
      exit;
    end
    else
      rlpFornecedor.PreviewModal;
  end;
  FreeAndNil(TRelTopFornecedor);
end;

procedure TTRelTopFornecedor.CarregaDados( xDataIni: TDateTime; xDataFim: TDateTime);
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT YMD ');
    SQL.Add('SELECT TOP 10 SUM(I.QUANTIDADE) AS VENDAS,  F.COD_FORNECEDOR ,F.NOME AS FORNECEDOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('INNER JOIN FORNECEDOR F ON F.COD_FORNECEDOR = P.COD_FORNECEDOR ');
    SQL.Add('INNER JOIN COMPRA A ON A.COD_COMPRA = I.COD_COMPRA');
    // TRATAMENTO POR DATA == A.DATA
    if (xDataIni <> 0 ) or (xDataFim <> 0) then
    begin
      if (xDataIni <> 0 ) and (xDataFim <> 0) then
        SQL.Add('WHERE A.DATA '+ DataBetweenSQL(xDataIni,xDataFim));
      if not (xDataIni <> 0 ) and (xDataFim <> 0) then
        SQL.Add('WHERE A.DATA = '+ DataSQL(xDataFim));
      if (xDataIni <> 0 ) and not (xDataFim <> 0) then
        SQL.Add('WHERE A.DATA = '+ DataSQL(xDataIni));
    end;

    SQL.Add('GROUP BY I.COD_PRODUTO, F.COD_FORNECEDOR ,F.NOME ');
    SQL.Add('ORDER BY SUM(I.QUANTIDADE) DESC ');
    Open;
  end;
end;

end.
