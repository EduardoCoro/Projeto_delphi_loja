unit GraficoListCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, TeEngine, Series, TeeProcs, Chart, DBChart, StdCtrls,
  Buttons, ExtCtrls;

type
  TTGraficoListCliente = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoCli: TDBChart;
    QCliente: TADOQuery;
    Series1: TPieSeries;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure GraficoCliPageChange(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaDados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TGraficoListCliente: TTGraficoListCliente;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoListCliente.Chamatela;
begin
  TGraficoListCliente := TTGraficoListCliente.Create(Application);
  with TGraficoListCliente do
  begin
    CarregaDados;
    // trava botoes?
    if (GraficoCli.Page) = (GraficoCli.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;

    if QCliente.IsEmpty then
    begin
      EnviaMensagem('Registro n�o encontrado!','Informa��o',mtInformation, [mbOK]);
      exit;
    end
    else
      ShowModal;
  end;
  FreeAndNil(TGraficoListCliente);
end;

procedure TTGraficoListCliente.CarregaDados;
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
    Label1.Caption := IntToStr(GraficoCli.Page) + '/' + IntToStr(GraficoCli.NumPages);
  end;
end;

procedure TTGraficoListCliente.btnAntesClick(Sender: TObject);
begin
  if GraficoCli.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoCli.PreviousPage;
    if GraficoCli.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoListCliente.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoListCliente.btnDepoisClick(Sender: TObject);
begin
  if GraficoCli.Page = GraficoCli.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoCli.NextPage;
    btnAntes.Enabled := True;
     if GraficoCli.Page = GraficoCli.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoListCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTGraficoListCliente.GraficoCliPageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoCli.Page) + '/' + IntToStr(GraficoCli.NumPages);
end;

end.
