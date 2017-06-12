unit ZoopDelphiDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ZoopWrapper_TLB, ActiveX,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    RichEdit1: TRichEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  marketplace_id, seller_id, zpk : String;

implementation

{$R *.dfm}

var
  ZoopAPI: IDZoopAPI;
  TerminalList: IDTerminalListManager;
  ZoopTerminalPayment: IDZoopTerminalPayment;
  ZoopTerminalVoidPayment: IDZoopTerminalVoidPayment;


procedure delphiShowMessageChargeListener(smessage: widestring; smessageType: widestring) stdcall;
begin
  showMessage(smessage);
//  showMessage(smessageType);
end;

procedure cardLast4DigitsRequestedListener();
var
  cardLast4Digits: widestring;
begin
showMessage('Insira os 4 ultimos digitos do cartao do cliente');
cardLast4Digits := '1234';

ZoopTerminalPayment := CoDZoopTerminalPayment.Create;
ZoopTerminalPayment.addCardLast4Digits(cardLast4Digits);
end;

procedure cardCVCRequestedListener();
var
  cardCVC: widestring;
begin
showMessage('Insira o CVC do cartao do cliente');
cardCVC := '123';

ZoopTerminalPayment := CoDZoopTerminalPayment.Create;
ZoopTerminalPayment.addCardCVC(cardCVC);
end;

procedure cardExpirationDateRequestedListener();
var
  cardExpirationDate: widestring;
begin
showMessage('Insira a data de expiração do cartao do cliente');
cardExpirationDate := '123';

ZoopTerminalPayment := CoDZoopTerminalPayment.Create;
ZoopTerminalPayment.addCardExpirationDate(cardExpirationDate);
end;

procedure paymentFailedListener();
var
  cardExpirationDate: widestring;
begin
showMessage('Insira a data de expiração do cartao do cliente');
cardExpirationDate := '123';

ZoopTerminalPayment := CoDZoopTerminalPayment.Create;
ZoopTerminalPayment.addCardExpirationDate(cardExpirationDate);
end;

procedure paymentSuccessfulListener(joResponse: widestring);
begin

end;

procedure paymentAbortedListener(joResponse: widestring);
begin

end;

procedure cardHolderSignatureRequestedListener();

begin
end;

procedure delphiStartTerminalDiscoveryListener(terminalArrayList: PSafeArray) stdcall;
var
  rgIndices, LBound, HBound : Integer;
  value: widestring;

begin
  SafeArrayGetLBound(terminalArrayList, 1, LBound);
  SafeArrayGetUBound(terminalArrayList, 1, HBound);
  for rgIndices := LBound to HBound do
  begin
    SafeArrayGetElement(terminalArrayList, rgIndices, value);
    showMessage(value);
  end;
  TerminalList.setSelectedTerminal(value);
end;

procedure voidSuccefulListener(joResponse: widestring) stdcall;
begin
  showMessage(joResponse);
end;

procedure voidFailedListener(joResponse: widestring) stdcall;
begin
  showMessage(joResponse);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  marketplace_id := '3249465a7753536b62545a6a684b0000';
  seller_id := '1e5ee2e290d040769806c79e6ef94ee1';
  zpk := 'zpk_test_EzCkzFFKibGQU6HFq7EYVuxI';

  ZoopAPI := CoDZoopAPI.Create;
  ZoopAPI.initialize(marketplace_id, seller_id, zpk);
  showMessage('Teste');
  TerminalList := CoDTerminalListManager.Create;
  TerminalList.startTerminalDiscovery(Integer(@delphiStartTerminalDiscoveryListener));

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  transaction_id: String;
  pointer_1, pointer_2, pointer_3: Integer;
begin
 ZoopTerminalVoidPayment := CoDZoopTerminalVoidPayment.Create;
 transaction_id := RichEdit1.Text;
 pointer_1 :=       Integer(@voidSuccefulListener);
 pointer_2 :=       Integer(@voidFailedListener);
 pointer_3 :=       Integer(@delphiShowMessageChargeListener);

 ZoopTerminalVoidPayment.voidTransaction(
  pointer_1,
  pointer_2,
  pointer_3,
  transaction_id
 );
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  amount_to_charge: Extended;

begin
  amount_to_charge := 1;

  ZoopTerminalPayment := CoDZoopTerminalPayment.Create;

  ZoopTerminalPayment.charge(
    Integer(@delphiShowMessageChargeListener),
    Integer(@cardLast4DigitsRequestedListener),
    Integer(@cardExpirationDateRequestedListener),
    Integer(@cardCVCRequestedListener),
    Integer(@paymentFailedListener),
    Integer(@paymentSuccessfulListener),
    Integer(@paymentAbortedListener),
    Integer(@cardHolderSignatureRequestedListener),
    amount_to_charge, 1, 1
  );
end;

end.
