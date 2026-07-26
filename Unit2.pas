unit Unit2;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.ADS,
  FireDAC.Phys.ADSDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Winapi.Windows, Vcl.Forms, FireDAC.Stan.ExprFuncs, Vcl.Dialogs;

type
  TDataModule2 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPEDCOXINHA: TFDTable;
    DSPEDCOXINHA: TDataSource;
    FDPEDCOXINHAID: TIntegerField;
    FDPEDCOXINHADT_PEDIDO: TDateField;
    FDPEDCOXINHADT_VENC: TDateField;
    FDPEDCOXINHADS_NOME: TStringField;
    FDPEDCOXINHAQT_ITEM: TIntegerField;
    FDPEDCOXINHAVL_ITEM: TBCDField;
    FDPEDCOXINHAVL_DOCTO: TBCDField;
    FDPEDCOXINHADT_REALIZA: TDateField;
    FDCLIENTE: TFDTable;
    CLIENTE: TDataSource;
    FDCONFIG: TFDTable;
    DSCONFIG: TDataSource;
    FDCONFIGFL_CHAVE: TStringField;
    FDCONFIGVL_COXINHA: TBCDField;
    FDCONFIGFL_TEMA: TStringField;
    FDCONFIGFL_IMAGEM: TMemoField;
    dsLinkConsulta: TDataSource;
    FDQueryAux: TFDQuery;
    FDPEDCOXINHAFL_ATIVO: TStringField;

    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDCONFIGFL_IMAGEMGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);


  private
    { Private declarations }
  public
    FCaminhoBase: string;
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDataModule2.DataModuleCreate(Sender: TObject);
begin
  FCaminhoBase := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  try
    FDConnection1.Connected := False;

    FDConnection1.Params.Values['Database'] := FCaminhoBase;

    // ALTERE DE 'Ignore' PARA 'Off'
    FDConnection1.Params.Values['AdsDeleted'] := 'Off';

    FDConnection1.Connected := True;

    FDCLIENTE.Open;
    FDPEDCOXINHA.Open;
    FDCONFIG.Open;
  except
    on E: Exception do
      ShowMessage('Erro ao conectar: ' + E.Message);
  end;
end;




procedure TDataModule2.FDCONFIGFL_IMAGEMGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TDataModule2.FDConnection1BeforeConnect(Sender: TObject);
var
  CaminhoDB: string;
begin
  // Pega a pasta onde o executável está rodando
  CaminhoDB := ExtractFilePath(ParamStr(0));

  // Define o banco de dados para a pasta do executável
  // Se o seu banco for Local (Free Tables .dbf), o Database é a PASTA
  FDConnection1.Params.Values['Database'] := CaminhoDB;
end;

end.
