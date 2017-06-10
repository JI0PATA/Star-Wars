unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, MMSystem, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Tanimate_, Tbuttons_, Tbase_, Tstatic_, Tbackground_, Treplics_, Tplayer_, Tbullet_, Tenemy_, Tenbullet_,
  Vcl.MPlayer;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawBackground; // draw space - background
    procedure WinInformation; // window with information about course work
    procedure WinMenu; // window with main menu
    procedure WinNewGame; // window for new game
    procedure WinGameOver; // window after game
    procedure ShowReplicPreview; // move and show first replic
    function ShowReplics(idReplic: Integer) : Boolean; // show all replics
    procedure BeginGame; // procedure for beginning game
    procedure NewBullet; // create bullets
    procedure DrawBullet; // draw bullets
    procedure NewEnemy; // create new enemy
    procedure DrawEnemy; // draw enemys
    procedure DrawGameInfo; // draw game info: score, health
    procedure DecHealth; // decrement health if hit
    procedure IncScore; // increment score if hit
    procedure IntersectionBulletAndEnemys;
    procedure IntersectionEnBulletsAndPlayer;
    procedure DrawEnemyBullets;
    procedure RepeatGame;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  // current window
  CurrentWindow: string = 'WinMenu'; // WinMenu


  // buttons graphics
  newgamePic: arrBut;
  infoPic: arrBut;
  closePic: arrBut;
  backPic: arrBut;
  skipPic: arrBut;
  nextPic: arrBut;
  repeatPic: arrBut;
  // buttons
  NewGame: TButton;
  Info: TButton;
  CloseB: TButton;
  Back: TButton;
  Skip: TButton;
  NextB: TButton;
  RepeatB: TButton;


  // backgrounds graphics
  spacePic: TBitmap;
  // backgrounds
  Space: array[0..1] of TBackground;


  // replics
  countReplics: Integer;
  currentIdReplic: Integer = 1;
  paddingT: Integer = 30;
  ReplicsF: TextFile;
  Replic: String;
  ReplicsOfFile: arrReplic;
  ReplicPreview: TReplic;
  Replics: array[0..15] of TReplic;
  Character: TPngImage;


  // delay
  delayAll: Integer = 0;


  // fields player
  score: Integer = 0;


  // graphics playes
  playerPic: arrAnim;
  // player
  Player: TPlayer;
  MoveL, MoveR: Boolean;


  // graphics bullets
  bulletPic: TBitmap;
  // bullets
  Bullets: array[0..100] of TBullet;
  Shoot: Boolean;
  DelayBullet: Integer = 0;


  // graphics enemys
  enemyPic: TPngImage;
  // enemys
  Enemy: array[0..100] of TEnemy;


  // graphics enemy bullets
  enBulletPic: TBitmap;
  // enemy bullets
  EnemyBullets: array[0..100] of TEnBullet;

implementation

{$R *.dfm}

procedure TForm1.BeginGame;
var
  i: Integer;
begin
	if (not Timer2.Enabled) then Timer2.Enabled := True;

    Player.nextFrame;
    Image1.Canvas.Draw(Player.getX, Player.getY, Player.getBitmap);

    DrawEnemy;
    DrawBullet;
    DrawEnemyBullets;
    DrawGameInfo;

    IntersectionBulletAndEnemys;
    IntersectionEnBulletsAndPlayer;

    if (MoveL) then Player.MoveL
    else if (MoveR) then Player.MoveR;


    if (Shoot) AND (DelayBullet >= 15) then
    begin
    	NewBullet;
        DelayBullet := 0;
    end;
    inc(DelayBullet);

end;

procedure TForm1.DecHealth;
begin
	Player.setHealth(Player.getHealth - 10);
    if (Player.getHealth = 0) then CurrentWindow := 'WinGameOver';
    if (Player.getHealth = 90) then
    begin
      	currentIdReplic := 3;
        showReplics(currentIdReplic);
    end;

end;

procedure TForm1.DrawBackground;
var i: Integer;
begin
	// draw background
	for i := 0 to 1 do
    begin
    	Space[i].move;
        Image1.Canvas.Draw(Space[i].getX, Space[i].getY, Space[i].getBitmap);
    end;
end;

procedure TForm1.DrawBullet;
var
  i: Integer;
begin
	for i := 0 to 100 do
    begin
    	if (Bullets[i] <> nil) then
        begin
        	if (Bullets[i].getY < -32) then
            begin
            	Bullets[i] := nil;
                Exit;
            end;
        	Image1.Canvas.Draw(Bullets[i].getX, Bullets[i].getY, Bullets[i].getBitmap);
        	Bullets[i].MoveBullet;
        end;
    end;

end;

procedure TForm1.DrawEnemy;
var i: Integer;
  j: Integer;
begin
	for i := 0 to 100 do
    begin
    	if (Enemy[i] <> nil) then
        begin
        	if (Enemy[i].getX + 50 > Player.getX) AND (Enemy[i].getX < Player.getX + 50) AND (Enemy[i].getY + 50 >= Player.getY) then
            begin
            	DecHealth;
                IncScore;
                Enemy[i] := nil;
                Exit;
            end;

        	if (Enemy[i].getY > 600) then
            begin
            	Enemy[i] := nil;
                Exit;
            end;
        	Image1.Canvas.Draw(Enemy[i].getX, Enemy[i].getY, Enemy[i].getBitmap);
            Enemy[i].MoveEnemy;
            if (Enemy[i].getY = 50) OR (Enemy[i].getY = 51) then
            begin
            	for j := 0 to 100 do
				begin
                	if (EnemyBullets[j] = nil) then
                    begin
                    	EnemyBullets[j] := TEnBullet.Create(Enemy[i].getX + 10, Enemy[i].getY + 50, Player.getX - Enemy[i].getX, enBulletPic);
                        Break;
                    end;

                end;
            end;
        end;
    end;
end;

procedure TForm1.DrawEnemyBullets;
var
  i: Integer;
begin
	for i := 0 to 100 do
	begin
      	if (EnemyBullets[i] <> nil) then
        begin
        	if (EnemyBullets[i].getY > 590) OR (EnemyBullets[i].getX > 600) OR (EnemyBullets[i].getX < -32) then
            begin
              	EnemyBullets[i] := nil;
                Break;
            end;
          	Image1.Canvas.Draw(EnemyBullets[i].getX, EnemyBullets[i].getY, EnemyBullets[i].getBitmap);
            EnemyBullets[i].MoveEnBullet;
        end;
    end;
end;

procedure TForm1.DrawGameInfo;
begin
	Image1.Canvas.TextOut(10, 10, 'HP: ' + IntToStr(Player.getHealth) + '%');
    Image1.Canvas.TextOut(485, 10, 'Score: ' + IntToStr(score));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, j: Integer;
  Value: DWORD;
begin
	DoubleBuffered := True;

    // load music
    MCISendString(PChar('play "music/imperial.mp3" repeat'),nil,0,0);
    // volume
    Value := $FFFF - 60000;
    WaveOutSetVolume(0, (Value SHL 16) + Value);


    // load graphics buttons
    for i := 0 to 1 do
    begin
      	newgamePic[i] := TBitmap.Create;
        newgamePic[i].LoadFromFile('buttons/newgame' + IntToStr(i) + '.bmp');

        infoPic[i] := TBitmap.Create;
        infoPic[i].LoadFromFile('buttons/info' + IntToStr(i) + '.bmp');

        closePic[i] := TBitmap.Create;
        closePic[i].LoadFromFile('buttons/close' + IntToStr(i) + '.bmp');

        backPic[i] := TBitmap.Create;
        backPic[i].LoadFromFile('buttons/back' + IntToStr(i) + '.bmp');

        skipPic[i] := TBitmap.Create;
        skipPic[i].LoadFromFile('buttons/skip' + IntToStr(i) + '.bmp');

        nextPic[i] := TBitmap.Create;
        nextPic[i].LoadFromFile('buttons/next' + IntToStr(i) + '.bmp');

        repeatPic[i] := TBitmap.Create;
        repeatPic[i].LoadFromFile('buttons/repeat' + IntToStr(i) + '.bmp');
    end;

    // create classes buttons
    NewGame := TButton.Create(170, 150, newgamePic);
    Info := TButton.Create(170, 270, infoPic);
    CloseB := TButton.Create(170, 390, closePic);
    Back := TButton.Create(10, 10, backPic);
    Skip := TButton.Create(10, 10, skipPic);
    NextB := TButton.Create(500, 550, nextPic);
    RepeatB := TButton.Create(170, 270, repeatPic);



    // load graphics backgrounds
    spacePic := TBitmap.Create;
    spacePic.LoadFromFile('backgrounds/space.bmp');
    // create classes backgrounds
    Space[0] := TBackground.Create(0, -300, spacePic);
    Space[1] := TBackground.Create(0,  300, spacePic);


    // set fonts
    Image1.Canvas.Font.Height := 23;
    Image1.Canvas.Font.Color := clYellow;
    Image1.Canvas.Brush.Style := bsClear;


    // load replics
    AssignFile(ReplicsF, 'replics/replics.txt');
    Reset(ReplicsF);
    i := -1;
    ReadLn(ReplicsF, Replic);
    while (not Eof(ReplicsF)) do
    begin
    	if (Replic = '@r') then
        begin
        	inc(i);
        	j := 1;
            ReadLn(ReplicsF, Replic);
            ReplicsOfFile[i][0] := Replic;
        end
        else
        begin
        	ReadLn(ReplicsF, Replic);
            if  Replic = '@r' then Continue;
			ReplicsOfFile[i][j] := Replic;
        	inc(j);
        end;
    end;
    countReplics := i;
    CloseFile(ReplicsF);

    // first replic
    ReplicPreview := TReplic.Create(180, 400, 0, ReplicsOfFile, ReplicsOfFile[0][0], Image1);

    // all replic
    for i := 1 to countReplics do
    begin
    	Replics[i] := TReplic.Create(40, 400, i, ReplicsOfFile, ReplicsOfFile[i][0], Image1);
    end;

    // load image characters
    Character := TPngImage.Create;
    Character.LoadFromFile('characters/jedi.png');


    // load graphics main player
    for i := 0 to 4 do
    begin
    	playerPic[i] := TPngImage.Create;
        playerPic[i].LoadFromFile('players/player' + IntToStr(i) + '.png');	
    end;
    // create player
    Player := TPlayer.Create(250, 500, playerPic, 4);


    // load graphics for bullet
    bulletPic := TBitmap.Create;
    bulletPic.LoadFromFile('explodes/bullet.bmp');
    bulletPic.Transparent := True;


    // load graphics for enemys
    enemyPic := TPngImage.Create;
    enemyPic.LoadFromFile('players/enemy.png');


    // load graphics for enemy bullets
    enBulletPic := TBitmap.Create;
    enBulletPic.LoadFromFile('explodes/enbullet.bmp');
    enBulletPic.Transparent := True;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (Key = VK_LEFT) then MoveL := True
    else if (Key = VK_RIGHT) then MoveR := True;

    if (Key = VK_SPACE) then Shoot := True;

end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if (Key = VK_LEFT) then MoveL := False
    else if (Key = VK_RIGHT) then MoveR := False;

    if (Key = VK_SPACE) then Shoot := False;

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
	// click on buttons
    if (CurrentWindow = 'WinMenu') then
    begin
    	if (X < NewGame.getX + 250) AND (X > NewGame.getX) AND (Y < NewGame.getY + 80) AND (Y > NewGame.getY) then CurrentWindow := 'WinNewGame';

    	if (X < Info.getX + 250) AND (X > Info.getX) AND (Y < Info.getY + 80) AND (Y > Info.getY) then CurrentWIndow := 'WinInformation';

    	if (X < CloseB.getX + 250) AND (X > CloseB.getX) AND (Y < CloseB.getY + 80) AND (Y > CloseB.getY) then Close;

    end;

    if (X < Back.getX + 250) AND (X > Back.getX) AND (Y < Back.getY + 80) AND (Y > Back.getY) then
    begin
    	if (CurrentWindow = 'WinInformation') then CurrentWindow := 'WinMenu';

    end;

    if (CurrentWindow = 'WinNewGame') then
    begin
    	if (X < Skip.getX + 150) AND (X > Skip.getX) AND (Y < Skip.getY + 50) AND (Y > Skip.getY) then ReplicPreview.setY(-690);

        if (X < NextB.getX + 75) AND (X > NextB.getX) AND (Y < NextB.getY + 30) AND (Y > NextB.getY) AND (not Timer1.Enabled)then
        begin
            NextB.prevFrame;
            ShowReplics(currentIdReplic);
        end;

    end;

    if (CurrentWindow = 'WinGameOver') then
    begin
    	if (X < RepeatB.getX + 250) AND (X > RepeatB.getX) AND (Y < RepeatB.getY + 80) AND (Y > RepeatB.getY) then RepeatGame;
    end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	// hover on buttons
	if (X < NewGame.getX + 250) AND (X > NewGame.getX) AND (Y < NewGame.getY + 80) AND (Y > NewGame.getY) then NewGame.nextFrame
    else NewGame.prevFrame;

    if (X < Info.getX + 250) AND (X > Info.getX) AND (Y < Info.getY + 80) AND (Y > Info.getY) then Info.nextFrame
    else Info.prevFrame;

    if (X < CloseB.getX + 250) AND (X > CloseB.getX) AND (Y < CloseB.getY + 80) AND (Y > CloseB.getY) then CloseB.nextFrame
    else CloseB.prevFrame;

    if (X < Back.getX + 150) AND (X > Back.getX) AND (Y < Back.getY + 50) AND (Y > Back.getY) then Back.nextFrame
    else Back.prevFrame;

    if (X < Skip.getX + 150) AND (X > Skip.getX) AND (Y < Skip.getY + 50) AND (Y > Skip.getY) then Skip.nextFrame
    else Skip.prevFrame;

    if (X < NextB.getX + 75) AND (X > NextB.getX) AND (Y < NextB.getY + 30) AND (Y > NextB.getY) then NextB.nextFrame
    else NextB.prevFrame;

    if (X < RepeatB.getX + 250) AND (X > RepeatB.getX) AND (Y < RepeatB.getY + 80) AND (Y > RepeatB.getY) then RepeatB.nextFrame
    else RepeatB.prevFrame;

    if (CurrentWindow = 'WinNewGame') AND (Timer1.Enabled = False) then
    begin
    	if (X < NextB.getX + 75) AND (X > NextB.getX) AND (Y < NextB.getY + 30) AND (Y > NextB.getY) then
        Image1.Canvas.Draw(NextB.getX, NextB.getY, NextB.getBitmap)
    	else Image1.Canvas.Draw(NextB.getX, NextB.getY, NextB.getBitmap);
    end;



end;

procedure TForm1.IncScore;
begin
	inc(score, 10);
    if (score = 10) then
    begin
    	currentIdReplic := 2;
        ShowReplics(currentidReplic);
    end;
    if (score mod 200 = 0) AND (Timer2.Interval >= 400) then Timer2.Interval := Timer2.Interval - 100;

end;

procedure TForm1.IntersectionBulletAndEnemys;
var
  i: Integer;
  j: Integer;
  BulletX, BulletY, EnemyX, EnemyY: Integer;
begin
	for i := 0 to 100 do
	begin
      	if (Bullets[i] <> nil) then
        begin
        	BulletX := Bullets[i].getX;
            BulletY := Bullets[i].getY;
        	for j := 0 to 100 do
            begin
              	if (Enemy[j] <> nil) then
                begin
                	EnemyX := Enemy[j].getX;
                    EnemyY := Enemy[j].getY;
                	if (BulletX + 32 > EnemyX) AND (BulletX < EnemyX + 50) AND (BulletY - 35 <= EnemyY) then
                    begin
                    	Bullets[i] := nil;
                        Enemy[j] := nil;
                        IncScore;
                    end;

                end;
            end;
        end;
    end;
end;

procedure TForm1.IntersectionEnBulletsAndPlayer;
var
  i: Integer;
begin
	for i := 0 to 100 do
	begin
      	if (EnemyBullets[i] <> nil) then
        begin
        	if (EnemyBullets[i].getX + 20 > Player.getX + 10) AND (EnemyBullets[i].getX < Player.getX + 40) AND (EnemyBullets[i].getY + 32 > Player.getY) then
            begin
            	EnemyBullets[i] := nil;
                DecHealth;
                Break;
            end;
        end;
    end;
end;

procedure TForm1.NewBullet;
var
  i: Integer;
begin
	for i := 0 to 100 do
    begin
    	if (Bullets[i] = nil) then
        begin
        	Bullets[i] := TBullet.Create(Player.getX + 15, Player.getY - 32, bulletPic);
            Exit;
        end;
    end;

end;

procedure TForm1.NewEnemy;
var
  i: Integer;
begin
	Randomize;
	for i := 0 to 100 do
	begin
    	if (Enemy[i] = nil) then
        begin
        	Enemy[i] := TEnemy.Create(Random(600) - 50, Random(100) - 130, enemyPic);
            Break;
        end;
    end;
end;

procedure TForm1.RepeatGame;
var
  i: Integer;
begin
	score := 0;
    Player.setHealth(100);
    for i := 0 to 100 do
	begin
      	Enemy[i] := nil;
        EnemyBullets[i] := nil;
        Bullets[i] := nil;
        currentWindow := 'WinNewGame';
    end;
end;

procedure TForm1.ShowReplicPreview;
begin
	Image1.Canvas.Font.Height := 23;
	Image1.Canvas.Draw(Skip.getX, Skip.getY, Skip.getBitmap);
	ReplicPreview.drawR;
    if (delayAll > 1) then
    begin
        ReplicPreview.setY(ReplicPreview.getY - 1);
        delayAll := 0;
    end;
    inc(delayAll);
end;

function TForm1.ShowReplics(idReplic: Integer) : Boolean;
var
  i: Integer;
begin
    DrawBackground;

    Image1.Canvas.Font.Height := 23;

    for i := 1 to countReplics do
    begin
      	if (Replics[i].getIdReplic = idReplic) AND (not Replics[i].getReadReplic) then
        begin
        	Timer1.Enabled := False;
            Timer2.Enabled := False;
        	Replics[i].drawR;
            Replics[i].setReadReplic(True);
            Image1.Canvas.Draw(30, 200, Character);
            Image1.Canvas.Draw(NextB.getX, NextB.getY, NextB.getBitmap);
            ShowReplics := False;
            Exit;
        end;
        if (i = countReplics) then
        begin
        	Timer1.Enabled := True;
            Timer2.Enabled := True;
            ShowReplics := True;
        end;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
begin
    // draw background
    DrawBackground;

    // select current window
    if (CurrentWindow = 'WinInformation') then WinInformation
    else if (CurrentWIndow = 'WinMenu') then WinMenu
    else if (CurrentWindow = 'WinNewGame') then WinNewGame
    else if (CurrentWindow = 'WinGameOver') then WinGameOver;


end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
	NewEnemy;
end;

procedure TForm1.WinGameOver;
begin
	Image1.Canvas.Font.Height := 40;
    Image1.Canvas.TextOut(220, 150, 'SCORE: ' + IntToStr(score));
	Image1.Canvas.TextOut(200, 200, 'GAME OVER!');

    Image1.Canvas.Draw(RepeatB.getX, RepeatB.getY, RepeatB.getBitmap);
end;

procedure TForm1.WinInformation;
begin
    Image1.Canvas.TextOut(30, 150, 'Курсовую работу сделал');
    Image1.Canvas.TextOut(30, 180, 'Жуков Иван');
    Image1.Canvas.TextOut(30, 210, 'Студент 230 группы ИБАС');
    Image1.Canvas.TextOut(30, 240, '"Star Wars IX: Space Battle"');
    Image1.Canvas.TextOut(30, 300, 'Все права защищены');

    Image1.Canvas.Draw(Back.getX, Back.getY, Back.getBitmap);
end;

procedure TForm1.WinMenu;
begin

    Image1.Canvas.TextOut(175, 70, '"Star Wars IX: Space Battle"');

	// draw buttons
    Image1.Canvas.Draw(NewGame.getX, NewGame.getY, NewGame.getBitmap);
    Image1.Canvas.Draw(Info.getX, Info.getY, Info.getBitmap);
    Image1.Canvas.Draw(CloseB.getX, CloseB.getY, CloseB.getBitmap);
end;

procedure TForm1.WinNewGame;
var
  i: Integer;
begin
	if (ReplicPreview.getY > -680) then ShowReplicPreview
    else if (ShowReplics(currentIdReplic)) then BeginGame;

end;

end.
