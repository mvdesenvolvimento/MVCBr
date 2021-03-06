unit DAL;

interface

uses
  System.JSON,
  MVCFramework.SystemJSONUtils,
  System.Generics.Collections,
  MVCFramework.Serializer.Commons;

type

  [MVCNameCase(ncLowerCase)]
  TPerson = class
  private
    FFirstName: string;
    FLastName: string;
    FAge: Integer;
    FItems: string;
    FGUID: string;
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetAge(const Value: Integer);
    procedure SetGUID(const Value: string);
    procedure SetItems(const Value: string);
  public
    [MVCNameAs('first_name')]
    property FirstName: string read FFirstName write SetFirstName;
    [MVCNameAs('last_name')]
    property LastName: string read FLastName write SetLastName;
    property Age: Integer read FAge write SetAge;
    property Items: string read FItems write SetItems;
    property GUID: string read FGUID write SetGUID;
  end;

  TPeople = class(TObjectList<TPerson>)
  end;

  IPeopleDAL = interface
    ['{3E534A3E-EAEB-44ED-B74E-EFBBAAAE11B4}']
    function GetPeople: TPeople;
    procedure AddPerson(FirstName, LastName: string; Age: Integer; Items: TArray<string>);
    procedure DeleteByGUID(GUID: string);
  end;

  TPeopleDAL = class(TInterfacedObject, IPeopleDAL)
  private const
    DATAFILE: string = 'people.data';
  public
    function GetPeople: TPeople;
    procedure AddPerson(FirstName, LastName: string; Age: Integer; Items: TArray<string>);
    procedure DeleteByGUID(GUID: string);
  end;

  TServicesFactory = class sealed
    class function GetPeopleDAL: IPeopleDAL;
  end;

implementation

uses
  System.SyncObjs,
  System.IOUtils,
  MVCFramework.Serializer.Defaults,
  System.SysUtils;

var
  // Hey! The storage is a simple json file, so some synchronization is needed
  _CS: TCriticalSection = nil;

  { TSimpleDAL }

procedure TPeopleDAL.AddPerson(FirstName, LastName: string; Age: Integer; Items: TArray<string>);
var
  lPeople: TPeople;
  lPerson: TPerson;
begin
  _CS.Enter;
  try
    lPeople := GetPeople;
    try
      lPerson := TPerson.Create;
      lPeople.Add(lPerson);
      lPerson.FirstName := FirstName;
      lPerson.LastName := LastName;
      lPerson.Age := Age;
      lPerson.Items := string.Join(',', Items);
      lPerson.GUID := TGuid.NewGuid.ToString;
      TFile.WriteAllText(DATAFILE, GetDefaultSerializer.SerializeCollection(lPeople));
    finally
      lPeople.Free;
    end;
  finally
    _CS.Leave;
  end;
end;

class function TServicesFactory.GetPeopleDAL: IPeopleDAL;
begin
  Result := TPeopleDAL.Create;
end;

procedure TPeopleDAL.DeleteByGUID(GUID: string);
var
  LJPeople: TPeople;
  I: Integer;
begin
  _CS.Enter;
  try
    LJPeople := GetPeople;
    try
      for I := 0 to LJPeople.Count - 1 do
      begin
        if LJPeople[I].GUID = GUID then
        begin
          LJPeople.Delete(i);
          break;
        end;
      end;
      TFile.WriteAllText(DATAFILE, GetDefaultSerializer.SerializeCollection(LJPeople));
    finally
      LJPeople.Free;
    end;
  finally
    _CS.Leave;
  end;
end;

function TPeopleDAL.GetPeople: TPeople;
var
  LData: string;
begin
  _CS.Enter;
  try
    Result := TPeople.Create;
    if TFile.Exists(DATAFILE) then
      LData := TFile.ReadAllText(DATAFILE).Trim;
    if not LData.IsEmpty then
    begin
      GetDefaultSerializer.DeserializeCollection(LData, Result, TPerson);
    end;
  finally
    _CS.Leave;
  end;
end;

{ TPerson }

procedure TPerson.SetAge(const Value: Integer);
begin
  FAge := Value;
end;

procedure TPerson.SetFirstName(const Value: string);
begin
  FFirstName := Value;
end;

procedure TPerson.SetGUID(const Value: string);
begin
  FGUID := Value;
end;

procedure TPerson.SetItems(const Value: string);
begin
  FItems := Value;
end;

procedure TPerson.SetLastName(const Value: string);
begin
  FLastName := Value;
end;

initialization

_CS := TCriticalSection.Create;

finalization

_CS.Free;

end.
