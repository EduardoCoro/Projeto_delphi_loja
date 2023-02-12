unit FiltroRelEstoque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ExtCtrls, Buttons, DB, ADODB, Mask, ComCtrls,
  DBClient, Grids, DBGrids;

type
  TTFiltroRelEstoquePro = class(TForm)
    Panel1: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    FiltroRelCliente: TPanel;
    Panel3: TPanel;
    gFornecedor: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    btnPesquisaFornecedor: TBitBtn;
    btnLimpaF: TBitBtn;
    edCodFornecedor: TEdit;
    edNomeFornecedor: TEdit;
    rgtipoFornece: TRadioGroup;
    cdsProduto: TClientDataSet;
    cdsProdutoCODIGO: TStringField;
    cdsProdutoNOME: TStringField;
    dsProduto: TDataSource;
    Pagecontrol: TPageControl;
    PgAnalitico: TTabSheet;
    rgOrdem: TRadioGroup;
    rgFiltro: TRadioGroup;
    gpestoque: TGroupBox;
    Label1: TLabel;
    rgOpcao: TRadioGroup;
    edEstoque: TEdit;
    btnlimpaOpcao: TBitBtn;
    PgGrafico: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edCodProduto: TEdit;
    edProduto: TEdit;
    btnPesquisaProduto: TBitBtn;
    btnLimpaP: TBitBtn;
    btnAdditens: TBitBtn;
    btnDeleteitens: TBitBtn;
    DBGProduto: TDBGrid;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure edEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure DCombNomeKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLimpaFClick(Sender: TObject);
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure edCodFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure edCodFornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnlimpaOpcaoClick(Sender: TObject);
    procedure edEstoqueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rgtipoForneceClick(Sender: TObject);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure btnLimpaPClick(Sender: TObject);
    procedure btnDeleteitensClick(Sender: TObject);
    procedure edCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdditensClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    VetAddProduto : TStringlist;
  public
    { Public declarations }
    procedure chamatela;

  end;

var
  TFiltroRelEstoquePro: TTFiltroRelEstoquePro;

implementation

uses
 RelEstoque, Funcoes, DMPrincipal, Fornecedor, Funcoesdb, Produto, GraficoEstoque, RelEstoqueS;

{$R *.dfm}


procedure TTFiltroRelEstoquePro.btnAdditensClick(Sender: TObject);
begin
  with cdsProduto do
  begin
    //  VERIFICA SE O CLIENTE J� EST� ADICIONADO NA GRID
    IF Locate('COD_PRODUTO', edCodProduto.Text, []) then
    begin
       EnviaMensagem('Produto j� listado!','Aten��o!',mtInformation, [mbOK]);
       btnLimpaP.Click;
       exit;
    end;

    First;
    Append;
    FieldByName('COD_PRODUTO').AsInteger := StrToInt(edCodProduto.Text);
    FieldByName('PRODUTO').AsString := edProduto.Text;
    Post;

    btnLimpaP.Click;
  end;
end;

procedure TTFiltroRelEstoquePro.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroRelEstoquePro.btnDeleteitensClick(Sender: TObject);
begin
  if not cdsProduto.IsEmpty then
  begin
    cdsProduto.Delete;
    btnLimpaP.Click;
  end;
end;

procedure TTFiltroRelEstoquePro.btnImprimirClick(Sender: TObject);
begin
  // PASSANDO OS C�DIGO DA TABELA AO VETOR
  if not cdsProduto.IsEmpty then
  begin
    cdsProduto.First;   // iniciando index inicial ou seja a primeira linha
    while not cdsProduto.Eof do
    begin
      //InputBox('','',cdsCliente.FieldByName('COD_CLIENTE').AsString);
      if not cdsProduto.FieldByName('COD_PRODUTO').IsNull then
      begin
        if VetAddProduto.IndexOf(cdsProduto.FieldByName('COD_PRODUTO').AsString) = -1 then
        begin //adicionando o codigo do cliente
          VetAddProduto.Add(cdsProduto.FieldByName('COD_PRODUTO').AsString);
        end;
      end;
      cdsProduto.Next;    // avan�� p/ proxima linha
    end;
  end;

  case rgtipoFornece.ItemIndex of
    0: //anal�tico
    begin
      if (rgOpcao.ItemIndex = 0) OR (rgOpcao.ItemIndex = 1) then
      begin
        if edEstoque.Text = '' then
        begin
          if edEstoque.CanFocus then
            edEstoque.SetFocus;

          EnviaMensagem('Digite a quantidade de estoque!','Campo selecionado est� vazio!',mtInformation,[mbOK]);
          exit;
        end;
      end;

      if Empty(edEstoque.Text) then
        TRelEstoque.chamatela(VetAddProduto,rgFiltro.ItemIndex, rgOrdem.ItemIndex, -1 ,edCodFornecedor.Text, rgOpcao.ItemIndex )
      else
        TRelEstoque.chamatela(VetAddProduto,rgFiltro.ItemIndex, rgOrdem.ItemIndex, StrToInt(edEstoque.Text) ,edCodFornecedor.Text, rgOpcao.ItemIndex);
    end;
    1:  //sintetico
    begin
      if edCodFornecedor.Text <> '' then
        TRelEstoqueS.Chamatela(StrToInt(edCodFornecedor.Text))
      else
        TRelEstoqueS.Chamatela(0);
    end;
    2:    //GRAFICO
    begin
      if edCodFornecedor.Text <> '' then
        TGraficoEstoque.Chamatela(StrToInt(edCodFornecedor.Text), VetAddProduto ,rgFiltro.ItemIndex, rgOrdem.ItemIndex )
      else
        TGraficoEstoque.Chamatela(0, VetAddProduto, rgFiltro.ItemIndex, rgOrdem.ItemIndex);
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.btnLimpaFClick(Sender: TObject);
begin
  edCodFornecedor.Clear;
  edNomeFornecedor.Clear;
  btnPesquisaFornecedor.Enabled := True;
  btnPesquisaFornecedor.Focused;
  btnLimpaF.Enabled := False;
  btnPesquisaFornecedor.SetFocus;
  PgGrafico.TabVisible := False;
  edCodFornecedor.ReadOnly := False;
  if edCodFornecedor.CanFocus then
    edCodFornecedor.SetFocus;
end;

procedure TTFiltroRelEstoquePro.btnlimpaOpcaoClick(Sender: TObject);
begin
  edEstoque.Clear;
  rgOpcao.ItemIndex := -1;
end;

procedure TTFiltroRelEstoquePro.btnLimpaPClick(Sender: TObject);
begin
  edCodProduto.Clear;
  edProduto.Clear;
  btnPesquisaProduto.Enabled := True;
  btnPesquisaProduto.Focused;
  btnLimpaP.Enabled := False;
  edCodProduto.ReadOnly := False;
  if edCodProduto.CanFocus then
    edCodProduto.SetFocus;
end;

procedure TTFiltroRelEstoquePro.btnPesquisaFornecedorClick(Sender: TObject);
var Codigo : Integer;
begin
  Codigo := TFornecedor.ChamaTela(True);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR, NOME');
      SQL.Add('FROM FORNECEDOR');
      SQL.Add('WHERE COD_FORNECEDOR = '+ IntToStr(Codigo) );
      Open;

      edCodFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;
      edNomeFornecedor.Text := FieldByName('NOME').AsString;

      Close;
      //ExecSQL;
      btnPesquisaFornecedor.Enabled := False;
      btnLimpaF.Enabled := True;
      edCodFornecedor.ReadOnly := True;
      PgGrafico.TabVisible := True;

      if  edCodFornecedor.CanFocus then
        edCodFornecedor.SetFocus;
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.btnPesquisaProdutoClick(Sender: TObject);
var Codigo : Integer;
begin

  Codigo := TProduto.ChamaTela('',StrToInt(edCodFornecedor.Text), True);
  //TProduto.Carregafornecedor(edCodFornecedor.Text);
  if Codigo > 0 then
  begin
    //select nome, rg
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PRODUTO, DESCRICAO, PRECO, COD_FORNECEDOR');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PRODUTO = '+ IntToStr(Codigo) );
      SQL.Add('AND COD_FORNECEDOR ='+ StringTextSql(edCodFornecedor.Text));
      Open;

      edCodProduto.Text := FieldByName('COD_PRODUTO').AsString;
      edProduto.Text := FieldByName('DESCRICAO').AsString;

      Close;
      //ExecSQL;
      btnPesquisaProduto.Enabled:= False;
      btnLimpaP.Enabled :=True;
    end;
    edCodProduto.ReadOnly := false;
    if  btnAdditens.CanFocus then
      btnAdditens.SetFocus;
  end;
end;

procedure TTFiltroRelEstoquePro.chamatela;
begin
  TFiltroRelEstoquePro := TTFiltroRelEstoquePro.Create(Application);
  with TFiltroRelEstoquePro do
  begin
    ShowModal;
  end;
  FreeAndNil(TFiltroRelEstoquePro);
end;

procedure TTFiltroRelEstoquePro.DCombNomeKeyPress(Sender: TObject;
  var Key: Char);
begin
  key := #0;
end;

procedure TTFiltroRelEstoquePro.edCodFornecedorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_F3:
    begin
      if (btnPesquisaFornecedor.Enabled) and (btnPesquisaFornecedor.Visible) then
        btnPesquisaFornecedor.Click;
    end;
    VK_F6:
    begin
      if (btnLimpaF.Enabled) and (btnLimpaF.Visible) then
        btnLimpaF.Click;
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.edCodFornecedorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = #13) and not Empty(edCodFornecedor.Text) then
  begin
    with TDMPrincipal.QAux do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR ,NOME');
      SQL.Add('FROM FORNECEDOR ');
      SQL.Add('WHERE COD_FORNECEDOR = ' + StringTextSql(edCodFornecedor.Text));
      Open;

      edNomeFornecedor.Text := FieldByName('NOME').AsString;
      edCodFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;

      if not IsEmpty then
      begin
        {passa os valores}
        edCodFornecedor.ReadOnly := True;
        btnPesquisaFornecedor.Enabled := False;
        btnLimpaF.Enabled := True;
        btnPesquisaFornecedor.Enabled := False;
        PgGrafico.TabVisible := True;
      end
      else
      begin
        EnviaMensagem('Nenhum registro encontrado!','', mtInformation, [mbok]);
        btnLimpaF.Click;
        Exit;
      end;
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.edCodProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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

procedure TTFiltroRelEstoquePro.edCodProdutoKeyPress(Sender: TObject;
  var Key: Char);
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
      SQL.Add('AND COD_FORNECEDOR ='+ StringTextSql(edCodFornecedor.Text));
      Open;

      edProduto.Text := FieldByName('DESCRICAO').AsString;

      if not IsEmpty then
      begin
        {passa os valores}
        edCodProduto.ReadOnly := True;
        btnPesquisaProduto.Enabled := False;
        btnLimpaP.Enabled := True;
        if btnAdditens.CanFocus then
          btnAdditens.SetFocus;
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

procedure TTFiltroRelEstoquePro.edEstoqueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F8:
    begin
      if (btnlimpaOpcao.Enabled) and (btnlimpaOpcao.Visible) then
        btnlimpaOpcao.Click;
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.edEstoqueKeyPress(Sender: TObject;
  var Key: Char);
begin
  edEstoque.MaxLength := 9;
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back) and (word(key) <> VK_RETURN)) then
    key := #0;
end;

procedure TTFiltroRelEstoquePro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(cdsProduto);
  FreeAndNil(VetAddProduto);
end;

procedure TTFiltroRelEstoquePro.FormCreate(Sender: TObject);
begin
  cdsProduto.CreateDataSet;
  VetAddProduto := TStringList.Create;
  PgGrafico.TabVisible := False;
end;

procedure TTFiltroRelEstoquePro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F5:
    begin
      if (btnImprimir.Enabled) and (btnImprimir.Visible) then
        btnImprimir.Click;
    end;
    VK_ESCAPE:
    begin
      if (btnCancelar.Enabled) and (btnCancelar.Visible) then
        btnCancelar.Click;
    end;
    VK_F8:
    begin
      if (btnlimpaOpcao.Enabled) and (btnlimpaOpcao.Visible) then
        btnlimpaOpcao.Click;
    end;
  end;
end;

procedure TTFiltroRelEstoquePro.rgtipoForneceClick(Sender: TObject);
begin
  case rgtipoFornece.ItemIndex of
    0:  //analitico
    begin
      Pagecontrol.Visible := True;
      gpestoque.Visible := True;
    end;
    1: //Sintetico
    begin
      Pagecontrol.Visible := False;
      gpestoque.Visible := True;
    end;
    2://Grafico
    begin
      Pagecontrol.Visible := True;
      gpestoque.Visible := False;
    end;
  end;
end;

end.


