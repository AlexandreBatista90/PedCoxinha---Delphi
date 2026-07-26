unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, Clipbrd, uPixPayload, DelphiZXingQRCode,
  Vcl.Themes, Vcl.Styles, System.IniFiles, Vcl.ComCtrls, Winapi.ShellAPI, System.IOUtils, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

const
  VERSAO_ATUAL = '1.1.1.0';

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Sair1: TMenuItem;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Opes1: TMenuItem;
    Configuraes1: TMenuItem;
    Image1: TImage;
    StatusBar1: TStatusBar;
    Sobre1: TMenuItem;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Label1: TLabel;
    procedure Sair1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AtualizarLogSistema;
    procedure Sobre1Click(Sender: TObject);

  private
    FImagemFundo: TPicture;
  public
    FCaminhoBase: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses FormPedCoxinha, Unit6, Unit4, unit2, UnitSobre;

procedure TForm1.AtualizarLogSistema;
var
  Qry: TFDQuery;
  TextoLog, VERSAO_ANT, ModoAntigo: string;
begin
  ModoAntigo := DataModule2.FDConnection1.Params.Values['Locking'];
  DataModule2.FDConnection1.Params.Values['Locking'] := 'Proprietary';

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DataModule2.FDConnection1;

    try
      Qry.ExecSQL('CREATE TABLE VERSATUCOXINHA (' +
                  'NR_VERSAO CHAR(10), ' +
                  'DT_ATUVER DATE, ' +
                  'NR_VERSANT CHAR(10), ' +
                  'DT_ATUANT DATE, ' +
                  'TX_EVOLU MEMO)');
    except
    end;

    Qry.Open('SELECT MAX(NR_VERSAO) FROM VERSATUCOXINHA');
    VERSAO_ANT := Qry.Fields[0].AsString;

    if VERSAO_ANT = '' then
      VERSAO_ANT := '1.0.0.0';

    Qry.Close;
    Qry.Open('SELECT NR_VERSAO FROM VERSATUCOXINHA WHERE NR_VERSAO = :VER', [VERSAO_ATUAL]);

    if Qry.IsEmpty then
    begin
      TextoLog := 'CORREÇÕES E EVOLUÇÕES (v' + VERSAO_ATUAL + '):' + sLineBreak +
                  '--------------------------------------------' + sLineBreak + sLineBreak +
                  '> ATALHOS: Adicionado ESC para cancelar e INSERT para novo pedido, na tela PedCoxinha;' + sLineBreak + sLineBreak +
                  '> QR CODE (PIX): Corrigido para compatibilidade com bancos mais rigorosos, como PicPay por exemplo;' + sLineBreak + sLineBreak +
                  '> Filtros de data automáticos: Lista de pedidos atualiza automaticamente na PedCoxinha ao clicar em ''novo'', e na tela de cobrança ao abrir ignora os registros apagados;' + sLineBreak + sLineBreak +
                  '> ATUALIZAÇÃO DE VERSÃO: Tela e aviso de atualização implementados.';

      Qry.Close;
      Qry.SQL.Text := 'INSERT INTO VERSATUCOXINHA (NR_VERSAO, DT_ATUVER, NR_VERSANT, DT_ATUANT, TX_EVOLU) ' +
                      'VALUES (:VER, :DATA, :VANT, :DANT, :TEXTO)';

      Qry.ParamByName('VER').AsString   := VERSAO_ATUAL;
      Qry.ParamByName('DATA').AsDate     := Date;
      Qry.ParamByName('VANT').AsString   := VERSAO_ANT;
      Qry.ParamByName('DANT').DataType   := ftDate;
      Qry.ParamByName('DANT').Clear;
      Qry.ParamByName('TEXTO').AsMemo    := TextoLog;
      Qry.ExecSQL;
    end;
  finally
    DataModule2.FDConnection1.Params.Values['Locking'] := ModoAntigo;
    Qry.Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);

var
  QryVer: TFDQuery;
  VersaoBanco: string;
begin
  QryVer := TFDQuery.Create(nil);
  try
    QryVer.Connection := DataModule2.FDConnection1;

    try
      QryVer.Open('SELECT MAX(NR_VERSAO) FROM VERSATUCOXINHA');
      VersaoBanco := QryVer.Fields[0].AsString;
    except
      VersaoBanco := '0.0.0.0';
    end;

    if (VERSAO_ATUAL > VersaoBanco) then
    begin
      // AJUSTADO: Usando nomes padrão do Delphi
      Panel1.Visible := True;
      Label1.Caption := 'Atualizando para ' + VERSAO_ATUAL + '...';
      ProgressBar1.Position := 10;

      Application.ProcessMessages;

      ProgressBar1.Position := 50;
      AtualizarLogSistema;

      ProgressBar1.Position := 100;
      Application.ProcessMessages;

      ShowMessage('O sistema foi atualizado com sucesso para a versão ' + VERSAO_ATUAL);
      Panel1.Visible := False;
    end;
  finally
    QryVer.Free;
  end;
end;

// --- MANTENHA AS OUTRAS PROCEDURES (FormCreate, FormPaint, etc) IGUAIS ---

procedure MatarWebViewZumbi;
begin
  ShellExecute(0, nil, 'cmd.exe', '/c taskkill /f /im msedgewebview2.exe /t', nil, SW_HIDE);
end;

procedure LimparCacheCorrompido;
var
  CaminhoBase: string;
  Pastas: TArray<string>;
  Pasta: string;
begin
  CaminhoBase := IncludeTrailingPathDelimiter(GetEnvironmentVariable('LOCALAPPDATA') + '\bds.exe.WebView2\EBWebView');
  if not TDirectory.Exists(CaminhoBase) then Exit;
  if TFile.Exists(CaminhoBase + 'Webview2.lock') then
    try TFile.Delete(CaminhoBase + 'Webview2.lock'); except end;
  try
    Pastas := TDirectory.GetDirectories(CaminhoBase, '*cache*', TSearchOption.soAllDirectories);
    for Pasta in Pastas do
    begin
      try
        if TDirectory.Exists(Pasta) then TDirectory.Delete(Pasta, True);
      except
      end;
    end;
  except
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  CaminhoImagemTabela, CaminhoImagemPadrao, TemaSalvo: string;
begin
  MatarWebViewZumbi;
  LimparCacheCorrompido;
  Self.DoubleBuffered := True;
  FImagemFundo := TPicture.Create;
  FCaminhoBase := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  CaminhoImagemPadrao := FCaminhoBase + 'Imagens\Capturar.bmp';
  if not DataModule2.FDCONFIG.Active then DataModule2.FDCONFIG.Open;
  TemaSalvo := Trim(DataModule2.FDCONFIG.FieldByName('FL_TEMA').AsString);
  if TemaSalvo <> '' then TStyleManager.TrySetStyle(TemaSalvo);
  CaminhoImagemTabela := Trim(DataModule2.FDCONFIG.FieldByName('FL_IMAGEM').AsString);
  try
    if (CaminhoImagemTabela <> '') and FileExists(CaminhoImagemTabela) then
      FImagemFundo.LoadFromFile(CaminhoImagemTabela)
    else if FileExists(CaminhoImagemPadrao) then
      FImagemFundo.LoadFromFile(CaminhoImagemPadrao);
  except
  end;
  if Screen.Width < 1600 then ScaleBy(Screen.Width, 1600);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  OnPaint := nil;
  if Assigned(FImagemFundo) then
  begin
    try
      if Assigned(FImagemFundo.Graphic) then FImagemFundo.Graphic := nil;
    finally
      FreeAndNil(FImagemFundo);
    end;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  if (csDestroying in ComponentState) or (HandleAllocated = False) then Exit;
  if Assigned(FImagemFundo) and Assigned(FImagemFundo.Graphic) then
    Canvas.StretchDraw(Rect(0, 0, ClientWidth, ClientHeight), FImagemFundo.Graphic);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OnPaint := nil;
  if Assigned(FImagemFundo) then FreeAndNil(FImagemFundo);
  try Halt(0); except end;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Sobre1Click(Sender: TObject);
var Frm: TFormSobre;
begin
  Frm := TFormSobre.Create(nil);
  try Frm.ShowModal; finally Frm.Free; end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  // 1. Cria a tela somente agora que o usuário clicou
  PedCoxinha := TPedCoxinha.Create(Self);
  try
    // 2. Exibe a tela de forma modal (trava a tela de trás)
    PedCoxinha.ShowModal;
  finally
    // 3. Garante a destruição da tela ao fechar, liberando a RAM
    if Assigned(PedCoxinha) then
    begin
      PedCoxinha.Release;
      PedCoxinha := nil; // Boa prática: limpa a variável para não virar ponteiro fantasma
    end;

    Self.ActiveControl := nil;
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  // 1. Cria a tela somente agora que o usuário clicou
  COBRANCA2 := TCOBRANCA2.Create(Self);
  try
    // 2. Exibe a tela de forma modal (trava a tela de trás)
    COBRANCA2.ShowModal;
  finally
    // 3. Garante a destruição da tela ao fechar, liberando a RAM
    if Assigned(COBRANCA2) then
    begin
      COBRANCA2.Release;
      COBRANCA2 := nil; // Boa prática: limpa a variável para não virar ponteiro fantasma
    end;

    Self.ActiveControl := nil;
  end;
end;

procedure TForm1.Configuraes1Click(Sender: TObject);
begin
  CONFIG.ShowModal;
end;

end.
