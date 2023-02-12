unit RelCompraModel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, pngimage;

type
  TTRelCompraModel = class(TForm)
    RLCompra: TRLReport;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand2: TRLBand;
    RLLabel1: TRLLabel;
    RLBand6: TRLBand;
    RLPanel11: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand7: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    dtsCompra: TDataSource;
    QCompra: TADOQuery;
    RLGroup1: TRLGroup;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel13: TRLPanel;
    RLLabel10: TRLLabel;
    RLPanel5: TRLPanel;
    RLLabel9: TRLLabel;
    RLBand4: TRLBand;
    RLPanel6: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel7: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel8: TRLPanel;
    RLDBText4: TRLDBText;
    RLPanel9: TRLPanel;
    RLDBText5: TRLDBText;
    RLPanel10: TRLPanel;
    RLDBText6: TRLDBText;
    lbltitulo: TRLLabel;
    RLSubDetail1: TRLSubDetail;
    RLBand9: TRLBand;
    RLPanel4: TRLPanel;
    RLLabel11: TRLLabel;
    RLPanel12: TRLPanel;
    RLLabel12: TRLLabel;
    RLPanel14: TRLPanel;
    RLLabel13: TRLLabel;
    RLPanel15: TRLPanel;
    RLLabel14: TRLLabel;
    RLPanel16: TRLPanel;
    RLLabel15: TRLLabel;
    RLBand8: TRLBand;
    RLPanel17: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel18: TRLPanel;
    RLDBText7: TRLDBText;
    RLPanel19: TRLPanel;
    RLDBText8: TRLDBText;
    RLPanel20: TRLPanel;
    RLDBText9: TRLDBText;
    RLPanel21: TRLPanel;
    RLDBText10: TRLDBText;
    DSProdutos: TDataSource;
    QProdutos: TADOQuery;
    RLBand1: TRLBand;
    RLPanel22: TRLPanel;
    rbdResult: TRLDBResult;
    procedure RLDBText7BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure RLDBText6BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure RLDBText10BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure RLGroup1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
    Taux : integer;
    XcodCliente : TStringlist;
    procedure Carregadados(Xordem : integer; xDataIni,xDataFim : TDateTime);
  public
    { Public declarations }
    procedure Chamatela(xcodCli : TStringlist ; Xordem : integer; xDataIni,xDataFim : TDateTime);
  end;

var
  TRelCompraModel: TTRelCompraModel;

implementation

uses
 Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTRelCompraModel.Chamatela(xcodCli: TStringlist; Xordem: Integer; xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TRelCompraModel := TTRelCompraModel.Create(Application);
  with TRelCompraModel do
  begin
    XcodCliente := xcodCli;
    //informando a data ini e fim
    lbltitulo.Caption := 'Por data: ' + DateToStr(xDataIni) + ' a ' + DateToStr(xDataFim) ;
    // subtitulo
    case xOrdem of
      0: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por C�digo';
      1: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Cliente';
      2: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Total de Maior Valor';
      3: lbltitulo.Caption := lbltitulo.Caption + ' Ordenado por Total de Menor Valor';
    end;
    Carregadados(Xordem,xDataIni,xDataFim);
    if QCompra.IsEmpty then
    begin
      //ShowModal;
      EnviaMensagem('Nenhum registro encontrado','',mtInformation,[mbOK]);
      exit;
    end
    else
      RLCompra.PreviewModal;
  end;
  FreeAndNil(TRelCompraModel);
end;

procedure TTRelCompraModel.RLDBText10BeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := FormatFloat('0.00', QProdutos.FieldByName('VALOR').AsFloat);
end;

procedure TTRelCompraModel.RLDBText6BeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := FormatFloat('0.00', QCompra.FieldByName('VALOR_TOTAL').AsFloat);
end;

procedure TTRelCompraModel.RLDBText7BeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  AText := FormatFloat('0.00', QProdutos.FieldByName('PRECO').AsFloat);
end;

procedure TTRelCompraModel.RLGroup1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
 // colocar consulta produtos de acordo com o codigo da compra
  with  QProdutos  do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT C.COD_COMPRA, P.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('INNER JOIN COMPRA C  ON C.COD_COMPRA = I.COD_COMPRA ');
    SQL.Add('WHERE C.COD_COMPRA = ' + StringTextSql( QCompra.FieldByName('COD_COMPRA').AsString));
    Open;

  end;
end;

procedure TTRelCompraModel.Carregadados(Xordem: Integer; xDataIni: TDateTime; xDataFim: TDateTime);
var aux : integer;
begin
  aux :=0;
  with QCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT ymd ');
    SQL.Add('SELECT A.COD_COMPRA, C.COD_CLIENTE, C.NOME, A.DATA, A.VALOR_TOTAL');
    SQL.Add('FROM COMPRA AS A ');
    SQL.Add('INNER JOIN CLIENTE C ON C.COD_CLIENTE = A.COD_CLIENTE ');
    // buscar por cliente especifico
    if XcodCliente.DelimitedText <> ''  then
      SQL.Add(GetCondicao(aux) + ' C.COD_CLIENTE IN (' + XcodCliente.DelimitedText + ')');

    //por data escolhida
    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add( GetCondicao(aux) + ' A.DATA  '+ DataBetweenSQL(xDataIni,xDataFim));
    end
    else
    begin
         SQL.Add( GetCondicao(aux) + ' A.DATA  = '+ DataSQL(xDataIni));
    end;

    // ordena��o
    case Xordem of
      0: SQL.Add('ORDER BY A.COD_COMPRA' );  //CODIGO
      1: SQL.Add('ORDER BY C.NOME' );   //NOME CLIENTE
      2: SQL.Add('ORDER BY A.VALOR_TOTAL DESC' );    // VALOR COMPRA
      3: SQL.Add('ORDER BY A.VALOR_TOTAL' );
    end;
    Open;

    {
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT ymd ');
    SQL.Add('SELECT  A.COD_COMPRA, A.COD_CLIENTE , A.DATA, A.VALOR_TOTAL ,C.NOME,I.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN COMPRA AS A ON A.COD_COMPRA = I.COD_COMPRA ');
    SQL.Add('INNER JOIN PRODUTO AS P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('INNER JOIN CLIENTE C ON C.COD_CLIENTE = A.COD_CLIENTE ');
    // buscar por cliente especifico
    if XcodCliente.DelimitedText <> ''  then
      SQL.Add(GetCondicao(aux) + ' C.COD_CLIENTE IN (' + XcodCliente.DelimitedText + ')');

    //por data escolhida
    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add( GetCondicao(aux) + ' A.DATA  '+ DataBetweenSQL(xDataIni,xDataFim));
    end
    else
    begin
         SQL.Add( GetCondicao(aux) + ' A.DATA  = '+ DataSQL(xDataIni));
    end;

    // ordena��o
    case Xordem of
      0: SQL.Add('ORDER BY A.COD_COMPRA' );  //CODIGO
      1: SQL.Add('ORDER BY C.NOME' );   //NOME CLIENTE
      2: SQL.Add('ORDER BY A.VALOR_TOTAL DESC' );    // VALOR COMPRA
      3: SQL.Add('ORDER BY A.VALOR_TOTAL' );
    end;
    Open;
    }

  end;
end;

end.
