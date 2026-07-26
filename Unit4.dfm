object CONFIG: TCONFIG
  Left = 0
  Top = 0
  Caption = 'Configura'#231#245'es'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 67
    Width = 55
    Height = 15
    Caption = 'Chave Pix:'
  end
  object Label2: TLabel
    Left = 264
    Top = 67
    Width = 73
    Height = 15
    Caption = 'Valor Coxinha'
  end
  object Label3: TLabel
    Left = 40
    Top = 147
    Width = 166
    Height = 15
    Caption = 'Caminho da imagem de fundo:'
  end
  object Label4: TLabel
    Left = 440
    Top = 67
    Width = 28
    Height = 15
    Caption = 'Tema'
  end
  object SpeedButton1: TSpeedButton
    Left = 224
    Top = 140
    Width = 41
    Height = 22
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object cbTemas: TComboBox
    Left = 440
    Top = 88
    Width = 145
    Height = 23
    TabOrder = 0
    OnChange = cbTemasChange
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 240
    Width = 561
    Height = 169
    DataSource = DataModule2.DSCONFIG
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'FL_CHAVE'
        Title.Caption = 'Chave Pix'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VL_COXINHA'
        Title.Caption = 'Valor da coxinha'
        Width = 96
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FL_TEMA'
        Title.Caption = 'Tema do sistema'
        Width = 169
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FL_IMAGEM'
        Title.Caption = 'Caminho da Imagem de Fundo'
        Width = 233
        Visible = True
      end>
  end
  object DBEdit1: TDBEdit
    Left = 24
    Top = 88
    Width = 153
    Height = 23
    DataField = 'FL_CHAVE'
    DataSource = DataModule2.DSCONFIG
    TabOrder = 2
    OnExit = DBEdit1Exit
  end
  object DBEdit2: TDBEdit
    Left = 264
    Top = 88
    Width = 113
    Height = 23
    DataField = 'VL_COXINHA'
    DataSource = DataModule2.DSCONFIG
    TabOrder = 3
    OnExit = DBEdit1Exit
  end
  object DBMemo1: TDBMemo
    Left = 40
    Top = 168
    Width = 529
    Height = 57
    DataField = 'FL_IMAGEM'
    DataSource = DataModule2.DSCONFIG
    TabOrder = 4
    WantReturns = False
  end
  object tmrSalvarTema: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tmrSalvarTemaTimer
    Left = 528
    Top = 40
  end
end
