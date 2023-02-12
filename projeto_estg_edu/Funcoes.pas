unit Funcoes;

interface

uses SysUtils, Dialogs, Controls, StdCtrls, Forms ,Classes, MaskUtils, rxToolEdit;


function Empty( Dados: string ): boolean;

function SomenteNumero(Key: Char): Char;

function ColocaPonto( valor: String): String;

function EnviaMensagem(Mensagem, Tipo: String; DlgType: TMsgDlgType; DlgButtonsType: TMsgDlgButtons): TModalResult;

function GetCondicao(var tag: Integer ):string;

function FormataValor(str : string) : string;

function ValidarData( Data: string ):Boolean;

function ValidaCPF(Dados: string): boolean;

function SomenteLetra(Key: Char): Char;

function SomenteLetraNumero(Key: Char): Char;

function Bissexto(AYear: Integer): Boolean;

function ValidarDataInicialFinal(DateEditIni, DateEditFin: TDateEdit): Boolean;

function DataSQL(Data: TDateTime): String;

function SomenteNumero2(str : string) : string;

function DataSQLT(Data: TDateTime ): String;

function DiasDoMes(AYear, AMonth: Integer): Integer;

function DataBetweenSQL(DataIni, DataFin: TDateTime): String;

function LimpaCaracter(Dados: String): String;

function MesAno( Data: TDateTime ): string;

function Mes( Data: TDateTime ): string;

function StrZero(N: longint; Tamanho: integer): string;

function Repl(C: string; Tamanho: integer): string;


type
   Formato = (Money);



implementation



function Empty( Dados: string ): boolean;
begin
  if Length( Trim( Dados ) ) = 0 then
    Empty := True
  else
    Empty := False;
end;

function Mes( Data: TDateTime ): string;
var
  sAno, sMes, sDia: Word;
begin
  DecodeDate( Data, sAno, sMes, sDia );
  Mes := StrZero( sMes, 2 );
end;

function MesAno( Data: TDateTime ): string;
var
  sAno, sMes, sDia: Word;
begin
  { Formato de data 01/1999 }
  DecodeDate( Data, sAno, sMes, sDia );
  Result := StrZero( sMes, 2 ) + '/' + Copy( StrZero( sAno, 4 ), 1, 4 );
end;

function ValidaCPF(Dados: string): boolean;
var CPF: string;
    Soma, Contar, Digito: Integer;
begin
  try
    Dados := LimpaCaracter(Dados);
    if (Length(Dados) <> 11) or
       (Dados = '00000000000') or (Dados = '11111111111') or
       (Dados = '22222222222') or (Dados = '33333333333') or
       (Dados = '44444444444') or (Dados = '55555555555') or
       (Dados = '66666666666') or (Dados = '77777777777') or
       (Dados = '88888888888') or (Dados = '99999999999') then
    begin
      Result := False;
      Exit;
    end;
    Cpf := Copy(Dados,1,9);
    Soma := 0;
    for contar := 1 to 9 do
      Soma := Soma + (StrToInt(Copy(CPF,Contar,1))*(11-Contar));
    Digito := 11 - (Soma Mod 11);
    if Digito in [10,11] then
      CPF := CPF + '0'
    else
      CPF := CPF + IntToStr(Digito);
    Soma:=0;
    for contar := 1 to 10 do
      Soma := Soma + (StrToInt(Copy(CPF,Contar,1))*(12-Contar));
    Digito := 11 - (Soma Mod 11);
    if Digito in [10,11] then
      CPF := CPF + '0'
    else
      CPF := CPF + IntToStr(Digito);
    if Dados <> CPF then
      Result := False
    else
      Result := True;
  except on econverterror do
    Result := False;
  end;
end;

function ValidarDataInicialFinal(DateEditIni, DateEditFin: TDateEdit): Boolean;
begin
  Result := False;
  if DateEditIni.Date = 0 then
  begin
    EnviaMensagem('� necess�rio informar a Data Inicial para continuar!', 'Informa��o...', mtInformation, [mbOK]);
    if DateEditIni.CanFocus then
      DateEditIni.SetFocus
  end
  else
  if DateEditFin.Date = 0 then
  begin
    EnviaMensagem('� necess�rio informar a Data Final para continuar!', 'Informa��o...', mtInformation, [mbOK]);
    if DateEditFin.CanFocus then
      DateEditFin.SetFocus
  end
  else
  if DateEditIni.Date > DateEditFin.Date then
  begin
    EnviaMensagem('A Data Inicial deve ser menor ou igual a Data Final!', 'Informa��o...', mtInformation, [mbOK]);
    if DateEditIni.CanFocus then
      DateEditIni.SetFocus
  end
  else
    Result := True;
end;

function SomenteNumero(Key: Char): Char;
begin
  if (not (Key in ['*',#13, #8, #46, #48..#57])) or (Key = '.') then
    Key := #0;
  Result := Key;
end;

function SomenteLetraNumero(Key: Char): Char;
begin
  if (not (Key in ['*',#32, #13, #8, #46, #48..#57 ,'A'..'Z', 'a'..'z'])) or (key = '.') then
    Key := #0;
  Result := Key;
end;

function SomenteLetra(Key: Char): Char;
begin
  if (not (Key in ['*',#32, #13, #8, #46, 'A'..'Z', 'a'..'z'])) or (key = '.') then
    Key := #0;
  Result := Key;
end;

function ValidarData( Data: string ): Boolean;
var
  I, Y, UltDiaAux, DiaAux, MesAux: Integer;
  Teste: Boolean;
  sDia, sMes, sAno, SMesAno: String;
begin
  Teste := True;
  I := Length(Data);

  for Y := 1 to I do
   if not(Data[Y] in ['0','1','2','3','4','5','6','7','8','9','/']) then
     Teste := False;

  if Teste = True then
  begin
    if (Length(Data) = 8) then
    begin
      sDia := Copy(Data, 1, 2);
      sMes := Copy(Data, 4, 2);
      sAno := Copy(Data, 7, 2);
      SMesAno := Copy(Data, 4, 5);
    end
    else
    begin
      if (Length(Data) = 10) then
      begin
        sDia := Copy(Data, 1, 2);
        sMes := Copy(Data, 4, 2);
        sAno := Copy(Data, 7, 4);
        SMesAno := Copy(Data,4, 7);
      end
      else
        Teste := False;
    end;
  end;

  if Teste = True then
  begin
    MesAux := StrtoInt(SMes);
    if (MesAux <= 12) And (MesAux > 0) then
    begin
      UltDiaAux := DiasDoMes(StrToInt(sAno), StrToInt(sMes));
      DiaAux := StrtoInt(Sdia);
      if (DiaAux > UltDiaAux) or (DiaAux < 1) then
        Teste := False;
    end
    else
      Teste := False;
  end;
  ValidarData := Teste;
end;

function DiasDoMes(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and Bissexto(AYear) then
    Inc(Result);
end;

function DataBetweenSQL(DataIni, DataFin: TDateTime): String;
begin
  Result := ' BETWEEN ' + DataSQL(DataIni) + ' AND ' + DataSQL(DataFin);
end;

function Bissexto(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

function ColocaPonto( valor: String): String;
var
 i: Integer;
begin
  for i :=0 to Length(valor) do
    if valor[i] =',' then
      valor[i] := '.' ;

  ColocaPonto:=   valor;
end;


function EnviaMensagem(Mensagem, Tipo: String; DlgType: TMsgDlgType; DlgButtonsType: TMsgDlgButtons): TModalResult;
var
  i: Integer;
begin
  with CreateMessageDialog(Mensagem, DlgType, DlgButtonsType) do
  try
    for i:= 0 to ComponentCount-1 do
     if Components[i] is TButton then
    begin
      with TButton(Components[i]) do
      case ModalResult of
        mrOk:     Caption:= 'Ok';
        mrCancel: Caption:= 'Cancelar';
        mrAbort:  Caption:= 'Abortar';
        mrRetry:  Caption:= 'Repetir';
        mrIgnore: Caption:= 'Ignorar';
        mrYes:    Caption:= 'Sim';
        mrNo:     Caption:= 'N�o';
      end;
    end;
    Caption:= Tipo;
    Result:= ShowModal;
  finally
    Free;
  end;
end;


function GetCondicao(var tag: Integer ):string; // FUN��O P/ PEGAR A SINTAXE DE ACORDO COM O QUE USU�RIO PREENCHEU
  var aux : string;
begin
  if tag = 0 then
  begin
    aux := 'WHERE ';
    Tag := 1;
  end
  else
    aux := 'AND ';
  Result := aux;
end;

function SomenteNumero2(str : string) : string;
var
    x : integer;
begin
  Result := '';
  for x := 0 to Length(str) - 1 do
    if (str[x] In ['0'..'9']) then
      Result := Result + str[x];
end;

function FormataValor(str : string) : string;
begin
  if Str = '' then
    Str := '0';

  try
    Result := FormatFloat('#,##0.00', strtofloat(str) / 100);
  except
    Result := FormatFloat('#,##0.00', 0);
  end;
end;

function DataSQL(Data : TDateTime ) : String;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Data) + ' 00:00:00');
end;

function DataSQLT(Data: TDateTime ): String;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss', Data));// + ' '+TimeToStr(Data) );
end;

function StrZero(N: longint; Tamanho: integer): string;
var
  Conteudo: string;
  Diferenca: longint;
begin
  Conteudo := IntToStr( N );
  Diferenca := Tamanho - Length( Conteudo );
  if Diferenca > 0 then
    Conteudo := Repl( '0', Diferenca ) + Conteudo;
  StrZero := Conteudo;
end;

function Repl(C: string; Tamanho: integer): string;
var
  Conteudo: string;
  Contar: integer;
begin
  Conteudo := '';
  for Contar := 1 to Tamanho do
  begin
    Conteudo := Conteudo + C;
    Application.ProcessMessages;
  end;
  Repl := Conteudo;
end;

function LimpaCaracter(Dados: String): String;
var Linha: String;
    Tam, i : Integer;
begin
  Linha:= '';
  Tam := Length(Dados);
  for i := 1 to Tam do
    if (Dados[I] in ['0','1','2','3','4','5','6','7','8','9'])then
      Linha := Linha + Dados[i];
  Result := Linha;
end;

end.
