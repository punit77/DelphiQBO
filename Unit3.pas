unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP, IdSSLOpenSSL, IdURI, System.JSON,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdIOHandler, REST.Authenticator.OAuth ,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL,IdMultipartFormData, IdServerIOHandler,System.Net.HttpClient, System.Net.HttpClientComponent,
  Vcl.ComCtrls; //System.Net.HttpClient.Interceptors;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Client: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Button2: TButton;
    HTTP: TIdHTTP;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
    HeaderControl1: THeaderControl;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  gAccessToken: string;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);

function ExtractAccessToken(const JSON: string): string;
var
  Token: TJSONObject;
begin
  Token := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  try
    Result := Token.Values['access_token'].Value;
  finally
    Token.Free;
  end;
end;

var
 // Client: TIdHTTP;
  Response: TStringStream;
  Params: TStringList;
  AccessToken: string;
begin
 // Client := TIdHTTP.Create(nil);
  Response := TStringStream.Create('');
 // Client.Request.BasicAuthentication := True;
  Params := TStringList.Create;
  try
    Params.Add('grant_type=client_credentials');
    Params.Add('scope=com.intuit.quickbooks.accounting');     //added to get proper response on 21-12
    Params.Add('client_id=' + 'ABMQPUrdjOKdDJtOg6gYSxOrkVr8HCHXJSVXwN6uQrVvfXPPOC');
    Params.Add('client_secret=' + 'gFUQMQKFOt6UIL3YdSRU6omQxtfdWHNMol6IG5ZX');

    Client.Post('https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer', Params, Response);
    gAccessToken := ExtractAccessToken(Response.DataString);
    ShowMessage(gAccessToken);
  finally
    Client.Free;
    Response.Free;
    Params.Free;
  end;

end;
procedure TForm3.Button2Click(Sender: TObject);
//resourcestring
//ACCESS_TOKEN = 'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..N757T818XUDiMJxSHaUOHg.i99dPMBuxs_ShLo6F5QFLlXyc9Box0oL7Del1GR8MILoArOiZzTjvYW5-ow4frYFE-BCQXTRaiiBwtzNiG9Qn3mDiGQ0ips4PjTFSazuygVNm9RjWd_5-eamIbts5qYvq7XAmZf_u2QE4g23l3w1hQ8AJHyh2c4QptxsfZO95_EMnZbnCa9o1Tc5tyu9U4ei9xz_qN4qIotx911kUMgo98XoK7p7Lz-YCxUYlCNeWguE-pAI0uqOuE5Oh09FyP_PnrpOU1z8mxbkOjPi6c-cDKl2MOioSbBGSF2B6wkmrSl1hhEo70L0F0YK8ka9ZuFLYkILXwiAW-hWvrODn7RNjpxkstdWlxBLbSo6YB7HvQkAJocdXOZwjSUzcSIQMcd6N1s9BWZdj8MnfAXvw9HX8_LlxmNIuqCo-iq12jZucblvQBCHAIUtvP39OZRRoXjVYxzqiqn1koLlUGXYDDAaXZKaV2tXccQwpFJX4eyHCoP0YGxfcsJevtWGkCbgHIQHV8YDjCEy9lcEAtnjO1aZEQJo0I3PLJS8Q4cW4qTlsThQqFUXEsu3dSrDji5adRlwU7Sf4mDzfyXlI9gNIe9FdUJPU-xTrAmp5az5OZqsX-tl6uyzWAJ0NPoisyxNQMj1R6Z0J5a1dLyczh3Q4N-F9hS8v5uaQwf8YWZh--CcabIyStKkbkbbIIVVUhEtNZKcP1xlLV5BSipvNunx43wONXRs2q987wj3YVGxTrjoG9SF90tJL3oCBqbKSiYgYVULz624wIky9XOd8xukCte6QGY5J2bAizwxns9sumeAjufn9ciIEWxN7LozQBoSDXou_OMuxEuL7KRlJFesDI0lWWg-ouW7Yg7et5PsQuHkfj44WTxor14UKs6rEmGbljw4.Me2FBEAM4aE0jJwxV7QmVA';
 var
  CompanyInfo: TJSONObject;
  Name: string;
  Email: string;
  Phone: string;
  Address: string;
  City: string;
  State: string;
  PostalCode: string;
  Country: string;

  Response: string;
  begin
//  accessToken := ACCESS_TOKEN;
  //  HTTP := TIdHTTP.Create(nil);
  try
  //  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    HTTP.IOHandler := SSL;
     HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + gAccessToken);
    //HTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + gAccessToken;
    //HTTP.Request.ContentType := 'application/json';
    //  Response := HTTP.Get('https://sandbox-quickbooks.api.intuit.com//v3/company/4620816365234295000/customer/2?minorversion=65');

  Response := HTTP.Get('https://sandbox-quickbooks.api.intuit.com/v3/company/4620816365234295000/companyinfo/4620816365234295000?minorversion=65');

    // parse the response to get the company information
    CompanyInfo := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    Name := CompanyInfo.GetValue<string>('CompanyName');
    Email := CompanyInfo.GetValue<string>('CompanyEmail');
    Phone := CompanyInfo.GetValue<string>('PrimaryPhone.FreeFormNumber');
    Address := CompanyInfo.GetValue<string>('CompanyAddr.Line1');
    City := CompanyInfo.GetValue<string>('CompanyAddr.City');
    State := CompanyInfo.GetValue<string>('CompanyAddr.CountrySubDivisionCode');
    PostalCode := CompanyInfo.GetValue<string>('CompanyAddr.PostalCode');
    Country := CompanyInfo.GetValue<string>('CompanyAddr.Country');
  finally
    HTTP.Free;
  end;
end;
end.

{
function CreateCustomer(AccessToken: string ; RealmID: string; Customer: TJSONObject): string;
var
  //HTTPClient: TIdHTTP;
  // SSLHandler: TIdSSLIOHandlerSocketOpenSSL;

  Params: TStringStream;
begin
 // HTTP := TIdHTTP.Create(nil);
  try
  //  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    HTTP.IOHandler := SSL;

    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + gAccessToken);
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.Accept := 'application/json';
    Params := TStringStream.Create(Customer.ToString, TEncoding.UTF8);
    try
      Result := HTTP.Post(
        'https://sandbox-quickbooks.api.intuit.com/v3/company/' + RealmID + '/customer',
        Params
      );
    finally
      Params.Free;
    end;
  finally
    HTTP.Free;
  end;
end;

 var
  RealmID: string;
  Customer: TJSONObject;
  Response: string;
begin

  RealmID := '4620816365234295000';

  Customer := TJSONObject.Create;
  try
    Customer.AddPair('BillAddr', TJSONObject.Create).AddPair('Line1', '123 Main Street');
    Customer.AddPair('BillAddr', TJSONObject.Create).AddPair('City', 'Mountain View');
    Customer.AddPair('BillAddr', TJSONObject.Create).AddPair('Country', 'United States');
    Customer.AddPair('BillAddr', TJSONObject.Create).AddPair('CountrySubDivisionCode', 'CA');
    Customer.AddPair('BillAddr', TJSONObject.Create).AddPair('PostalCode', '94042');
    Customer.AddPair('Notes', 'This is a test customer.');
    Customer.AddPair('Title', 'Mr.');
    Customer.AddPair('GivenName', 'John');
    Customer.AddPair('MiddleName', 'D');
    Customer.AddPair('FamilyName', 'Doe');
    Customer.AddPair('Suffix', 'Jr.');
    Customer.AddPair('FullyQualifiedName', 'John Doe Jr.');
    Customer.AddPair('CompanyName', 'Acme Co.');

    Response := CreateCustomer(gAccessToken, RealmID, Customer);
    WriteLn(Response);
  finally
    Customer.Free;
  end;

 end;
}
