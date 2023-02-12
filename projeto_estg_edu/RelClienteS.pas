unit RelClienteS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, pngimage;

type
  TTRelClienteS = class(TForm)
    rlpCliente: TRLReport;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
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
    DsCliente: TDataSource;
    QCliente: TADOQuery;
    RLBand4: TRLBand;
    RLPanel2: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel1: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLPanel3: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel4: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel5: TRLPanel;
    RLLabel2: TRLLabel;
  private
    { Private declarations }
    procedure Carregadados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TRelClienteS: TTRelClienteS;

implementation

uses
 DMPrincipal, Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTRelClienteS.Chamatela;
begin
  TRelClienteS := TTRelClienteS.Create(Application);
  with TRelClienteS do
  begin
    Carregadados;
    rlpCliente.PreviewModal;
  end;
  FreeAndNil(TRelClienteS);
end;

procedure TTRelClienteS.Carregadados;
begin
  with QCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_CLIENTE) AS QUANTIDADE ');
    SQL.Add('FROM CLIENTE ');
    SQL.Add('WHERE ATIVO = 1 ');
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_CLIENTE) AS QUANTIDADE ');
    SQL.Add('FROM CLIENTE ');
    SQL.Add('WHERE ATIVO = 0 ');
    Open;
  end;
end;

end.
