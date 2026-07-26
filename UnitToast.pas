unit UnitToast;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormToast = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormToast: TFormToast;

implementation

{$R *.dfm}


procedure TFormToast.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  Action := caFree; // Isso remove o form da memória ao fechar

end;

procedure TFormToast.FormShow(Sender: TObject);
begin
  // Centraliza em relação à tela principal
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;

  Timer1.Interval := 50; // Velocidade do efeito de sumir
  Timer1.Enabled := True;
end;

procedure TFormToast.Timer1Timer(Sender: TObject);
begin
  if Self.AlphaBlendValue > 10 then
    Self.AlphaBlendValue := Self.AlphaBlendValue - 15 // Diminui a opacidade
  else
  begin
    Timer1.Enabled := False;
    Self.Close; // Fecha quando estiver quase invisível
  end;
end;

end.
