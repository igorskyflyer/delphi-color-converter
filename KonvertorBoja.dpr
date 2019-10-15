program KonvertorBoja;

uses
  Vcl.Forms,
  Main in 'Main.pas' {CC};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:=True;
  ReportMemoryLeaksOnShutdown:=True;
  Application.CreateForm(TCC, CC);
  Application.Run;
end.
