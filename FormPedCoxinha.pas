unit FormPedCoxinha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Unit1, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection;

type
  TPedCoxinha = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    DTVENC: TDBEdit;
    DTPEDIDO: TDBEdit;
    QUANTIDADE: TDBEdit;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    VALORTOTAL: TDBEdit;
    NOME: TDBLookupComboBox;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnSalvar: TBitBtn;
    Edit1: TEdit;
    btnNovo: TBitBtn;
    btnExcluir: TBitBtn;
    btnCancelar: TBitBtn;
    Label3: TLabel;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    Panel2: TPanel;
    procedure DTPEDIDOKeyPress(Sender: TObject; var Key: Char);
    procedure DTVENCKeyPress(Sender: TObject; var Key: Char);
    procedure QUANTIDADEKeyPress(Sender: TObject; var Key: Char);
    procedure DTPEDIDOChange(Sender: TObject);
    procedure NOMEClick(Sender: TObject);
    procedure QUANTIDADEChange(Sender: TObject);
    procedure NOMEExit(Sender: TObject);
    procedure QUANTIDADEExit(Sender: TObject);
    procedure DTPEDIDOExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure QUANTIDADEEnter(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure AtualizarLista;
    procedure AtualizarBotoes;
    function EncontraRegistro: Boolean;
  public
  end;

var
  PedCoxinha: TPedCoxinha;

implementation

{$R *.dfm}

uses Unit2;

function TPedCoxinha.EncontraRegistro: Boolean;
begin
  Result := DataModule2.FDPEDCOXINHA.Locate('DS_NOME;DT_PEDIDO;QT_ITEM',
    VarArrayOf([
      DataModule2.FDQuery1.FieldByName('DS_NOME').Value,
      DataModule2.FDQuery1.FieldByName('DT_PEDIDO').Value,
      DataModule2.FDQuery1.FieldByName('QT_ITEM').Value
    ]), []);
end;

procedure TPedCoxinha.AtualizarBotoes;
begin
  btnSalvar.Enabled   := DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit];
  btnCancelar.Enabled := DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit];
  btnNovo.Enabled     := DataModule2.FDPEDCOXINHA.State = dsBrowse;
  btnExcluir.Enabled  := DataModule2.FDPEDCOXINHA.State = dsBrowse;
end;

procedure TPedCoxinha.btnSalvarClick(Sender: TObject);
begin
// Validação extra de segurança antes do Post
  if Trim(NOME.Text) = '' then
  begin
    ShowMessage('Não é possível salvar sem um nome!');
    NOME.SetFocus;
    Exit;
  end;
  try
    if DataModule2.FDPEDCOXINHA.State in [dsEdit, dsInsert] then
    begin
      if DataModule2.FDPEDCOXINHA.State = dsInsert then
         DataModule2.FDPEDCOXINHA.FieldByName('FL_ATIVO').AsString := 'S';

      DataModule2.FDPEDCOXINHA.Post;
      AtualizarLista;
    end;
    btnNovo.Click;
    AtualizarBotoes;
  except
    on E: Exception do ShowMessage('Erro ao salvar: ' + E.Message);
  end;
end;

procedure TPedCoxinha.btnNovoClick(Sender: TObject);

begin
  try
    DataModule2.FDPEDCOXINHA.Append;
    DataModule2.FDPEDCOXINHA.FieldByName('DT_PEDIDO').AsDateTime := Date;
    DataModule2.FDPEDCOXINHA.FieldByName('DT_VENC').AsDateTime   := Date;
    Edit1.Text := DateToStr(Date);
    NOME.SetFocus;
    AtualizarBotoes;
    AtualizarLista;
  except
    on E: Exception do ShowMessage('Erro ao criar novo pedido: ' + E.Message);
  end;
end;

procedure TPedCoxinha.btnCancelarClick(Sender: TObject);
begin
  DataModule2.FDPEDCOXINHA.Cancel;
  AtualizarLista;
  AtualizarBotoes;
end;

procedure TPedCoxinha.btnExcluirClick(Sender: TObject);
begin
  if DataModule2.FDQuery1.IsEmpty then Exit;
  if MessageDlg('Deseja realmente remover este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      if EncontraRegistro then
      begin
        DataModule2.FDPEDCOXINHA.Edit;
        DataModule2.FDPEDCOXINHA.FieldByName('FL_ATIVO').AsString := 'N';
        DataModule2.FDPEDCOXINHA.Post;
        AtualizarLista;
        ShowMessage('Removido com sucesso!');
      end;
    except
      on E: Exception do ShowMessage('Erro ao excluir: ' + E.Message);
    end;
  end;
end;

procedure TPedCoxinha.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // LÓGICA PARA CANCELAR (ESC)
  if Key = VK_ESCAPE then
  begin
    if (DataModule2.FDPEDCOXINHA.State in [dsEdit, dsInsert]) then
    begin
      // Simula o clique no botão cancelar que já tem a lógica de botões
      if btnCancelar.Enabled then
        btnCancelar.Click;
        Self.ActiveControl := nil;
      Key := 0;
      Exit; // CRITICAL: Para a execução aqui para não entrar no "btnNovo" abaixo
    end;
  end;

  // LÓGICA PARA NOVO (Exemplo usando a tecla INSERT)
  if Key = VK_INSERT then
  begin
    if (DataModule2.FDPEDCOXINHA.State = dsBrowse) then
    begin
      btnNovo.Click;
      Key := 0;
    end;
  end;
end;


procedure TPedCoxinha.FormShow(Sender: TObject);
var
  DataBruta: TDateTime;
begin
  Self.SetBounds((Screen.WorkAreaWidth - Width) div 2, (Screen.WorkAreaHeight - Height) div 2, Width, Height);
  DataModule2.FDQuery1.Close;
  DataModule2.FDQuery1.SQL.Text :=
    'SELECT MAX(DT_PEDIDO) AS MAIOR FROM PEDCOXINHA WHERE (FL_ATIVO IS NULL OR FL_ATIVO = ''S'')';
  try
    DataModule2.FDQuery1.Open;
    if not DataModule2.FDQuery1.FieldByName('MAIOR').IsNull then
    begin
      DataBruta := DataModule2.FDQuery1.FieldByName('MAIOR').AsDateTime;
      Edit1.Text := FormatDateTime('dd/mm/yyyy', DataBruta);
    end
    else
      AtualizarLista;
  except
    AtualizarLista;
  end;
  AtualizarBotoes;
  AtualizarLista;
end;

procedure TPedCoxinha.Edit1Change(Sender: TObject);
begin
  if (Length(Edit1.Text) = 10) or (Edit1.Text = '') then
    AtualizarLista;
end;

procedure TPedCoxinha.AtualizarLista;
var
  vData: TDateTime;
begin
  DataModule2.FDQuery1.Close;
  DataModule2.FDQuery1.SQL.Clear;
  DataModule2.FDQuery1.SQL.Add('SELECT * FROM PEDCOXINHA WHERE (FL_ATIVO IS NULL OR FL_ATIVO = ''S'')');
  if (Edit1.Text <> '') and (Length(Edit1.Text) = 10) then
  begin
    if TryStrToDate(Edit1.Text, vData) then
    begin
      DataModule2.FDQuery1.SQL.Add('AND DT_PEDIDO = :pData');
      DataModule2.FDQuery1.ParamByName('pData').AsDate := vData;
    end;
  end;
  try
    DataModule2.FDQuery1.Open;
  except
    on E: Exception do ShowMessage('Erro na consulta: ' + E.Message);
  end;
end;


procedure TPedCoxinha.NOMEExit(Sender: TObject);
begin
  if (ActiveControl = btnCancelar) then Exit;

  if DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit] then
  begin
    if Trim(NOME.Text) = '' then
    begin
      ShowMessage('Preencha o nome!');
      NOME.SetFocus;
      Exit;
    end;

    DataModule2.FDQueryAux.Close;
    DataModule2.FDQueryAux.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM PEDCOXINHA ' +
                                      'WHERE DS_NOME = :pNome AND DT_PEDIDO = :pData ' +
                                      'AND (FL_ATIVO IS NULL OR FL_ATIVO = ''S'')';
    DataModule2.FDQueryAux.ParamByName('pNome').AsString := NOME.Text;
    DataModule2.FDQueryAux.ParamByName('pData').AsDate   := DataModule2.FDPEDCOXINHA.FieldByName('DT_PEDIDO').AsDateTime;
    DataModule2.FDQueryAux.Open;

    if DataModule2.FDQueryAux.FieldByName('TOTAL').AsInteger > 0 then
    begin
      ShowMessage('Já existe um pedido para este cliente nesta data!');
      NOME.SetFocus;
    end;
  end;
end;

procedure TPedCoxinha.DTPEDIDOExit(Sender: TObject);
begin
  if (ActiveControl = btnCancelar) then Exit;
  if (DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit]) and (Trim(DTPEDIDO.Text) = '') then
  begin
    ShowMessage('Preencha a data do pedido');
    DTPEDIDO.SetFocus;
  end;
end;

procedure TPedCoxinha.QUANTIDADEEnter(Sender: TObject);
begin
  if DataModule2.FDPEDCOXINHA.State = dsBrowse then
    DataModule2.FDPEDCOXINHA.Edit;
end;

procedure TPedCoxinha.QUANTIDADEExit(Sender: TObject);
begin
  if (ActiveControl = btnCancelar) then Exit;
  if DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit] then
  begin
    if (Trim(QUANTIDADE.Text) = '') or (StrToIntDef(QUANTIDADE.Text, 0) <= 0) then
    begin
      ShowMessage('Digite uma quantidade válida');
      QUANTIDADE.SetFocus;
    end;
  end;
  DataModule2.FDPEDCOXINHA.Post;
  AtualizarLista;
end;

procedure TPedCoxinha.BitBtn1Click(Sender: TObject);
begin
  if EncontraRegistro then
  begin
    DataModule2.FDPEDCOXINHA.Edit;
    DataModule2.FDPEDCOXINHA.FieldByName('DT_REALIZA').AsDateTime := Date;
    DataModule2.FDPEDCOXINHA.Post;
    AtualizarLista;
  end;
end;

procedure TPedCoxinha.BitBtn2Click(Sender: TObject);
begin
  if EncontraRegistro then
  begin
    DataModule2.FDPEDCOXINHA.Edit;
    DataModule2.FDPEDCOXINHA.FieldByName('DT_REALIZA').AsVariant := Null;
    DataModule2.FDPEDCOXINHA.Post;
    AtualizarLista;
  end;
end;

procedure TPedCoxinha.DTPEDIDOKeyPress(Sender: TObject; var Key: Char);
begin if not CharInSet(Key, ['0'..'9', '/', #8]) then Key := #0; end;

procedure TPedCoxinha.DTVENCKeyPress(Sender: TObject; var Key: Char);
begin if not CharInSet(Key, ['0'..'9', '/', #8]) then Key := #0; end;

procedure TPedCoxinha.QUANTIDADEKeyPress(Sender: TObject; var Key: Char);
begin if not CharInSet(Key, ['0'..'9', #8]) then Key := #0; end;

procedure TPedCoxinha.DBGrid1CellClick(Column: TColumn);
begin
  // Sempre que clicar em uma célula, sincroniza o Dataset de edição
  if not DataModule2.FDQuery1.IsEmpty then
  begin
    EncontraRegistro;
    AtualizarBotoes;
  end;
end;



procedure TPedCoxinha.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Garante que funcione também ao navegar pelas setas do teclado
  if (Key = VK_UP) or (Key = VK_DOWN) then
    DBGrid1CellClick(nil);
end;

procedure TPedCoxinha.DTPEDIDOChange(Sender: TObject); begin DTPEDIDO.Color := $00E6FFFF; end;
procedure TPedCoxinha.NOMEClick(Sender: TObject); begin NOME.Color := $00E6FFFF; end;
procedure TPedCoxinha.QUANTIDADEChange(Sender: TObject);
var
  VUnitario, VTotal: Currency;
  Qtd: Integer;
 begin
 QUANTIDADE.Color := $00E6FFFF;


begin
  // 1. Pega o valor unitário que está salvo na tabela de configurações
  VUnitario := DataModule2.FDCONFIG.FieldByName('VL_COXINHA').AsCurrency;

  // 2. Pega a quantidade digitada (se for vazio ou erro, assume 0)
  Qtd := StrToIntDef(QUANTIDADE.Text, 0);

  // 3. Só calcula se estiver em modo de edição ou inserção
  if DataModule2.FDPEDCOXINHA.State in [dsInsert, dsEdit] then
  begin
    VTotal := Qtd * VUnitario;

    // 4. Joga o resultado no campo VALORTOTAL (que deve ser o nome do seu DBEdit ou Field)
    DataModule2.FDPEDCOXINHA.FieldByName('VL_DOCTO').AsCurrency := VTotal;
  end;

  // Mantém a cor de destaque que você já tinha
  QUANTIDADE.Color := $00E6FFFF;
end;
 end;

end.
