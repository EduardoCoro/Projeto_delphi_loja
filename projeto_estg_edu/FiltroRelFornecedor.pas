unit FiltroRelFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TTFiltroRelFornecedor = class(TForm)
    FiltroRelCliente: TPanel;
    rgOrdem: TRadioGroup;
    rgFiltro: TRadioGroup;
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    rgTipo: TRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgTipoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure chamatela;
  end;

var
  TFiltroRelFornecedor: TTFiltroRelFornecedor;

implementation

uses
 RelFornecedor, RelFornecedorS, GraficoListFornecedor;

{$R *.dfm}

procedure TTFiltroRelFornecedor.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroRelFornecedor.btnImprimirClick(Sender: TObject);
begin
  case rgTipo.ItemIndex of
    0: TRelFornecedor.chamatela(rgFiltro.ItemIndex, rgOrdem.ItemIndex) ;
    1: TRelFornecedorS.Chamatela; // sintetico
    2: TGraficoListFornecedor.Chamatela; //grafico
  end;
end;

procedure TTFiltroRelFornecedor.chamatela;
begin
  TFiltroRelFornecedor := TTFiltroRelFornecedor.Create(Application);
  with TFiltroRelFornecedor do
  begin
    ShowModal;
  end;
  FreeAndNil(TFiltroRelFornecedor);
end;

procedure TTFiltroRelFornecedor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F5:
    begin
      if (btnImprimir.Enabled) and (btnImprimir.Visible) then
        btnImprimir.Click;
    end;
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTFiltroRelFornecedor.rgTipoClick(Sender: TObject);
begin
  if (rgTipo.ItemIndex = 1) or ( rgTipo.ItemIndex =  2) then
  begin
    rgFiltro.Enabled:= False;
    rgOrdem.Enabled := False;
  end
  else
  begin
    rgFiltro.Enabled:= True;
    rgOrdem.Enabled := True;
  end;
end;

end.
