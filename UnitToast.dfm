object FormToast: TFormToast
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'FormToast'
  ClientHeight = 56
  ClientWidth = 197
  Color = 4210752
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 12
    Top = 8
    Width = 170
    Height = 30
    Caption = 'Imagem copiada!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 60
    OnTimer = Timer1Timer
    Left = 88
    Top = 48
  end
end
