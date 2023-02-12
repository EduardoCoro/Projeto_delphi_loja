unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, pngimage;

type
  TTlogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancelar: TBitBtn;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Tlogin: TTlogin;

implementation

{$R *.dfm}

end.
