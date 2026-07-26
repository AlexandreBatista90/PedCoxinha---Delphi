program PROJECT2;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {DataModule2: TDataModule},
  FormPedCoxinha in 'FormPedCoxinha.pas' {PedCoxinha},
  uPixPayload in 'uPixPayload.pas',
  DelphiZXIngQRCode in 'C:\Delphi\Componentes\DelphiZXingQRCode-master\Source\DelphiZXIngQRCode.pas',
  Unit6 in 'Unit6.pas' {COBRANCA2},
  ACBrDelphiZXingQRCode in 'COMPONENTES\Gera-PIX-QRCode-Pascal-Delphi-main\ACBrDelphiZXingQRCode.pas',
  uClassePix in 'COMPONENTES\Gera-PIX-QRCode-Pascal-Delphi-main\uClassePix.pas',
  Unit8 in 'Unit8.pas' {FMWhatsapp},
  Vcl.Themes,
  Vcl.Styles,
  Unit4 in 'Unit4.pas' {CONFIG},
  UnitToast in 'UnitToast.pas' {FormToast},
  UnitSobre in 'UnitSobre.pas' {FormSobre},
  UnitAtu in 'UnitAtu.pas' {FormAtu};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := False;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // 1. DataModule sempre primeiro
  Application.CreateForm(TDataModule2, DataModule2);
  // 2. Aplica o estilo antes de criar as telas para evitar repintura inútil
  TStyleManager.TrySetStyle('Sapphire Kamri');

  // 3. Main Form
  Application.CreateForm(TForm1, Form1);

  // 4. Outras telas (O ideal seria criar sob demanda, mas vamos manter aqui por enquanto)


  Application.CreateForm(TFMWhatsapp, FMWhatsapp);
  Application.CreateForm(TCONFIG, CONFIG);
  Application.CreateForm(TFormToast, FormToast);

  Application.Run;
end.
