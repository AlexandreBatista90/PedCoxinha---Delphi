unit Unit8;

interface

uses
  Unit1, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.StdCtrls, System.IOUtils, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Clipbrd, Winapi.ShellAPI, Vcl.Buttons;

type
  TFMWhatsapp = class(TForm)
    EdgeBrowser1: TEdgeBrowser;
    ListView1: TListView;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CarregarArquivos;
    procedure ListView1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ListView1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMWhatsapp: TFMWhatsapp;

implementation

{$R *.dfm}
type
  TDropFiles = record
    pFiles: DWORD;
    pt: TPoint;
    fNC: BOOL;
    fWide: BOOL;
  end;
  PDropFiles = ^TDropFiles;

procedure CopiarArquivoParaClipboard(const CaminhoArquivo: string);
var
  vDropFiles: PDropFiles;
  hGlobal: THandle;
  Len: Integer;
  pData: PByte;
begin
  // Espaço para o caminho + terminador nulo duplo
  Len := (Length(CaminhoArquivo) + 2) * SizeOf(WideChar);

  // Aloca memória global
  hGlobal := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(TDropFiles) + Len);
  if hGlobal = 0 then Exit;

  pData := GlobalLock(hGlobal);
  if pData = nil then Exit;

  try
    vDropFiles := PDropFiles(pData);
    vDropFiles^.pFiles := SizeOf(TDropFiles);
    vDropFiles^.fWide := True; // Unicode

    // Move o ponteiro para depois da estrutura
    pData := pData + SizeOf(TDropFiles);

    // Copia os dados da string para a memória
    Move(CaminhoArquivo[1], pData^, Length(CaminhoArquivo) * SizeOf(WideChar));
  finally
    GlobalUnlock(hGlobal);
  end;

  Clipboard.Open;
  try
    Clipboard.Clear;
    // CF_HDROP é uma constante padrão do Windows (15)
    Clipboard.SetAsHandle(15, hGlobal);
  finally
    Clipboard.Close;
  end;
end;



procedure TFMWhatsapp.EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
if Succeeded(AResult) then
  begin
    // Comente a linha abaixo para não sobrepor a navegação vinda da Unit6
    // EdgeBrowser1.Navigate('https://web.whatsapp.com/send?phone=5521976321750')
  end
  else
    ShowMessage('Erro: WebView2 não pôde ser iniciado.');
end;

procedure TFMWhatsapp.FormCreate(Sender: TObject);
begin
  ListView1.ViewStyle := vsReport;
  ListView1.RowSelect := True;
  ListView1.Columns.Clear;

  with ListView1.Columns.Add do
  begin
    Caption := 'Arquivo';
    Width := 300;
  end;

  with ListView1.Columns.Add do
  begin
    Caption := 'Caminho';
    Width := 200;
  end;

  EdgeBrowser1.CreateWebView;
end;

procedure TFMWhatsapp.FormShow(Sender: TObject);
begin
// Define a largura para 90% da área útil do monitor
  Self.Width := Round(Screen.WorkAreaWidth * 0.70);

  // Define a altura para 90% da área útil do monitor
  Self.Height := Round(Screen.WorkAreaHeight * 0.80);

  // Centraliza a janela depois de mudar o tamanho
  Self.Left := (Screen.WorkAreaWidth - Self.Width) div 2;
  Self.Top := (Screen.WorkAreaHeight - Self.Height) div 2;
  CarregarArquivos;
end;

procedure TFMWhatsapp.BitBtn1Click(Sender: TObject);
var
  HoraLimite: TDateTime;
begin
  // 1. Foca no navegador
  EdgeBrowser1.SetFocus;
  Application.ProcessMessages;
  Sleep(50); // Pausa curta apenas para o Windows processar o foco

  // 2. Simula CTRL + V
  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(Ord('V'), 0, 0, 0);
  keybd_event(Ord('V'), 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  // --- O SEGREDO ESTÁ AQUI ---
  // Força o processamento imediato do CTRL+V antes de começar a espera
  Application.ProcessMessages;

  // 3. Aguarda 5 segundos sem congelar o sistema
  HoraLimite := Now + EncodeTime(0, 0, 4, 0); // Define 5 segundos à frente
  while Now < HoraLimite do
  begin
    Application.ProcessMessages; // Mantém o app respondendo e processando eventos
    Sleep(10); // Evita uso excessivo de CPU durante o laço
  end;

  // 4. Simula o ENTER
  keybd_event(VK_RETURN, 0, 0, 0);
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFMWhatsapp.CarregarArquivos;
var
  Arquivo: string;
  Item: TListItem;
  CaminhoPasta: string;
begin
  CaminhoPasta := IncludeTrailingPathDelimiter(Form1.FCaminhoBase) + 'ARQUIVOS';

if not TDirectory.Exists(CaminhoPasta) then
  TDirectory.CreateDirectory(CaminhoPasta);

  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    for Arquivo in TDirectory.GetFiles(CaminhoPasta, '*.*') do
    begin
      Item := ListView1.Items.Add;
      Item.Caption := ExtractFileName(Arquivo);
      Item.SubItems.Add(Arquivo);
    end;
  finally
    ListView1.Items.EndUpdate;
  end;
  InvalidateRect(ListView1.Handle, nil, True);
end;

procedure TFMWhatsapp.ListView1Click(Sender: TObject);
var
  Url: string;
begin
  if (ListView1.Selected <> nil) and (ListView1.Selected.SubItems.Count > 0) then
  begin
    Url := ListView1.Selected.SubItems[0];
    if not Url.StartsWith('http', True) then
      Url := 'file:///' + Url;
    EdgeBrowser1.Navigate(Url);
  end;
end;

procedure TFMWhatsapp.ListView1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (ListView1.Selected <> nil) then
    ListView1.BeginDrag(False);
end;

procedure TFMWhatsapp.ListView1EndDrag(Sender, Target: TObject; X, Y: Integer);
var
  P: TPoint;
  CaminhoArquivo: string;
begin
  // Converte a posição do mouse para a área do Edge
  P := EdgeBrowser1.ScreenToClient(Mouse.CursorPos);

  // Se soltou dentro do navegador
  if (P.X >= 0) and (P.Y >= 0) and (P.X <= EdgeBrowser1.Width) and (P.Y <= EdgeBrowser1.Height) then
  begin
    if (ListView1.Selected <> nil) and (ListView1.Selected.SubItems.Count > 0) then
    begin
      CaminhoArquivo := ListView1.Selected.SubItems[0];

      // Executa a "Cópia" para a memória do Windows
      CopiarArquivoParaClipboard(CaminhoArquivo);

      Self.Caption := 'Pronto! Clique no site e dê Ctrl+V para anexar: ' + ExtractFileName(CaminhoArquivo);
    end;
  end;
end;

end.
