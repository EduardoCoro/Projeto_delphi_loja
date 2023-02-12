   unit RelTopCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB;

type
  TTRelTopCliente = class(TForm)
    rlpCliente: TRLReport;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel2: TRLPanel;
    V: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel8: TRLPanel;
    rlbStatus: TRLLabel;
    RLBand3: TRLBand;
    RLPanel4: TRLPanel;
    RLPanel5: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel6: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel9: TRLPanel;
    Td: TRLDBText;
    RLBand4: TRLBand;
    RLPanel7: TRLPanel;
    rbdResult: TRLDBResult;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand6: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    QCliente: TADOQuery;
    DsCliente: TDataSource;
    Tdbcontador: TRLDBResult;
    lbltitulo: TRLLabel;
  private
    { Private declarations }
    procedure CarregaDados(xDataIni, xDataFim : TDateTime);
  public
    { Public declarations }
    procedure Chamatela(xDataIni, xDataFim : TDateTime);
  end;

var
  TRelTopCliente: TTRelTopCliente;

implementation

uses
 DMPrincipal, Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTRelTopCliente.Chamatela(xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TRelTopCliente := TTRelTopCliente.Create(Application);
  with TRelTopCliente do
  begin
    CarregaDados(xDataIni,xDataFim);
    //informando a data ini e fim
    lbltitulo.Caption := '  De ' + DateToStr(xDataIni) + ' � ' + DateToStr(xDataFim) ;
    if QCliente.IsEmpty then
    begin
      EnviaMensagem('Nenhum registro encontrado','',mtInformation,[mbOK]);
      exit;
    end
    else
      rlpCliente.PreviewModal;
  end;
  FreeAndNil(TRelTopCliente);
end;

procedure TTRelTopCliente.CarregaDados(xDataIni: TDateTime; xDataFim: TDateTime);
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
  end;
end;

end.
