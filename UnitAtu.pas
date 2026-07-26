unit UnitAtu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TFormAtu = class(TForm)
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    LogAtu: TRichEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAtu: TFormAtu;

implementation

{$R *.dfm}

procedure TFormAtu.FormCreate(Sender: TObject);
begin
  // Usamos o componente pelo nome que você deu: reLog

  TRichEdit(LogAtu).Paragraph.LeftIndent := 5;
end;

procedure TFormAtu.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

end.
