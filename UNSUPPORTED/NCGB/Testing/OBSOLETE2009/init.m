If[$NC$p9cLoaded$===True
  , Print["Do not load NCGB.m before loading this file."];
    Exit[];
];
Get["../../SetNCDir.m"];
Get["TestingEnvironment.m"];

(*
  Change the following 2 assignments to change which executable (C++) 
  version of NCGB you are using.
*)
Get["NCGB.m"];
Get["TestingEnvironment.m"];
$NC$CurrentTest$ = $NC$TestResults$;
Get["NCGBTestCompare.m"];
