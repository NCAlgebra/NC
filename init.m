(* Allows accessing NCAlgebra and NCGB from anywhere. Use <<NC`   
      Done by M. de Oliveira  2004, Updated 2009 *)

$NC$INITDOTM = ToFileName["NC","init.m"];
$NC$INITDOTMPATH = FileNames[$NC$INITDOTM, $Path];

If[$NC$INITDOTMPATH==={}, 
  $NC$INITDOTMPATH = FileNames[ToFileName["*", $NC$INITDOTM],$Path]
];

(* Print["$NC$INITDOTMPATH = ", $NC$INITDOTMPATH]; *)

If[ $NC$INITDOTMPATH =!= {}
  , (* Print["Setting NC directory..."]; *)

    $NCDir$ = DirectoryName[$NC$INITDOTMPATH[[1]]];

    (* Print["$NCDir$ = ", $NCDir$]; *)

    (* Replace . in the first position if needed 
       THIS FIXES THE PATH ERROR ON THE COMPUTER LAB WINDOWS MACHINES *)
    If [ StringMatchQ[$NCDir$, "." ~~ ___ ],
         $NCDir$ = StringReplace[$NCDir$, "." -> Directory[], 1];
    ];

    (* Print["$NCDir$ = ", $NCDir$]; *)

    Print["You are using the version of NCAlgebra which is found in:"];
    Print["  ", StringDrop[$NCDir$,-1]];

    (* Setting NCAlgebra Path *)
    AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra" }]];
    AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra", "Testing" }]];
    AppendTo[$Path,ToFileName[{$NCDir$, "NCAlgebra", "Systems" }]];

    (* Setting NCGB Path *)
    AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "MmaSource"}]];
    AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing"}]];
    AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing", "C++TestFiles"}]];
    AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Testing", "MmaTestFiles"}]];

    (* Additional Path for NCGB Binaries *)
    If[ StringPosition[ $OperatingSystem, "indows" ] == {},
      AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Binary"}]];
     ,
      AppendTo[$Path,ToFileName[{$NCDir$, "NCGB", "Binary", "p9c", "Windows"}]];
    ];

    (* Setting NCTeX Path *)
    AppendTo[$Path,ToFileName[{$NCDir$, "NCTeX" }]];

    (* Setting NCSDP Path *)
    AppendTo[$Path,ToFileName[{$NCDir$, "NCSDP" }]];

    (* Setting NCPoly Path *)
    AppendTo[$Path,ToFileName[{$NCDir$, "NCPoly" }]];

    Print["You can now use \"<< NCAlgebra`\" to load NCAlgebra or ",
          "\"<< NCGB`\" to load NCGB."];

  , 
    Print["ERROR: Could not find NC directory. See documentation for installation information."];
];
