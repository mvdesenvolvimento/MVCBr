unit WS.Datamodule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Comp.UI,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt;

type
  TWSDatamodule = class(TDataModule)
    FDManager1: TFDManager;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDSchemaAdapter1: TFDSchemaAdapter;
    procedure FDManager1AfterLoadConnectionDefFile(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFDQueryAuto = class(TFDQuery)
  public
    constructor create(AOwner: TComponent); override;
  end;

var
  WSDatamodule: TWSDatamodule;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }
//uses FireDAC.Adpt;

{$R *.dfm}

procedure TWSDatamodule.FDManager1AfterLoadConnectionDefFile(Sender: TObject);
begin

end;

{ TFDQueryAuto }
constructor TFDQueryAuto.create(AOwner: TComponent);
begin
  inherited;
  ConnectionName := 'MVCBr_Firebird';
end;

end.