object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    624
    441)
  TextHeight = 15
  object PaintBox1: TPaintBox
    Left = 8
    Top = 8
    Width = 321
    Height = 289
    OnClick = PaintBox1Click
  end
  object PaintBox2: TPaintBox
    Left = 386
    Top = 191
    Width = 230
    Height = 242
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnClick = PaintBox2Click
  end
  object Button1: TButton
    Left = 112
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
end
