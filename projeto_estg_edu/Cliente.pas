unit Cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DB, ADODB, DBCtrls,
  ImgList, Mask;

type
  TTCliente = class(TForm)
    TPanel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    QCliente: TADOQuery;
    dsCliente: TDataSource;
    DBGrid: TDBGrid;
    btnFechar: TBitBtn;
    btnconsulta: TBitBtn;
    btnRemover: TBitBtn;
    btnedit: TBitBtn;
    btnInserir: TBitBtn;
    btnLimpar: TBitBtn;
    rbFiltro: TRadioGroup;
    lblDescricao: TLabel;
    btnTransferir: TButton;
    DBNavigator1: TDBNavigator;
    ImageList1: TImageList;
    edPesquisa: TMaskEdit;
    lblRegistro: TLabel;
    Label1: TLabel;
    procedure btnInserirClick(Sender: TObject);
    procedure btnconsultaClick(Sender: TObject);
    procedure btneditClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure edPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure rbFiltroClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTransferirClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure btnTransferirEnter(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure QClienteATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  private
    { Private declarations }
    CanClose : Boolean;
    ColunaPesquisa : String;
  public
    { Public declarations }
    function ChamaTela(Transferir : Boolean = False):Integer;
  end;

var
  TCliente: TTCliente;

implementation

uses DMPRINCIPAL, Funcoes, Funcoesdb, ClienteC;

{$R *.dfm}
procedure TTCliente.btnconsultaClick(Sender: TObject);
begin
  if QCliente.IsEmpty then
  begin
    EnviaMensagem('Selecione um Cliente para Consultar!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;
  TClienteC.ChamaTela('C', QCliente.FieldByName('COD_CLIENTE').AsInteger);
end;

procedure TTCliente.btneditClick(Sender: TObject);
  var Codigo : Integer;
begin
  if QCliente.IsEmpty then
  begin
    EnviaMensagem('Selecione um Cliente para Editar!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;

  Codigo :=  TClienteC.ChamaTela('E', QCliente.FieldByName('COD_CLIENTE').AsInteger);

  if Codigo > 0 then
  begin
    if QCliente.Active then
      QCliente.Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QCliente do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_CLIENTE, NOME, RG, CPF, ATIVO');
        SQL.Add('FROM CLIENTE');
        SQL.Add('WHERE COD_CLIENTE = ' + IntegerTextSql(Codigo));
        Open;
      end;
    end;
    QCliente.Locate('COD_CLIENTE', Codigo, []);
  end;
end;

procedure TTCliente.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTCliente.btnInserirClick(Sender: TObject);
var Codigo : Integer;
begin
  Codigo := TClienteC.ChamaTela('I', 0);
  if Codigo > 0 then
  begin
    if QCliente.Active then
      QCliente.Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QCliente do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_CLIENTE, NOME, RG, CPF, ATIVO');
        SQL.Add('FROM CLIENTE');
        SQL.Add('WHERE COD_CLIENTE = ' + IntegerTextSql(Codigo));
        Open;
        FieldByName('ATIVO').OnGetText := QClienteATIVOGetText;
        lblRegistro.Caption := IntToStr(QCliente.RecordCount);
      end;
    end;
    QCliente.Locate('COD_CLIENTE', Codigo, []);
  end;
end;

procedure TTCliente.btnLimparClick(Sender: TObject);
begin
  lblRegistro.Caption := '0';
  edPesquisa.Clear;
  QCliente.Close;
  if edPesquisa.CanFocus then
    edPesquisa.SetFocus;
end;

procedure TTCliente.btnRemoverClick(Sender: TObject);
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
  if QCliente.IsEmpty then
  begin
    EnviaMensagem('Selecione o cliente para Remover!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;

  //NOME:= QCliente.FieldByName('NOME').AsString;
  CanClose := False;

  if not Empty(TemReferencia('CLIENTE',QCliente.FieldByName('COD_CLIENTE').AsString, 'ESTAGIARIO_EDU')) then
  begin
    //somente para inativos
    if QCliente.FieldByName('ATIVO').AsBoolean = False then
    begin
       EnviaMensagem('O cliente possui referência no sistema, impossível excluí-lo','Aviso...',mtInformation,[mbOK]);
       exit;
    end;

    if MessageBox(Handle,'O cliente possui referência no sistema, impossível excluí-lo, deseja inativa-lo?','Aviso!',MB_ICONQUESTION+MB_YESNO) = IDYES then
    begin
      //cliente inativo
      with TDMPrincipal.QAux do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE CLIENTE');
        SQL.ADD('SET ATIVO = 0');
        SQL.Add('WHERE COD_CLIENTE = '+ IntegerTextSql(QCliente.FieldByName('COD_CLIENTE').AsInteger));
        ExecSQL;
      end;
      EnviaMensagem('Cliente está inativo!', 'Status de Cliente', mtInformation, [mbOK]);
    end;
  end
  else
  begin
    if MessageBox(Handle,'Deseja realmente Excluir o cliente ?','Deletar Cliente! ',MB_ICONQUESTION+MB_YESNO) = IDYES then
    begin
      CanClose := True;
    end;
  end;

  if CanClose = True then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE CLIENTE');
      SQL.Add('WHERE COD_CLIENTE = '+ IntToStr(QCliente.FieldByName('COD_CLIENTE').AsInteger) );
      ExecSQL;

      EnviaMensagem('Cliente Removido!', 'Deletar cliente', mtInformation, [mbOK]);
    end;
  end;
  if ColunaPesquisa = '' then
    ColunaPesquisa:='NOME';

  edPesquisa.Tag := 0;
  with QCliente do
  begin  // inserçao do comando no sql
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_CLIENTE, NOME, RG, CPF, ATIVO');
    SQL.Add('FROM CLIENTE');

    // IDENTIFICAR A SELEÇÃO DE ATIVO,INATIVO
    case rbFiltro.ItemIndex of
      0 : SQL.Add(GetCondicao + ' ATIVO = 1');
      1 : SQL.Add(GetCondicao + ' ATIVO = 0');
    end;

    if edPesquisa.Text <> '*' then
    begin                                      // codigo do cliente
      if (ColunaPesquisa = 'COD_CLIENTE') or (ColunaPesquisa = 'RG') then
        SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(edPesquisa.Text))
      else
        SQL.Add(GetCondicao + ' NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
    end;
    Open;

    FieldByName('ATIVO').OnGetText := QClienteATIVOGetText;
    lblRegistro.Caption := IntToStr(QCliente.RecordCount);
    if  DBGrid.CanFocus then
      DBGrid.SetFocus;
  end;
end;

procedure TTCliente.btnTransferirClick(Sender: TObject);
begin
  if QCliente.IsEmpty then
  begin
    if edPesquisa.CanFocus then
      edPesquisa.SetFocus;
    EnviaMensagem('Selecione um Cliente para transferir!', 'Informação...', mtInformation, [mbOK]);
    Exit;
  end;

  if rbFiltro.ItemIndex = 1 then
  begin
    EnviaMensagem('Cliente está Inativo!','Cliente inválido!', mtInformation, [mbOK]);
      exit;
  end;

  if not QCliente.IsEmpty then
  begin
    btnTransferir.Tag := 1;
    Close;
  end;
end;

procedure TTCliente.btnTransferirEnter(Sender: TObject);
begin
  btnTransferir.Click;
end;

function TTCliente.ChamaTela(Transferir : Boolean = False):Integer;//(pAcaoTela: string );
begin
 {  TELA  CLIENTE RECEBE A CLASSE QUE CRIA A APLICAÇÃO }
  TCliente := TTCliente.Create(Application);
  with TCliente do
  begin
    if Transferir then
    begin
      btnTransferir.Visible := True;
      btnInserir.Visible := False;
      btnconsulta.Visible:= False;
      btnRemover.Visible :=False;
      btnedit.Visible:=False;
      rbFiltro.Visible := False;
    end;
    ShowModal;
    if btnTransferir.Tag = 1 then
      Result := QCliente.FieldByName('COD_CLIENTE').AsInteger
    else
      Result := 0;
  end;
  FreeAndNil(TCliente);
 {  tudo que cria na memproa TEM que ser liberado }
end;

procedure TTCliente.DBGridDblClick(Sender: TObject);
begin
  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTCliente.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if btnTransferir.Visible = True then
  begin
    if (key = #13)then
    begin
      btnTransferir.Click;
    end;
  end;
end;

procedure TTCliente.DBGridTitleClick(Column: TColumn);
var
  I : Integer;
begin
  ColunaPesquisa := Column.FieldName;
  edPesquisa.EditMask :='';

  if Column.Title.Caption <> 'STATUS' then
  begin
    lblDescricao.Caption := 'Digite um(a) ' + Column.Title.Caption + ' ou * para todos e Tecle Enter';
    btnLimpar.Click;
    for I := 0 to DBGrid.Columns.Count - 1 do
    begin
      if DBGrid.Columns[I].FieldName = ColunaPesquisa then
        DBGrid.Columns[I].Title.Font.Color := clRed
      else
        DBGrid.Columns[I].Title.Font.Color := clBlack;
    end;
  end;
end;

procedure TTCliente.edPesquisaKeyPress(Sender: TObject; var Key: Char);
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
  edPesquisa.Tag :=0;
  if (ColunaPesquisa = 'CPF') then  // EDICAO CPF
  begin
     {if not CharInSet(key, [#8, #13, #86, #42, #46, #48..#57]) then}
    //if (not(key in [#8, #13, #86, #42, #46, #48..#57])) or (key = '.') then
    //  Key := #0;
    if Empty(LimpaCaracter(edPesquisa.Text)) or (edPesquisa.Text = '*')  then
    begin
      edPesquisa.EditMask := '';
      edPesquisa.MaxLength := 1;
    end
    else
    begin
      edPesquisa.EditMask := '999\.999\.999-99;1;_'; //
      //edPesquisa.MaxLength := 14;
    end;
  end;

  if (Key = '*') and Empty(edPesquisa.Text) then
  begin
    edPesquisa.MaxLength := 1;
  end
  else
  begin
    if (ColunaPesquisa = 'RG') then  // EDICAO CPF
    begin
      edPesquisa.MaxLength := 12;
    end;
    if edPesquisa.Text <> '*' then
    begin
      if ColunaPesquisa = 'COD_CLIENTE' then
      begin
        edPesquisa.MaxLength := 9;
        key := SomenteNumero(Key);
      end
      else
      if ColunaPesquisa = 'NOME' then
      begin
        edPesquisa.MaxLength := 0;
        if key in ['1','2','3','4','5','6','7','8','9','0',',', '+', '-', '/' , '.','ª',  '}' , 'ª' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'¨' ,'&' , ')' , '(' ,'§' ,'ª' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '´','-','=' ] then
           key :=#0;
      end;
    end;
  end;

  if (key = #13) and not Empty(edPesquisa.Text) then   // identificação do botão ENTER
  begin
    with QCliente do
    begin  // inserçao do comando no sql
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLIENTE, NOME, RG, CPF, ATIVO');
      SQL.Add('FROM CLIENTE');
        // IDENTIFICAR A SELEÇÃO DE ATIVO,INATIVO
      case rbFiltro.ItemIndex of
        0 : SQL.Add(GetCondicao + ' ATIVO = 1');
        1 : SQL.Add(GetCondicao + ' ATIVO = 0');
      end;

      if edPesquisa.Text <> '*' then
      begin                                      // codigo do cliente
        if (ColunaPesquisa = 'COD_CLIENTE') or (ColunaPesquisa = 'RG') or (ColunaPesquisa = 'CPF')  then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(edPesquisa.Text))
        else
          SQL.Add(GetCondicao + ' NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
      end;

      Open;

      if IsEmpty then
      begin
        btnLimpar.Click;
        EnviaMensagem('Registro não encontrado!','',mtInformation, [mbOK]);
        exit;
      end;

      FieldByName('ATIVO').OnGetText := QClienteATIVOGetText;
      lblRegistro.Caption := IntToStr(QCliente.RecordCount);

      if  DBGrid.CanFocus then
        DBGrid.SetFocus;
    end;
  end;
end;

procedure TTCliente.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'NOME'
end;

procedure TTCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
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

procedure TTCliente.QClienteATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QCliente.IsEmpty then
  begin
    if QCliente.FieldByName('ATIVO').AsBoolean = True then
      Text := 'Ativo'
    else
      Text := 'Inativo';
  end
  else
    Text := '';
end;

procedure TTCliente.rbFiltroClick(Sender: TObject);
begin
  rbFiltro.Refresh;
  QCliente.Close;
  edPesquisa.Clear;
  edPesquisa.SetFocus;
  //edPesquisa.EditMask :='';
end;
end.
