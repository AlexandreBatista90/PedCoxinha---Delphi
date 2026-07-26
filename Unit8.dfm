object FMWhatsapp: TFMWhatsapp
  Left = 0
  Top = 0
  Caption = 'Whatsapp'
  ClientHeight = 532
  ClientWidth = 806
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 241
    Height = 532
    Align = alLeft
    Columns = <>
    MultiSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnEndDrag = ListView1EndDrag
    OnMouseMove = ListView1MouseMove
  end
  object Panel1: TPanel
    Left = 241
    Top = 0
    Width = 565
    Height = 532
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object EdgeBrowser1: TEdgeBrowser
      Left = 1
      Top = 1
      Width = 563
      Height = 489
      Align = alClient
      TabOrder = 0
      AllowSingleSignOnUsingOSPrimaryAccount = False
      TargetCompatibleBrowserVersion = '117.0.2045.28'
      UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
      OnCreateWebViewCompleted = EdgeBrowser1CreateWebViewCompleted
      ExplicitHeight = 530
    end
    object BitBtn1: TBitBtn
      Left = 1
      Top = 490
      Width = 563
      Height = 41
      Align = alBottom
      Caption = 'Colar + Enviar'
      TabOrder = 1
      OnClick = BitBtn1Click
      ExplicitLeft = 56
      ExplicitTop = 464
      ExplicitWidth = 73
    end
  end
end
