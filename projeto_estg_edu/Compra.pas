unit Compra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, ADODB, StdCtrls, ExtCtrls, DBCtrls, ImgList,
  Buttons, Mask, DBClient;

type
  TTCompra = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    QCompra: TADOQuery;
    DBGrid: TDBGrid;
    DtsCompra: TDataSource;
    lblDescricao: TLabel;
    DBNavigator1: TDBNavigator;
    btnExcluir: TBitBtn;
    btnTransferir: TButton;
    btnInserir: TBitBtn;
    btnconsulta: TBitBtn;
    btnEditar: TBitBtn;
    btnFechar: TBitBtn;
    ImageList1: TImageList;
    btnLimpar: TBitBtn;
    edPesquisa: TMaskEdit;
    Panel4: TPanel;
    DBGridProduto: TDBGrid;
    dsProduto: TDataSource;
    QProduto: TADOQuery;
    lblProduto: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    lblRegistro: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure edPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure btnConsultaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnInserirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DtsCompraDataChange(Sender: TObject; Field: TField);
    procedure DBGridDblClick(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure btnTransferirEnter(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    ColunaPesquisa : string;
  public
    { Public declarations }
    function ChamarTelaCompra(Transferir : Boolean = False):Integer;

  end;

var
  TCompra: TTCompra;

implementation

uses DMPRINCIPAL, Cliente, Funcoes, Funcoesdb, Produto, CompraC;

{$R *.dfm}


procedure TTCompra.btnConsultaClick(Sender: TObject);
begin
  if QCompra.IsEmpty then
  begin
    EnviaMensagem('Selecione um Cliente para Consultar!', 'Informa��o...', mtInformation, [mbOK]);
    edPesquisa.SetFocus;
    Exit;
  end;
  TCompraC.ChamaTela('C',QCompra.FieldByName('COD_COMPRA').AsInteger);
end;

procedure TTCompra.btnEditarClick(Sender: TObject);
begin
  if QCompra.IsEmpty then
  begin
    EnviaMensagem('Selecione um Cliente para Editar!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;
  TCompraC.ChamaTela('E', QCompra.FieldByName('COD_COMPRA').AsInteger);
end;

procedure TTCompra.btnExcluirClick(Sender: TObject);
var CanClose : Boolean;
begin
  if QCompra.IsEmpty then
  begin
    EnviaMensagem('Selecione um Cliente para Excluir!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;
  CanClose := False;

  if MessageBox(Handle,'Deseja realmente Excluir o cliente ?','Deletar Cliente! ',MB_ICONQUESTION+MB_YESNO)=IDYES then
    CanClose := True;

  if CanClose = True then
    with TDMPrincipal.QAux do
    begin
      // DELETE DADOS TABELA ITENS_COMPRA
      Close;
      SQL.Clear;
      SQL.Add('DELETE ITENS_COMPRA');
      SQL.Add('WHERE ITENS_COMPRA.COD_COMPRA = '+ IntToStr(QCompra.FieldByName('COD_COMPRA').AsInteger) );
      ExecSQL;
      /// DELETE DADOS DA TABELA COMPRA
      Close;
      SQL.Clear;
      SQL.Add('DELETE COMPRA');
      SQL.Add('WHERE COD_COMPRA = '+ IntToStr(QCompra.FieldByName('COD_COMPRA').AsInteger) );
      ExecSQL;

      EnviaMensagem('Compra deletada!', 'Exclusao da compra!', mtInformation, [mbOK]);
    end;

    edPesquisa.Tag:=0;
    with QCompra do
    begin  // inser�ao do comando no sql
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.COD_COMPRA,  P.COD_CLIENTE , C.NOME AS CLIENTE, P.DATA, P.VALOR_TOTAL');
      SQL.Add('FROM COMPRA AS P');
      SQL.Add('INNER JOIN CLIENTE AS C ON C.COD_CLIENTE = P.COD_CLIENTE');

      if edPesquisa.Text <> '*' then
      begin                                      // codigo do cliente
        if (ColunaPesquisa = 'COD_COMPRA') or (ColunaPesquisa = 'DATA') OR (ColunaPesquisa = 'VALOR_TOTAL') then
          SQL.Add({GetCondicao}'WHERE '+ ColunaPesquisa + ' = ' + StringTextSql(ColocaPonto( edPesquisa.Text)))
        else if (ColunaPesquisa = 'COD_CLIENTE') then
          SQL.Add('WHERE P.COD_CLIENTE = ' + StringTextSql( edPesquisa.Text))
        else
          SQL.Add({GetCondicao}'WHERE ' + ' C.NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
         // if (ColunaPesquisa = 'CCLIENTE') then
         //   SQL.Add({GetCondicao}'WHERE ' + ' C.COD_CLIENTE = ' + StringTextSql(edPesquisa.Text))
      end;
      Open;
    end;
end;

procedure TTCompra.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTCompra.btnInserirClick(Sender: TObject);
begin
  TCompraC.ChamaTela('I' , 0);
end;

procedure TTCompra.btnLimparClick(Sender: TObject);
begin
  lblRegistro.Caption := '0';
  edPesquisa.Clear;
  QCompra.Close;
  edPesquisa.SetFocus;
  QProduto.Close;
  lblProduto.Caption := '0';
end;

procedure TTCompra.btnTransferirClick(Sender: TObject);
begin
  if not QCompra.IsEmpty then
  begin
    btnTransferir.Tag := 1;
    Close;
  end;
end;

procedure TTCompra.btnTransferirEnter(Sender: TObject);
begin
  btnTransferir.Click;
end;

function TTCompra.ChamarTelaCompra(Transferir : Boolean = False):Integer;
begin
  TCompra := TTCompra.Create(Application);
  with TCompra do
  begin
    if Transferir then
    begin
      btnTransferir.Visible := True;
      btnInserir.Visible := False;
      btnconsulta.Visible:= False;
      btnExcluir.Visible :=False;
      btnEditar.Visible:=False;
    end;
    ShowModal;
    if btnTransferir.Tag = 1 then
      Result := QCompra.FieldByName('COD_COMPRA').AsInteger
    else
      Result := 0;
  end;
  FreeAndNil(TCompra);
end;

procedure TTCompra.DBGridDblClick(Sender: TObject);
begin
  if QCompra.IsEmpty then
  begin
      //EnviaMensagem('Tabela est� vazia!', 'Lista vazia!', mtInformation, [mbOK]);
      exit;
  end;

  with QProduto do
  begin  // inser�ao do comando no sql
    Close;
    SQL.Clear;
    SQL.Add('SELECT I.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR');
    SQL.Add('FROM ITENS_COMPRA I');
    SQL.Add('INNER JOIN COMPRA AS C ON C.COD_COMPRA = I.COD_COMPRA');
    SQL.Add('INNER JOIN PRODUTO AS P ON P.COD_PRODUTO = I.COD_PRODUTO');

    SQL.Add('WHERE C.COD_COMPRA = '+ QCompra.FieldByName('COD_COMPRA').AsString);
    Open;
    lblProduto.Caption := 'N� de registros: '+ IntToStr(QProduto.RecordCount);
  end;

  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTCompra.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if btnTransferir.Visible = True then
  begin
    if (key = #13)then
    begin
      btnTransferir.Click;
    end;
  end;
end;

procedure TTCompra.DBGridTitleClick(Column: TColumn);
var
  I : Integer;
begin
  ColunaPesquisa := Column.FieldName;
  lblDescricao.Caption := 'Digite um(a) ' + Column.Title.Caption + ' ou * para todos e Tecle Enter';
  btnLimpar.Click;
  {
  if ColunaPesquisa = 'DATA' then
  begin
    edPesquisa.EditMask:= '!99/99/9999;1;_';
  end
  else
  begin
    edPesquisa.EditMask:='';
  end; }
  for I := 0 to DBGrid.Columns.Count - 1 do
  begin
    if DBGrid.Columns[I].FieldName = ColunaPesquisa then
      DBGrid.Columns[I].Title.Font.Color := clRed
    else
      DBGrid.Columns[I].Title.Font.Color := clBlack;
  end;
end;

procedure TTCompra.DtsCompraDataChange(Sender: TObject; Field: TField);
begin
  with QProduto  do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT I.COD_PRODUTO, P.DESCRICAO, P.PRECO, I.QUANTIDADE, P.PRECO * I.QUANTIDADE AS VALOR ');
    SQL.Add('FROM ITENS_COMPRA I ');
    SQL.Add('INNER JOIN COMPRA AS C ON C.COD_COMPRA = I.COD_COMPRA ');
    SQL.Add('INNER JOIN PRODUTO AS P ON P.COD_PRODUTO = I.COD_PRODUTO ');
    SQL.Add('WHERE I.COD_COMPRA = ' + IntegerTextSql(QCompra.FieldByName('COD_COMPRA').AsInteger));
    Open;

    lblProduto.Caption := IntToStr(QProduto.RecordCount);
  end;
end;

procedure TTCompra.edPesquisaKeyPress(Sender: TObject; var Key: Char);
function GetCondicao():string; // FUN��O P/ PEGAR A SINTAXE DE ACORDO COM O QUE USU�RIO PREENCHEU
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
  edPesquisa.Tag := 0;
  //Key := UpCase(Key); ///colocar em maiusculo

  if (ColunaPesquisa = 'DATA') then
  begin
     {if not CharInSet(key, [#8, #13, #86, #42, #46, #48..#57]) then}
    if (not(key in [#8, #13, #86, #42, #46, #48..#57])) or (key = '.') then
      Key := #0;

    if Empty(LimpaCaracter(edPesquisa.Text)) or (edPesquisa.Text = '*')  then
    begin
      edPesquisa.EditMask := '';
      EdPesquisa.MaxLength := 1;
    end
    else
    begin
       edPesquisa.EditMask:= '99/99/0000;1;';
       edPesquisa.MaxLength := 11;
    end;
  end;

  if (Key = '*') and Empty(edPesquisa.Text) then
  begin
      edPesquisa.MaxLength := 1;
  end;

  if ColunaPesquisa = 'VALOR_TOTAL' then
  begin
    edPesquisa.MaxLength := 15;             // condi��o para anular caracteres espec�ficos, impedir de digitar no maskedit
    if key in ['�','�', '�' , '�', '�', '�' , '�' , '�', '�' ,'�', '}', '�' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'�' ,'&' , ')' , '(' ,'�' ,'�' ,'{' ,'"' , '+' , '-' , '\' , '?' , ';' , '[' , ']' , '�' , '-' , '='] then
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

  if (ColunaPesquisa = 'COD_CLIENTE') OR (ColunaPesquisa = 'COD_COMPRA') then
  begin   // condi��o para anular caracteres espec�ficos, impedir de digitar no maskedit
    edPesquisa.MaxLength := 9;
    if key in ['�','�', '�' , '�', '�', '�' , '�' , '�', '�' ,'�', '}', '�' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'�' ,'&' , ')' , '(' ,'�' ,'�' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '�','-','='] then
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

  if ColunaPesquisa = 'CLIENTE' then
  begin  // condi��o para anular caracteres espec�ficos, impedir de digitar no maskedit
    edPesquisa.MaxLength := 0;
    if key in ['1','2','3','4','5','6','7','8','9','0',',', '+', '-', '/' , '.',';','\','?',','] then
       key :=#0;
  end;

  if (key = #13) and not Empty(edPesquisa.Text) then   // identifica��o do bot�o ENTER
  begin
    with QCompra do
    begin  // inser�ao do comando no sql
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.COD_COMPRA,  P.COD_CLIENTE , C.NOME AS CLIENTE, P.DATA, P.VALOR_TOTAL');
      SQL.Add('FROM COMPRA AS P');
      SQL.Add('INNER JOIN CLIENTE AS C ON C.COD_CLIENTE = P.COD_CLIENTE');

      if edPesquisa.Text <> '*' then
      begin                                      // codigo do cliente
        if (ColunaPesquisa = 'COD_COMPRA') or (ColunaPesquisa = 'DATA') OR (ColunaPesquisa = 'VALOR_TOTAL') then
          SQL.Add({GetCondicao}'WHERE '+ ColunaPesquisa + ' = ' + StringTextSql(ColocaPonto( edPesquisa.Text)))
        else if (ColunaPesquisa = 'COD_CLIENTE') then
          SQL.Add('WHERE P.COD_CLIENTE = ' + StringTextSql( edPesquisa.Text))
        else
          SQL.Add({GetCondicao}'WHERE ' + ' C.NOME LIKE ' + StringTextSql('' + edPesquisa.Text + '%'));
         // if (ColunaPesquisa = 'CCLIENTE') then
           //   SQL.Add({GetCondicao}'WHERE ' + ' C.COD_CLIENTE = ' + StringTextSql(edPesquisa.Text))
      end;
      Open;

      if IsEmpty then
      begin
        btnLimpar.Click;
        EnviaMensagem('Registro n�o encontrado!','',mtInformation, [mbOK]);
        exit;
      end;
      // mostra quantos registros
      lblRegistro.Caption := IntToStr(QCompra.RecordCount);

      if  DBGrid.CanFocus then
        DBGrid.SetFocus;
    end;
  end;
end;

procedure TTCompra.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'CLIENTE' ;
end;

procedure TTCompra.FormKeyDown(Sender: TObject; var Key: Word;
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
      if (btnEditar.Enabled) and (btnEditar.Visible) then
        btnEditar.Click;
    end;
    VK_F8:
    begin
      if (btnExcluir.Enabled) and (btnExcluir.Visible) then
        btnExcluir.Click;
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

end.
