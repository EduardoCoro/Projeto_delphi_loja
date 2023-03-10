unit RelItensVendas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RLReport, pngimage;

type
  TTRelItensVendas = class(TForm)
    RLCompra: TRLReport;
    RLBand1: TRLBand;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
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
    dsProduto: TDataSource;
    QProduto: TADOQuery;
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
    RLBand8: TRLBand;
    RLPanel17: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel18: TRLPanel;
    RLDBText7: TRLDBText;
    RLPanel19: TRLPanel;
    RLDBText8: TRLDBText;
    RLPanel20: TRLPanel;
    RLPanel21: TRLPanel;
    RLDBText10: TRLDBText;
    RLLabel15: TRLLabel;
    RLDBText9: TRLDBText;
    lbltitulo: TRLLabel;
    procedure dtsCompraDataChange(Sender: TObject; Field: TField);
    procedure QCompraVALOR_TOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoPRECOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoVALORGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    codCompra : integer;
    procedure carregaCliente;
    procedure carregadados(xOrdem: Integer; xcodigo: Integer);
  public
    { Public declarations }
    procedure  chamatela(xOrdem: Integer; xcodigo: Integer);
  end;

var
  TRelItensVendas: TTRelItensVendas;

implementation

uses
 DMPrincipal, Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTRelItensVendas.chamatela(xOrdem: Integer; xcodigo: Integer);
begin
  TRelItensVendas := TTRelItensVendas.Create(Application);
  with TRelItensVendas do
  begin
    codCompra:= xcodigo;
    // subtitulo
    case xOrdem of
      0: lbltitulo.Caption := 'Ordenado por C?digo';
      1: lbltitulo.Caption := 'Ordenado por Produto';
      2: lbltitulo.Caption := 'Ordenado por Produto de Maior Valor';
      3: lbltitulo.Caption := 'Ordenado por Produto de Menor Valor';
    end;
    carregaCliente;
    carregadados(xOrdem,xcodigo);
    RLCompra.PreviewModal;
  end;
  FreeAndNil(TRelItensVendas);
end;

procedure TTRelItensVendas.dtsCompraDataChange(Sender: TObject; Field: TField);
begin   {
  with QProduto  do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT I.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN COMPRA AS C ON C.COD_COMPRA = I.COD_COMPRA ');
    SQL.Add('INNER JOIN PRODUTO AS P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('WHERE I.COD_COMPRA = ' + IntegerTextSql(QCompra.FieldByName('COD_COMPRA').AsInteger));
    Open;
  end;  }
end;

procedure TTRelItensVendas.QCompraVALOR_TOTALGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatFloat('0.00', QCompra.FieldByName('VALOR_TOTAL').AsFloat);
end;

procedure TTRelItensVendas.QProdutoPRECOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatFloat('0.00', QProduto.FieldByName('PRECO').AsFloat);
end;

procedure TTRelItensVendas.QProdutoVALORGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatFloat('0.00', QProduto.FieldByName('VALOR').AsFloat);
end;

procedure TTRelItensVendas.carregaCliente;
begin
  with QCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('');
    SQL.Add('SELECT A.COD_COMPRA, A.COD_CLIENTE ,C.NOME, A.DATA, A.VALOR_TOTAL ');
    SQL.Add('FROM COMPRA A ');
    SQL.Add('INNER JOIN CLIENTE C ON C.COD_CLIENTE = A.COD_CLIENTE ');
    SQL.Add('WHERE A.COD_COMPRA = ' + IntegerTextSql(codCompra) );
    open;

    FieldByName('VALOR_TOTAL').OnGetText := QCompraVALOR_TOTALGetText;
  end;
end;

procedure TTRelItensVendas.carregadados(xOrdem: Integer; xcodigo: Integer);
begin
  // carregar os itens compras
  with QProduto  do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT I.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN COMPRA AS C ON C.COD_COMPRA = I.COD_COMPRA ');
    SQL.Add('INNER JOIN PRODUTO AS P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('WHERE I.COD_COMPRA = ' + IntegerTextSql(QCompra.FieldByName('COD_COMPRA').AsInteger));
    // ORDENA??O
    case xOrdem of
      0: SQL.Add('ORDER BY COD_PRODUTO');
      1: SQL.Add('ORDER BY DESCRICAO');
      2: SQL.Add('ORDER BY P.PRECO DESC');    // MAIOR VALOR
      3: SQL.Add('ORDER BY P.PRECO');        // Menor valor
    end;
    Open;

    // tratamento de valor float
    FieldByName('PRECO').OnGetText := QProdutoPRECOGetText;
    FieldByName('VALOR').OnGetText := QProdutoVALORGetText;
  end;
end;

end.
