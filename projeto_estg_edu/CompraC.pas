unit CompraC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, ExtCtrls, Buttons, rxToolEdit,
  rxCurrEdit, DB, DBClient;

type
  TTCompraC = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    edCodCliente: TEdit;
    edNomeCli: TEdit;
    edRGCli: TEdit;
    btnPesquisaCliente: TBitBtn;
    btnLimpaC: TBitBtn;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    edCodProduto: TEdit;
    edNomeProduto: TEdit;
    btnPesquisaProduto: TBitBtn;
    btnLimpaP: TBitBtn;
    edQuantidade: TEdit;
    btnAdditens: TBitBtn;
    btnDeleteitens: TBitBtn;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edValorUn: TCurrencyEdit;
    Label9: TLabel;
    cdsCompras: TClientDataSet;
    dsCompra: TDataSource;
    cdsComprasCOD_PRODUTO: TIntegerField;
    cdsComprasDESCRICAO: TStringField;
    cdsComprasPRECO: TFloatField;
    cdsComprasQUANTIDADE: TIntegerField;
    cdsComprasVALOR_TOTAL: TFloatField;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    mostraTotal: TCurrencyEdit;
    Label10: TLabel;
    qtd_itens: TLabel;
    cdsComprasACAO: TStringField;
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnLimpaCClick(Sender: TObject);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure btnLimpaPClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAdditensClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteitensClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure btnLimpaPKeyPress(Sender: TObject; var Key: Char);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure edCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsComprasPRECOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cdsComprasVALOR_TOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);


  private
    { Private declarations }
    VALOR : Double;
    xCodCompra: Integer;
    VetDeletarItens : TStringlist;
    VetsaldoEstoque : TStringlist;
    AcaoTela: String;
    procedure DesabilitaComponentes;
    procedure CarregaDados;
    procedure AtualizaSaldoEstoque(acao : string;codProduto : integer; quantidade : integer);
    //function BuscaSaldoEstoque(codProduto : integer): Integer;
  public
    { Public declarations }
    procedure ChamaTela(pAcaoTela: string ; CodCompra : Integer );

  end;

var

  TCompraC: TTCompraC;

implementation

uses Cliente, Compra,Funcoes, Funcoesdb, Produto, DMPrincipal;

{$R *.dfm}

procedure TTCompraC.btnAdditensClick(Sender: TObject);
var
  aux : Double;
  SALDO : integer;
function BuscaSaldoEstoque(codProduto , SaldoEstoque: Integer):Integer;
  begin
    with TDMPrincipal.QAux do  // REALIZADO A BUSCA DO ESTOQUE DE PRODUTOS
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ESTOQUE');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PRODUTO = ' + IntToStr(codProduto));
      Open;
      SALDO := FieldByName('ESTOQUE').AsInteger;
    end;
    Result := SALDO - SaldoEstoque;;
  end;
begin
  if Empty(edCodProduto.Text)    then
  begin
    EnviaMensagem('Codigo do produto est? vazio! Informe novamente o produto e o Cliente!', 'Aten??o!', mtInformation, [mbOK]);
    if edCodProduto.CanFocus then
      edCodProduto.SetFocus;
      Exit;
  end;
  IF Empty(edNomeProduto.Text)    then
  begin
    EnviaMensagem('N?o existe Nome do produto, selecione outro produto!', 'Aten??o!', mtInformation, [mbOK]);
    if edNomeProduto.CanFocus then
      edNomeProduto.SetFocus;
      Exit;
  end;

  IF Empty(edQuantidade.Text) then
  begin
    EnviaMensagem('Informe a Quantidade!', 'Aten??o!', mtInformation, [mbOK]);
    if edQuantidade.CanFocus then
      edQuantidade.SetFocus;
      Exit;
  end;

  IF Empty(edValorUn.Text) then
  begin
    EnviaMensagem('N?o existe Pre?o do produto, selecione outro produto!', 'Aten??o!', mtInformation, [mbOK]);
    if edValorUn.CanFocus then
      edValorUn.SetFocus;
      Exit;
  end;

  //cdsCompras.Open;
  with cdsCompras do
  begin
    IF Locate('COD_PRODUTO', edCodProduto.Text, []) then
    begin
       EnviaMensagem('produto j? listado!','Aten??o!',mtInformation, [mbOK]);
       btnLimpaP.Click;
       exit;
    end;
    // Verifica se ultrapassou o estoque
    if (BuscaSaldoEstoque(StrToInt(edCodProduto.Text), StrToInt(edQuantidade.Text))) < 0 then
    begin
      EnviaMensagem('Quantidade do Produto em falta no estoque! No estoque: '+ IntToStr(SALDO) ,'Aten??o!',mtInformation, [mbOK]);
      if edQuantidade.CanFocus then
        edQuantidade.SetFocus;
      exit;
    end;

    // tratamento de estoque
    // verifica saldo estoque
    First;
    Append;
    FieldByName('COD_PRODUTO').AsInteger := StrToInt(edCodProduto.Text);
    FieldByName('DESCRICAO').AsString := edNomeProduto.Text;
    FieldByName('PRECO').AsFloat := StrToFloat(edValorUn.Text);
    FieldByName('QUANTIDADE').AsInteger := StrToInt(edQuantidade.Text);
    FieldByName('VALOR_TOTAL').AsFloat :=  StrToInt(edQuantidade.Text) * StrToFloat(edValorUn.Text);
    FieldByName('ACAO').AsString := 'I';

    aux := StrToInt(edQuantidade.Text) * StrToFloat(edValorUn.Text);

    qtd_itens.Caption := IntToStr(strToInt(qtd_itens.Caption) + StrToInt(edQuantidade.Text));

  //    FieldByName('PRECO').OnGetText := cdsComprasPRECOGetText;
  //    FieldByName('VALOR_TOTAL').OnGetText := cdsComprasVALOR_TOTALGetText;
    Post;

  end;
  VALOR:= aux + VALOR;
  mostraTotal.Text := FloatToStr(VALOR);
  btnLimpaP.Click;
end;

procedure TTCompraC.DesabilitaComponentes;
begin
  btnPesquisaCliente.Enabled := False;
  btnLimpaC.Enabled := False;
  btnPesquisaProduto.Enabled := False;
  btnLimpaP.Enabled := False;
  btnAdditens.Enabled := False;
  btnDeleteitens.Enabled := False;
  btnSalvar.Enabled := False;
  edCodCliente.ReadOnly := True;
  edCodProduto.ReadOnly := True;
  edQuantidade.ReadOnly := True;
end;

procedure TTCompraC.CarregaDados;
begin
  with TDMPrincipal.QAux do  // REALIZADO A BUSCA DE CLIENTES QUE REALIZOU A COMPRA
  begin
    Close;
    SQL.Clear;
    SQL.Add(' SELECT P.COD_COMPRA, P.COD_CLIENTE , C.RG , C.NOME AS CLIENTE, P.DATA AS DATA , P.VALOR_TOTAL');
    SQL.Add('FROM COMPRA P');
    SQL.Add('INNER JOIN CLIENTE AS C ON C.COD_CLIENTE = P.COD_CLIENTE');
    SQL.Add('WHERE COD_COMPRA = ' + IntegerTextSql(xCodCompra));
    Open;

    // PEGA BUSCANDO DADOS E MONSTRANDO
    edCodCliente.Text := FieldByName('COD_CLIENTE').AsString;
    edNomeCli.Text := FieldByName('CLIENTE').AsString;
    edRGCli.Text := FieldByName('RG').AsString;
    //mostraValorTotal := FieldByName('VALOR_TOTAL').AsString;

    VALOR := FieldByName('VALOR_TOTAL').AsFloat;
    mostraTotal.Text := FloatToStr(VALOR);

    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PRODUTO ,P.DESCRICAO, P.PRECO, I.QUANTIDADE, C.VALOR_TOTAL');
    SQL.Add('FROM ITENS_COMPRA AS I ');
    SQL.Add('INNER JOIN COMPRA C');
    SQL.Add('ON C.COD_COMPRA = I.COD_COMPRA');
    SQL.Add('INNER JOIN PRODUTO  P');
    SQL.Add('ON I.COD_PRODUTO = P.COD_PRODUTO');
    SQL.Add('WHERE C.COD_COMPRA = ' + IntegerTextSql(xCodCompra) );
    open;

    First;
    while not Eof do
    Begin
      cdsCompras.Append;
      cdsCompras.FieldByName('COD_PRODUTO').Value := FieldByName('COD_PRODUTO').AsInteger;
      cdsCompras.FieldByName('DESCRICAO').VALUE := FieldByName('DESCRICAO').AsString;
      cdsCompras.FieldByName('PRECO').Value := FieldByName('PRECO').AsString;
      cdsCompras.FieldByName('QUANTIDADE').value := FieldByName('QUANTIDADE').AsInteger;
      cdsCompras.FieldByName('VALOR_TOTAL').Value := FieldByName('PRECO').AsFloat * FieldByName('QUANTIDADE').AsInteger;
      cdsCompras.FieldByName('ACAO').AsString := 'N'  ;
      qtd_itens.Caption := IntToStr(strToInt(qtd_itens.Caption) + FieldByName('QUANTIDADE').AsInteger);
      cdsCompras.Post;
      Next;
    End;
  end;
end;

procedure TTCompraC.cdsComprasPRECOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not cdsCompras.IsEmpty then
    Text := 'R$ '+ FormatFloat('0.00', cdsCompras.FieldByName('PRECO').AsFloat)
  else
    Text := '';
end;

procedure TTCompraC.cdsComprasVALOR_TOTALGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not cdsCompras.IsEmpty then
    Text := 'R$ '+ FormatFloat('0.00', cdsCompras.FieldByName('VALOR_TOTAL').AsFloat)
  else
    Text := '';
end;

procedure TTCompraC.btnCancelarClick(Sender: TObject);
begin
  if MessageBox(Handle,'Deseja realmente Fechar?','',MB_ICONQUESTION+MB_YESNO)=IDYES then
    Close
  else
    exit;
end;

procedure TTCompraC.btnDeleteitensClick(Sender: TObject);
begin
  if not cdsCompras.IsEmpty then
  begin
    IF not cdsCompras.FieldByName('COD_PRODUTO').IsNull then
    begin
      if VetDeletarItens.IndexOf(cdsCompras.FieldByName('COD_PRODUTO').AsString) = -1 then
      begin
        VetDeletarItens.Add(cdsCompras.FieldByName('COD_PRODUTO').AsString);
        VetsaldoEstoque.Add(cdsCompras.FieldByName('QUANTIDADE').AsString);
      end;
    end;
  end
  else
  begin
    EnviaMensagem('Nenhum registro adicionado!','Informa??o...', mtInformation, [mbOK]);
    if edCodProduto.CanFocus then
      edCodProduto.SetFocus;
    exit;
  end;
  VALOR:= VALOR -  cdsCompras.FieldByName('VALOR_TOTAL').AsFloat;
  mostraTotal.Text :=  FloatToStr(VALOR);

  qtd_itens.Caption := IntToStr(strToInt(qtd_itens.Caption) -  cdsCompras.FieldByName('QUANTIDADE').AsInteger );

  cdsCompras.Delete; // remo?a? da linha selecionada
  btnLimpaP.Click;
end;

procedure TTCompraC.btnLimpaCClick(Sender: TObject);
begin
  edCodCliente.ReadOnly := False;
  edCodCliente.Clear;
  edNomeCli.Clear;
  edRGCli.Clear;
  btnPesquisaCliente.Enabled:= True;
  btnLimpaC.Enabled:=False;
  if edCodCliente.CanFocus then
    edCodCliente.SetFocus;
end;

procedure TTCompraC.btnLimpaPClick(Sender: TObject);
begin
  edCodProduto.Clear;
  edNomeProduto.Clear;
  edQuantidade.Clear;
  edValorUn.Clear;
  btnPesquisaProduto.Enabled := True;
  btnPesquisaProduto.Focused;
  btnLimpaP.Enabled := False;
  edQuantidade.ReadOnly := True;
  edCodProduto.ReadOnly := False;
  if edCodProduto.CanFocus then
    edCodProduto.SetFocus;
end;

procedure TTCompraC.btnLimpaPKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    if  btnPesquisaProduto.CanFocus then
    begin
      btnPesquisaProduto.SetFocus;
    end;
  end;
end;

procedure TTCompraC.btnPesquisaClienteClick(Sender: TObject);
var Codigo : Integer;
begin
  Codigo := TCliente.ChamaTela(True);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLIENTE, NOME, CPF');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLIENTE = '+ IntToStr(Codigo) );
      Open;

      edCodCliente.Text := FieldByName('COD_CLIENTE').AsString;
      edNomeCli.Text := FieldByName('NOME').AsString;
      edRGCli.Text := FieldByName('CPF').AsString;

      Close;
      //ExecSQL;
      btnPesquisaCliente.Enabled:= False;
      btnLimpaC.Enabled :=True;
      btnPesquisaProduto.Enabled := True;
      edCodProduto.Enabled := True;
      edQuantidade.ReadOnly := False;

      if  edCodProduto.CanFocus then
        edCodProduto.SetFocus;
    end;
  end;
end;

procedure TTCompraC.btnPesquisaProdutoClick(Sender: TObject);
var Codigo : Integer;
begin
  Codigo := TProduto.ChamaTela('',0,True);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PRODUTO, DESCRICAO, PRECO');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PRODUTO = '+ IntToStr(Codigo) );
      Open;

      edCodProduto.Text := FieldByName('COD_PRODUTO').AsString;
      edNomeProduto.Text := FieldByName('DESCRICAO').AsString;
      edValorUn.Text := FieldByName('PRECO').AsString;

      Close;
      //ExecSQL;
      btnPesquisaProduto.Enabled:= False;
      btnLimpaP.Enabled :=True;
    end;
    edQuantidade.ReadOnly := false;
    if  edQuantidade.CanFocus then
      edQuantidade.SetFocus;
  end;
end;

procedure TTCompraC.btnSalvarClick(Sender: TObject);
var
  vr : integer;
  i : Smallint;
  aux : integer;
begin
// inserir a??o de salvar na tabela Compras e itens_Compra
// utilizada uma grid tempor?ria com ele e os dados do cliente
// realizar a inser??o dos dados correspondes das tabelas
  if cdsCompras.IsEmpty then // verifica??o de produto adicionado no carrinho
  begin
    EnviaMensagem('Nenhum produto adicionado na compra!','Sem produtos!',mtInformation, [mbOK]);
    if edCodProduto.CanFocus then
      edCodProduto.SetFocus;
   // exit;
  end;
  if Empty(edCodCliente.Text)  then     // verifica??o de sele??o de clientes
  begin
     EnviaMensagem('Consulte o Cliente da venda','Cliente n?o informado!',mtInformation, [mbOK]);
     if edCodCliente.CanFocus then
       edCodCliente.SetFocus;
     exit;
  end;

  with TDMPrincipal.QAux do
  begin
    case AcaoTela[1] of
      'I':        //INSERIR
      begin
        // inserir dados na tabela compra
        Close;
        SQL.CLEAR;
        SQL.Add('SET DATEFORMAT ymd ');
        SQL.Add('INSERT INTO COMPRA( DATA, COD_CLIENTE, VALOR_TOTAL)');
        SQL.Add('VALUES(' + DataSQL(Date()));
        SQL.Add(', ' + IntegerTextSql(edCodCliente.Text) );
        SQL.Add(', ' +  ColocaPonto(mostraTotal.Text));
        SQL.Add(' )');
        ExecSQL;

        vr:= GetCodigoIdentity('COMPRA');  // BUSCA O CODIGO DA ?LTIMA COMPRA
        //insere os dados na tabela itens_compra
        cdsCompras.First;   // iniciando index inicial ou seja a primeira linha
        while not cdsCompras.Eof do
        begin // inserir dados na tabela ITENS_COMPRA
          SQL.Clear;
          SQL.Add('INSERT INTO ITENS_COMPRA ( COD_PRODUTO, QUANTIDADE, COD_COMPRA)');
          SQL.Add('VALUES ( ');
          SQL.Add(IntegerTextSql(cdsCompras.FieldByName('COD_PRODUTO').AsInteger));
          SQL.Add(', ' + IntegerTextSql(cdsCompras.FieldByName('QUANTIDADE').AsInteger));
          SQL.Add(', ' + IntegerTextSql(vr));
          SQL.Add(' )');
          ExecSQL;            // executa comando

          AtualizaSaldoEstoque('I',cdsCompras.FieldByName('COD_PRODUTO').AsInteger, cdsCompras.FieldByName('QUANTIDADE').AsInteger);

          cdsCompras.Next;    // avan?? p/ proxima linha
        end;

        EnviaMensagem('Compra Cadastada!','Status da Compra Finalizada!',mtInformation, [mbOk]);
//        cdsCompras.Close;
      end;
      'E':
      begin
        Close;
        {VERFICAR SE O VETOR POSSUI ITENS}
        IF NOT(VetDeletarItens.DelimitedText = '') then
        begin
          For i:=0 to VetDeletarItens.Count-1 do
          begin
            aux := StrToInt(VetsaldoEstoque.Strings[i]);
            AtualizaSaldoEstoque('D',StrToInt(VetDeletarItens.Strings[i]), aux);
          end;
          // ShowMessage(listas.Strings[i]);
          {SE POSSUIR DELETAR OS ITENS QUE EST?O NO VETOR}
          SQL.CLEAR;
          SQL.Add('DELETE ITENS_COMPRA');
          SQL.Add('WHERE COD_PRODUTO IN (');
          SQL.Add(VetDeletarItens.DelimitedText);
          SQL.Add(')');
          ExecSQL;
          //  InputBox('','',SQL.Text);
        end;

        // editar (UPdate) dados na tabela compra
        SQL.CLEAR;
        SQL.Add('SET DATEFORMAT ymd ');
        SQL.Add('UPDATE COMPRA ');
        SQL.Add('SET  DATA = ' + StringTextSql(DateToStr(Date)));
        SQL.Add(', COD_CLIENTE = ' + IntegerTextSql(edCodCliente.Text) );
        SQL.Add(', VALOR_TOTAL = ' +  ColocaPonto(mostraTotal.Text));
        SQL.Add('WHERE COD_COMPRA = ' + IntegerTextSql(xCodCompra) );
        ExecSQL;

        {WHILE]
        {S? VAI ADICIONAR OS ITENS TEM POSSUIREM O PARAMETRO ACAO = 'I'}
        // EDITANDO A TABELA ITENS_COMPRA
        cdsCompras.First;   // iniciando index inicial ou seja a primeira linha
        while not cdsCompras.Eof do
        begin // inserir dados na tabela ITENS_COMPRA
          if cdsCompras.FieldByName('ACAO').AsString = 'I' then
          begin
            SQL.Clear;
            SQL.Add('INSERT INTO ITENS_COMPRA (COD_PRODUTO, QUANTIDADE, COD_COMPRA)');
            SQL.Add('VALUES ( ');
            SQL.Add(IntegerTextSql(cdsCompras.FieldByName('COD_PRODUTO').AsInteger));
            SQL.Add(', ' + IntegerTextSql(cdsCompras.FieldByName('QUANTIDADE').AsInteger));
            SQL.Add(', ' + IntegerTextSql(xCodCompra));
            SQL.Add(' )');
            ExecSQL;   // executa comando
            // atualiza estoque de produto comprado
            AtualizaSaldoEstoque('I',cdsCompras.FieldByName('COD_PRODUTO').AsInteger, cdsCompras.FieldByName('QUANTIDADE').AsInteger);
          end;

          cdsCompras.Next;    // avan?? p/ proxima linha
        end;
        EnviaMensagem('COMPRA do '+ edNomeCli.Text  +' est? EDITADO!', 'Aten??o!', mtInformation,[mbOK] );
      end;
    end;
  end;
  // botoes para realizar a limpeza da dbgrid e campos
  cdsCompras.EmptyDataSet;
  btnLimpaC.Click;
  btnLimpaP.Click;
  mostraTotal.Clear;
  qtd_itens.Caption := '';
  btnPesquisaProduto.Enabled := False;
  if edCodCliente.CanFocus then
    edCodCliente.SetFocus;
end;

procedure TTCompraC.AtualizaSaldoEstoque(acao : string ;codProduto: Integer; quantidade: Integer);
var ESTOQUE : Integer;
begin
  //BUSCAR O SALDO
  with TDMPrincipal.QAux do
  begin
    SQL.Clear;
    SQL.Add('SELECT ESTOQUE');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE COD_PRODUTO = '+ IntegerTextSql(codProduto));
    Open;
    ESTOQUE := FieldByName('ESTOQUE').AsInteger;

    IF acao = 'I' then
      ESTOQUE := ESTOQUE - quantidade;
    if acao = 'D' then
      ESTOQUE := ESTOQUE + quantidade;

    // ATUALIZA O SALDO
    SQL.Clear;
    SQL.Add('UPDATE PRODUTO');
    SQL.Add('SET ESTOQUE = '+ IntegerTextSql(ESTOQUE));
    SQL.Add('WHERE COD_PRODUTO =' + IntegerTextSql(codProduto));
    ExecSQL;
  end;
end;

procedure TTCompraC.ChamaTela(pAcaoTela: string ; CodCompra : Integer) ;
begin
  TCompraC := TTCompraC.Create(Application);
  with TCompraC do
  begin
    xCodCompra := CodCompra;
    AcaoTela := pAcaoTela;
    if AcaoTela = 'I' then {Inserir}
    begin
      //CarregaDados;
     // DesabilitaComponentes;
      //.Caption:='CONSULTAR CLIENTE';
    end;
    if AcaoTela = 'C' then {Consultar}
    begin
      CarregaDados;
      DesabilitaComponentes;
      TCompraC.Caption:='CONSULTAR VENDA';
    end;
    if AcaoTela = 'E' then {Editar}
    begin
      CarregaDados;
      btnPesquisaProduto.Enabled := True;
      edQuantidade.ReadOnly := False;
      TCompraC.Caption:='EDITAR VENDA';
    end;
    ShowModal;
  end;
  FreeAndNil(TCompraC);
end;

procedure TTCompraC.edCodClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      if btnPesquisaCliente.CanFocus then
      begin
        btnPesquisaCliente.SetFocus;
      end;
    end;
    VK_F3:
    begin
      if (btnPesquisaCliente .Enabled) and (btnPesquisaCliente.Visible) then
        btnPesquisaCliente.Click;
    end;
    VK_F6:
    begin
      if (btnLimpaC.Enabled) and (btnLimpaC.Visible) then
        btnLimpaC.Click;
    end;
  end;
end;

procedure TTCompraC.edCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and not Empty(edCodCliente.Text) then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLIENTE ,NOME, CPF, ATIVO');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLIENTE = ' + StringTextSql(edCodCliente.Text));
      Open;

      edNomeCli.Text := FieldByName('NOME').AsString;
      edRGCli.Text := FieldByName('CPF').AsString;

      if not IsEmpty then
      begin
        {passa os valores}
        edCodCliente.ReadOnly := True;
        btnPesquisaCliente.Enabled := False;
        btnLimpaC.Enabled := True;
        btnPesquisaProduto.Enabled := True;
      end
      else
      begin
        EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbok]);
        btnLimpaC.Click;
        Exit;
      end;
      if edCodProduto.CanFocus then
        edCodProduto.SetFocus;
    end;
  end;
end;

procedure TTCompraC.edCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      if btnPesquisaProduto.CanFocus then
        btnPesquisaProduto.SetFocus;
    end;
    VK_F3:
    begin
      if (btnPesquisaProduto.Enabled) and (btnPesquisaProduto.Visible) then
        btnPesquisaProduto.Click;
    end;
    VK_F6:
    begin
      if (btnLimpaP.Enabled) and (btnLimpaP.Visible) then
        btnLimpaP.Click;
    end;
  end;
end;

procedure TTCompraC.edCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and not Empty(edCodProduto.Text) then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PRODUTO, DESCRICAO, PRECO');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PRODUTO = '+ StringTextSql(edCodProduto.Text));
      Open;

      edNomeProduto.Text := FieldByName('DESCRICAO').AsString;
      edValorUn.Text := FieldByName('PRECO').AsString;

      if not IsEmpty then
      begin
        {passa os valores}
        edCodProduto.ReadOnly := True;
        btnPesquisaProduto.Enabled := False;
        btnLimpaP.Enabled := True;
        edQuantidade.ReadOnly := False;
        if edQuantidade.CanFocus then
          edQuantidade.SetFocus;
      end
      else
      begin
        EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbok]);
        btnLimpaP.Click;
        Exit;
      end;
    end;
  end;
end;

procedure TTCompraC.edQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    if  btnAdditens.CanFocus then
    begin
      btnAdditens.SetFocus;
    end;
  end;
  edQuantidade.MaxLength := 9;
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back) and (word(key) <> VK_RETURN)) then
    key := #0;
end;

procedure TTCompraC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //btnCancelar.Click;
  VALOR:=0;
  FreeAndNil(cdsCompras);
  FreeAndNil(VetDeletarItens);
  FreeAndNil(VetsaldoEstoque);
end;

procedure TTCompraC.FormCreate(Sender: TObject);
begin
  cdsCompras.CreateDataSet;
  VetDeletarItens := TStringList.Create;
  VetsaldoEstoque := TStringList.Create;
end;

procedure TTCompraC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F5:
    begin
      if (btnSalvar.Enabled) and (btnSalvar.Visible) then
        btnSalvar.Click;
    end;
  end;
end;

end.
