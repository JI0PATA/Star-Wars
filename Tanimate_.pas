unit Tanimate_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Imaging.pngimage, Tbase_;

type
	arrAnim = array[0..100] of TPngImage;
	TAnimate = class(TBase)
    	protected
        	bitmap: arrAnim;
        	curFrame : Integer;
            maxFrame : Integer;
        public
        	constructor Create(x0, y0 : Integer; bitmap0: arrAnim; maxFrame0: Integer);
            procedure nextFrame;
            procedure setBitmap(bitmap0: arrAnim);
            function getBitmap : TPngImage;
    end;

implementation

{ TAnimate }

constructor TAnimate.Create(x0, y0: Integer; bitmap0: arrAnim; maxFrame0: Integer);
begin
	x := x0;
    y := y0;
    bitmap := bitmap0;
    curFrame := 0;
    maxFrame := maxFrame0;
end;

function TAnimate.getBitmap: TPngImage;
begin
	Result := bitmap[curFrame];
end;

procedure TAnimate.nextFrame;
begin
	if curFrame < maxFrame then
        inc(curFrame)
	else curFrame := 0;
end;

procedure TAnimate.setBitmap(bitmap0: arrAnim);
begin
	bitmap := bitmap0;
end;

end.
