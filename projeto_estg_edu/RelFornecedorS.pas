unit RelFornecedorS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RLReport, pngimage;

type
  TTRelFornecedorS = class(TForm)
    rlpFornecedor: TRLReport;
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
    DsFornecedor: TDataSource;
    QFornecedor: TADOQuery;
  private
    { Private declarations }
    procedure Carregadados;
  public
    { Public declarations }
    procedure Chamatela;

  end;

var
  TRelFornecedorS: TTRelFornecedorS;

implementation

{$R *.dfm}

procedure TTRelFornecedorS.Carregadados;
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_FORNECEDOR) AS QUANTIDADE ');
    SQL.Add( 'FROM FORNECEDOR ');
    SQL.Add('WHERE ATIVO = 1 ');
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_FORNECEDOR) AS QUANTIDADE ');
    SQL.Add('FROM FORNECEDOR ');
    SQL.Add('WHERE ATIVO = 0 ');
    Open;
  end;
end;

procedure  TTRelFornecedorS.Chamatela;
begin
  TRelFornecedorS := TTRelFornecedorS.Create(Application);
  with TRelFornecedorS do
  begin
   Carregadados;
   rlpFornecedor.PreviewModal;
  end;
  FreeAndNil(TRelFornecedorS);
end;

end.
