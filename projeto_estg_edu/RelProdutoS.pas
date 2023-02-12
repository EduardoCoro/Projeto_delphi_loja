unit RelProdutoS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB;

type
  TTRelProdutoS = class(TForm)
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
  private
    { Private declarations }
    procedure Carregadados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TRelProdutoS: TTRelProdutoS;

implementation

{$R *.dfm}

procedure TTRelProdutoS.Chamatela;
begin
  TRelProdutoS := TTRelProdutoS.Create(Application);
  with TRelProdutoS do
  begin
    Carregadados;
    rlpProduto.PreviewModal;
  end;
  FreeAndNil(TRelProdutoS);
end;

procedure TTRelProdutoS.Carregadados;
begin
  with QProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ATIVO = 1 ');
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE ');
    SQL.Add('FROM PRODUTO ');
    SQL.Add('WHERE ATIVO = 0 ');
    Open;
  end;//SELECT 'ATIVO' AS STATUS,  COUNT(COD_PRODUTO) AS QUANTIDADE
end;

end.
