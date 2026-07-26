unit Unit6;

interface

uses
  Unit1, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uClassePix, ACBrDelphiZXingQRCode,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Unit8, Vcl.ComCtrls, Unit2, Data.DB, System.UITypes,
  Vcl.ImgList, Clipbrd, System.Types, Winapi.CommCtrl, System.NetEncoding, Winapi.ShellAPI, UnitToast;

type
  TCOBRANCA2 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit; // Filtro de Nome
    RadioGroup1: TRadioGroup; // Filtro Pago/Pendente
    Edit2: TEdit;
    ListView1: TListView;
    Panel2: TPanel;
    BitBtn1: TBitBtn; // Gerar Pix
    BitBtn3: TBitBtn; // Abrir FMWhatsapp (Configurações/WhatsApp)
    Image1: TImage;
    BitBtn2: TBitBtn; // Enviar WhatsApp via Form
    BitBtn4: TBitBtn;
    Memo1: TMemo;
    BitBtn6: TBitBtn; // Enviar WhatsApp via ShellExecute
    Label1: TLabel;
    lblTotal: TStaticText;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure BitBtn6Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    FColunaClick: Integer; // A variável DEVE ficar aqui (antes dos métodos)
    procedure GerarQRCode(APict: TPicture; Pix: String);
    procedure AtualizarLista;
    function OnlyNumbers(const S: string): string;
    function GetChavePix: string; // Busca chave da tabela CONFIG
  public
    { Public declarations }
  end;

var
  COBRANCA2: TCOBRANCA2;

implementation

{$R *.dfm}

{ Função para buscar a chave na tabela CONFIG }
procedure TCOBRANCA2.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  // Guarda o índice da coluna que foi clicada para usar na comparação
  FColunaClick := Column.Index;
  // Dispara a reordenação
  (Sender as TCustomListView).AlphaSort;
end;

procedure TCOBRANCA2.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  // Se for a primeira coluna (Caption/Cliente)
  if FColunaClick = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    // Se forem as outras colunas (SubItems)
    // O índice do SubItem é sempre o índice da coluna - 1
    Compare := CompareText(Item1.SubItems[FColunaClick - 1], Item2.SubItems[FColunaClick - 1]);
end;

function TCOBRANCA2.GetChavePix: string;
var
  ChaveLimpa: string;
  I: Integer;
begin
  Result := 'abcarlos@gmail.com'; // Default

  DataModule2.FDQueryAux.Close;
  DataModule2.FDQueryAux.SQL.Text := 'SELECT FL_CHAVE FROM CONFIG';
  try
    DataModule2.FDQueryAux.Open;
    if not DataModule2.FDQueryAux.FieldByName('FL_CHAVE').IsNull then
      Result := DataModule2.FDQueryAux.FieldByName('FL_CHAVE').AsString;
  except
    // Falha silenciosa
  end;

  // --- TRATAMENTO PARA CELULAR ---

  // 1. Remove espaços, parênteses e traços (Deixa apenas números)
  ChaveLimpa := '';
  for I := 1 to Length(Result) do
    if Result[I] in ['0'..'9'] then
      ChaveLimpa := ChaveLimpa + Result[I];

  // 2. Verifica se é um celular (9 dígitos) ou celular com DDD (11 dígitos)
  if Length(ChaveLimpa) = 9 then
    // Apenas o número: Adiciona +55 (Brasil) e 21 (Rio)
    Result := '+5521' + ChaveLimpa
  else if (Length(ChaveLimpa) = 11) and (Copy(ChaveLimpa, 1, 1) <> '0') then
    // Número com DDD: Adiciona apenas o +55
    Result := '+55' + ChaveLimpa;

  // Se for e-mail ou CPF, a lógica acima será ignorada pois os tamanhos/caracteres divergem.
end;

{ Função para limpar o telefone }
function TCOBRANCA2.OnlyNumbers(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if CharInSet(S[I], ['0'..'9']) then
      Result := Result + S[I];
end;

procedure TCOBRANCA2.FormCreate(Sender: TObject);
begin
  ListView1.ViewStyle := vsReport;
  ListView1.RowSelect := True;
  ListView1.GridLines := True;
  ListView1.Columns.Clear;

  with ListView1.Columns.Add do begin Caption := 'Cliente'; Width := 150; end;
  with ListView1.Columns.Add do begin Caption := 'Telefone'; Width := 100; end;
  with ListView1.Columns.Add do begin Caption := 'Qtd'; Width := 40; end;
  with ListView1.Columns.Add do begin Caption := 'Valor'; Width := 80; end;
  with ListView1.Columns.Add do begin Caption := 'Vencimento'; Width := 80; end;
  with ListView1.Columns.Add do begin Caption := 'Dt Pedido'; Width := 80; end;
  with ListView1.Columns.Add do begin Caption := 'Status'; Width := 70; end;
end;

procedure TCOBRANCA2.FormShow(Sender: TObject);
var
  MaiorData: string;
begin
  Self.Width := Round(Screen.WorkAreaWidth * 0.85);
  Self.Height := Round(Screen.WorkAreaHeight * 0.90);
  Self.Left := (Screen.WorkAreaWidth - Self.Width) div 2;
  Self.Top := (Screen.WorkAreaHeight - Self.Height) div 2;

  DataModule2.FDQuery1.Close;
  DataModule2.FDQuery1.SQL.Text := 'SELECT MAX(DT_PEDIDO) as MAIOR FROM PEDCOXINHA WHERE FL_ATIVO <> ''N''';
  try
    DataModule2.FDQuery1.Open;
    if not DataModule2.FDQuery1.FieldByName('MAIOR').IsNull then
    begin
      MaiorData := DataModule2.FDQuery1.FieldByName('MAIOR').AsString;
      Edit2.Text := MaiorData;
    end
    else
      AtualizarLista;
  except
    on E: Exception do AtualizarLista;
  end;
AtualizarLista;

end;

procedure TCOBRANCA2.Edit1Change(Sender: TObject);
begin
  AtualizarLista;
end;

procedure TCOBRANCA2.Edit2Change(Sender: TObject);
begin
  AtualizarLista;
end;

procedure TCOBRANCA2.RadioGroup1Click(Sender: TObject);
begin
  AtualizarLista;
end;

procedure TCOBRANCA2.AtualizarLista;
var
  Item: TListItem;
  TotalGeral: Currency;
  DiaBusca, MesBusca: string;
begin
  TotalGeral := 0;
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    DataModule2.FDQuery1.Close;
    DataModule2.FDQuery1.SQL.Clear;

    DataModule2.FDQuery1.SQL.Add('SELECT P.DS_NOME, P.DT_PEDIDO, P.DT_VENC, C.NR_TEL, P.QT_ITEM, P.VL_DOCTO, P.DT_REALIZA');
    DataModule2.FDQuery1.SQL.Add('FROM PEDCOXINHA P, CLIENTE C');
    DataModule2.FDQuery1.SQL.Add('WHERE P.DS_NOME = C.NM_CLIENTE');

        // FILTRO DE INATIVOS (Adicionado conforme solicitado)
    DataModule2.FDQuery1.SQL.Add('AND (P.FL_ATIVO <> ''N'')');

    // 1. Filtro de Status
    if RadioGroup1.ItemIndex = 1 then DataModule2.FDQuery1.SQL.Add('AND P.DT_REALIZA IS NULL');
    if RadioGroup1.ItemIndex = 2 then DataModule2.FDQuery1.SQL.Add('AND P.DT_REALIZA IS NOT NULL');

    // 2. Filtro de Nome
    if Edit1.Text <> '' then
    begin
      DataModule2.FDQuery1.SQL.Add('AND UPPER(P.DS_NOME) LIKE UPPER(:nome)');
      DataModule2.FDQuery1.ParamByName('nome').AsString := '%' + Edit1.Text + '%';
    end;

    // 3. Filtro de Data (Dia/Mês para ADS)
    if Edit2.Text <> '' then
    begin
      if (Length(Edit2.Text) >= 5) and (Pos('/', Edit2.Text) > 0) then
      begin
        DiaBusca := Copy(Edit2.Text, 1, 2);
        MesBusca := Copy(Edit2.Text, 4, 2);
        DataModule2.FDQuery1.SQL.Add('AND DAY(P.DT_PEDIDO) = :dia');
        DataModule2.FDQuery1.SQL.Add('AND MONTH(P.DT_PEDIDO) = :mes');
        DataModule2.FDQuery1.ParamByName('dia').AsInteger := StrToIntDef(DiaBusca, 0);
        DataModule2.FDQuery1.ParamByName('mes').AsInteger := StrToIntDef(MesBusca, 0);
      end
      else
      begin
        DataModule2.FDQuery1.SQL.Add('AND REPLACE(REPLACE(CONVERT(P.DT_PEDIDO, SQL_VARCHAR), ''/'', ''''), ''-'', '''') LIKE :data');
        DataModule2.FDQuery1.ParamByName('data').AsString := '%' + OnlyNumbers(Edit2.Text) + '%';
      end;
    end;

    DataModule2.FDQuery1.Open;
    while not DataModule2.FDQuery1.Eof do
    begin
      TotalGeral := TotalGeral + DataModule2.FDQuery1.FieldByName('VL_DOCTO').AsCurrency;

      Item := ListView1.Items.Add;
      Item.Caption := DataModule2.FDQuery1.FieldByName('DS_NOME').AsString; // Col 0
      Item.SubItems.Add(DataModule2.FDQuery1.FieldByName('NR_TEL').AsString); // Col 1
      Item.SubItems.Add(DataModule2.FDQuery1.FieldByName('QT_ITEM').AsString); // Col 2
      Item.SubItems.Add(FormatCurr('R$ #,##0.00', DataModule2.FDQuery1.FieldByName('VL_DOCTO').AsCurrency)); // Col 3
      Item.SubItems.Add(DataModule2.FDQuery1.FieldByName('DT_VENC').AsString); // Col 4
      Item.SubItems.Add(DataModule2.FDQuery1.FieldByName('DT_PEDIDO').AsString); // Col 5

      // IMPORTANTE: O status precisa estar no SubItem[5] (6ª coluna) para o CustomDraw pintar
      if DataModule2.FDQuery1.FieldByName('DT_REALIZA').IsNull then
        Item.SubItems.Add('PENDENTE')
      else
        Item.SubItems.Add('PAGO');

      DataModule2.FDQuery1.Next;
    end;
  finally
    ListView1.Items.EndUpdate;
  end;

  lblTotal.Caption := 'Total: ' + FormatCurr('R$ #,##0.00', TotalGeral);
  ListView1.AlphaSort;
end;

procedure TCOBRANCA2.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Status: string;
  R: TRect;
begin
  // Pegamos o status que está na última coluna (SubItems[5])
  if Item.SubItems.Count >= 6 then
    Status := Item.SubItems[5]
  else
    Status := '';

  // Define a cor de fundo e da fonte baseada no texto
  if Status = 'PAGO' then
  begin
    Sender.Canvas.Brush.Color := $00EBFFEB; // Verde bem claro
    Sender.Canvas.Font.Color  := clGreen;
  end
  else
  begin
    Sender.Canvas.Brush.Color := $00ECECFF; // Vermelho bem claro
    Sender.Canvas.Font.Color  := clRed;
  end;

  // Se o item estiver selecionado, mantém a cor de seleção padrão
  if cdsSelected in State then
  begin
    Sender.Canvas.Brush.Color := clHighlight;
    Sender.Canvas.Font.Color  := clHighlightText;
  end;

  // Aplica a pintura no retângulo do item
  R := Item.DisplayRect(drBounds);
  Sender.Canvas.FillRect(R);
  DefaultDraw := True;
end;

procedure TCOBRANCA2.BitBtn1Click(Sender: TObject);
var
  ValorTratado: string;
  infoPix: TInformacoesPix;
  PixString: string;
  Bmp: TBitmap;
  QRRect: TRect;
  Nome, Quantidade, Valor: string;
  Margem, QRSize: Integer;
begin
  if ListView1.Selected = nil then Exit;
  Nome := 'ANTONIO';
  Quantidade := ListView1.Selected.SubItems[1];
  Valor := ListView1.Selected.SubItems[2];

  infoPix := TInformacoesPix.Create;
  try
    infoPix.ChavePix := GetChavePix;
    ValorTratado := StringReplace(Valor, 'R$ ', '', [rfReplaceAll]);
    ValorTratado := StringReplace(ValorTratado, '.', '', [rfReplaceAll]);
    ValorTratado := StringReplace(ValorTratado, ',', '.', [rfReplaceAll]);
    infoPix.Valor := ValorTratado;
    infoPix.Nome := Nome;
    infoPix.Cidade := 'RIO DE JANEIRO';
    PixString := infoPix.GerarPix;
    Memo1.Lines.Text := PixString;
  finally
    infoPix.Free;
  end;

  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(400, 400);
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    Margem := 15;
    Bmp.Canvas.Font.Name := 'Segoe UI';
    Bmp.Canvas.Font.Size := 11;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.TextOut(Margem, 10, 'Pague a Coxinha!');
    Bmp.Canvas.Font.Size := 9;
    Bmp.Canvas.Font.Style := [];
    Bmp.Canvas.TextOut(Margem, 40, 'Nome: ' + Nome);
    Bmp.Canvas.TextOut(Margem, 40, 'Qtd: ' + Quantidade);
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.TextOut(Margem, 80, 'Valor: ' + Valor);

    GerarQRCode(Image1.Picture, PixString);
    QRSize := 220;
    if Assigned(Image1.Picture.Graphic) then
    begin
      QRRect := Rect((Bmp.Width - QRSize) div 2, 120, ((Bmp.Width - QRSize) div 2) + QRSize, 120 + QRSize);
      Bmp.Canvas.StretchDraw(QRRect, Image1.Picture.Graphic);
    end;
    Image1.Picture.Assign(Bmp);
    Clipboard.Assign(Bmp);
    FormToast := TFormToast.Create(Self);
    FormToast.Label1.Caption := 'QR Code Copiado!';
    FormToast.AlphaBlend := True;
    FormToast.AlphaBlendValue := 255;
    FormToast.Show; // Use .Show para não travar a tela
    // ----------------------------
  finally
    Bmp.Free;
  end;
  Self.ActiveControl := nil;
end;

procedure TCOBRANCA2.BitBtn2Click(Sender: TObject);
var
  ProximoIndice: Integer;
begin
  if ListView1.Selected = nil then Exit;

  // 1. Guarda o índice do próximo registro antes de atualizar a lista
  ProximoIndice := ListView1.Selected.Index + 1;

  // 2. Executa a atualização no banco de dados
  DataModule2.FDQueryAux.Close;
  DataModule2.FDQueryAux.SQL.Text := 'UPDATE PEDCOXINHA SET DT_REALIZA = CURDATE() ' +
                                    'WHERE DS_NOME = :nome AND DT_PEDIDO = :data';

  DataModule2.FDQueryAux.ParamByName('nome').AsString := ListView1.Selected.Caption;
  DataModule2.FDQueryAux.ParamByName('data').AsDate := StrToDate(ListView1.Selected.SubItems[4]);
  DataModule2.FDQueryAux.ExecSQL;

  // 3. Atualiza a lista (isso recarrega os itens do ListView)
  AtualizarLista;

  // 4. Posiciona no próximo registro
  // Verifica se o próximo índice existe na lista atualizada
  if (ProximoIndice < ListView1.Items.Count) then
  begin
    ListView1.ItemIndex := ProximoIndice;
    ListView1.Items[ProximoIndice].Focused := True;
    ListView1.Items[ProximoIndice].Selected := True;
    ListView1.Items[ProximoIndice].MakeVisible(False); // Garante que o item apareça se houver scroll
  end;

  Self.ActiveControl := nil;
end;

procedure TCOBRANCA2.BitBtn3Click(Sender: TObject);
var
  TextoMsg, UrlFinal: string;
begin
  if ListView1.Selected = nil then Exit;
  TextoMsg := 'Olá, seguem os dados para pagamento da(s) coxinha(s):' + sLineBreak +
              'Nome: ' + ListView1.Selected.Caption + sLineBreak +
              'Valor: ' + ListView1.Selected.SubItems[2] + sLineBreak +
              'Chave Pix: ' + GetChavePix;

  UrlFinal := 'https://web.whatsapp.com/send?phone=55' + OnlyNumbers(ListView1.Selected.SubItems[0]) +
              '&text=' + TNetEncoding.URL.Encode(TextoMsg);

  if not Assigned(FMWhatsapp) then Application.CreateForm(TFMWhatsapp, FMWhatsapp);
  FMWhatsapp.Show;
  FMWhatsapp.EdgeBrowser1.Navigate(UrlFinal);
  Self.ActiveControl := nil;
end;

procedure TCOBRANCA2.BitBtn4Click(Sender: TObject);
begin
  if ListView1.Selected = nil then Exit;

  DataModule2.FDQueryAux.Close;
  DataModule2.FDQueryAux.SQL.Text := 'UPDATE PEDCOXINHA SET DT_REALIZA = NULL ' +
                                    'WHERE DS_NOME = :nome AND DT_PEDIDO = :data';

  DataModule2.FDQueryAux.ParamByName('nome').AsString := ListView1.Selected.Caption;
  DataModule2.FDQueryAux.ParamByName('data').AsDate := StrToDate(ListView1.Selected.SubItems[4]);

  DataModule2.FDQueryAux.ExecSQL;

  AtualizarLista;
  Self.ActiveControl := nil;
end;

procedure TCOBRANCA2.BitBtn6Click(Sender: TObject);
var
  TextoMsg, Telefone, UrlFinal: string;
begin
  if ListView1.Selected = nil then Exit;
  Telefone := OnlyNumbers(ListView1.Selected.SubItems[0]);
  TextoMsg := 'Olá, seguem os dados para pagamento da(s) coxinha(s):' + sLineBreak +
              'Nome: ' + ListView1.Selected.Caption + sLineBreak +
              'Valor: ' + ListView1.Selected.SubItems[2] + sLineBreak +
              'Chave Pix: ' + GetChavePix;

  UrlFinal := 'https://wa.me/55' + Telefone + '?text=' + TNetEncoding.URL.Encode(TextoMsg);
  ShellExecute(0, 'open', PChar(UrlFinal), nil, nil, SW_SHOWNORMAL);
  Self.ActiveControl := nil;
end;

procedure TCOBRANCA2.GerarQRCode(APict: TPicture; Pix: String);
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap: TBitmap;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    QRCode.QuietZone := 1;
    QRCode.Data := Trim(Pix);
    QRCodeBitmap.Width := QRCode.Columns;
    QRCodeBitmap.Height := QRCode.Rows;
    for Row := 0 to QRCode.Rows - 1 do
      for Column := 0 to QRCode.Columns - 1 do
        if QRCode.IsBlack[Row, Column] then
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
        else
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
    APict.Assign(QRCodeBitmap);
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
  end;
end;

end.
