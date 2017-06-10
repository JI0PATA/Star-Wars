unit TBackground_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Tstatic_;

type TBackground = class(TStatic)
	private
    	delay: Integer;
	public
    	constructor Create(x0, y0: Integer; bitmap0: TBitmap);
    	procedure move;
end;

implementation

{ TBackground }

constructor TBackground.Create(x0, y0: Integer; bitmap0: TBitmap);
begin
	x := x0;
    y := y0;
    bitmap := bitmap0;
    delay := 0;
end;

procedure TBackground.move;
begin
	inc(delay);
    if (delay > 5) then
    begin
    	delay := 0;
        inc(y);
    end;

    if y >= 600 then y := -600;
end;


end.
