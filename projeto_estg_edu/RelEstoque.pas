unit RelEstoque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RLReport, pngimage;

type
  TTRelEstoque = class(TForm)
    rlpProduto: TRLReport;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand1: TRLBand;
    lblT: TRLLabel;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel13: TRLPanel;
    rlb_fornecedor: TRLLabel;
    RLBand3: TRLBand;
    RLPanel6: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel7: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel8: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel14: TRLPanel;
    rlbdNome: TRLDBText;
    dtsProduto: TDataSource;
    QEstoque: TADOQuery;
    RLPanel4: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel5: TRLPanel;
    RLDBText5: TRLDBText;
    RLPanel9: TRLPanel;
    lbl_status: TRLLabel;
    RLPanel10: TRLPanel;
    rlbdAtivo: TRLDBText;
    RLBand4: TRLBand;
    RLPanel11: TRLPanel;
    rbdResult: TRLDBResult;
    RLBand6: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    lbltitulo: TRLLabel;
    procedure QEstoqueATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    //xcodProd : TStringlist;
    procedure carregadados(xcodProd : TStringlist;xFiltro, xOrdem, xEstoque : Integer; FORNECE : STRING; xOpcao : integer);
    procedure habilitacomponentes;
  public
    { Public declarations }
    procedure chamatela(xcodProd : TStringlist;xFiltro, xOrdem, xEstoque : Integer;  FORNECE : STRING; xOpcao : integer);
  end;

var
  TRelEstoque: TTRelEstoque;

implementation

uses
 DMPrincipal, Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTRelEstoque.chamatela(xcodProd : TStringlist;xFiltro, xOrdem, xEstoque : Integer;  FORNECE : STRING; xOpcao : integer);
var aux : string;
begin
  TRelEstoque := TTRelEstoque.Create(Application);
  with TRelEstoque do
  begin
    case xFiltro of
      0: aux:= 'Filtrado por Ativo ';
      1: aux:= 'Filtrado por Inativo ';
      2:
      begin
        aux:= 'Filtrado por Todos ';
        habilitacomponentes;
      end;
    end;
    // subtitulo
    case xOrdem of
      0: aux := aux + ' Ordenado por C�digo';
      1: aux := aux + ' Ordenado por Fornecedor';
      2: aux := aux + ' Ordenado por Produto';
      3: aux := aux + ' Ordenado por Produto de Maior Valor';
      4: aux := aux + ' Ordenado por Produto de Menor Valor';
    end;
    lbltitulo.Caption := aux;

    carregadados(xcodProd,xFiltro, xOrdem, xEstoque , FORNECE, xOpcao);

    if QEstoque.IsEmpty then
    begin
      EnviaMensagem('Registro n�o encotrado!', 'Informa��o...', mtInformation, [mbOK]);
      exit;
    end
    else
      rlpProduto.PreviewModal;
  end;
  FreeAndNil(TRelEstoque);
end;

procedure TTRelEstoque.habilitacomponentes;
begin
  lbl_status.Visible := True;
  rlbdAtivo.Visible := True;
  rlb_fornecedor.Borders.DrawRight := True;
  rlbdNome.Borders.DrawRight := True;
end;

procedure TTRelEstoque.QEstoqueATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QEstoque.IsEmpty then
  begin
    if QEstoque.FieldByName('ATIVO').AsBoolean = True then
    begin
      Text := 'ATIVO';
    end
    else
      Text := 'INATIVO';
  end
  else
    Text := '';
end;

procedure TTRelEstoque.carregadados(xcodProd : TStringlist;xFiltro, xOrdem, xEstoque : Integer; FORNECE : STRING; xOpcao : integer);
begin
  with QEstoque  do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.ESTOQUE  ,P.ATIVO, P.COD_FORNECEDOR, F.NOME');
    SQL.Add('FROM PRODUTO P');
    SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    // filtro condicao
    case xFiltro of
      0: SQL.Add('WHERE P.ATIVO = 1');
      1: SQL.Add('WHERE P.ATIVO = 0');
    end;
    // Fornecedor
    if FORNECE <> '' then
      SQL.Add('AND F.COD_FORNECEDOR = '+ StringTextSql(FORNECE));
    // Produto
    if xcodProd.DelimitedText <> '' then
      SQL.Add('AND P.COD_PRODUTO IN ('+ xcodProd.DelimitedText +')');

    if xOpcao <> -1 then
    begin
      // op��o do tipo de busca
      case  xOpcao of
        0: SQL.Add('AND P.ESTOQUE >= '+ IntegerTextSql(xEstoque)); // Maior que
        1: SQL.Add('AND P.ESTOQUE <= '+ IntegerTextSql(xEstoque)); // Menor que
      end;
    end
    else
    begin
      // buscar por estoque
      if (xEstoque <> -1) then
        SQL.Add('AND P.ESTOQUE = '+ IntegerTextSql(xEstoque));
    end;

    // ordena��o
    case xOrdem of
      0: SQL.Add('ORDER BY P.COD_PRODUTO'); // codigo produto
      1: SQL.Add('ORDER BY P.DESCRICAO'); // nome PRODUTO
      2: SQL.Add('ORDER BY P.COD_FORNECEDOR'); // CODIGO DE FORNECEDOR
      3: SQL.Add('ORDER BY F.NOME'); //  NOME DE FORNECEDOR
      4: SQL.Add('ORDER BY P.ESTOQUE DESC'); // maior valor
      5: SQL.Add('ORDER BY P.ESTOQUE'); // menor valor
    end;
    OPEN;

    FieldByName('ATIVO').OnGetText := QEstoqueATIVOGetText;
  end;
end;

end.
