object TFiltroRelTopCli: TTFiltroRelTopCli
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Filtro de Relat'#243'rio dos Clientes que mais compraram'
  ClientHeight = 172
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FiltroRelCliente: TPanel
    Left = 0
    Top = 0
    Width = 394
    Height = 130
    Align = alClient
    BorderStyle = bsSingle
    Color = 15329769
    ParentBackground = False
    TabOrder = 0
    ExplicitHeight = 150
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 388
      Height = 66
      Align = alTop
      Caption = 'Busca por data..'
      TabOrder = 0
      object Label4: TLabel
        Left = 19
        Top = 30
        Width = 28
        Height = 16
        Caption = ' De: '
        Color = 15329769
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object Label2: TLabel
        Left = 181
        Top = 30
        Width = 34
        Height = 16
        Caption = '   '#193's  '
        Color = 15329769
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object edDataFim: TDateEdit
        Left = 233
        Top = 25
        Width = 120
        Height = 21
        CheckOnExit = True
        DialogTitle = 'Seleciona uma data'
        NumGlyphs = 2
        TabOrder = 1
        OnExit = edDataFimExit
      end
      object edDataInicio: TDateEdit
        Left = 55
        Top = 25
        Width = 120
        Height = 21
        CheckOnExit = True
        DialogTitle = 'Seleciona uma data'
        NumGlyphs = 2
        TabOrder = 0
        OnExit = edDataInicioExit
      end
    end
    object rgTipoRel: TRadioGroup
      Left = 1
      Top = 67
      Width = 388
      Height = 52
      Align = alTop
      Caption = 'Tipo de relat'#243'rio...'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Anal'#237'tico'
        'Gr'#225'fico')
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 130
    Width = 394
    Height = 42
    Align = alBottom
    BorderStyle = bsSingle
    Color = 15329769
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 150
    object btnImprimir: TBitBtn
      AlignWithMargins = True
      Left = 180
      Top = 4
      Width = 100
      Height = 30
      Align = alRight
      Caption = 'Imprimir(F5)'
      Glyph.Data = {
        36100000424D3610000000000000360000002800000020000000200000000100
        2000000000000010000000000000000000000000000000000000FFFFFF71FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF0000000000000000000000000073717300737173717371
        7373737173717371737373717371737173737371737173717373FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF000000000000C30000008200C300000000737173007371
        7373737173717371737373717371737173737371737173717373FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF000000000000C3000000C30000008200C30082000000000082FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF000000000000C3000000C30000008200C30082000000000082FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF000000000000C3000000C300C300C3000000C300C300820000008200820000
        0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF000000000000C3000000C300C300C3000000C300C300820000008200820000
        0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
        000000C3000000C30000C6FFC6C300FF00C600C300FF00C30000008200C30082
        000000000082FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF009C616300FFFFFF63FFFFFF00FFFFFF00FFFFFF000000
        000000C3000000C30000C6FFC6C300FF00C600C300FF00C30000008200C30082
        000000000082FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF009C616300000000619C6163009C616361FFFFFF630000000000C3
        000000C300C3C6FFC60000FF00FF00FF0000000000FF00C3000000C300C30082
        00000082008200000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF009C61630000000063FFCBCE00000000CE000000009C6163000000006100FF
        000000FF00FF00FF0000C6FFC6FF000000C6FFFFFF000000000000C300000082
        00000082008200000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C61
        630000000061FFCBCE00FFCBCECBFFCBCECECE9A9CCB0000009C000000000000
        000000FF000000FF000000FF00FF00000000FFFFFF000000000000C3000000C3
        0000008200C30082000000000082FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C6163000000
        0063FFCBCE00FFCBCECECE9A9CCBCE9A9C9C9C61639A9C616363000000610000
        00000000000000000000000000009C616300FFFFFF61FFFFFF000000000000C3
        0000008200C30082000000000082FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C61630000000061FFCB
        CE00CE9A9CCBCE9A9C9C9C61639A9C61636300000061000000009C6163009C61
        63639C6163619C616363000000619C6163009C616361FFFFFF630000000000C3
        000000C300C3008200000082008200000000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C61630000000063CE9A9C00CE9A
        9C9C9C61639A9C6163630000006100000000CE9A9C00CE9A9C9CCE9A9C9ACE9A
        9C9CCE9A9C9ACE9A9C9CCE9A9C9A0000009C000000009C6163009C6163610000
        006300C30000008200000082008200000000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF009C61630000000061CE9A9C009C61639A9C61
        63630000006100000000CE9A9C00CE9A9C9CCE9A9C9ACE9A9C9CCE9A9C9ACE9A
        9C9CCE9A9C9ACE9A9C9CCE9A9C9ACE9A9C9C0000009A00000000000000000000
        000000C3000000C30000008200C30082000000000082FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF009C616300000000639C6163009C616363000000610000
        0000FFCBCE00CE9A9CCEFFCBCE9ACE9A9CCEFFCBCE9ACE9A9CCEFFCBCE9ACE9A
        9CCEFFCBCE9ACE9A9CCEFFCBCE9ACE9A9CCEDEDBDE9A210000DE9C6163000000
        00630000000000C30000008200C30082000000000082FFFFFF00FFFFFF00FFFF
        FF00FFFFFF009C616300000000619C6163000000006100000000FFCBCE00FFCB
        CECEFFCBCECBFFCBCECEFFCBCECBFFCBCECEFFCBCECBFFCBCECEFFCBCECBFFCB
        CECEFFCBCECBFFCBCECEDEDBDECBFFCBCEDEFFCBCECBFFCBCECE000000CB9C61
        63000000006100C3000000C300C3C6FFC60000FF00FF00000000FFFFFF00FFFF
        FF009C616300000000630000000000000000FFCBCE00FFCBCECEFFCBCECBFFCB
        CECEFFCBCECBFFCBCECEFFCBCECBFFCBCECEFFCBCECBFFCBCECE316163CBFFCB
        CE63FFCBCECBFFCBCECEFFCBCECBFFCBCECEFFCBCECBFFCBCECEFFCBCECB0000
        00CE9C61630000000063C6FFC60000FF00C600FF00FF00000000FFFFFF009C61
        63000000006100000000FFCBCE00FFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFF
        FFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFFFFCE316163FFFFFFFF63FFCBCEFF0000
        00CEFFCBCE00FFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFF
        FFCE000000FF0000000000FF000000FF0000000000FF00000000000000610000
        0000FFFFFF00FFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCB
        CEFFFFFFFFCBFFCBCEFF316163CBFFCBCE63FFFFFFCB316163FFFFCBCE61FFFF
        FFCE316163FFFFCBCE63FFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCB
        CEFFFFFFFFCB000000FF000000000000000000000000FFFFFF00FFFFFF000000
        0000FFCBCE00FFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFF
        FFCE316163FFFFFFFF63FFCBCEFF316163CEFFCBCE61FFFFFFCE316163FFFFCB
        CE63FFFFFFCB316163FFFFCBCE61FFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFF
        FFCEFFCBCEFFFFFFFFCE000000FF9C6163009C6163619C616363FFFFFF00FFFF
        FF0000000000FFCBCE00FFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFF316163CBFFCB
        CE63FFFFFFCB316163FFFFFFFF61FFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCB0000
        00FFFFFFFF00FFCBCEFF316163CBFFCBCE63FFFFFFCBFFCBCEFFFFFFFFCBFFCB
        CEFFFFFFFFCBFFCBCEFFFFFFFFCB000000FFFFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF0000000000FFCBCE00FFFFFFCEFFFFFFFFFFFFFFFFFFFFFFFF3161
        63FFFFFFFF61FFFFFFFF316163FFFFFFFF63FFFFFFFF316163FFFFFFFF61FFFF
        FFFF000000FFFFFFFF00FFFFFFFF000000FFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFCBCEFFFFFFFFCE000000FFFFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF0000000000FFCBCE00FFFFFFCBFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF00FFFFFFFF316163FFFFFF
        FF63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FF00000000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF0000000000FFCBCE00FFFFFFCEFFFFFFFFFFFF
        FFFFFFFFFFFF316163FFFFFFFF61FFFFFFFF000000FFFFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF000000FF00000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFCBCE00FFFFFFCBFFCB
        CEFFFFFFFFCBFFCBCEFF316163CBFFCBCE63FFFFFFCBFFCBCEFFFFFFFFCBFFCB
        CEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFF000000CB0000
        0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFCBCE00FFFF
        FFCEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFCB
        CE00FFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCBCEFFFFFFFFCBFFCB
        CEFFFFFFFFCBFFCBCEFF000000CB00000000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
        0000FFCBCE00FFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFFFFCEFFCBCEFFFFFF
        FFCE000000FF00000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF0000000000FFCBCE00FFCBCECBFFCBCECEFFCBCECBFFCBCECE000000CB0000
        0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF0000000000FFCBCE00FFCBCECE000000CB00000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
      TabOrder = 0
      OnClick = btnImprimirClick
    end
    object btnCancelar: TBitBtn
      AlignWithMargins = True
      Left = 286
      Top = 4
      Width = 100
      Height = 30
      Align = alRight
      Cancel = True
      Caption = 'Cancelar(ESC)'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F6F00006000
        006000006000004FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF2F2FAF00008000008F00008F00008F00008F00008F000080000050FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2FAF00009000009000009F00009F00
        00A000009F00009000008F00008F000060FFFFFFFFFFFFFFFFFFFFFFFF2F2FAF
        0000A00F0F9F9F9FD06F6FD00000AF0000AF0000AF4F4FBFB0B0E02020A00000
        8F000050FFFFFFFFFFFFFFFFFF2F2FAF0000AF2F2FA0DFDFD0FFFFFF6060D000
        00B04040C0E0E0EFFFFFF05F5FB000009F000080FFFFFFFFFFFF4F4FD00000B0
        0000BF0000C04F4FA0E0E0DFFFFFFF9F9FE0EFEFF0FFFFF07070BF0000B00000
        AF0000A010105FFFFFFF4F4FD00F0FBF0000CF0000D00000CF5050B0F0F0EFFF
        FFFFFFFFFF7070CF0000BF0000C00000BF0000AF10106FFFFFFF4F4FD00F0FCF
        0F0FDF0F0FDF0000D03F3FCFEFEFEFFFFFFFFFFFFF5F5FDF0000CF0000CF0000
        C00000BF10107FFFFFFF4F4FD01010DF1010EF0F0FF04040DFE0E0EFFFFFF0BF
        BFD0EFEFEFFFFFFF6060E00000D00F0FCF0F0FC020207FFFFFFF4F4FD02020E0
        2020FF3F3FEFDFDFE0FFFFEF7070C00000D05050B0E0E0D0FFFFFF6060E00F0F
        DF0F0FCF10107FFFFFFFFFFFFF3030FF3030FF5050EFB0B0C07070CF0000EF00
        00EF0000EF5050B0AFAFB04F4FE01F1FEF1F1FB0FFFFFFFFFFFFFFFFFF3030FF
        3F3FFF5050FF6F6FEF5050FF3F3FFF2020FF2F2FFF3F3FFF4040EF3030FF1F1F
        EF3030FFFFFFFFFFFFFFFFFFFFFFFFFF3030FF4F4FFF6F6FFF9090FF9090FF80
        80FF7070FF6060FF5050FF3030FF3030FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF3030FF3030FF6F6FFF8080FF9090FF7070FF5050FF5050F03030FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3030FF3030FF30
        30FF3030FF3030FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
end
