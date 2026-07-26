unit uClassePix;

interface

uses SysUtils;

type TInformacoesPix = class
  private
    FChavePix: String;
    FValor: String;
    FNome: String;
    FCidade: String;
    FDescricao: String;
    FIdentificador: String;
  public
    property ChavePix: String read FChavePix write FChavePix;
    property Valor: String read FValor write FValor;
    property Nome: String read FNome write FNome;
    property Cidade: String read FCidade write FCidade;
    property Descricao: String read FDescricao write FDescricao;
    property Identificador: String read FIdentificador write FIdentificador;

    function GerarPix: String;
    function CRC16CCITT(texto: string): WORD;
    function RetornaQtdeZeroEsquerda(Str: String): String;


end;

implementation

{ TInformacoesPix }

function TInformacoesPix.GerarPix: String;
var
  pix, temp, vTXID: String;
  CRC16: String;
begin
  // ID 00: Versão do Payload (Fixo)
  pix := '000201';

  // ID 26: Merchant Account Information
  // Usamos maiúsculas no domínio para seguir o manual do BACEN
  temp := '0014BR.GOV.BCB.PIX';

  // Adiciona a chave apenas se ela existir
  if FChavePix <> '' then
    temp := temp + '01' + RetornaQtdeZeroEsquerda(FChavePix) + FChavePix;

  // CORREÇÃO: Só adiciona o ID 02 (Descrição) se houver texto nela!
  if FDescricao <> '' then
    temp := temp + '02' + RetornaQtdeZeroEsquerda(FDescricao) + FDescricao;

  // Monta o bloco 26 com o tamanho correto do 'temp'
  pix := pix + '26' + RetornaQtdeZeroEsquerda(temp) + temp;

  // IDs Fixos 52 e 53
  pix := pix + '52040000';
  pix := pix + '5303986';

  // ID 54: Valor (Garante que o valor formatado seja enviado)
  pix := pix + '54' + RetornaQtdeZeroEsquerda(FValor) + FValor;

  // ID 58 e 59: País e Nome
  pix := pix + '5802BR';
  pix := pix + '59' + RetornaQtdeZeroEsquerda(FNome) + FNome;

  // ID 60: Cidade
  pix := pix + '60' + RetornaQtdeZeroEsquerda(FCidade) + FCidade;

  // ID 62: Campo Adicional (Transaction ID)
  // Se o Identificador estiver vazio, usamos '***' para o PicPay aceitar
  if FIdentificador = '' then
    vTXID := '***'
  else
    vTXID := FIdentificador;

  temp := '05' + RetornaQtdeZeroEsquerda(vTXID) + vTXID;
  pix := pix + '62' + RetornaQtdeZeroEsquerda(temp) + temp;

  // ID 63: Início do CRC
  pix := pix + '6304';

  // Cálculo do CRC16
  CRC16 := IntToHex(CRC16CCITT(pix), 4);
  Result := pix + UpperCase(CRC16);
end;

function TInformacoesPix.CRC16CCITT(texto: string): WORD;
const
  polynomial = $1021;
var
  crc: WORD;
  i, j: Integer;
  b: Byte;
  bit, c15: Boolean;
begin
  crc := $FFFF;
  for i := 1 to length(texto) do
  begin
    b := Byte(texto[i]);
    for j := 0 to 7 do
    begin
      bit := (((b shr (7 - j)) and 1) = 1);
      c15 := (((crc shr 15) and 1) = 1);
      crc := crc shl 1;
      if (c15 xor bit) then
        crc := crc xor polynomial;
    end;
  end;
  Result := crc and $FFFF;
end;

function TInformacoesPix.RetornaQtdeZeroEsquerda(Str: String): String;
begin
  result := '00';
  var LengthStr := Length(Str);

  if (LengthStr > 0) And (LengthStr < 10) then
    result := '0' + IntToStr(LengthStr)
  else if LengthStr >= 10 then
    result := IntToStr(LengthStr);
end;


end.
