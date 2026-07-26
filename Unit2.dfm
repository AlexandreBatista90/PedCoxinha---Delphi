object DataModule2: TDataModule2
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = FDQuery1
    Left = 288
    Top = 40
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ServerTypes=Local'
      'TableType=CDX'
      'DriverID=ADS')
    LoginPrompt = False
    BeforeConnect = FDConnection1BeforeConnect
    Left = 56
    Top = 40
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM PEDCOXINHA')
    Left = 176
    Top = 40
  end
  object FDPEDCOXINHA: TFDTable
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = '"PEDCOXINHA.dbf"'
    Left = 56
    Top = 176
    object FDPEDCOXINHAID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
    end
    object FDPEDCOXINHADT_PEDIDO: TDateField
      FieldName = 'DT_PEDIDO'
      Origin = 'DT_PEDIDO'
      EditMask = '##/##/####;1;_'
    end
    object FDPEDCOXINHADT_VENC: TDateField
      FieldName = 'DT_VENC'
      Origin = 'DT_VENC'
      EditMask = '##/##/####;1;_'
    end
    object FDPEDCOXINHADS_NOME: TStringField
      FieldName = 'DS_NOME'
      Origin = 'DS_NOME'
      FixedChar = True
      Size = 60
    end
    object FDPEDCOXINHAQT_ITEM: TIntegerField
      FieldName = 'QT_ITEM'
      Origin = 'QT_ITEM'
    end
    object FDPEDCOXINHAVL_ITEM: TBCDField
      FieldName = 'VL_ITEM'
      Origin = 'VL_ITEM'
      Precision = 7
      Size = 2
    end
    object FDPEDCOXINHAVL_DOCTO: TBCDField
      FieldName = 'VL_DOCTO'
      Origin = 'VL_DOCTO'
      Precision = 11
      Size = 2
    end
    object FDPEDCOXINHADT_REALIZA: TDateField
      FieldName = 'DT_REALIZA'
      Origin = 'DT_REALIZA'
      EditMask = '##/##/####;1;_'
    end
    object FDPEDCOXINHAFL_ATIVO: TStringField
      FieldName = 'FL_ATIVO'
    end
  end
  object DSPEDCOXINHA: TDataSource
    DataSet = FDPEDCOXINHA
    Left = 56
    Top = 288
  end
  object FDCLIENTE: TFDTable
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'CLIENTE'
    Left = 168
    Top = 176
  end
  object CLIENTE: TDataSource
    DataSet = FDCLIENTE
    Left = 168
    Top = 288
  end
  object FDCONFIG: TFDTable
    Connection = FDConnection1
    TableName = 'CONFIG'
    Left = 272
    Top = 176
    object FDCONFIGFL_CHAVE: TStringField
      FieldName = 'FL_CHAVE'
    end
    object FDCONFIGVL_COXINHA: TBCDField
      FieldName = 'VL_COXINHA'
      Size = 2
    end
    object FDCONFIGFL_TEMA: TStringField
      FieldName = 'FL_TEMA'
    end
    object FDCONFIGFL_IMAGEM: TMemoField
      FieldName = 'FL_IMAGEM'
      OnGetText = FDCONFIGFL_IMAGEMGetText
      BlobType = ftMemo
    end
  end
  object DSCONFIG: TDataSource
    DataSet = FDCONFIG
    Left = 272
    Top = 288
  end
  object dsLinkConsulta: TDataSource
    DataSet = FDQuery1
    Left = 384
    Top = 40
  end
  object FDQueryAux: TFDQuery
    Connection = FDConnection1
    Left = 504
    Top = 48
  end
end
