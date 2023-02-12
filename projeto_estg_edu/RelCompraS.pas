unit RelCompraS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, pngimage, DB, ADODB;

type
  TTRelCompraS = class(TForm)
    rlpCompraS: TRLReport;
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
    lbltitulo: TRLLabel;
    DsCompra: TDataSource;
    QCompra: TADOQuery;
    procedure RLDBText1BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
    procedure Carregadados(xDataIni, xDataFim : TDateTime);
  public
    { Public declarations }
    procedure Chamatela(xDataIni, xDataFim : TDateTime);
  end;

var
  TRelCompraS: TTRelCompraS;

implementation

uses
 Funcoes, Funcoesdb;

{$R *.dfm}

procedure TTRelCompraS.Chamatela(xDataIni: TDateTime; xDataFim: TDateTime);
begin
  TRelCompraS := TTRelCompraS.Create(Application);
  with TRelCompraS do
  begin
    Carregadados(xDataIni,xDataFim);
    //Verifica se t�m registro
    if QCompra.FieldByName('QUANTIDADE').AsInteger = 0 then
    begin
      EnviaMensagem('Nehum registro encontrado!','', mtInformation, [mbOK]);
      Exit;
    end
    else
      rlpCompraS.PreviewModal;

  end;
  FreeAndNil(TRelCompraS);
end;

procedure TTRelCompraS.RLDBText1BeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin
  Atext := 'R$ ' + FormatFloat('0.00', QCompra.FieldByName('Total').AsFloat);
end;

procedure TTRelCompraS.Carregadados(xDataIni: TDateTime; xDataFim: TDateTime);
begin
  with QCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SET DATEFORMAT YMD ');
    SQL.Add('SELECT COUNT(*) AS QUANTIDADE, SUM(VALOR_TOTAL) AS TOTAL');
    SQL.Add('FROM COMPRA ');
    SQL.Add('WHERE ');
    if (xDataIni <> 0) and (xDataFim <> 0) then
    begin
      SQL.Add('DATA  '+ DataBetweenSQL(xDataIni,xDataFim));
      lbltitulo.Caption :='A data de ' + DateToStr(xDataIni) + ' � ' + DateToStr(xDataFim);
    end
    else
    begin
      if xDataIni <> 0 then
      begin
        SQL.Add('DATA  = '+ DataSQL(xDataIni));
        lbltitulo.Caption :='A data de ' + DateToStr(xDataIni);
      end
      else
      begin
        SQL.Add('DATA  = '+ DataSQL(xDataFim));
        lbltitulo.Caption :='A data de ' + DateToStr(xDataFim);
      end;
    end;
    Open;
  end;
end;

end.
