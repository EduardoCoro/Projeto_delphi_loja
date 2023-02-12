unit FiltroRelTopFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit, ExtCtrls, Buttons, rxToolEdit;

type
  TTFiltroRelTopFuncionario = class(TForm)
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    FiltroRelCliente: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label2: TLabel;
    edDataFim: TDateEdit;
    edDataInicio: TDateEdit;
    rgTipoRel: TRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnImprimirClick(Sender: TObject);
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
  TFiltroRelTopFuncionario: TTFiltroRelTopFuncionario;

implementation

uses
 RelTopFornecedor, Funcoes, GraficoTopFornecedor;

{$R *.dfm}

procedure TTFiltroRelTopFuncionario.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroRelTopFuncionario.FormCreate(Sender: TObject);
begin
  edDataFim.Date := date();
  edDataInicio.Date := StrToDate('01/' + MesAno(date()));;
end;

procedure TTFiltroRelTopFuncionario.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroRelTopFuncionario.FormShow(Sender: TObject);
begin
  edDataInicio.MaxDate := Now;
  edDataFim.MaxDate := Now;
end;

procedure TTFiltroRelTopFuncionario.btnImprimirClick(Sender: TObject);
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
      0: TRelTopFornecedor.Chamatela(edDataInicio.Date, edDataFim.Date); // sintetico
      1: TGraficoFornecedor.Chamatela(edDataInicio.Date, edDataFim.Date);//grafico
    end;
  end;
end;

procedure TTFiltroRelTopFuncionario.Chamatela;
begin
  TFiltroRelTopFuncionario := TTFiltroRelTopFuncionario.Create(Application);
  with TFiltroRelTopFuncionario do
  begin
    ShowModal;
  end;
  FreeAndNil(TFiltroRelTopFuncionario);
end;

procedure TTFiltroRelTopFuncionario.edDataFimExit(Sender: TObject);
begin
  if (edDataFim.Date <= 0) and (edDataFim.Text <> '  /  /    ') then
  begin
    EnviaMensagem('Data Inv�lida!','Aten��o...',mtInformation,[mbOK]);
    edDataFim.Clear;
    if edDataFim.CanFocus then
      edDataFim.SetFocus;
    exit;
  end;
  if edDataFim.Date > date() then
  begin
    EnviaMensagem('A Data � maior que a data atual!','Aten��o...',mtInformation,[mbOK]);
    edDataFim.Clear;
    exit;
  end;
end;

procedure TTFiltroRelTopFuncionario.edDataInicioExit(Sender: TObject);
begin
  if (edDataInicio.Date <= 0) and (edDataInicio.Text <> '  /  /    ') then
  begin
    EnviaMensagem('Data Inv�lida!','Aten��o...',mtInformation,[mbOK]);
    edDataInicio.Clear;
    if edDataInicio.CanFocus then
      edDataInicio.SetFocus;
    exit;
  end;
  if edDataInicio.Date > date() then
  begin
    EnviaMensagem('A Data � maior que a data atual!','Aten��o...',mtInformation,[mbOK]);
    edDataInicio.Clear;
    if edDataInicio.CanFocus then
      edDataInicio.SetFocus;
    exit;
  end;
end;

end.
