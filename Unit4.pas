unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Themes, Vcl.Styles, Data.DB, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Unit2, Vcl.Buttons, Vcl.ExtDlgs;

type
  TCONFIG = class(TForm)
    cbTemas: TComboBox;
    DBGrid1: TDBGrid;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBMemo1: TDBMemo;
    SpeedButton1: TSpeedButton;
    tmrSalvarTema: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure cbTemasChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBEdit1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrSalvarTemaTimer(Sender: TObject);
  private
    procedure SalvarTema(Nome: string);
  public
  end;

var
  CONFIG: TCONFIG;

implementation

{$R *.dfm}

uses Unit1;

procedure TCONFIG.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // 1. Para o timer por segurança para não disparar com a tela fechando
  tmrSalvarTema.Enabled := False;

  // 2. Garante o salvamento se houver algo pendente no banco
  if (DataModule2.FDCONFIG.State in [dsEdit, dsInsert]) then
  begin
    try
      DataModule2.FDCONFIG.Post;
    except
      on E: Exception do ; // Abafa erros no fechamento
    end;
  end;

  // 3. Reativa o evento de pintura do Form1 e força o redesenho da imagem de fundo
  if Assigned(Form1) then
  begin
    Form1.OnPaint := Form1.FormPaint;
    Form1.Invalidate; // Força a imagem a aparecer sobre o novo tema
  end;

  // 4. Libera mensagens pendentes e fecha a tela
  Application.ProcessMessages;
  Action := caHide;
end;

procedure TCONFIG.FormCreate(Sender: TObject);
var
  TemaSalvo: string;
begin
  // 1. Carrega a lista de temas disponíveis no sistema
  cbTemas.Items.Clear;
  cbTemas.Items.AddStrings(TStyleManager.StyleNames);

  // 2. Garante que a tabela de configurações está aberta
  if not DataModule2.FDCONFIG.Active then
    DataModule2.FDCONFIG.Open;

  // 3. Posiciona o combo no tema atual gravado
  TemaSalvo := DataModule2.FDCONFIG.FieldByName('FL_TEMA').AsString;

  if TemaSalvo <> '' then
  begin
    cbTemas.ItemIndex := cbTemas.Items.IndexOf(TemaSalvo);
  end;
end;

procedure TCONFIG.cbTemasChange(Sender: TObject);
var
  NovoTema: string;
begin
  if cbTemas.ItemIndex < 0 then Exit;
  NovoTema := cbTemas.Items[cbTemas.ItemIndex];

  // 1. SILENCIA O BANCO E O FORM PRINCIPAL
  DataModule2.FDCONFIG.DisableControls;
  if Assigned(Form1) then Form1.OnPaint := nil;

  // 2. TRAVA A ATUALIZAÇÃO VISUAL NO WINDOWS
  // Isso impede que o CallWindowProc seja chamado durante a troca
  LockWindowUpdate(Application.MainForm.Handle);

  try
    // 3. LIMPA MENSAGENS PENDENTES ANTES DA TROCA
    Application.ProcessMessages;

    try
      // 4. APLICA O ESTILO
      Application.ProcessMessages;
      TStyleManager.TrySetStyle(NovoTema);

      // Dá um fôlego para o Windows processar a nova estrutura
      Application.ProcessMessages;
    except
      on E: Exception do ;
    end;

    // 5. ATRIBUI AO BANCO E LIGA O TIMER
    if not (DataModule2.FDCONFIG.State in [dsEdit, dsInsert]) then
      DataModule2.FDCONFIG.Edit;
    DataModule2.FDCONFIG.FieldByName('FL_TEMA').AsString := NovoTema;

    tmrSalvarTema.Enabled := False;
    tmrSalvarTema.Enabled := True;

  finally
    // 6. LIBERA A JANELA PARA VOLTAR A DESENHAR
    LockWindowUpdate(0);

    // 7. RESTAURA CONTROLES E PINTURA
    DataModule2.FDCONFIG.EnableControls;
    if Assigned(Form1) then
    begin
      Form1.OnPaint := Form1.FormPaint;
      Form1.Invalidate; // Força redesenhar o fundo
    end;

    Self.Repaint;
  end;
end;
procedure TCONFIG.DBEdit1Exit(Sender: TObject);
begin
  // Mantive sua lógica original, mas agora o Timer também ajuda a salvar
  if (DataModule2.FDCONFIG.State in [dsEdit, dsInsert]) then
  begin
    try
      DataModule2.FDCONFIG.Post;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao salvar alteração: ' + E.Message);
      end;
    end;
  end;
end;

procedure TCONFIG.SpeedButton1Click(Sender: TObject);
var
  OpenDialog: TOpenPictureDialog;
begin
  OpenDialog := TOpenPictureDialog.Create(Self);
  try
    if OpenDialog.Execute then
    begin
      if not (DataModule2.FDCONFIG.State in [dsEdit, dsInsert]) then
        DataModule2.FDCONFIG.Edit;

      DataModule2.FDCONFIG.FieldByName('FL_IMAGEM').AsString := OpenDialog.FileName;
      DataModule2.FDCONFIG.Post;

      // Força a atualização da imagem no Form1 se ela foi trocada
      if Assigned(Form1) then Form1.Invalidate;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TCONFIG.tmrSalvarTemaTimer(Sender: TObject);
begin
  tmrSalvarTema.Enabled := False;

  if (DataModule2.FDCONFIG.State in [dsEdit, dsInsert]) then
  begin
    try
      DataModule2.FDCONFIG.Post;
    except
      on E: Exception do
        OutputDebugString(PChar('Erro ao salvar tema via Timer: ' + E.Message));
    end;
  end;
end;

procedure TCONFIG.SalvarTema(Nome: string);
var
  Ini: TIniFile;
  Caminho: string;
begin
  Caminho := ExtractFilePath(Application.ExeName) + 'config.ini';
  Ini := TIniFile.Create(Caminho);
  try
    Ini.WriteString('CONFIG', 'TEMA', Nome);
  finally
    Ini.Free;
  end;
  if FileExists(Caminho) then
    SetFileAttributes(PChar(Caminho), FILE_ATTRIBUTE_HIDDEN);
end;

end.
