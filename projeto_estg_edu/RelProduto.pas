unit RelProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB, RLRichText;

type
  TTRelProduto = class(TForm)
    rlpProduto: TRLReport;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand1: TRLBand;
    rltitulo: TRLLabel;
    RLBand2: TRLBand;
    QProduto: TADOQuery;
    dtsProduto: TDataSource;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel4: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel6: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel7: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel8: TRLPanel;
    RLPanel9: TRLPanel;
    RLBDataValidade: TRLDBText;
    RLPanel13: TRLPanel;
    RLLabel10: TRLLabel;
    RLPanel14: TRLPanel;
    RLBand7: TRLBand;
    RLPanel15: TRLPanel;
    rbdResult: TRLDBResult;
    RLBand8: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    rlPreco: TRLDBText;
    RLPanel11: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel12: TRLPanel;
    RLDBText3: TRLDBText;
    lbltitulo: TRLLabel;
    RLLabel11: TRLLabel;
    RLDBMemo1: TRLDBMemo;
    procedure QProdutoPRECOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoSEM_VALIDADEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoDATA_VALIDADEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
     procedure carregadados(xFiltro, xValidade ,xOrdem : Integer; FORNECE : STRING);
  public
    { Public declarations }
     procedure chamatela( xFiltro, xValidade , xOrdem : Integer;  FORNECE : STRING);

  end;

var
  TRelProduto: TTRelProduto;

implementation

uses
 DMPrincipal, Funcoesdb;

{$R *.dfm}


procedure TTRelProduto.carregadados(xFiltro: Integer; xValidade : Integer ;xOrdem: Integer; FORNECE: string);
begin
  with QProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.PRECO ');
    SQL.Add(', P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, P.COD_FORNECEDOR, F.NOME');
    SQL.Add('FROM PRODUTO P');
    SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    // FILTRAR ATIVO OU INATIVO
    case xFiltro of
      0: SQL.Add('WHERE P.ATIVO = 1');
      1: SQL.Add('WHERE P.ATIVO = 0');
    end;
    // Filtrar por produto com ou sem validade
    case xValidade of
      1: SQL.Add('And P.SEM_VALIDADE = 1');
      2: SQL.Add('And P.SEM_VALIDADE = 0');
    end;

    // Busca por Fornecedor
    if FORNECE <> '' then
      SQL.Add('AND F.COD_FORNECEDOR = '+ StringTextSql(FORNECE));
    // ORDENA��O
    case xOrdem of
      0: SQL.Add('ORDER BY COD_PRODUTO');
      1: SQL.Add('ORDER BY DESCRICAO');
      2: SQL.Add('ORDER BY P.PRECO DESC');    // MAIOR VALOR
      3: SQL.Add('ORDER BY P.PRECO');        // Menor valor
    end;
    //InputBox('','', SQL.Text);
    //ExecSQL;
    Open;

    FieldByName('PRECO').OnGetText := QProdutoPRECOGetText;
    FieldByName('SEM_VALIDADE').OnGetText := QProdutoSEM_VALIDADEGetText;
    FieldByName('ATIVO').OnGetText := QProdutoATIVOGetText;
    FieldByName('DATA_VALIDADE').OnGetText := QProdutoDATA_VALIDADEGetText;
  end;
end;

procedure TTRelProduto.chamatela( xFiltro,xValidade, xOrdem : Integer ;  FORNECE: STRING);
var aux : string;
begin
  TRelProduto := TTRelProduto.Create(Application);
  with TRelProduto do
  begin
    // Filtro
    case xFiltro of
      0:
      begin
        aux:= 'Filtrado por Ativo';
        RLPanel4.Borders.DrawRight := False;
        RLBDataValidade.Borders.DrawRight := False;
      end;
      1:
      begin
        rltitulo.Caption := 'Relat�rio de Produto inativo';
        RLPanel4.Borders.DrawRight := False;
        RLBDataValidade.Borders.DrawRight := False;
        aux:= 'Filtrado por Inativo';
      end;
      2:
      begin
        //RLLabel12.Borders.DrawRight := True;
        //rlbdSemValidade.Borders.DrawRight := True;
        RLLabel1.Visible := True;
        RLDBText3.Visible := True;
        aux:= 'Filtrado por Todos';
      end;
    end;
    // Validade de Produto
    case xValidade of
      1: aux:= aux + ', Produto sem validade,';
      2: aux:= aux + ', Produto com validade,';
    end;
    // ordena��o
    case xOrdem of
      0: aux:= aux + ' Ordenado por C�digo';
      1: aux:= aux + ' Ordenado por Nome';
      2: aux:= aux + ' Ordenado por Produto de Maior Valor';
      3: aux:= aux + ' Ordenado por Produto de Menor Valor';
    end;
    lbltitulo.Caption := aux;

    carregadados(xFiltro, xValidade ,xOrdem,  FORNECE);
    rlpProduto.PreviewModal;
  end;
  FreeAndNil(TRelProduto);
end;

procedure TTRelProduto.QProdutoATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if QProduto.FieldByName('ATIVO').AsBoolean = True then
    begin
      Text := 'Ativo';
    end
    else
      Text := 'Inativo';
  end
  else
    Text := '';
end;

procedure TTRelProduto.QProdutoDATA_VALIDADEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if  QProduto.FieldByName('DATA_VALIDADE').IsNull then
    begin
      RLBDataValidade.Font.Size := 8;
      Text:= 'N�o possui';
    end
    else
    begin
      RLBDataValidade.Font.Size := 9;
      Text:= QProduto.FieldByName('DATA_VALIDADE').Value ;
    end;
  end;
end;

procedure TTRelProduto.QProdutoPRECOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatFloat('0.00', QProduto.FieldByName('PRECO').AsFloat);
end;

procedure TTRelProduto.QProdutoSEM_VALIDADEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if QProduto.FieldByName('SEM_VALIDADE').AsBoolean = True then
    begin
      Text := 'S';
    end
    else
      Text := 'N';
  end
  else
    Text := '';
end;

end.
