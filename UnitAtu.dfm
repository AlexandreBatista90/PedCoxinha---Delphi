object FormAtu: TFormAtu
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormAtu'
  ClientHeight = 472
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 624
    Height = 15
    Align = alTop
    ExplicitWidth = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 431
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 258
      Top = 6
      Width = 111
      Height = 22
      Caption = 'Fechar'
      OnClick = SpeedButton1Click
    end
  end
  object LogAtu: TRichEdit
    AlignWithMargins = True
    Left = 6
    Top = 20
    Width = 612
    Height = 406
    Margins.Left = 6
    Margins.Top = 5
    Margins.Right = 6
    Margins.Bottom = 5
    Align = alClient
    Color = clAntiquewhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'LogAtu')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    StyleElements = [seFont]
  end
end
