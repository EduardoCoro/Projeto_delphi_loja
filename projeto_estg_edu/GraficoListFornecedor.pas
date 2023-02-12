unit GraficoListFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, TeEngine, Series, TeeProcs, Chart, DBChart, StdCtrls,
  Buttons, ExtCtrls;

type
  TTGraficoListFornecedor = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnCancelar: TBitBtn;
    btnAntes: TBitBtn;
    btnDepois: TBitBtn;
    GraficoFor: TDBChart;
    Series1: TPieSeries;
    QFornecedor: TADOQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDepoisClick(Sender: TObject);
    procedure btnAntesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GraficoForPageChange(Sender: TObject);
  private
    { Private declarations }
    procedure Carregadados;
  public
    { Public declarations }
    procedure Chamatela;
  end;

var
  TGraficoListFornecedor: TTGraficoListFornecedor;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTGraficoListFornecedor.Chamatela;
begin
  TGraficoListFornecedor := TTGraficoListFornecedor.Create(Application);
  with TGraficoListFornecedor do
  begin
    Carregadados;
     // trava botoes?
    if (GraficoFor.Page) = (GraficoFor.NumPages) then
    begin
      btnAntes.Enabled := False;
      btnDepois.Enabled := False;
    end;
    if QFornecedor.IsEmpty then
    begin
      EnviaMensagem('Registro n�o encontrado!','Informa��o...', mtInformation, [mbOK]);
      exit;
    end
    else
      ShowModal;
  end;
end;

procedure TTGraficoListFornecedor.Carregadados;
begin
  with QFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ''ATIVO'' AS STATUS,  COUNT(COD_FORNECEDOR) AS QUANTIDADE ');
    SQL.Add('FROM FORNECEDOR ');
    SQL.Add('WHERE ATIVO = 1 ');
    SQL.Add('UNION ALL ');
    SQL.Add('SELECT  ''INATIVO'' AS STATUS,  COUNT(COD_FORNECEDOR) AS QUANTIDADE ');
    SQL.Add('FROM FORNECEDOR ');
    SQL.Add('WHERE ATIVO = 0 ');
    Open;
    Label1.Caption := IntToStr(GraficoFor.Page) + '/' + IntToStr(GraficoFor.NumPages);
  end;
end;

procedure TTGraficoListFornecedor.btnAntesClick(Sender: TObject);
begin
  if GraficoFor.Page = 1 then
    btnAntes.Enabled := False
  else
  begin
    btnDepois.Enabled := True;
    GraficoFor.PreviousPage;
    if GraficoFor.Page = 1 then
      btnAntes.Enabled := False;
  end;
end;

procedure TTGraficoListFornecedor.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoListFornecedor.btnDepoisClick(Sender: TObject);
begin
  if GraficoFor.Page = GraficoFor.NumPages then
    btnDepois.Enabled := False
  else
  begin
    GraficoFor.NextPage;
    btnAntes.Enabled := True;
     if GraficoFor.Page = GraficoFor.NumPages then
       btnDepois.Enabled := False;
  end;
end;

procedure TTGraficoListFornecedor.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TTGraficoListFornecedor.GraficoForPageChange(Sender: TObject);
begin
  Label1.Caption := IntToStr(GraficoFor.Page) + '/' + IntToStr(GraficoFor.NumPages);
end;

end.
