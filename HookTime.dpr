library HookTime;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  ComObj,
  ShlObj,

  Windows,Vcl.StdCtrls,
  Vcl.Dialogs,
  HookIntfs in 'HookIntfs.pas',
  HookUtils in 'HookUtils.pas';

{$R *.res}

var
GetSystemTimeNext:procedure(var LPSYSTEMTIME: TSystemTime); stdcall;
GetLocalTimeNext:procedure(var LPSYSTEMTIME: TSystemTime); stdcall;


procedure  GetLocalTimeCallBack (var lpSystemTime: TSystemTime); stdcall;
begin
    //原始函数备胎指针
    GetLocalTimeNext(lpSystemTime);

    lpSystemTime.wYear:= 2013;
    lpSystemTime.wMonth:= 08;
    lpSystemTime.wDay := 08;


    lpSystemTime.wHour:=12;

end;

procedure  GetSystemTimeCallBack (var lpSystemTime: TSystemTime); stdcall;
begin
    //原始函数备胎指针
    GetLocalTimeNext(lpSystemTime);

    lpSystemTime.wYear:= 2013;
    lpSystemTime.wMonth:= 08;
    lpSystemTime.wDay := 08;


    lpSystemTime.wHour:=09;

end;


function inject_hook(): integer;stdcall;
begin
  //HookProc(kernel32, 'GetSystemTime', @GetSystemTimeCallBack, @GetSystemTimeNext);
  HookProc(kernel32, 'GetLocalTime', @GetLocalTimeCallBack, @GetLocalTimeNext);
  ShowMessage('改写时间。');
  result:=0;
end;

exports
  inject_hook;
begin
end.
