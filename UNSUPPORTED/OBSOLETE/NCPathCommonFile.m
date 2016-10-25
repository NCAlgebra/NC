(*
  This file is loaded by SetNCPath.m and by SetNCDir.m.
  We recommend loading SetNCPath.m.
  SetNCDir.m is used only at the development site.
*)
If[Not[Head[$NCDir$]===String]
  , Print["The file NCPathCommonFile.m was loaded before the $NCDir$ variable was set."];
    If[Not[Head[$NC$Loaded$NCLoader$]===String]
      , Print["This file should only be read in via the file SetNCPath.m"];
        Print["You installation of NCAlgebra and/or NCGB was not performed"];
        Print["correctly or there is a problem with the distribution of"];
        Print["this code via the file ",$NC$Loaded$NCLoader$];
      , Print["This file was loaded after"];
        Print["$NC$Loaded$NCLoader$ was set to ",$NC$Loaded$NCLoader$];
        Print["This is very odd. Send e-mail to ncalg@osiris.ucsd.edu"];
        Print["with the aboves messages included."];
    ];
];

$NCGB$DefaultTestPrefix$ =ToFileName[{$NCDir$, "NCGB", "Testing"}];

AppendTo[$Path, $NCDir$];
AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Binary"}]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "MmaSource"}]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing"}]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra" }]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra", "Testing" }]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra", "Systems" }]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCTeX" }]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing", "C++TestFiles"}]];
AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing", "MmaTestFiles"}]];

(* CLEANED UP BY MAURICIO JUNE 2009 *)
(*
WhatNCDirectoriesDoIHave[] := 
Module[{len,temp},
  len = StringLength[$NCDir$];
  temp = FileNames["*",StringTake[$NCDir$,{1,len-1}],1];
  Print[ColumnForm[temp]];
  Return[temp];
];
 *)

(*  Some weird thing that makes NCGB work *)
(* $NCGB$Summer1999$Setup = True; *)

(* CLEANED UP BY MAURICIO JUNE 2009 *)
(* Change needed for Mma 4.0 ---- New Mma doesn't 
like 
If [ variable, , DoTHis ];
We just turn it off. 
THIS IS OUTRAGEOUS! BETTER FIX IT! DONE BY MAURICIO JUNE 2009
*)
(* Off[ Syntax::com ]; *)
