unit RelFornecedorProdutoS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RLReport, pngimage;

type
  TTRelFornecedorProdutoS = class(TForm)
    rlCompraS: TRLReport;
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
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    rlTitulo: TRLLabel;
    lblFornecedor: TRLLabel;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel1: TRLLabel;
    QFornecedor: TADOQuery;
    dtsFornecedor: TDataSource;
    RLPanel2: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel3: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel4: TRLPanel;
    RLDBText2: TRLDBText;
    RLBand4: TRLBand;
    RLPanel5: TRLPanel;
    RLDBResult1: TRLDBResult;
  private
    { Private declarations }
    procedure CarregaDados(xcodigo : string);
  public
    { Public declarations }
    procedure ChamaRelatorio(xcodigo : string);
  end;

var
  TRelFornecedorProdutoS: TTRelFornecedorProdutoS;

implementation

uses
 DMPrincipal, Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTRelFornecedorProdutoS.ChamaRelatorio(xcodigo: string);
begin
  TRelFornecedorProdutoS := TTRelFornecedorProdutoS.Create(Application);
  with TRelFornecedorProdutoS do
  begin
    CarregaDados(xcodigo);
    if QFornecedor.IsEmpty then
    begin
      EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbOK]);
      exit;
    end
    else
      rlCompraS.PreviewModal;
  end;
end;

procedure TTRelFornecedorProdutoS.CarregaDados(xcodigo: string);
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT F.NOME ,COUNT(P.COD_PRODUTO) AS PRODUTOS ');
    SQL.Add('FROM FORNECEDOR F ');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
    // se tiver fornecedor selecionado
    if xcodigo <> '' then
      SQL.Add('WHERE F.COD_FORNECEDOR = ' + IntegerTextSql(StrToInt(xcodigo)));

    SQL.Add('GROUP BY F.NOME ');
    Open;
  end;
end;

end.
