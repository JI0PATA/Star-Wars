unit Tenbullet_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Vcl.ExtCtrls, Tstatic_;

type TEnBullet = class(TStatic)
	private
        angle : real;
        a, b: Integer;
    public
    	constructor Create(x0: Integer; y0: Integer; b0: Integer; bitmap0: TBitmap);
    	procedure MoveEnBullet;
end;

implementation

{ TEnBullet }

constructor TEnBullet.Create(x0: Integer; y0: Integer; b0: Integer; bitmap0: TBitmap);
begin
	x := x0;
    y := y0;
    bitmap := bitmap0;
    a := 500 - y;
    b := b0;
    angle := (b / a) * 4;
end;

procedure TEnBullet.MoveEnBullet;
begin
	inc(y, 4);
    x := x + Round(angle);
end;

end.
