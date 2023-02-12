unit RelCompra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB;

type
  TTRelCompra = class(TForm)
    RLCompra: TRLReport;
    RLBand1: TRLBand;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    dtsCompra: TDataSource;
    QCompra: TADOQuery;
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel13: TRLPanel;
    RLLabel10: TRLLabel;
    RLBand4: TRLBand;
    RLPanel6: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel7: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel8: TRLPanel;
    RLPanel5: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel9: TRLPanel;
    RLDBText5: TRLDBText;
    RLPanel10: TRLPanel;
    RLDBText6: TRLDBText;
    RLDBText4: TRLDBText;
    RLBand6: TRLBand;
    RLPanel11: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand7: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    lbltitulo: TRLLabel;
    RLLabel11: TRLLabel;
    procedure RLDBText6BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
    Taux: integer;
    procedure carregadados(xFiltro: Integer; xOrdem: Integer;  xDataIni,xDataFim : TDateTime);
  public
    { Public declarations }
    procedure chamatela(xFiltro: Integer; xOrdem: Integer; xDataIni, xDataFim : TDateTime);

  end;

var
  TRelCompra : TTRelCompra;

implementation

uses
 DMPrincipal, Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTRelCompra.carregadados(xFiltro: Integer; xOrdem: Integer; xDataIni: TDateTime; xDataFim: TDateTime);
var aux : integer;
begin
  aux :=0;
  with QCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT ymd ');
    SQL.Add('SELECT A.COD_COMPRA, A.COD_CLIENTE, C.NOME, A.DATA, A.VALOR_TOTAL');
    SQL.Add('FROM COMPRA A');
    SQL.Add('INNER JOIN CLIENTE C ON C.COD_CLIENTE = A.COD_CLIENTE');
    // FILTRAR cliente OU todos
    if xFiltro > 0 then
    begin
      SQL.Add( GetCondicao(aux) + ' A.COD_CLIENTE = '+ IntegerTextSql(xFiltro));
      aux:=1;
    end;
    //por data escolhida

    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add( GetCondicao(aux) + ' A.DATA  '+ DataBetweenSQL(xDataIni,xDataFim));
    end
    else
    begin
         SQL.Add( GetCondicao(aux) + ' A.DATA  = '+ DataSQL(xDataIni));
    end;
   
    // ORDENA��O
    case xOrdem of
      0: SQL.Add('ORDER BY A.COD_COMPRA');   // CODIGO
      1: SQL.Add('ORDER BY C.NOME');     // NOME
      2: SQL.Add('ORDER BY A.VALOR_TOTAL DESC');    // MAIOR VALOR
      3: SQL.Add('ORDER BY A.VALOR_TOTAL ');    // MENOR VALOR
    end;
    //InputBox('','', SQL.Text);
    //ExecSQL;
    Open;

    //FieldByName('VALOR_TOTAL').OnGetText := QCompraVALOR_TOTALGetText;
  end;
end;

procedure TTRelCompra.chamatela(xFiltro: Integer; xOrdem: Integer; xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TRelCompra := TTRelCompra.Create(Application);
  with TRelCompra do
  begin
    // subtitulo
    //informando a data ini e fim
    lbltitulo.Caption := 'Por data: ' + DateToStr(xDataIni) + ' a ' + DateToStr(xDataFim) ;
    //ordena��o
    case xOrdem of
      0: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por C�digo';
      1: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Cliente';
      2: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Maior Valor';
      3: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Menor Valor';
    end;
    {chamar carregadados}
    carregadados(xFiltro, xOrdem, xDataIni, xDataFim);
    if QCompra.IsEmpty then
    begin
      EnviaMensagem('Nenhum registro encontrado','',mtInformation,[mbOK]);
      exit;
    end
    else
      RLCompra.PreviewModal;
  end;
  FreeAndNil(TRelCompra);
end;

procedure TTRelCompra.RLDBText6BeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  AText := FormatFloat('0.00', QCompra.FieldByName('VALOR_TOTAL').AsFloat);
end;

end.
