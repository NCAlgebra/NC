
NCGBMmaDiagnostics::usage = 
  "NCGBMmaDiagnostics[True] allows for extra output to the screen.
NCGBMmDiagnostics[False] prevents extra output to the screen.";

NCGBMmaDiagnosticsQ::usage = 
  "NCGBMmaDiagnosticsQ[] returns True or False. If returns
the last argument to the command NCGBMmaDiagnostics.";

NCGBMmaDiagnosticsQ[] := $NC$NCGBMmaDiagnostics;

NCGBMmaDiagnostics[True] := (
  $NC$NCGBMmaDiagnostics = True;
  $NC$NCGBMmaDiagnosticPrint  = Print;
);

NCGBMmaDiagnostics[False] := (
  $NC$NCGBMmaDiagnostics = False;
  $NC$NCGBMmaDiagnosticPrint  = $NC$NCGBMmaDiagnosticNoPrint;
);

NCGBMmaDiagnostics[False]; (* Set the default to False *)

NCGBMmaDiagnostics[x___] := BadCall["NCGBMmaDiagnostics",x];
   
$NC$NCGBMmaDiagnosticNoPrint[x___] = Null;
