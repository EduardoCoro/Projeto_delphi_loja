object TDMPrincipal: TTDMPrincipal
  OldCreateOrder = False
  Height = 265
  Width = 378
  object ADOConexao: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=01;Persist Security Info=True;User ' +
      'ID=sa;Initial Catalog=ESTAGIARIO_EDU;Data Source=192.168.1.190\s' +
      'qlexpress,3316;Use Procedure for Prepare=1;Auto Translate=True;P' +
      'acket Size=4096;Workstation ID=LEANDRO-PC;Use Encryption for Dat' +
      'a=False;Tag with column collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 152
    Top = 56
  end
  object QAux: TADOQuery
    Connection = ADOConexao
    Parameters = <>
    Left = 56
    Top = 64
  end
end
