unit uPixPayload;

interface

uses
  System.SysUtils;

type
  TPixPayload = class
  private
    FChave: string;
    FNome: string;
    FCidade: string;
    FValor: Double;

    function FormatField(ID, Value: string): string;
    function CRC16(const Data: string): string;
  public
    function Chave(const AValue: string): TPixPayload;
    function Nome(const AValue: string): TPixPayload;
    function Cidade(const AValue: string): TPixPayload;
    function Valor(const AValue: Double): TPixPayload;

    function Gerar: string;
  end;

implementation

function TPixPayload.Chave(const AValue: string): TPixPayload;
begin
  FChave := AValue;
  Result := Self;
end;

function TPixPayload.Nome(const AValue: string): TPixPayload;
begin
  FNome := AValue;
  Result := Self;
end;

function TPixPayload.Cidade(const AValue: string): TPixPayload;
begin
  FCidade := AValue;
  Result := Self;
end;

function TPixPayload.Valor(const AValue: Double): TPixPayload;
begin
  FValor := AValue;
  Result := Self;
end;

function TPixPayload.FormatField(ID, Value: string): string;
begin
  Result := ID + IntToStr(Length(Value)) + Value;
end;

function TPixPayload.CRC16(const Data: string): string;
var
  CRC: Word;
  i, j: Integer;
begin
  CRC := $FFFF;

  for i := 1 to Length(Data) do
  begin
    CRC := CRC xor Ord(Data[i]);
    for j := 1 to 8 do
    begin
      if (CRC and $0001) <> 0 then
        CRC := (CRC shr 1) xor $1021
      else
        CRC := CRC shr 1;
    end;
  end;

  Result := UpperCase(IntToHex(CRC, 4));
end;

function TPixPayload.Gerar: string;
var
  Payload, MerchantAccount, ValorStr: string;
begin
  ValorStr := FormatFloat('0.00', FValor);
  ValorStr := StringReplace(ValorStr, ',', '.', [rfReplaceAll]);

  MerchantAccount :=
    FormatField('00', 'BR.GOV.BCB.PIX') +
    FormatField('01', FChave);

  Payload :=
    FormatField('00', '01') +
    FormatField('26', MerchantAccount) +
    FormatField('52', '0000') +
    FormatField('53', '986') +
    FormatField('54', ValorStr) +
    FormatField('58', 'BR') +
    FormatField('59', FNome) +
    FormatField('60', FCidade) +
    '6304';

  Result := Payload + CRC16(Payload);
end;

end.
