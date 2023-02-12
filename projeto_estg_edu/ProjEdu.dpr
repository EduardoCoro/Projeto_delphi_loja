program ProjEdu;

uses
  Forms,
  MenuPrincipal in 'MenuPrincipal.pas' {TMenuPrincipal},
  Cliente in 'Cliente.pas' {TCliente},
  Produto in 'Produto.pas' {TProduto},
  Compra in 'Compra.pas' {TCompra},
  Funcoes in 'Funcoes.pas',
  Funcoesdb in 'Funcoesdb.pas',
  ClienteC in 'ClienteC.pas' {TClienteC},
  CompraC in 'CompraC.pas' {TCompraC},
  DMPrincipal in 'DMPrincipal.pas' {TDMPrincipal: TDataModule},
  Login in 'Login.pas' {Tlogin},
  ProdutoC in 'ProdutoC.pas' {TProdutoC},
  RelProduto in 'RelProduto.pas' {TRelProduto},
  FiltroRelCliente in 'FiltroRelCliente.pas' {TFiltroRelCliente},
  RelCliente in 'RelCliente.pas' {TRelCliente},
  Fornecedor in 'Fornecedor.pas' {TFornecedor},
  FornecedorC in 'FornecedorC.pas' {TFornecedorC},
  FiltroRelProduto in 'FiltroRelProduto.pas' {TFiltroRelProduto},
  ProdutoEstoque in 'ProdutoEstoque.pas' {TEstoque},
  FiltroRelCompra in 'FiltroRelCompra.pas' {TFiltroRelCompraCli},
  RelCompra in 'RelCompra.pas' {TRelCompra},
  FiltroRelFornecedor in 'FiltroRelFornecedor.pas' {TFiltroRelFornecedor},
  RelFornecedor in 'RelFornecedor.pas' {TRelFornecedor},
  FiltroRelEstoque in 'FiltroRelEstoque.pas' {TFiltroRelEstoquePro},
  RelEstoque in 'RelEstoque.pas' {TRelEstoque},
  FiltroRelItensVendas in 'FiltroRelItensVendas.pas' {TFiltroRelItensVendas},
  RelItensVendas in 'RelItensVendas.pas' {TRelItensVendas},
  RelClienteS in 'RelClienteS.pas' {TRelClienteS},
  RelTopCliente in 'RelTopCliente.pas' {TRelTopCliente},
  FiltroRelTopCliente in 'FiltroRelTopCliente.pas' {TFiltroRelTopCli},
  FiltroRelTopProduto in 'FiltroRelTopProduto.pas' {TFiltroRelTopProduto},
  RelTopProduto in 'RelTopProduto.pas' {TRelTopProduto},
  FiltroRelTopFornecedor in 'FiltroRelTopFornecedor.pas' {TFiltroRelTopFuncionario},
  RelTopFornecedor in 'RelTopFornecedor.pas' {TRelTopFornecedor},
  RelFornecedorProduto in 'RelFornecedorProduto.pas' {TRelFornecedorProd},
  RelProdutoS in 'RelProdutoS.pas' {TRelProdutoS},
  RelFornecedorS in 'RelFornecedorS.pas' {TRelFornecedorS},
  FiltroRelCompraModel in 'FiltroRelCompraModel.pas' {TFiltroRelCompModel},
  RelCompraModel in 'RelCompraModel.pas' {TRelCompraModel},
  RelCompraModelFornecedor in 'RelCompraModelFornecedor.pas' {TRelCompraModelFornece},
  FiltroRelCompraModelFornecedor in 'FiltroRelCompraModelFornecedor.pas' {TfiltroRelCompraModelFornecedor},
  RelCompraS in 'RelCompraS.pas' {TRelCompraS},
  GraficoCliente in 'GraficoCliente.pas' {TGrafCliente},
  GraficoTopCliente in 'GraficoTopCliente.pas' {TGraficoTopCliente},
  GraficoTopFornecedor in 'GraficoTopFornecedor.pas' {TGraficoFornecedor},
  GraficoTopProdutos in 'GraficoTopProdutos.pas' {TGraficoTopProdutos},
  GraficoFornecedor in 'GraficoFornecedor.pas' {TGraficoForneceProdutos},
  GraficoListCliente in 'GraficoListCliente.pas' {TGraficoListCliente},
  GraficoListFornecedor in 'GraficoListFornecedor.pas' {TGraficoListFornecedor},
  GraficoListProdutos in 'GraficoListProdutos.pas' {TGraficoListProdutos},
  GraficoEstoque in 'GraficoEstoque.pas' {TGraficoEstoque},
  RelEstoqueS in 'RelEstoqueS.pas' {TRelEstoqueS},
  GraficoCompra in 'GraficoCompra.pas' {TGraficoCompra},
  RelFornecedorProdutoS in 'RelFornecedorProdutoS.pas' {TRelFornecedorProdutoS},
  Configuracoes in 'Configuracoes.pas' {TConfig};

//TTDMPrincipal
{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'S.T Propulsao';
  Application.CreateForm(TTDMPrincipal, TDMPrincipal);
  Application.CreateForm(TTMenuPrincipal, TMenuPrincipal);
  Application.Run;
end.
