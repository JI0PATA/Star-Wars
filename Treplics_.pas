unit Treplics_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Vcl.ExtCtrls, Tbase_;

type
arrReplic = array[0..100, 0..100] of String;
TReplic = class(TBase)
	private
    	character: Integer;
        replics: arrReplic;
        idReplic: Integer;
        Sender: TImage;
        ReadReplic: Boolean;
    public
    	constructor Create(x0: Integer; y0: Integer; character0: Integer; var replics0: arrReplic; idReplic0: String; Sender0: TImage);
        procedure setCharacter(character0: Integer);
        procedure setReplics(replics0: arrReplic);
        procedure setIdReplic(idReplic0: Integer);
        procedure setReadReplic(ReadReplic0: Boolean);
        procedure drawR;
        function getCharacter : Integer;
        function getIdReplic : Integer;
        function getReadReplic : Boolean;
end;

implementation

{ TReplic }

constructor TReplic.Create(x0, y0, character0: Integer; var replics0: arrReplic; idReplic0: String; Sender0: TImage);
begin
	x := x0;
    y := y0;
    character := character0;
    replics := replics0;
    idReplic := StrToInt(idReplic0);
    Sender := Sender0;
    ReadReplic := False;
end;

procedure TReplic.drawR;
var paddingL: Integer;
  	j: Integer;
begin
	paddingL := 0;
   	for j := 1 to 100 do
    begin
    	if (Replics[character][j] <> '') then
        begin
        	inc(paddingL, 20);
        	Sender.Canvas.TextOut(x, y + paddingL, Replics[character][j]);
        end;
    end;

end;

function TReplic.getCharacter: Integer;
begin
	Result := character;
end;

function TReplic.getIdReplic: Integer;
begin
	Result := idReplic;
end;

function TReplic.getReadReplic: Boolean;
begin
	Result := ReadReplic;
end;

procedure TReplic.setCharacter(character0: Integer);
begin
	character := character0;
end;

procedure TReplic.setIdReplic(idReplic0: Integer);
begin
	idReplic := idReplic0;
end;

procedure TReplic.setReadReplic(ReadReplic0: Boolean);
begin
	ReadReplic := ReadReplic0;
end;

procedure TReplic.setReplics(replics0: arrReplic);
begin
	replics := replics0;
end;

end.
