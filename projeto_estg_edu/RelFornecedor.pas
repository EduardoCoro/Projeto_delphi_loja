unit RelFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, pngimage, RLReport;

type
  TTRelFornecedor = class(TForm)
    rlpFornecedor: TRLReport;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel2: TRLPanel;
    V: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLBand3: TRLBand;
    RLPanel4: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel5: TRLPanel;
    RLPanel6: TRLPanel;
    RLDBText3: TRLDBText;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    QFornecedor: TADOQuery;
    dtsFornecedor: TDataSource;
    RLPanel8: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel9: TRLPanel;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLBand7: TRLBand;
    RLPanel10: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand8: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    RLPanel7: TRLPanel;
    lblStatus: TRLLabel;
    RLPanel11: TRLPanel;
    rlbdAtivo: TRLDBText;
    RLDBText2: TRLDBText;
    lbltitulo: TRLLabel;
    procedure rlbdAtivoBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
    procedure carregadados(xFiltro, xOrdem : Integer);
  public
    { Public declarations }
    procedure chamatela(xFiltro, xOrdem : Integer);

  end;

var
  TRelFornecedor: TTRelFornecedor;

implementation

uses
 DMPrincipal, Funcoesdb;

{$R *.dfm}

procedure TTRelFornecedor.carregadados(xFiltro: Integer; xOrdem: Integer);
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_FORNECEDOR, NOME , DDD ,TELEFONE, CNPJ, ATIVO');
    SQL.Add('FROM FORNECEDOR');
    // FILTRAR POR ATIVO
    case xFiltro of
      0: SQL.Add('WHERE ATIVO = 1');
      1: SQL.Add('WHERE ATIVO = 0');
    end;
    // ORDENAR AS BUSCAS
    case xOrdem of
      0: SQL.Add('ORDER BY COD_FORNECEDOR');
      1: SQL.Add('ORDER BY NOME');
    end;
    Open;

    //FieldByName('ATIVO').OnGetText := QFornecedorATIVOGetText;
  end;
end;

procedure TTRelFornecedor.chamatela(xFiltro: Integer; xOrdem: Integer);
var aux : string;
begin
  TRelFornecedor := TTRelFornecedor.Create(Application);
  with TRelFornecedor do
  begin
    case xFiltro of
      0: aux := 'Filtrado por Ativo' ;
      1: aux := 'Filtrado por Inativo ';
      2:
      begin
        lblStatus.Visible := True;
        rlbdAtivo.Visible := True;
        RLPanel8.Borders.DrawRight := True;
        RLPanel9.Borders.DrawRight := True;
         aux := 'Filtrado por Todos ';
      end;
    end;

    // subtitulo
    case xOrdem of
      0: aux := aux + ' Ordenado por C�digo';
      1: aux := aux + ' Ordenado por Nome';
    end;
    lbltitulo.Caption := aux;

    carregadados(xFiltro, xOrdem);
    rlpFornecedor.PreviewModal;
  end;
  FreeAndNil(TRelFornecedor);
end;

procedure TTRelFornecedor.rlbdAtivoBeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  if not QFornecedor.IsEmpty then
  begin
    if QFornecedor.FieldByName('ATIVO').AsBoolean = True then
    begin
      AText := 'ATIVO';
    end
    else
      AText := 'INATIVO';
  end
  else
    AText := '';
end;

end.
