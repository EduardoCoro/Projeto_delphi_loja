unit RelEstoqueS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB;

type
  TTRelEstoqueS = class(TForm)
    rlpProduto: TRLReport;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    RLBand2: TRLBand;
    RLPanel4: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel5: TRLPanel;
    RLLabel2: TRLLabel;
    RLBand3: TRLBand;
    RLPanel2: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel3: TRLPanel;
    RLDBText1: TRLDBText;
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
    RLBand4: TRLBand;
    RLPanel1: TRLPanel;
    RLDBResult1: TRLDBResult;
    DsProduto: TDataSource;
    QProduto: TADOQuery;
    lblFornecedor: TRLLabel;
  private
    { Private declarations }
    procedure CarregaDados(xcodfornece : integer);
    procedure CarregaFornecedor(xcodfornece : integer);
  public
    { Public declarations }
    procedure Chamatela(xcodfornece : integer);
  end;

var
  TRelEstoqueS: TTRelEstoqueS;

implementation

uses
 Funcoesdb, Funcoes, DMPrincipal;

{$R *.dfm}

procedure TTRelEstoqueS.Chamatela(xcodfornece: Integer);
begin
  TRelEstoqueS := TTRelEstoqueS.Create(Application);
  with TRelEstoqueS do
  begin
    //CARREGAR O NOME DE FORNECEDOR
    if xcodfornece <> 0 then
      CarregaFornecedor(xcodfornece)
    else
      lblFornecedor.Caption := 'Todos os Produtos que possui ou teve movimenta��o no estoque';
    // carregar dados dos estoque
    CarregaDados(xcodfornece);
    if QProduto.IsEmpty then
    begin
      EnviaMensagem('Registro n�o encontrado!','Informa��o...', mtInformation, [mbok]);
      exit;
    end
    else
      rlpProduto.PreviewModal;
  end;
  FreeAndNil(TRelEstoqueS);
end;

procedure TTRelEstoqueS.CarregaDados(xcodfornece: Integer);
begin
  with QProduto do
  begin
    Close;
    SQL.Clear;
    // ATIVO
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ESTOQUE > 0 AND ATIVO = 1');
    //SE POSSUI FORNECEDOR
    if xcodfornece <> 0 then
      SQL.Add('AND COD_FORNECEDOR = ' + IntegerTextSql(xcodfornece) );
    // INATIVO
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ESTOQUE <= 0 AND ATIVO = 1');
    //SE POSSUI FORNECEDOR
    if xcodfornece <> 0 then
      SQL.Add('AND COD_FORNECEDOR = ' + IntegerTextSql(xcodfornece) );

    Open;
  end;
end;

procedure TTRelEstoqueS.CarregaFornecedor(xcodfornece: Integer);
begin
  with TDMPrincipal.QAux do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT NOME');
    SQL.Add('FROM FORNECEDOR');
    SQL.Add('WHERE COD_FORNECEDOR = '+ IntegerTextSql(xcodfornece));

    Open;
    lblFornecedor.Caption := 'Produtos do fornecedor: '+ FieldByName('NOME').AsString;
  end;
end;

end.
