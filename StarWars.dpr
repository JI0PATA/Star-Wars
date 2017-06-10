program StarWars;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  Tbuttons_ in 'Tbuttons_.pas',
  Tbase_ in 'Tbase_.pas',
  Tanimate_ in 'Tanimate_.pas',
  Tstatic_ in 'Tstatic_.pas',
  TBackground_ in 'TBackground_.pas',
  Treplics_ in 'Treplics_.pas',
  Tplayer_ in 'Tplayer_.pas',
  Tbullet_ in 'Tbullet_.pas',
  Tenemy_ in 'Tenemy_.pas',
  Tenbullet_ in 'Tenbullet_.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
