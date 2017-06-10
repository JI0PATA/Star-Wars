unit Tplayer_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Tanimate_;

type TPlayer = class(TAnimate)
	private
    	health: Integer;
    public
    	constructor Create(x0, y0 : Integer; bitmap0: arrAnim; maxFrame0: Integer);
    	procedure MoveL;
        procedure MoveR;
        procedure setHealth(health0: Integer);
        function getHealth : Integer;
end;

const MoveDist = 5;

implementation

{ TPlayer }

constructor TPlayer.Create(x0, y0: Integer; bitmap0: arrAnim;
  maxFrame0: Integer);
begin
	inherited;
    health := 100;
end;

function TPlayer.getHealth: Integer;
begin
	Result := health;
end;

procedure TPlayer.MoveL;
begin
	if x > -27 then dec(x, MoveDist);

end;

procedure TPlayer.MoveR;
begin
	if x <= 600 - 31 then inc(x, MoveDist);
    
end;

procedure TPlayer.setHealth(health0: Integer);
begin
	health := health0;
end;

end.
