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
  UnitToast in 'UnitToast.pas' {FormToast};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPedCoxinha, PedCoxinha);
  Application.CreateForm(TCOBRANCA2, COBRANCA2);
  Application.CreateForm(TFMWhatsapp, FMWhatsapp);
  Application.CreateForm(TCONFIG, CONFIG);
  Application.CreateForm(TFormToast, FormToast);
  Application.Run;
  ReportMemoryLeaksOnShutdown := True;
end.
