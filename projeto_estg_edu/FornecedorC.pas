unit FornecedorC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, IniFiles, ExtCtrls;

type
  TTFornecedorC = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    cbAtivo: TCheckBox;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    GroupBox1: TGroupBox;
    edtNome: TEdit;
    Panel3: TPanel;
    gpCnpj: TGroupBox;
    edtCnpj: TMaskEdit;
    gpContato: TGroupBox;
    Label2: TLabel;
    edDD: TEdit;
    edTelefone: TEdit;
    Label5: TLabel;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure edTelefoneKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtNomeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ArquivoINI : TIniFile;
    Forcnpj : Boolean;
    Forcontato : Boolean;
    xCodFornecedor: Integer;
    AcaoTela: String;
    procedure DesabilitaComponentes;
    procedure CarregaDados;
  public
    { Public declarations }
    function ChamaTela(pAcaoTela: string ; CodFornecedor : Integer ): integer;
  end;

var
  TFornecedorC: TTFornecedorC;

implementation

uses
 DMPrincipal, Funcoesdb, Funcoes;

{$R *.dfm}

procedure TTFornecedorC.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFornecedorC.btnSalvarClick(Sender: TObject);
begin
  //nome fornecedor
  if Empty(edtNome.Text) or (edtNome.Text = '') or (Length(edtNome.Text) <= 2) then
  begin
    EnviaMensagem('Informe o Nome!', 'Informa��o...', mtInformation,[mbOK] );
    if edtNome.CanFocus then
      edtNome.SetFocus;
    Exit
  end;
  // cnpj
  if Forcnpj <> True then
    if Empty(edtCnpj.Text) or (edtCnpj.Text = '  .   .   /    -  ') then
    begin
      EnviaMensagem('Informe o CNPJ!', 'Informa��o...', mtInformation,[mbOK] );
      if edtCnpj.CanFocus then
        edtCnpj.SetFocus;
      Exit;
    end;
  //telefone
  if Forcontato <> True then
    if Empty(edTelefone.Text) or Empty(edDD.Text) then
    begin
      if Empty(edTelefone.Text) then
      begin
        EnviaMensagem('Informe o Telefone!', 'Informa��o...', mtInformation,[mbOK] );
        if edTelefone.CanFocus then
          edTelefone.SetFocus;
      end
      else
      begin
        EnviaMensagem('Informe o DDD!', 'Informa��o...', mtInformation,[mbOK] );
        if edDD.CanFocus then
          edDD.SetFocus;
      end;

      Exit
    end;

  // VERFICA TELEFONE nome e cnpj
  with TDMPrincipal.QAux do
  begin
    //Telefone
    Close;
    SQL.Clear;
    SQL.Add('SELECT TELEFONE');
    SQL.Add('FROM FORNECEDOR');
    SQL.Add('WHERE TELEFONE =' + StringTextSql(edTelefone.Text));
    Open;
    if (FieldByName('TELEFONE').AsString) = edTelefone.Text then
    begin
      EnviaMensagem('N�mero de telefone inv�lido, pois j� pertence a outro cadastro!','Informa��o...',mtInformation, [mbok]);
      if edTelefone.CanFocus then
        edTelefone.SetFocus;
      exit;
    end;
    //Nome de fornecedor
    SQL.Clear;
    SQL.Add('SELECT NOME');
    SQL.Add('FROM FORNECEDOR');
    SQL.Add('WHERE NOME =' + StringTextSql(edtNome.Text));
    Open;
    if (FieldByName('NOME').AsString) = edtNome.Text then
    begin
      EnviaMensagem('Nome de fornecedor inv�lido, pois j� pertence a outro cadastro!','Informa��o...',mtInformation, [mbok]);
      if edtNome.CanFocus then
        edtNome.SetFocus;
      exit;
    end;
    //CNPJ
    SQL.Clear;
    SQL.Add('SELECT CNPJ');
    SQL.Add('FROM FORNECEDOR');
    SQL.Add('WHERE CNPJ =' + StringTextSql(edtCnpj.Text));
    Open;
    if (FieldByName('CNPJ').AsString) = edtCnpj.Text then
    begin
      EnviaMensagem('CNPJ de fornecedor inv�lido, pois j� pertence a outro cadastro!','Informa��o...',mtInformation, [mbok]);
      if edtCnpj.CanFocus then
        edtCnpj.SetFocus;
      exit;
    end;
  end;

  // COMANDOS EVENTOS SQL
  with TDMPrincipal.QAux do
  begin
    case AcaoTela[1] of
      'I':  //INSERIR
      begin
        cbAtivo.Checked:=True;
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO FORNECEDOR( NOME, DDD ,TELEFONE, CNPJ, ATIVO)');
        SQL.Add('VALUES('+ StringTextSql(edtNome.Text));
        SQL.Add(', '+ StringTextSql(edDD.Text ));
        SQL.Add(', '+ StringTextSql(edTelefone.Text));
        SQL.Add(', '+ StringTextSql(edtCnpj.Text));
        sql.Add((', ' + BooleanTextSql(cbAtivo.Checked)));
        SQL.Add(')');
        ExecSQL;

        xCodFornecedor := GetCodigoIdentity('FORNECEDOR');

        EnviaMensagem('Fornecedor '+ edtNome.Text  +' est� cadastrado!', 'Aten��o!', mtInformation,[mbOK] );
      end;
      'E':   // EDITAR
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE FORNECEDOR');
        SQL.Add('SET NOME = '+ StringTextSql(edtNome.Text));
        SQL.Add(', DDD = '+ StringTextSql(edDD.Text));
        SQL.Add(', TELEFONE = '+ StringTextSql(edTelefone.Text));
        SQL.Add(', CNPJ = '+ StringTextSql(edtCnpj.Text));

        if cbAtivo.Checked = True  then
          SQL.Add( ', ATIVO = 1')
        else
          SQL.Add(', ATIVO = 0');

        SQL.Add('WHERE COD_Fornecedor = '+ IntToStr(xCodFornecedor) );
        ExecSQL;
        EnviaMensagem('Fornecedor '+ edtNome.Text  +' est� EDITADO!', 'Aten��o!', mtInformation,[mbOK] );
      end;
    end;
  end;
  Close;
end;

procedure TTFornecedorC.edTelefoneKeyPress(Sender: TObject; var Key: Char);
begin
  if key in [ '�','�', '�' , '�', '�', '�' , '�' , '�', '�', '�', '}' , '�' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'�' ,'&' , ')' , '(' ,'�' ,'�' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '�','-','='] then
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

procedure TTFornecedorC.edtNomeExit(Sender: TObject);
begin
  if edtNome.Text <> '' then
    if (Length(edtNome.Text) <= 2) then
    begin
      //A��o
      EnviaMensagem('Nome Inv�lido,teve conter mais de 3 palavras ,digite novamente!','Informa��o...',mtInformation,[mbOK]);
      if edtNome.CanFocus then
        edtNome.SetFocus;
    end;
end;

procedure TTFornecedorC.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpCase(Key);
   if key in ['/', '*' ,'�', '�' , '�', '�', '�' , '�' , '�', '�', '�', '}' , '�' ,'~' ,'^' ,'!' ,'@' ,'#' ,'$' ,'%' ,'�' ,'&' , ')' , '(' ,'�' ,'�' ,'{' ,'"',',','+','-','.','\','?',';','[',']', '�','='] then
     Key:=#0;
end;

procedure TTFornecedorC.FormCreate(Sender: TObject);
begin
  //abrir
  ArquivoINI := TIniFile.Create('D:\FOCUS\Ini\ConfigPrjEstagio.ini');
  // Leitura
  if ArquivoINI.ReadBool('Fornecedor','cnpj', Forcnpj ) = True then
  begin
    gpCnpj.Visible := False;
  end;
  if ArquivoINI.ReadBool('Fornecedor','contato', Forcontato ) = True then
  begin
    gpContato.Visible := False;
  end;
end;

procedure TTFornecedorC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F5:
    begin
      if (btnSalvar.Enabled) and (btnSalvar.Visible) then
        btnSalvar.Click;
    end;
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
  end;
end;

procedure TTFornecedorC.CarregaDados;
begin
  with TDMPrincipal.QAux do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_FORNECEDOR , NOME, DDD ,TELEFONE ,CNPJ, ATIVO');
    SQL.Add('FROM FORNECEDOR');
    SQL.Add('WHERE COD_FORNECEDOR = ' + IntToStr(xCodFornecedor));
    Open;

    edtNome.Text := FieldByName('NOME').AsString;
    edtCnpj.Text := FieldByName('CNPJ').AsString;
    edDD.Text := FieldByName('DDD').AsString;
    edTelefone.Text := FieldByName('TELEFONE').AsString;
    cbAtivo.Checked := FieldByName('ATIVO').AsBoolean;

    Close;
  end;
end;

procedure TTFornecedorC.DesabilitaComponentes;
begin
  edtNome.ReadOnly := True;
  edtCnpj.ReadOnly := True;
  edDD.ReadOnly := True;
  edTelefone.ReadOnly := True;
  cbAtivo.Enabled := False;
  btnSalvar.Enabled := False;
end;

function TTFornecedorC.ChamaTela(pAcaoTela: string; CodFornecedor: Integer): integer;
begin
  TFornecedorC := TTFornecedorC.Create(Application);
  with TFornecedorC do
  begin
   {I - inserir
    C - Consultar
    E - Editar}
    xCodFornecedor:= CodFornecedor;
    AcaoTela := pAcaoTela;
    if AcaoTela = 'C' then {CONSULTAR}
    begin
      CarregaDados;
      DesabilitaComponentes;
      TFornecedorC.Caption:='Consultar Fornecedor';
    end;
    if AcaoTela = 'E' then {EDITAR}
    begin
      CarregaDados;
      cbAtivo.Enabled := True;
      TFornecedorC.Caption:='Editar Fornecedor';
    end;
    if AcaoTela = 'I' then {inserir}
    begin
      CarregaDados;
      cbAtivo.Checked:=True;
      TFornecedorC.Caption:='Cadastro de Fornecedor';
    end;
    ShowModal;
    if xCodFornecedor > 0 then
      Result := xCodFornecedor;
  end;
  FreeAndNil(TFornecedorC);
end;

end.
