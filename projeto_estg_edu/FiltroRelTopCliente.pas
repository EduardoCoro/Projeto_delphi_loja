unit FiltroRelTopCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit, Buttons, ExtCtrls, rxToolEdit;

type
  TTFiltroRelTopCli = class(TForm)
    FiltroRelCliente: TPanel;
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label2: TLabel;
    edDataFim: TDateEdit;
    edDataInicio: TDateEdit;
    rgTipoRel: TRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edDataFimExit(Sender: TObject);
    procedure edDataInicioExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TFiltroRelTopCli: TTFiltroRelTopCli;

implementation

uses
 RelTopCliente, Funcoesdb, Funcoes, GraficoTopCliente;

{$R *.dfm}

procedure TTFiltroRelTopCli.btnImprimirClick(Sender: TObject);
begin
  //verifica se est� correto os dados
  //ValidarDataInicialFinal(edDataInicio, edDataFim);
  if not ((edDataInicio.Date <> 0) or (edDataFim.Date <> 0) ) then
  begin
    if not (edDataInicio.Date <> 0) then
    begin
      MessageBox(Handle,'Preencha corretamente o campo da data inicial!','Informa��o..',MB_ICONQUESTION+MB_OK);
      if edDataInicio.CanFocus then
        edDataInicio.SetFocus;
    end
    else
    begin
      MessageBox(Handle,'Preencha corretamente o campo da data fim!','Informa��o..',MB_ICONQUESTION+MB_OK);
      if edDataFim.CanFocus then
        edDataFim.SetFocus;
    end;
    exit;
  end
  else
  begin
    //data inicio
    if edDataInicio.Date > date() then
    begin
      EnviaMensagem('Data maior que a atual!','',mtInformation,[mbOK]);
      edDataInicio.Clear;
      if edDataInicio.CanFocus then
        edDataInicio.SetFocus;
      exit;
    end;
    if (edDataInicio.Date <= 0) and (edDataInicio.Text <> '  /  /    ') then
    begin
      EnviaMensagem('Data Inv�lida!','',mtInformation,[mbOK]);
      edDataInicio.Clear;
      if edDataInicio.CanFocus then
        edDataInicio.SetFocus;
      exit;
    end;

    //data fim
    if edDataFim.Date > date() then
    begin
      EnviaMensagem('Data maior que a atual!','',mtInformation,[mbOK]);
      edDataFim.Clear;
      if edDataFim.CanFocus then
        edDataFim.SetFocus;
      exit;
    end;
    if (edDataFim.Date <= 0) and (edDataFim.Text <> '  /  /    ') then
    begin
      EnviaMensagem('Data Inv�lida!','',mtInformation,[mbOK]);
      edDataFim.Clear;
      if edDataFim.CanFocus then
        edDataFim.SetFocus;
      exit;
    end;

    case rgTipoRel.ItemIndex of
      0: TRelTopCliente.Chamatela(edDataInicio.Date, edDataFim.Date); // anal�tico
      1: TGraficoTopCliente.Chamatela(edDataInicio.Date, edDataFim.Date); //grafico
    end;
  end;
end;

procedure TTFiltroRelTopCli.Chamatela;
begin
  TFiltroRelTopCli := TTFiltroRelTopCli.Create(Application);
  with TFiltroRelTopCli do
  begin
    ShowModal;
  end;
  FreeAndNil(TFiltroRelTopCli);
end;

procedure TTFiltroRelTopCli.edDataFimExit(Sender: TObject);
begin
  if edDataFim.Date > date() then
  begin
    EnviaMensagem('Data maior que a atual!','',mtInformation,[mbOK]);
    edDataFim.Clear;
    if edDataFim.CanFocus then
      edDataFim.SetFocus;
  end;

  if (edDataFim.Date <= 0) and (edDataFim.Text <> '  /  /    ') then
  begin
    EnviaMensagem('Data Inv�lida!','',mtInformation,[mbOK]);
    edDataFim.Clear;
    if edDataFim.CanFocus then
      edDataFim.SetFocus;
  end;
end;

procedure TTFiltroRelTopCli.edDataInicioExit(Sender: TObject);
begin
  if edDataInicio.Date > date() then
  begin
    EnviaMensagem('Data maior que a atual!','',mtInformation,[mbOK]);
    edDataInicio.Clear;
    if edDataInicio.CanFocus then
      edDataInicio.SetFocus;
  end;

  if (edDataInicio.Date <= 0) and (edDataInicio.Text <> '  /  /    ') then
  begin
    EnviaMensagem('Data Inv�lida!','',mtInformation,[mbOK]);
    edDataInicio.Clear;
    if edDataInicio.CanFocus then
      edDataInicio.SetFocus;
  end;
end;

procedure TTFiltroRelTopCli.FormCreate(Sender: TObject);
begin
  edDataFim.Date := date();
  edDataInicio.Date := StrToDate('01/' + MesAno(date()));;
end;

procedure TTFiltroRelTopCli.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
    VK_F5:
    begin
      if (btnImprimir.Enabled) and (btnImprimir.Visible) then
        btnImprimir.Click;
    end;
  end;
end;

procedure TTFiltroRelTopCli.FormShow(Sender: TObject);
begin
  edDataInicio.MaxDate := Now;
  edDataFim.MaxDate := Now;
end;

procedure TTFiltroRelTopCli.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

end.
