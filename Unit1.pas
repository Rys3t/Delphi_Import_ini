unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, DB, DBTables, ExtCtrls;

type
  TfrmMain = class(TForm)
    btnConnect: TButton;
    rgDBSource: TRadioGroup;
    lbMessage: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    DB1: TDatabase;
    procedure btnConnectClick(Sender: TObject);
    procedure rgDBSourceClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    sIniFileName : string;
    iniDB: TIniFile;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnConnectClick(Sender: TObject);
var
  i,j : integer;
  sAppPath : string;
  slSection, slParamater,slInsert: TStringList;
begin
  sAppPath := ExtractFilePath(Application.ExeName);
  iniDB := TInifile.Create(sAppPath + '\' + sIniFileName + '.ini');

  slSection := TStringList.Create;
  slParamater := TStringList.Create;
  iniDB.ReadSections(slSection);
  Memo1.Lines := slSection;

  iniDB.ReadSectionValues('DB1', slParamater);
  Memo2.Lines := slParamater;


  j := 0;
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i].Name <> 'Database1' then
      Continue;

    TDatabase(Components[i]).DatabaseName := 'DB1';

    while (j <= slParamater.Count - 1) do
    begin
      TDatabase(Components[i]).Params.Add(slParamater[j]);
      j := j + 1;
    end;

    try
      TDatabase(Components[i]).Connected := True;
    except
      on e: exception do
      begin
        ShowMessage(e.Message);
        ShowMessage('Connect fail');
        Exit;
      end;
    end;
    ShowMessage('Connect OK!');
    TDatabase(Components[i]).Connected := False;
    Break;
  end;
end;

procedure TfrmMain.rgDBSourceClick(Sender: TObject);
begin
  case TRadioGroup(Sender).ItemIndex of
    0 : sIniFileName := 'DB1';
    1 : sIniFileName := 'DB2';
  else
    sIniFileName := '';
  end;
  lbMessage.Caption := sIniFileName;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  sAppPath : string;
  slSection, slParamater, slReadSectionValues: TStringList;
begin

  sAppPath := ExtractFilePath(Application.ExeName);
  iniDB := TInifile.Create(sAppPath + '\' + sIniFileName + '.ini');

  slSection := TStringList.Create;
  slParamater := TStringList.Create;
  iniDB.ReadSections(slSection);
  Memo1.Lines := slSection;

  //iniDB.ReadSection('DB1', slParamater);
  iniDB.ReadSectionValues('DB1', slParamater);
  Memo2.Lines := slParamater;

  //iniDB.ReadSectionValues('DBname', slReadSectionValues);
  //Memo3.Lines := slReadSectionValues;

  lbMessage.Caption := iniDB.ReadString('DB1', slParamater[0] , '');
  iniDB.Free;
end;

end.
