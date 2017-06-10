unit Tbullet_;

interface

uses System.SysUtils, System.Classes, Vcl.Graphics, Tstatic_;

type TBullet = class(TStatic)
    public
    	procedure MoveBullet;
end;



implementation

{ TBullet }

procedure TBullet.MoveBullet;
begin
	dec(y, 5);
end;

end.
