unit Fornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Mask, Buttons, Grids, DBGrids, DBCtrls, ExtCtrls,
  DB, ADODB;

type
  TTFornecedor = class(TForm)
    Panel1: TPanel;
    rbFiltro: TRadioGroup;
    DBNavigator1: TDBNavigator;
    DBGrid: TDBGrid;
    Panel2: TPanel;
    lblDescricao: TLabel;
    btnLimpar: TBitBtn;
    edPesquisa: TMaskEdit;
    TPanel: TPanel;
    btnFechar: TBitBtn;
    btnconsulta: TBitBtn;
    btnRemover: TBitBtn;
    btnedit: TBitBtn;
    btnInserir: TBitBtn;
    btnTransferir: TButton;
    ImageList1: TImageList;
    QFornecedor: TADOQuery;
    dsFornecedor: TDataSource;
    Label1: TLabel;
    lblRegistro: TLabel;
    procedure btnLimparClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure edPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure QFornecedorATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure btnTransferirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnInserirClick(Sender: TObject);
    procedure btnconsultaClick(Sender: TObject);
    procedure btneditClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure rbFiltroClick(Sender: TObject);
  private
    { Private declarations }
    CanClose : Boolean;
    ColunaPesquisa : String;
    //procedure ApplicationEvents1Exception;

  public
    { Public declarations }
    function Chamatela(Transferir : Boolean = False):Integer;
  end;

var
  TFornecedor: TTFornecedor;

implementation

uses
 Funcoesdb, Funcoes, DMPrincipal, FornecedorC;

{$R *.dfm}

procedure TTFornecedor.btnconsultaClick(Sender: TObject);
begin
  if QFornecedor.IsEmpty then
  begin
    EnviaMensagem('Selecione um Fornecedor para Consultar!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;
  TFornecedorC.ChamaTela('C', QFornecedor.FieldByName('COD_FORNECEDOR').AsInteger);
end;

{procedure TTFornecedor.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
     if Pos('Invalid input', E.Message) > 0 then
     begin
        meCNPJ_CPF.Clear; <<---- "MaskEdit"
        Close;
     end;
end; }

procedure TTFornecedor.btneditClick(Sender: TObject);
 var Codigo : integer;
begin
  if QFornecedor.IsEmpty then
  begin
    EnviaMensagem('Selecione um Fornecedor para Editar!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;

  Codigo := TFornecedorC.ChamaTela('E', QFornecedor.FieldByName('COD_FORNECEDOR').AsInteger);

  if Codigo > 0 then
  begin
    if QFornecedor.Active then
      QFornecedor .Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QFornecedor do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_FORNECEDOR, NOME, DDD ,TELEFONE, CNPJ , ATIVO');
        SQL.Add('FROM FORNECEDOR');
        SQL.Add('WHERE COD_FORNECEDOR = ' + IntegerTextSql(Codigo));
        Open;
      end;
    end;
    QFornecedor.Locate('COD_FORNECEDOR', Codigo, []);
  end;
end;

procedure TTFornecedor.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTFornecedor.btnInserirClick(Sender: TObject);
var Codigo : integer;
begin
  Codigo := TFornecedorC.ChamaTela('I', 0);
  if Codigo > 0 then
  begin
    if QFornecedor.Active then
      QFornecedor .Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QFornecedor do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_FORNECEDOR, NOME, DDD ,TELEFONE, CNPJ , ATIVO');
        SQL.Add('FROM FORNECEDOR');
        SQL.Add('WHERE COD_FORNECEDOR = ' + IntegerTextSql(Codigo));
        Open;

        FieldByName('ATIVO').OnGetText := QFornecedorATIVOGetText;
        lblRegistro.Caption := IntToStr(QFornecedor.RecordCount);
      end;
    end;
    QFornecedor.Locate('COD_FORNECEDOR', Codigo, []);
  end;
end;

procedure TTFornecedor.btnLimparClick(Sender: TObject);
begin
  lblRegistro.Caption := '0';
  edPesquisa.Clear;
  edPesquisa.EditMask := '';
  edPesquisa.MaxLength := 0;
  QFornecedor.Close;
  if edPesquisa.CanFocus then
    edPesquisa.SetFocus;
end;

procedure TTFornecedor.btnRemoverClick(Sender: TObject);
function GetCondicao():string; // FUNÇÃO P/ PEGAR A SINTAXE DE ACORDO COM O QUE USUÁRIO PREENCHEU
  var aux : string;
  begin
    if edPesquisa.Tag = 0 then
    begin
      aux := 'WHERE ';
      edPesquisa.Tag := 1;
    end
    else
      aux := 'AND ';
    Result := aux;
  end;
begin
  if QFornecedor.IsEmpty then
  begin
    EnviaMensagem('Selecione o Fornecedor para Remover!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;

  CanClose := False;

  if not Empty(TemReferencia('FORNECEDOR',QFornecedor.FieldByName('COD_FORNECEDOR').AsString, 'ESTAGIARIO_EDU')) then
  begin
    //somente para inativos
    if QFornecedor.FieldByName('ATIVO').AsBoolean = False then
    begin
      EnviaMensagem('O Fornecedor possui referência no sistema, impossível excluí-lo','Aviso...',mtInformation,[mbOK]);
      exit;
    end;
    if MessageBox(Handle,'O Fornecedor possui referência no sistema, impossível excluí-lo, deseja inativa-lo?','Aviso!',MB_ICONQUESTION+MB_YESNO) = IDYES then
    begin
      //cliente inativo
      with TDMPrincipal.QAux do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE FORNECEDOR');
        SQL.ADD('SET ATIVO = 0');
        SQL.Add('WHERE COD_FORNECEDOR = '+ IntegerTextSql(QFornecedor.FieldByName('COD_FORNECEDOR').AsInteger));
        ExecSQL;
      end;
      EnviaMensagem('Fornecedor está inativo!', 'Status de Fornecedor', mtInformation, [mbOK]);
    end;
  end
  else
  begin
    if MessageBox(Handle,'Deseja realmente Excluir o Fornecedor?','Deletar Fornecedor! ',MB_ICONQUESTION+MB_YESNO)=IDYES then
    begin
      CanClose := True;
    end;
  end;

  if CanClose = True then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;                         //'COD_FORNECEDOR'
      SQL.Clear;
      SQL.Add('DELETE FORNECEDOR');
      SQL.Add('WHERE COD_FORNECEDOR = '+ IntToStr(QFornecedor.FieldByName('COD_FORNECEDOR').AsInteger) );
      ExecSQL;

      EnviaMensagem('Fornecedor removido!', 'Fornecedor deletado!', mtInformation, [mbOK]);
    end;
  end;
  // atualizar a grid
  if ColunaPesquisa = '' then
    ColunaPesquisa:='NOME';

  edPesquisa.Tag := 0;
  with QFornecedor do
  begin  // inserçao do comando no sql
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_FORNECEDOR, NOME, DDD ,TELEFONE, CNPJ, ATIVO');
    SQL.Add('FROM FORNECEDOR');
    // IDENTIFICAR A SELEÇÃO DE ATIVO,INATIVO
    case rbFiltro.ItemIndex of
      0 : SQL.Add(GetCondicao + ' ATIVO = 1');
      1 : SQL.Add(GetCondicao + ' ATIVO = 0');
    end;

    if edPesquisa.Text <> '*' then
    begin                                      // codigo do cliente
      if (ColunaPesquisa = 'COD_FORNECEDOR')  or (ColunaPesquisa = 'DDD') or (ColunaPesquisa = 'CNPJ') or (ColunaPesquisa = 'TELEFONE') then
        SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(edPesquisa.Text))
      else
        SQL.Add(GetCondicao + ' NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
    end;

    Open;
    FieldByName('ATIVO').OnGetText := QFornecedorATIVOGetText;
    lblRegistro.Caption := IntToStr(QFornecedor.RecordCount);

    if  DBGrid.CanFocus then
      DBGrid.SetFocus;
  end;
end;

procedure TTFornecedor.btnTransferirClick(Sender: TObject);
begin
  if QFornecedor.IsEmpty then
  begin
    if edPesquisa.CanFocus then
      edPesquisa.SetFocus;
    EnviaMensagem('Selecione um Fornecedor para transferir!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;
  if rbFiltro.ItemIndex = 1 then
  begin
    EnviaMensagem('Produto está Inativo!','Produto inválido!', mtInformation, [mbOK]);
      exit;
  end;

  if not QFornecedor.IsEmpty then
  begin
    btnTransferir.Tag := 2;
    Close;
  end;
end;

procedure TTFornecedor.DBGridDblClick(Sender: TObject);
begin
  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTFornecedor.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if btnTransferir.Visible = True then
  begin
    if (key = #13)then
    begin
      btnTransferir.Click;
    end;
  end;
end;

procedure TTFornecedor.DBGridTitleClick(Column: TColumn);
var
  I : integer;
begin
  ColunaPesquisa := Column.FieldName;

  if Column.Title.Caption <> 'STATUS' then
  begin
    lblDescricao.Caption := 'Digite um(a) ' + Column.Title.Caption + ' ou * para todos e Tecle Enter';
    btnLimpar.Click;
    edPesquisa.EditMask := '';
    for I := 0 to DBGrid.Columns.Count - 1 do
    begin
      if DBGrid.Columns[I].FieldName = ColunaPesquisa then
        DBGrid.Columns[I].Title.Font.Color := clRed
      else
        DBGrid.Columns[I].Title.Font.Color := clBlack;
    end;
  end;
end;

procedure TTFornecedor.edPesquisaKeyPress(Sender: TObject; var Key: Char);
function GetCondicao():string; // FUNÇÃO P/ PEGAR A SINTAXE DE ACORDO COM O QUE USUÁRIO PREENCHEU
  var aux : string;
  begin
    if edPesquisa.Tag = 0 then
    begin
      aux := 'WHERE ';
      edPesquisa.Tag := 1;
    end
    else
      aux := 'AND ';
    Result := aux;
  end;
begin
  //Key := UpCase(Key);    // tratamento para letras Maiusculas
  edPesquisa.Tag :=0;

  // tratemento de maskara de CNPJ
  if (ColunaPesquisa = 'CNPJ') then
  begin
     {if not CharInSet(key, [#8, #13, #86, #42, #46, #48..#57]) then}
    if (not(key in [#8, #13, #86, #42, #46, #48..#57])) or (key = '.') then
      Key := #0;

    if Empty(LimpaCaracter(edPesquisa.Text)) or (edPesquisa.Text = '*')  then
   //if edPesquisa.Text <> '*'  then
    begin
      edPesquisa.EditMask := '';
      EdPesquisa.MaxLength := 1;
    end
    else
    begin
      edPesquisa.EditMask:= '99\.999\.999/9999\-99;1;';
   //   edPesquisa.MaxLength := 19;
    end;
  end;

  if (Key = '*') and Empty(edPesquisa.Text) then
  begin
    edPesquisa.MaxLength := 1;
  end
  else
  begin
    if edPesquisa.Text <> '*' then
    begin
      if (ColunaPesquisa = 'COD_FORNECEDOR') OR (ColunaPesquisa = 'TELEFONE') OR (ColunaPesquisa = 'DDD') OR (ColunaPesquisa = 'CNPJ')  then
      begin
        if ColunaPesquisa = 'COD_FORNECEDOR' then
          edPesquisa.MaxLength := 9;
        if ColunaPesquisa = 'TELEFONE' then
          edPesquisa.MaxLength := 16;
        if ColunaPesquisa = 'DDD' then
          edPesquisa.MaxLength := 3;
        if key in [ 'ç','á', 'à' , 'ã', 'ó', 'ò' , 'õ' , 'ô', 'â', '°', '}' , 'ª' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'¨' ,'&' , ')' , '(' ,'§' ,'ª' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '´','-','='] then
          Key:=#0;
        Case Key of
          'a'..'z':
            Key:=#0;
          'A'..'Z':
            Key:=#0;
          '/':
            Key:=#0;
        end;
      end;

      if ColunaPesquisa = 'NOME' then
      begin
        edPesquisa.MaxLength := 0;
        if key in ['1','2','3','4','5','6','7','8','9','0',',', '+', '-', '/' , '.','ª',  '}' , 'ª' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'¨' ,'&' , ')' , '(' ,'§' ,'ª' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '´','-','=' ] then
          key :=#0;
      end;
    end;
  end;

  if (key = #13) and not Empty(edPesquisa.Text)  then   // identificação do botão ENTER
  begin
    with QFornecedor do
    begin  // inserçao do comando no sql
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR, NOME, DDD ,TELEFONE, CNPJ, ATIVO');
      SQL.Add('FROM FORNECEDOR');
      // IDENTIFICAR A SELEÇÃO DE ATIVO,INATIVO
      case rbFiltro.ItemIndex of
        0 : SQL.Add(GetCondicao + ' ATIVO = 1');
        1 : SQL.Add(GetCondicao + ' ATIVO = 0');
      end;

      if edPesquisa.Text <> '*' then
      begin                                      // codigo do cliente
        if (ColunaPesquisa = 'COD_FORNECEDOR') or (ColunaPesquisa = 'DDD') or (ColunaPesquisa = 'CNPJ') or (ColunaPesquisa = 'TELEFONE') then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(edPesquisa.Text))
        else
          SQL.Add(GetCondicao + ' NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
      end;

      Open;
      //registros vazio
      if IsEmpty then
      begin
        btnLimpar.Click;
        EnviaMensagem('Registro não encontrado!','',mtInformation, [mbOK]);
        exit;
      end;

      FieldByName('ATIVO').OnGetText := QFornecedorATIVOGetText;
      lblRegistro.Caption := IntToStr(QFornecedor.RecordCount);

      if  DBGrid.CanFocus then
        DBGrid.SetFocus;
    end;
  end;
end;

procedure TTFornecedor.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'NOME';
end;

procedure TTFornecedor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case key of
    VK_F2:
    begin
      if (btnInserir.Enabled) and (btnInserir.Visible) then
        btnInserir.Click;
    end;
    VK_F3:
    begin
      if (btnconsulta.Enabled) and (btnconsulta.Visible) then
        btnconsulta.Click;
    end;
    VK_F4:
    begin
      if (btnedit.Enabled) and (btnedit.Visible) then
        btnedit.Click;
    end;
    VK_F8:
    begin
      if (btnRemover.Enabled) and (btnRemover.Visible) then
        btnRemover.Click;
    end;
    VK_ESCAPE:
    begin
      if (btnFechar.Enabled) and (btnFechar.Visible) then
        btnFechar.Click;
    end;
    VK_F6:
    begin
      if (btnLimpar.Enabled) and (btnLimpar.Visible) then
        btnLimpar.Click;
    end;
    VK_F12:
    begin
      if (btnTransferir.Enabled) and (btnTransferir.Visible) then
        btnTransferir.Click;
    end;
  end;
end;

procedure TTFornecedor.QFornecedorATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QFornecedor.IsEmpty then
  begin
    if QFornecedor.FieldByName('ATIVO').AsBoolean = True then
      Text := 'Ativo'
    else
      Text := 'Inativo';
  end
  else
    Text := '';
end;

procedure TTFornecedor.rbFiltroClick(Sender: TObject);
begin
  rbFiltro.Refresh;
  QFornecedor.Close;
  edPesquisa.Clear;
  edPesquisa.SetFocus;
end;

function TTFornecedor.Chamatela(Transferir : Boolean = False):Integer;
begin
  TFornecedor := TTFornecedor.Create(Application);
  with TFornecedor do
  begin
    if Transferir then
    begin
      btnTransferir.Visible := True;
      btnInserir.Visible := False;
      btnconsulta.Visible:= False;
      btnedit.Visible :=False;
      btnRemover.Visible:=False;
      rbFiltro.Visible := False;
    end;
    ShowModal;
    if btnTransferir.Tag = 2 then
      Result := QFornecedor.FieldByName('COD_FORNECEDOR').AsInteger
    else
      Result := 0;
  end;
  FreeAndNil(TFornecedor);
end;

end.
