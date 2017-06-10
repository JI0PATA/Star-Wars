unit Tbuttons_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Tbase_;

type
	arrBut = array[0..1] of TBitmap;
	TButton = class(TBase)
    	private
            bitmap: arrBut;
            curFrame: Integer;
        public
        	constructor Create(x0, y0: Integer; bitmap0: arrBut);
            procedure setBitmap(bitmap0: arrBut);
            procedure nextFrame;
            procedure prevFrame;
            function getBitmap : TBitmap;
            function getCurFrame : Integer;
    end;

implementation

{ TButton }

constructor TButton.Create(x0, y0: Integer; bitmap0: arrBUt);
begin
    x := x0;
    y := y0;
    curFrame := 0;
    bitmap := bitmap0;
end;

function TButton.getBitmap: TBitmap;
begin
	Result := bitmap[curFrame];
end;

function TButton.getCurFrame: Integer;
begin
	Result := curFrame;
end;

procedure TButton.nextFrame;
begin
	curFrame := 1;
end;

procedure TButton.prevFrame;
begin
	curFrame := 0;
end;

procedure TButton.setBitmap(bitmap0: arrBut);
begin
	bitmap := bitmap0;
end;

end.
