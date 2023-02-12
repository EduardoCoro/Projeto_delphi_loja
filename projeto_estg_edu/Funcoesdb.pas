unit Funcoesdb;

interface

uses SysUtils, Variants, DB, ADODB, Forms,
     RLReport, RLTypes,
     Dialogs, PanelX, Funcoes, Controls, Windows, DBGrids, StdCtrls, jpeg,
     DBChart ,{ VarConst,} DateUtils, AdvProgressBar, Classes , CheckLst,
     StrUtils, CheckListBoxValues, ExtCtrls, QRCtrls, pngimage, Graphics,
     DBClient;

Function StringTextSql( xTexto:Variant ):String ;

function BooleanTextSql(xValor: Variant): String;

function TemReferencia(Tabela, Valor_PK, xBanco: String; TabsIgnorar: String = ''): String;

Function IntegerTextSql( xValor:Variant ):String ;

function ExecutaSQL(LinhaSQL: String): Boolean;

function EmptyTable(LinhaSQL: String): Boolean;

function GetCodigoIdentity( TabelaNome:String = '' ): Integer;

Function DateTextSql( xData:TDateTime; xTipoHora:char = 'N' ):String ;

function CommitSQL( xADOQuery: TADOQuery ; pRodarExec:Boolean ):Boolean ;

implementation

uses
 DMPRINCIPAL;

Function StringTextSql( xTexto:Variant ):String;
Begin
  if (xTexto = '') or (xTexto = null) then
   Result := 'NULL'
  else
    Result := QuotedStr(xTexto) ;
end ;

function ExecutaSQL(LinhaSQL: String): Boolean;
var ADOQueryAux : TADOQuery;
begin
  ADOQueryAux := TADOQuery.Create(Application);
  ADOQueryAux.CommandTimeout := 0;
  ADOQueryAux.Connection := TDMPrincipal.ADOConexao;

  with ADOQueryAux do
  begin
    ADOQueryAux.Tag := 0;
    Close;
    SQL.Clear;
    SQL.add(LinhaSQL);
    try
      ExecSQL;
    except
      ADOQueryAux.Tag := 1;
    end;
    if (ADOQueryAux.Tag = 0) then
    begin
      commitsql(ADOQueryAux, True) ;
    end;
    Result := (ADOQueryAux.Tag = 0);
    Free;
  end;
end;

function TemReferencia(Tabela, Valor_PK, xBanco: String; TabsIgnorar: String = ''): String;
var ADOQueryAux : TADOQuery;
    Reconectou, OcorreuErro: Boolean;
    Aux, ClassErro, MsgErro: String;
    Label InicioPesquisa;
begin
  ADOQueryAux := TADOQuery.Create(Application);
  try
    try
      with ADOQueryAux do
      begin
        CommandTimeout := 0;
        Connection := TDMPrincipal.ADOConexao;
        ExecutaSQL('USE ' + xBanco);
        InicioPesquisa:
        Reconectou := False;
        OcorreuErro := False;
        ClassErro := '';
        MsgErro := '';
        try
          try
            Close;
            SQL.Clear;
            SQL.Add('SELECT COLUNA.NAME AS COLUNA, OBJECT_NAME(FK.PARENT_OBJECT_ID) AS TABELA ');
            SQL.Add('FROM SYS.FOREIGN_KEYS AS FK INNER JOIN SYS.FOREIGN_KEY_COLUMNS AS COLUNAFK ');
            SQL.Add('ON COLUNAFK.CONSTRAINT_OBJECT_ID = FK.OBJECT_ID ');
            SQL.Add('INNER JOIN SYS.COLUMNS AS COLUNA ON COLUNAFK.PARENT_COLUMN_ID = COLUNA.COLUMN_ID ');
            SQL.Add('AND COLUNAFK.PARENT_OBJECT_ID = COLUNA.OBJECT_ID ');
            SQL.Add('WHERE OBJECT_NAME(FK.REFERENCED_OBJECT_ID) = ' + StringTextSql(Tabela));
            if not Empty(TabsIgnorar) then
              SQL.Add('AND OBJECT_NAME(FK.PARENT_OBJECT_ID) NOT IN ' + TabsIgnorar);
            SQL.Add('ORDER BY TABELA ');
            Open;
          except
             on E: Exception do
            begin
              OcorreuErro := True;
              ClassErro := E.ClassName;
              MsgErro := E.Message;
            end;
          End;
        finally
          if OcorreuErro then
          begin
            if (MsgErro = 'Falha de conexão') or
                 (MsgErro = '[DBNETLIB][ConnectionWrite (send()).]Erro geral de rede. Verifique a documentação da rede')
                 or (MsgErro = '[DBNETLIB][ConnectionWrite (WrapperWrite()).]Erro geral de rede. Verifique a documentação da rede')
                 or (MsgErro = 'Database 8 cannot be autostarted during server shutdown or startup') then
            begin
                  Reconectou := True;
            end
            else
            begin
              EnviaMensagem('Ocorreu um erro ao Verificar as Referencias do Banco!' + #13 +
                            'Classe do erro: ' + ClassErro + ';' + #13 +
                            'Mensagem do erro: ' + MsgErro + '.', 'Aviso...', mtWarning, [mbOK]);
            end;
          end;
        end;
        if Reconectou then
           goto InicioPesquisa;
        Aux := '';
        if not IsEmpty then
        begin
          First;
          while not Eof do
          begin
            if not EmptyTable('SELECT ' + FieldByName('COLUNA').AsString + ' FROM ' + FieldByName('TABELA').AsString +
                   ' WHERE ' + FieldByName('COLUNA').AsString + ' = ' + StringTextSql(Valor_PK)) then
            begin
              Aux := FieldByName('TABELA').AsString;
              Break;
            end;
            Next;
          end;
        end;
        Close;
      end;
    except
      Aux := '';
    end;
  finally
    FreeAndNil(ADOQueryAux);
    ExecutaSQL('USE ESTAGIARIO_EDU');
  end;
  Result := Aux;
end;

function EmptyTable(LinhaSQL: String): Boolean;
var ADOQueryAux : TADOQuery;
  Reconectou, OcorreuErro: Boolean;
  ClassErro, MsgErro: String;
  Label InicioPesquisa;
begin
  // testa se a tabela indicada no select está vazia
  ADOQueryAux := TADOQuery.Create(Application);
  ADOQueryAux.CommandTimeout := 0;
  ADOQueryAux.Connection := TDMPrincipal.ADOConexao;

  with ADOQueryAux do
  begin
    InicioPesquisa:
    Reconectou := False;
    OcorreuErro := False;
    ClassErro := '';
    MsgErro := '';
    try
      try
        Close;
        SQL.Clear;
        SQL.Add(LinhaSQL);
        Open;
      except
        on E: Exception do
        begin
          OcorreuErro := True;
          ClassErro := E.ClassName;
          MsgErro := E.Message;
        end;
      End;
    finally
      if OcorreuErro then
      begin
        if (MsgErro = 'Falha de conexão') or
             (MsgErro = '[DBNETLIB][ConnectionWrite (send()).]Erro geral de rede. Verifique a documentação da rede')
             or (MsgErro = '[DBNETLIB][ConnectionWrite (WrapperWrite()).]Erro geral de rede. Verifique a documentação da rede')
             or (MsgErro = 'Database 8 cannot be autostarted during server shutdown or startup') then
        begin
              Reconectou := True;
        end
        else
        begin
          EnviaMensagem('Ocorreu um erro ao Carregar Informações do Banco!' + #13 + 'Classe do erro: ' + ClassErro + ';' + #13 +'Mensagem do erro: ' + MsgErro + '.', 'Aviso...', mtWarning, [mbOK]);
        end;
      end;
    end;
    if Reconectou then
       goto InicioPesquisa;

    Result := IsEmpty;
    Close;
    FreeAndNil(ADOQueryAux);
  end;
end;

Function IntegerTextSql( xValor:Variant ):String ;
Begin
  if ( xValor = null ) then
    Result := 'NULL'
  Else Begin
    Result := StringTextSql( IntToStr(xValor)  ) ;
  End;
End;

function GetCodigoIdentity(TabelaNome:String ): Integer;
var
  ADOQueryAux : TADOQuery;
  BancoDefault: String;
begin
  ADOQueryAux := TADOQuery.Create(Application);
  ADOQueryAux.Connection := DMPRINCIPAL.TDMPrincipal.ADOConexao;
  BancoDefault := DMPRINCIPAL.TDMPrincipal.ADOConexao.DefaultDatabase;
  with ADOQueryAux do
  begin
    if (Not Empty(TabelaNome)) then
      SQL.Add('SELECT @@Identity as CODIGO');
    //
    Open;
    //
    if (ADOQueryAux.FieldByName('CODIGO').AsVariant <> null) then
      Result := ADOQueryAux.FieldByName('CODIGO').AsInteger
    else
      Result := 0;
    //
    Close;
  end;
  FreeAndNil(ADOQueryAux);
end;

function BooleanTextSql(xValor: Variant): String;
begin
  if xValor = Null then
    Result := 'NULL'
  else
  begin
    if xValor = True then
      Result := StringTextSql('1')
    Else
      Result := StringTextSql('0');
  end;
end;

Function DateTextSql( xData:TDateTime; xTipoHora:char ):String ;
Begin
  if xData = 0 then
    Result := 'NULL'
  else
  if xTipoHora = 'T' then
  begin
    Result := DataSQLT(xData);
  end
  else
    Result := DataSQL(xData);
End;

function CommitSQL( xADOQuery: TADOQuery ; pRodarExec:Boolean ):Boolean ;
Begin
  if pRodarExec then
  Begin
    with xADOQuery do
    begin
      ExecSQL ;
    end;
  End;
End;

end.
