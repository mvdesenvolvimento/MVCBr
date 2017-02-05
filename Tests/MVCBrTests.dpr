program MVCBrTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  DUnitTestRunner,
  TestMVCBr.Controller in 'TestMVCBr.Controller.pas',
  TestMVCBrModel in 'TestMVCBrModel.pas',
  MVCBr.Model in '..\MVCBr.Model.pas',
  MVCBr.InterfaceHelper in '..\MVCBr.InterfaceHelper.pas',
  MVCBr.Interf in '..\MVCBr.Interf.pas',
  TestMVCBr.View in 'TestMVCBr.View.pas',
  MVCBr.View in '..\MVCBr.View.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

