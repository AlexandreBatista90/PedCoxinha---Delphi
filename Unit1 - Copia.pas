unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Clipbrd, uPixPayload, DelphiZXingQRCode, Vcl.Themes, Vcl.Styles, Unit4, System.IniFiles, Vcl.ComCtrls;

type
  TForm1 = class(TForm)

    MainMenu1: TMainMenu;
    Sair1: TMenuItem;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Opes1: TMenuItem;
    Configuraes1: TMenuItem;
    Image1: TImage;
    procedure Sair1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FBitMapFundo: TBitmap; // Guarda a imagem na memória
    FColunaClick: Integer;
    FImagemFundo: TPicture;

    { Private declarations }
  public
    FCaminhoBase: string;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses FormPedCoxinha, Unit6;


procedure CarregarTema;
var
  Ini: TIniFile;
  Caminho, Tema: string;
begin
  Caminho := ExtractFilePath(Application.ExeName) + 'config.ini';

  if not FileExists(Caminho) then Exit;

  Ini := TIniFile.Create(Caminho);
  try
    Tema := Ini.ReadString('CONFIG', 'TEMA', '');

    if Tema <> '' then
      TStyleManager.SetStyle(Tema);
  finally
    Ini.Free;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  PedCoxinha.ShowModal;
  Self.ActiveControl := nil;
end;


procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  COBRANCA2.ShowModal;
  Self.ActiveControl := nil;
end;

procedure TForm1.Configuraes1Click(Sender: TObject);
begin
  CONFIG.ShowModal;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
FImagemFundo := TPicture.Create;
  try
    // Coloque o caminho da sua imagem aqui
    if FileExists('C:\Users\Alexandre\Documents\Embarcadero\Studio\Projects\DBF_2\Win64\Debug\Imagens\Capturar.bmp') then
    FImagemFundo.LoadFromFile('C:\Users\Alexandre\Documents\Embarcadero\Studio\Projects\DBF_2\Win64\Debug\Imagens\Capturar.bmp');
  except
    on E: Exception do ShowMessage('Erro ao carregar fundo: ' + E.Message);
  end;
  // ...
  FCaminhoBase := IncludeTrailingPathDelimiter(
                    ExtractFilePath(Application.ExeName)
                  );
  FCaminhoBase := IncludeTrailingPathDelimiter(
  ExtractFilePath(Application.ExeName)
                  );
  CarregarTema;

end;


procedure TForm1.FormPaint(Sender: TObject);
begin
// Usando a variável FImagemFundo, que foi a que você carregou no Create
  if Assigned(FImagemFundo.Graphic) then
  begin
    // Use ClientWidth e ClientHeight para ignorar as bordas da janela
    Canvas.StretchDraw(Rect(0, 0, ClientWidth, ClientHeight), FImagemFundo.Graphic);
  end;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
