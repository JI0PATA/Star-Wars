unit Tenemy_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Imaging.pngimage, Tstatic_;

type TEnemy = class(TStatic)
	private
    	bitmap: TPngImage;
	public
    	constructor Create(x0, y0: Integer; bitmap0: TPngImage);
    	procedure MoveEnemy;
        function getBitmap : TPngImage;
end;

implementation

{ TEnemy }

constructor TEnemy.Create(x0, y0: Integer; bitmap0: TPngImage);
begin
	x := x0;
    y := y0;
    bitmap := bitmap0;
end;

function TEnemy.getBitmap: TPngImage;
begin
	Result := bitmap;
end;

procedure TEnemy.MoveEnemy;
begin
	inc(y, 2);
end;

end.
