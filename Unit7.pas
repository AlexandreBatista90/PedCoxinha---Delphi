unit Unit7;

interface

uses
  Unit1, Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge;

type
  TTESTEWHATSAPP01 = class(TForm)
    EdgeBrowser1: TEdgeBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser;
      AResult: HRESULT);
  private
  public
  end;

var
  TESTEWHATSAPP01: TTESTEWHATSAPP01;

implementation

{$R *.dfm}
procedure TTESTEWHATSAPP01.FormCreate(Sender: TObject);
begin
  EdgeBrowser1.CreateWebView;
end;

procedure TTESTEWHATSAPP01.FormShow(Sender: TObject);
begin
  // garante que o controle já está visível antes do WebView iniciar
end;

procedure TTESTEWHATSAPP01.EdgeBrowser1CreateWebViewCompleted(
  Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  if Succeeded(AResult) then
    EdgeBrowser1.Navigate('https://www.google.com/')
  else
    ShowMessage('Erro ao inicializar WebView2');
end;

end.


