unit Tbase_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics;

type
	TBase = class
    	protected
        	x: Integer;
            y: Integer;
        public
        	procedure setX(x0: Integer);
            procedure setY(y0: Integer);
            function getX : Integer;
            function getY : Integer;
            constructor Create(x0, y0: Integer);
    end;

implementation

{ TBase }

constructor TBase.Create(x0, y0: Integer);
begin
	x := x0;
    y := y0;
end;

function TBase.getX: Integer;
begin
	Result := x;
end;

function TBase.getY: Integer;
begin
	Result := y;
end;


procedure TBase.setX(x0: Integer);
begin
	x := x0;
end;

procedure TBase.setY(y0: Integer);
begin
	y := y0;
end;

end.
