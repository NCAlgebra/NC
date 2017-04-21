(* 
   Allows accessing NCAlgebra and NCGB from anywhere through
     << NC`   
   Done by M. de Oliveira  2004, Updated 2017
*)

Module[
  {$NC$Dir = DirectoryName[FindFile["NC`"]]},
      
  If[ $NC$Dir =!= {}
     ,
      (* Setup Path *)

      Print["You are using the version of NCAlgebra which is found in:"];
      Print["  ", $NC$Dir];

      (* Setting NCAlgebra Path *)
      AppendTo[$Path,$NC$Dir];
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCAlgebra" }]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCAlgebra", "Systems" }]];

      (* Setting NCGB Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "MmaSource"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "Testing"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "Testing", "C++TestFiles"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "Testing", "MmaTestFiles"}]];

      (* Additional Path for NCGB Binaries *)
      If[ StringPosition[ $OperatingSystem, "indows" ] == {},
        AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "Binary"}]];
       ,
        AppendTo[$Path,ToFileName[{$NC$Dir, "NCGB", "Binary", "p9c", "Windows"}]];
      ];

      (* Setting NCExtras Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCExtras" }]];

      (* Setting NCTeX Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCTeX" }]];

      (* Setting NCSDP Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCSDP" }]];

      (* Setting NCPoly Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "NCPoly" }]];

      (* Setting TESTING Path *)
      AppendTo[$Path,ToFileName[{$NC$Dir, "TESTING"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "TESTING", "NCAlgebra"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "TESTING", "NCSDP"}]];
      AppendTo[$Path,ToFileName[{$NC$Dir, "TESTING", "NCPoly"}]];

      Print["You can now use \"<< NCAlgebra`\" to load NCAlgebra."];
     ,
      (* Did not find NC` *)
      Print["ERROR: Could not find NC directory. See documentation for installation information."];
  ];
    
];
