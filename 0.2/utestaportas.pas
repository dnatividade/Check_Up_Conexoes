unit utestaportas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IdTCPClient, IdUDPClient, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfrmTestaPortas }

  TfrmTestaPortas = class(TForm)
    btTestaTCP: TBitBtn;
    btTestaUDP: TBitBtn;
    edtHost: TEdit;
    edtTCPPort: TEdit;
    edtUDPPort: TEdit;
    IdTCPClient1: TIdTCPClient;
    IdUDPClient1: TIdUDPClient;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    lbStatusTCP: TLabel;
    lbStatusUDP: TLabel;
    procedure btTestaTCPClick(Sender: TObject);
    procedure btTestaUDPClick(Sender: TObject);
    function TestaPortaTCP(Host: String; Port: Word; Timeout: Integer): Boolean;
    function TestaPortaUDP(Host: String; Port: Word; Timeout: Integer): Boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTestaPortas: TfrmTestaPortas;

implementation

{$R *.lfm}

{ TfrmTestaPortas }

function TfrmTestaPortas.TestaPortaTCP(Host: String; Port: Word; Timeout: Integer): Boolean;
var
 IdTCPClient: TIdTCPClient;
begin
 try
   result:= false;
   IdTCPClient:= TIdTCPClient.Create(Nil);
   IdTCPClient.ReadTimeout:= Timeout;
   IdTCPClient.Host:= Host;
   IdTCPClient.Port:= Port;
   try
     IdTCPClient.Connect;
   except
     IdTCPClient.Disconnect;
     result:= false;
     exit;
   end;
   IdTCPClient.Disconnect;
   result:= true;
 finally
   FreeAndNil(IdTCPClient);
 end;
end;

function TfrmTestaPortas.TestaPortaUDP(Host: String; Port: Word; Timeout: Integer): Boolean;
var
 IdUDPClient: TIdUDPClient;
begin
 try
   result:= false;
   IdUDPClient:= TIdUDPClient.Create(Nil);
   IdUDPClient.Host:= Host;
   IdUDPClient.Port:= Port;
   try
     IdUDPClient.Send(Host, Port, 'CONNECTIVA REDES');
   except
     result:= false;
     exit;
   end;
   result:= true;
 finally
   FreeAndNil(IdUDPClient);
 end;
end;

procedure TfrmTestaPortas.btTestaTCPClick(Sender: TObject);
begin
 Application.ProcessMessages;
 if TestaPortaTCP(edtHost.Text, StrToInt(edtTCPPort.Text), 2000) then
 begin
   lbStatusTCP.Font.Color:= clGreen;
   lbStatusTCP.Caption:= 'ABERTO';
   Application.ProcessMessages;
   ShowMessage('A porta '+edtTCPPort.Text+'/TCP no host '+edtHost.Text+#13+
               'está ABERTA!')
 end
   else
   begin
     lbStatusTCP.Font.Color:= clRed;
     lbStatusTCP.Caption:= 'FECHADO';
     Application.ProcessMessages;
     ShowMessage('A porta '+edtTCPPort.Text+'/TCP no host '+edtHost.Text
                  +#13+'está FECHADA!')
   end;
end;

procedure TfrmTestaPortas.btTestaUDPClick(Sender: TObject);
begin
  Application.ProcessMessages;
  if TestaPortaUDP(edtHost.Text, StrToInt(edtUDPPort.Text), 2000) then
  begin
    lbStatusUDP.Font.Color:= clMaroon;
    lbStatusUDP.Caption:= 'ENVIADO';
    Application.ProcessMessages;
    ShowMessage('Um pacote foi enviado na porta '+edtUDPPort.Text+'/TCP no host '+edtHost.Text
                 +#13+'Cheque nos logs do servidor remoto se o pacote foi recebido.')
  end
    else
    begin
      lbStatusUDP.Font.Color:= clRed;
      lbStatusUDP.Caption:= 'FECHADO';
      Application.ProcessMessages;
      ShowMessage('Falha ao enviar dados na porta '+edtUDPPort.Text+'/TCP no host '+edtHost.Text);
    end;
end;

end.

