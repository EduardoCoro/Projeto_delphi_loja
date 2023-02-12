unit Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, ADODB, DB, DBCtrls, ImgList,
  Buttons, Mask;

type
  TTProduto = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    DTSProduto: TDataSource;
    QProduto: TADOQuery;
    DBGrid: TDBGrid;
    lblDescricao: TLabel;
    rdFiltro: TRadioGroup;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    btnTransferir: TButton;
    btnInserir: TBitBtn;
    btnconsulta: TBitBtn;
    btnEditar: TBitBtn;
    btnExcluir: TBitBtn;
    btnFechar: TBitBtn;
    ImageList1: TImageList;
    btnLimpar: TBitBtn;
    edPesquisa: TMaskEdit;
    BtnEstoque: TBitBtn;
    Label1: TLabel;
    lblRegistro: TLabel;
    procedure btnInserirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);
    procedure edPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure rdFiltroClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnTransferirClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridDblClick(Sender: TObject);
    procedure BtnEstoqueClick(Sender: TObject);
    procedure QProdutoATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoSEM_VALIDADEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QProdutoPRECOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  private
    { Private declarations }
    CanClose : Boolean;
    ColunaPesquisa : String;
    xcodFornecedor : integer;
    xacao : string;
  public
    { Public declarations }
    procedure Carregafornecedor;
    function ChamaTela(pacao: string ;codFornecedor : integer; Transferir : Boolean = False):Integer;
  end;

var
  TProduto: TTProduto;

implementation

uses    Funcoes, Funcoesdb, ProdutoC, DMPrincipal, ProdutoEstoque;

{$R *.dfm}

procedure TTProduto.Carregafornecedor;
begin
  //xcodFornecedor := StrToInt(XcodFornece);
  with QProduto do
  begin  // inser�ao do comando no sql
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.ESTOQUE ,P.PRECO, P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
    SQL.Add('FROM PRODUTO P ');
    SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
    SQL.Add('WHERE P.COD_FORNECEDOR = ' + IntegerTextSql(xcodFornecedor));
    Open;

  end;
end;

function TTProduto.ChamaTela(pacao: string ;codFornecedor : integer; Transferir : Boolean = False):Integer;//(pAcaoTela: string );
begin
 {  TELA  CLIENTE RECEBE A CLASSE QUE CRIA A APLICA��O }
  TProduto := TTProduto.Create(Application);
  with TProduto do
  begin
    if Transferir then
    begin
      xacao := pacao;
      xcodFornecedor := codFornecedor;
      Carregafornecedor;
      btnTransferir.Visible := True;
      btnInserir.Visible := False;
      btnconsulta.Visible := False;
      btnEditar.Visible := False;
      btnExcluir.Visible := False;
      BtnEstoque.Visible := False;
      rdFiltro.Visible := False;
    end;
    ShowModal;
    if btnTransferir.Tag = 2 then
      Result := QProduto.FieldByName('COD_PRODUTO').AsInteger
    else
      Result := 0;
  end;
  FreeAndNil(TProduto);
 {  tudo que cria na memproa TEM que ser liberado }
end;

procedure TTProduto.DBGridDblClick(Sender: TObject);
begin
  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTProduto.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
 // mudar a cor da linha selecionada
//  TDbGrid(Sender).Canvas.font.Color:= clBlack; //aqui � definida a cor da fonte
//  if gdSelected in State then
//    with (Sender as TDBGrid).Canvas do
//    begin
//      Brush.Color:=clRed; //aqui � definida a cor do fundo
//      FillRect(Rect);
//    end;
//
//  TDbGrid(Sender).DefaultDrawDataCell(Rect, TDbGrid(Sender).columns[datacol].field, State);
end;

procedure TTProduto.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if btnTransferir.Visible = True then
  begin
    if (key = #13)then
    begin
      btnTransferir.Click;
    end;
  end;
end;

procedure TTProduto.DBGridTitleClick(Column: TColumn);
var
  I : Integer;
begin
  ColunaPesquisa := Column.FieldName;
  
  iF Column.Title.Caption <> 'N�o Vence'  then
  begin
    if Column.Title.Caption <> 'STATUS'  THEN
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
end;

procedure TTProduto.edPesquisaKeyPress(Sender: TObject; var Key: Char);
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
  Key := UpCase(Key);
  edPesquisa.Tag := 0;

  if (Key = '*') and Empty(edPesquisa.Text) then
  begin
      edPesquisa.MaxLength := 1;
  end
  else
  begin
    if edPesquisa.Text <> '*' then
    begin
      if ColunaPesquisa = 'DATA_VALIDADE' then
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

      // TRATAMENTO PARA DIGITAR NUMERICO
      if (ColunaPesquisa = 'COD_PRODUTO') or (ColunaPesquisa = 'ESTOQUE') then
      begin
        edPesquisa.MaxLength := 9;
        if ((key in [ '*','0'..'9'] = false) and (word(key) <> vk_back) and (word(key) <> VK_RETURN)) then
          key := #0;
      end;
      // TRATAMENTO PARA DIGITAR VALORES
      if ColunaPesquisa = 'PRECO' then
      begin
        edPesquisa.MaxLength := 0;
        if ((key in ['0'..'9', '*','.', ','] = false) and (word(key) <> vk_back) and (word(key) <> VK_RETURN)) then
          key := #0;
      end;
      // TRATAMENTO PARA DIGITAR PALAVRAS N�O NUMERICAS
      if (ColunaPesquisa = 'DESCRICAO') OR (ColunaPesquisa = 'NOME') then
      begin
        edPesquisa.MaxLength := 0;
        if ((Key in['*','A'..'Z', 'a'..'z',#8] = False) and (word(key) <> vk_back) and (word(key) <> VK_RETURN) ) then
           Key := #0;
      end;
    end;
  end;

  if (key = #13) and not Empty(edPesquisa.Text)  then   // identifica��o do bot�o ENTER
  begin
    with QProduto do
    begin  // inser�ao do comando no sql
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.ESTOQUE ,P.PRECO, P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
      SQL.Add('FROM PRODUTO P ');
      SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');

      // IDENTIFICAR A SELE��O DE ATIVO,INATIVO
      case rdFiltro.ItemIndex of
        0 : SQL.Add(GetCondicao + ' P.ATIVO = 1');
        1 : SQL.Add(GetCondicao + ' P.ATIVO = 0');
      end;

      if edPesquisa.Text <> '*' then
      begin                                    // codigo do
        if (ColunaPesquisa = 'COD_PRODUTO')or (ColunaPesquisa = 'ESTOQUE') or (ColunaPesquisa = 'PRECO') or (ColunaPesquisa = 'DATA_VALIDADE') or (ColunaPesquisa = 'SEM_VALIDADE')  then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(ColocaPonto(edPesquisa.Text)));
        if ColunaPesquisa = 'NOME' then
          SQL.Add(GetCondicao + ' F.NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
        if (ColunaPesquisa = 'DESCRICAO')   then
          SQL.Add(GetCondicao + ' P.DESCRICAO LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'));
      end;
      //for�ando por fornecedor
      if xcodFornecedor <> 0 then
         SQL.Add(GetCondicao + 'P.COD_FORNECEDOR = ' + IntegerTextSql(xcodFornecedor));

      Open;

      // registro vazio
      if IsEmpty then
      begin
        btnLimpar.Click;
        EnviaMensagem('Registro n�o encontrado!','',mtInformation, [mbOK]);
        exit;
      end;

      FieldByName('PRECO').OnGetText := QProdutoPRECOGetText;
      FieldByName('ATIVO').OnGetText :=  QProdutoATIVOGetText;
      FieldByName('SEM_VALIDADE').OnGetText := QProdutoSEM_VALIDADEGetText;

      lblRegistro.Caption := IntToStr(QProduto.RecordCount);

      if  DBGrid.CanFocus then
        DBGrid.SetFocus;
    end;
  end;
end;

procedure TTProduto.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'DESCRICAO' ;
  //rdFiltro.Buttons[0].Checked:= True;
end;

procedure TTProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F1:
    begin
      if (BtnEstoque.Enabled) and (BtnEstoque.Visible) then
        BtnEstoque.Click;
    end;
    VK_F2:
    begin
      if (btnInserir.Enabled) and (btnInserir.Visible) then
        btnInserir.Click;
    end;
    VK_F3:
    begin
      if (btnConsulta.Enabled) and (btnConsulta.Visible) then
        btnConsulta.Click;
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

procedure TTProduto.QProdutoATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if QProduto.FieldByName('ATIVO').AsBoolean = True then
      Text := 'Ativo'
    else
      Text := 'Inativo';
  end
  else
    Text := '';
end;

procedure TTProduto.QProdutoPRECOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if QProduto.FieldByName('PRECO').AsFloat >= 0 then
      Text := 'R$ ' + FormatFloat('0.00', QProduto.FieldByName('PRECO').AsFloat);
  end
  else
    Text := '';
end;

procedure TTProduto.QProdutoSEM_VALIDADEGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not QProduto.IsEmpty then
  begin
    if QProduto.FieldByName('SEM_VALIDADE').AsBoolean = True then
      Text := 'S'
    else
      Text := 'N';
  end
  else
    Text := '';
end;

procedure TTProduto.rdFiltroClick(Sender: TObject);
begin
  QProduto.Close;
  edPesquisa.Clear;
  edPesquisa.SetFocus;
end;

procedure TTProduto.btnConsultaClick(Sender: TObject);
begin
  if QProduto.IsEmpty then
  begin
    EnviaMensagem('Selecione um Produto para Consultar!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;
  TProdutoC.ChamaTela('C', QProduto.FieldByName('COD_PRODUTO').AsInteger);
end;

procedure TTProduto.btnEditarClick(Sender: TObject);
var Codigo : integer;
begin
  if QProduto.IsEmpty then
  begin
    EnviaMensagem('Selecione um Produto para Editar!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;

  Codigo := TProdutoC.ChamaTela('E', QProduto.FieldByName('COD_PRODUTO').AsInteger);
  if Codigo > 0 then
  begin
    if QProduto.Active then
      QProduto.Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QProduto do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.PRECO, P.ESTOQUE , P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
        SQL.Add('FROM PRODUTO P ');
        SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
        SQL.Add('WHERE P.COD_PRODUTO = ' + IntegerTextSql(Codigo));
        Open;
      end;
    end;
    QProduto.Locate('COD_PRODUTO', Codigo, []);
  end;
end;

procedure TTProduto.BtnEstoqueClick(Sender: TObject);
var Codigo : integer;
begin
  if QProduto.IsEmpty then
  begin
    EnviaMensagem('Selecione um Produto!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;

  if QProduto.FieldByName('ATIVO').AsBoolean = False then
    EnviaMensagem('Produto est� inativo!','Opera��o inv�lida!',mtInformation,[mbOK])
  else
  begin
    if QProduto.IsEmpty then
    begin
      EnviaMensagem('Selecione um Produto!', 'Informa��o...', mtInformation, [mbOK]);
      Exit;
    end
    else
    begin
      Codigo := TEstoque.ChamaTela('E', QProduto.FieldByName('COD_PRODUTO').AsInteger);
      if Codigo > 0 then
      begin
        if QProduto.Active then
          QProduto.Requery()
        else
        begin
         { SELECT PRA TRAZER O CLIENTE }
          with QProduto do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.PRECO, P.ESTOQUE , P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
            SQL.Add('FROM PRODUTO P ');
            SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
            SQL.Add('WHERE P.COD_PRODUTO = ' + IntegerTextSql(Codigo));
            Open;
          end;
        end;
        QProduto.Locate('COD_PRODUTO', Codigo, []);
      end;
    end;
  end;
end;

procedure TTProduto.btnExcluirClick(Sender: TObject);
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
  CanClose := False;
  if QProduto.IsEmpty then
  begin
    EnviaMensagem('Selecione um Produto para Remover!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;

  if not Empty(TemReferencia('PRODUTO',QProduto.FieldByName('COD_PRODUTO').AsString, 'ESTAGIARIO_EDU')) then
  begin
     //somente para inativos
    if QProduto.FieldByName('ATIVO').AsBoolean = False then
    begin
       EnviaMensagem('O Produto possui refer�ncia no sistema, imposs�vel exclu�-lo','Aviso...',mtInformation,[mbOK]);
       exit;
    end;
    //
    if MessageBox(Handle,'O produto possui refer�ncia no sistema, imposs�vel exclu�-lo, deseja inativa-lo?','Aviso!',MB_ICONQUESTION+MB_YESNO) = IDYES then
    begin
      //cliente inativo
      with TDMPrincipal.QAux do
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE PRODUTO');
        SQL.ADD('SET ATIVO = 0');
        SQL.Add('WHERE COD_PRODUTO = '+ IntegerTextSql(QProduto.FieldByName('COD_PRODUTO').AsInteger));
        ExecSQL;
      end;
      EnviaMensagem('Produto est� inativo!', 'Status de Produto', mtInformation, [mbOK]);
    end
    else
    begin
      exit;
    end;
  end
  else
  begin
    if MessageBox(Handle,'Deseja realmente Excluir o PRODUTO ?','Deletar Produto! ',MB_ICONQUESTION+MB_YESNO)=IDYES then
    begin
      CanClose := True;
    end
    else
    begin
      exit;
    end;
  end;

  if CanClose = True then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE PRODUTO');
      SQL.Add('WHERE COD_PRODUTO = '+ IntegerTextSql(QProduto.FieldByName('COD_PRODUTO').AsInteger));
      ExecSQL;

      EnviaMensagem('Produto removido!', 'Exclus�o do Produto!', mtInformation, [mbOK]);
    end;
  end;

  // atualiza a grid com os dados consultados
  with QProduto do
  begin  // inser�ao do comando no sql
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.PRECO, P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
    SQL.Add('FROM PRODUTO P ');
    SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');

    edPesquisa.Tag:= 0;
    // IDENTIFICAR A SELE��O DE ATIVO,INATIVO
    case rdFiltro.ItemIndex of
      0 : SQL.Add(GetCondicao + ' P.ATIVO = 1');
      1 : SQL.Add(GetCondicao + ' P.ATIVO = 0');
    end;

    if edPesquisa.Text <> '*' then
    begin                                    // codigo do
      if (ColunaPesquisa = 'COD_PRODUTO') or (ColunaPesquisa = 'PRECO') or (ColunaPesquisa = 'DATA_VALIDADE') or (ColunaPesquisa = 'SEM_VALIDADE')  then
        SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + StringTextSql(ColocaPonto(edPesquisa.Text)));
      if ColunaPesquisa = 'NOME' then
        SQL.Add(GetCondicao + ' F.NOME LIKE ' + StringTextSql('%' + edPesquisa.Text + '%'))
      else
        SQL.Add(GetCondicao + ' P.DESCRICAO LIKE ' + StringTextSql('' + edPesquisa.Text + '%'));
    end;
    Open;

    lblRegistro.Caption := IntToStr(QProduto.RecordCount);
    if  DBGrid.CanFocus then
      DBGrid.SetFocus;
  end;
end;

procedure TTProduto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTProduto.btnInserirClick(Sender: TObject);
var Codigo : integer;
begin
  Codigo := TProdutoC.ChamaTela('I', 0);
  if Codigo > 0 then
  begin
    if QProduto.Active then
      QProduto.Requery()
    else
    begin
     { SELECT PRA TRAZER O CLIENTE }
      with QProduto do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT P.COD_PRODUTO,  P.DESCRICAO, P.PRECO, P.ESTOQUE , P.DATA_VALIDADE, P.ATIVO, P.SEM_VALIDADE, F.NOME ');
        SQL.Add('FROM PRODUTO P ');
        SQL.Add('INNER JOIN FORNECEDOR F ON P.COD_FORNECEDOR = F.COD_FORNECEDOR ');
        SQL.Add('WHERE P.COD_PRODUTO = ' + IntegerTextSql(Codigo));
        Open;

        FieldByName('PRECO').OnGetText := QProdutoPRECOGetText;
        FieldByName('ATIVO').OnGetText :=  QProdutoATIVOGetText;
        FieldByName('SEM_VALIDADE').OnGetText := QProdutoSEM_VALIDADEGetText;

        lblRegistro.Caption := IntToStr(QProduto.RecordCount);
      end;
    end;
    QProduto.Locate('COD_PRODUTO', Codigo, []);
  end;
end;

procedure TTProduto.btnLimparClick(Sender: TObject);
begin
  lblRegistro.Caption := '0';
  edPesquisa.Clear;
  QProduto.Close;
  if edPesquisa.CanFocus then
    edPesquisa.SetFocus;
end;

procedure TTProduto.btnTransferirClick(Sender: TObject);
begin
  if QProduto.IsEmpty then
  begin
    if edPesquisa.CanFocus then
      edPesquisa.SetFocus;
    EnviaMensagem('Selecione um Produto para transferir!', 'Informa��o...', mtInformation, [mbOK]);
    Exit;
  end;
  //verifica inativo
  if rdFiltro.ItemIndex = 1 then
  begin
    EnviaMensagem('Produto est� Inativo!','Produto inv�lido!', mtInformation, [mbOK]);
    exit;
  end;
  // verifica se t�m estoque
  if not (xacao = 'Estoque')  then
    if xcodFornecedor = 0 then
      if QProduto.FieldByName('ESTOQUE').AsInteger <= 0 then
      begin
        EnviaMensagem('Produto Sem estoque!','Informa��o..',mtInformation, [mbOK]);
        exit;
      end;
  // tabela vazia
  if not QProduto.IsEmpty then
  begin
    btnTransferir.Tag := 2;
    Close;
  end;
end;

end.
