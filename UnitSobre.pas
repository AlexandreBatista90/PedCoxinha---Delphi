unit UnitSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage;

type
  TFormSobre = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton; // Botão "Versão Atual"
    SpeedButton2: TSpeedButton; // Botão "Anteriores"
    SpeedButton3: TSpeedButton; // Botão "Fechar"
    Image2: TImage;
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject); // Versão Atual
    procedure SpeedButton2Click(Sender: TObject); // Anteriores
  private
  public
  end;

var
  FormSobre: TFormSobre;

implementation

// unit2 deve ser onde está sua FDQuery (QueryLog)
uses UnitAtu, unit2;

{$R *.dfm}

procedure TFormSobre.FormCreate(Sender: TObject);
var R: HRGN;
begin
  R := CreateRoundRectRgn(0, 0, Width, Height, 30, 30);
  SetWindowRgn(Handle, R, True);
end;

// --- BOTÃO: VERSÃO ATUAL ---
procedure TFormSobre.SpeedButton1Click(Sender: TObject);
begin
  FormAtu := TFormAtu.Create(Self);
  try
    FormAtu.Label1.Caption := 'O que há de novo';
    FormAtu.LogAtu.Lines.Clear; // Agora usando reLog (TRichEdit)

    DataModule2.FDQueryAux.Close;
    DataModule2.FDQueryAux.SQL.Text := 'SELECT TOP 1 NR_VERSAO, TX_EVOLU FROM VERSATUCOXINHA ORDER BY DT_ATUVER DESC';
    DataModule2.FDQueryAux.Open;

    if not DataModule2.FDQueryAux.IsEmpty then
    begin
       // Estilizando o título via código antes de adicionar o texto
       FormAtu.LogAtu.SelAttributes.Style := [fsBold];
       FormAtu.LogAtu.Lines.Add('VERSÃO: ' + DataModule2.FDQueryAux.FieldByName('NR_VERSAO').AsString);

       FormAtu.LogAtu.SelAttributes.Style := []; // Volta ao texto normal
       FormAtu.LogAtu.Lines.Add(DataModule2.FDQueryAux.FieldByName('TX_EVOLU').AsString);

       FormAtu.ShowModal;
    end;
  finally
    FreeAndNil(FormAtu);
  end;
end;

// --- BOTÃO: MUDANÇAS ANTERIORES ---
procedure TFormSobre.SpeedButton2Click(Sender: TObject);
begin
  // 1. Faz a busca primeiro para validar se existe algo
  DataModule2.FDQueryAux.Close;
  // Pula a primeira (START AT 2) e pega as próximas 2 anteriores
  DataModule2.FDQueryAux.SQL.Text := 'SELECT TOP 2 START AT 2 NR_VERSAO, TX_EVOLU FROM VERSATUCOXINHA ORDER BY DT_ATUVER DESC';
  DataModule2.FDQueryAux.Open;

  // 2. Se não houver nada, sai sem abrir o formulário (conforme solicitado)
  if DataModule2.FDQueryAux.IsEmpty then
    Exit;

  // 3. Se chegou aqui, existem dados. Cria o formulário de exibição
  FormAtu := TFormAtu.Create(Self);
  try
    FormAtu.Label1.Caption := 'Histórico de Mudanças';
    FormAtu.LogAtu.Lines.Clear;

    // Percorre todos os registros encontrados (até 2 versões)
    while not DataModule2.FDQueryAux.Eof do
    begin
      // Configura o cabeçalho da versão em Negrito
      FormAtu.LogAtu.SelAttributes.Style := [fsBold];
      FormAtu.LogAtu.SelAttributes.Size := 10;
      FormAtu.LogAtu.Lines.Add('VERSÃO: ' + DataModule2.FDQueryAux.FieldByName('NR_VERSAO').AsString);

      // Linha divisória simples
      FormAtu.LogAtu.Lines.Add('---------------------------------------');

      // Adiciona o corpo do log em texto normal
      FormAtu.LogAtu.SelAttributes.Style := [];
      FormAtu.LogAtu.SelAttributes.Size := 9;
      FormAtu.LogAtu.Lines.Add(DataModule2.FDQueryAux.FieldByName('TX_EVOLU').AsString);

      // Pula duas linhas para separar da próxima versão no histórico
      FormAtu.LogAtu.Lines.Add('');
      FormAtu.LogAtu.Lines.Add('=======================================');
      FormAtu.LogAtu.Lines.Add('');

      DataModule2.FDQueryAux.Next;
    end;

    FormAtu.ShowModal;
  finally
    FreeAndNil(FormAtu);
  end;
end;

procedure TFormSobre.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

end.
