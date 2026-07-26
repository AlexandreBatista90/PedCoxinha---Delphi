unit Unit3;

interface

uses
  Unit1, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Unit2;

type
  TFormCadProduto = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  FormCadProduto: TFormCadProduto;

implementation

{$R *.dfm}


procedure TFormCadProduto.FormCreate(Sender: TObject);
begin
  DBGrid1.DataSource := DataModule2.DataSource1;
  DataModule2.FDQuery1.Open;
end;



end.
