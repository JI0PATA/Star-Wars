unit Tstatic_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Tbase_;

type TStatic = class(TBase)
  protected
  	bitmap: TBitmap;
  public
  	constructor Create(x0, y0: Integer; bitmap0: TBitmap);
    procedure setBitmap(bitmap0: TBitmap);
    function getBitmap : TBitmap;
end;

implementation

{ TStatic }

constructor TStatic.Create(x0, y0: Integer; bitmap0: TBitmap);
begin
	x := x0;
    y := y0;
    bitmap := bitmap0;
end;

function TStatic.getBitmap: TBitmap;
begin
	result := bitmap;
end;

procedure TStatic.setBitmap(bitmap0: TBitmap);
begin
	bitmap := bitmap0;
end;

end.
