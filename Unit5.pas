unit Unit5;

interface

uses
  Unit1,
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls,
  DelphiZXingQRCode, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm5 = class(TForm)
    PaintBox1: TPaintBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Click(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    QRCodeBitmap: TBitmap;
  public
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
var
  QR: TDelphiZXingQRCode;
begin
  QR := TDelphiZXingQRCode.Create;
  try
    QR.Data := 'TESTE';
    ShowMessage(QR.Rows.ToString);
  finally
    QR.Free;
  end;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  QRCodeBitmap := TBitmap.Create;
  QRCodeBitmap.PixelFormat := pf24bit;
end;


procedure TForm5.PaintBox1Click(Sender: TObject);
begin
  PaintBox1.Canvas.Brush.Color := clYellow;
  PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);

  if Assigned(QRCodeBitmap) then
    ShowMessage('Bitmap existe')
  else
    ShowMessage('Bitmap NIL');
end;

procedure TForm5.PaintBox1Paint(Sender: TObject);
begin
  if Assigned(QRCodeBitmap) then
    PaintBox1.Canvas.StretchDraw(PaintBox1.ClientRect, QRCodeBitmap);
end;

procedure TForm5.PaintBox2Click(Sender: TObject);
begin
  PaintBox1.Canvas.Brush.Color := clRed;
  PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
end;

end.
