unit GraficoEstoque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, DB, DBClient, ADODB,
  TeEngine, Series, TeeProcs, Chart, DBChart;

type
  TTGraficoEstoque = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoProd: TDBChart;
    Series1: TBarSeries;
    QEstoque: TADOQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GraficoProdPageChange(Sender: TObject);

  private
    { Private declarations }
    procedure Carregadados(xcodFornecedor : integer; XcodProdutos : TStringlist;  xfiltro, xordem : integer);
  public
    { Public declarations }
    procedure Chamatela(xcodFornecedor : integer; XcodProdutos : TStringlist; xfiltro, xordem : integer);
  end;
                                  //rgFiltro.ItemIndex, rgOrdem.ItemIndex
var
  TGraficoEstoque: TTGraficoEstoque;

implementation

uses
 Funcoes, Funcoesdb, DMPrincipal, Fornecedor, Produto;

{$R *.dfm}

procedure TTGraficoEstoque.Chamatela(xcodFornecedor: Integer; XcodProdutos: TStringList; xfiltro: Integer; xordem: Integer);
begin
  TGraficoEstoque := TTGraficoEstoque.Create(Application);
  with TGraficoEstoque do
  begin
    Carregadados(xcodFornecedor,XcodProdutos, xfiltro,xordem);
    // TRAVAR OS BOT�ES
    if (GraficoProd.Page) = (GraficoProd.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;
    if QEstoque.IsEmpty then
    begin
      EnviaMensagem('Nenhum registro encontrado!','',mtInformation,[mbOK]);
      exit;
    end
    else    //CHAMAR TELA
      ShowModal;
  end;
  FreeAndNil(TGraficoEstoque);
end;

procedure TTGraficoEstoque.Carregadados(xcodFornecedor: Integer; XcodProdutos: TStringList; xfiltro: Integer; xordem: Integer);
var aux : integer;
begin
  aux := 0;
  with QEstoque do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.ESTOQUE  ,P.ATIVO, P.COD_FORNECEDOR, F.NOME ');
    SQL.Add('FROM PRODUTO P ');
    SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');

    // filtro condicao
    case xFiltro of
      0:
      begin
        SQL.Add( GetCondicao(aux)  + ' P.ATIVO = 1');
        aux := 1;
      end;
      1:
      begin
        SQL.Add( GetCondicao(aux) + ' P.ATIVO = 0');
        aux := 1;
      end;
    end;

    if xcodFornecedor <> 0 then
    begin
      SQL.Add( GetCondicao(aux) + ' P.COD_FORNECEDOR = '+ IntegerTextSql(xcodFornecedor));
      aux :=1;
      if XcodProdutos.DelimitedText <> '' then
        SQL.Add( GetCondicao(aux) +  ' P.COD_PRODUTO IN ('+ XcodProdutos.DelimitedText + ')' );
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
    Open;

    Label1.Caption := IntToStr(GraficoProd.Page) + '/' + IntToStr(GraficoProd.NumPages);
  end;
end;

procedure TTGraficoEstoque.btnAntesClick(Sender: TObject);
begin
  if GraficoProd.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoProd.PreviousPage;
    if GraficoProd.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoEstoque.btnCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TTGraficoEstoque.btnDepoisClick(Sender: TObject);
begin
  if GraficoProd.Page = GraficoProd.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoProd.NextPage;
    btnAntes.Enabled := True;
     if GraficoProd.Page = GraficoProd.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoEstoque.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if(btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTGraficoEstoque.GraficoProdPageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoProd.Page) + '/' + IntToStr(GraficoProd.NumPages);
end;

end.
