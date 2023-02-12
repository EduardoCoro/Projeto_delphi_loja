unit RelCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, pngimage;

type
  TTRelCliente = class(TForm)
    rlpCliente: TRLReport;
    RLBand1: TRLBand;
    rlTitulo: TRLLabel;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    QCliente: TADOQuery;
    DsCliente: TDataSource;
    RLBand5: TRLBand;
    RLImage1: TRLImage;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand6: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel2: TRLPanel;
    V: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel4: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel5: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel6: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel7: TRLPanel;
    rbdResult: TRLDBResult;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    RLPanel8: TRLPanel;
    rlbStatus: TRLLabel;
    RLPanel9: TRLPanel;
    rlbdAtivo: TRLDBText;
    lbltitulo: TRLLabel;
    procedure QClienteATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    {procedure carregadados}
    procedure carregadados(xFiltro, xOrdem : Integer);
  public
    { Public declarations }
    procedure chamatela(xFiltro, xOrdem : Integer);

  end;

var
  TRelCliente: TTRelCliente;

implementation

uses
 DMPrincipal;

{$R *.dfm}

procedure TTRelCliente.chamatela(xFiltro, xOrdem : Integer);
var aux : string;
begin
  TRelCliente := TTRelCliente.Create(Application);
  with TRelCliente do
  begin
    //aux := rlTitulo.Caption;
    {chamar carregadados}
    carregadados(xFiltro, xOrdem);
    case xFiltro of
      0:
      begin
        aux := 'Filtrado por Ativo ';
      end;
      1:
      begin
        aux := 'Filtrado por Inativo ';
      end;
      2:
      begin
        RLPanel3.Borders.DrawRight := True;
        RLPanel6.Borders.DrawRight := True;
        rlbStatus.Visible := True;
        rlbdAtivo.Visible := True;
        aux := ' Filtrado por Todos ';
      end;
    end;
    // subtitulo
    case xOrdem of
      0: aux := aux + ' Ordenado por C�digo';
      1: aux := aux +' Ordenado por Nome';
    end;
    lbltitulo.Caption:= aux;
    rlpCliente.PreviewModal;
  end;
  FreeAndNil(TRelCliente);
end;

procedure TTRelCliente.QClienteATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QCliente.IsEmpty then
  begin
    if QCliente.FieldByName('ATIVO').AsBoolean = True then
    begin
      Text := 'ATIVO';
    end
    else
      Text := 'INATIVO';
  end
  else
    Text := '';
end;

procedure TTRelCliente.carregadados(xFiltro: Integer; xOrdem: Integer);
begin
  with QCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_CLIENTE, NOME, RG, ATIVO');
    SQL.Add('FROM CLIENTE');
    // FILTRAR ATIVO OU INATIVO
    case xFiltro of
      0: SQL.Add('WHERE ATIVO = 1');
      1: SQL.Add('WHERE ATIVO = 0');
    end;
    // ORDENA��O
    case xOrdem of
      0: SQL.Add('ORDER BY COD_CLIENTE');
      1: SQL.Add('ORDER BY NOME');
    end;
    //InputBox('','', SQL.Text);
    //ExecSQL;
    Open;
    FieldByName('ATIVO').OnGetText := QClienteATIVOGetText;
  end;
end;

end.
