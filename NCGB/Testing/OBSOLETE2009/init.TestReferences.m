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
$NC$Binary$Dir$ = "/home/mstankus/CurrentDistribution/Binary/SOLARIS5.5/";
$NC$Binary$Name$ = "p9c_non";

Get["NCGB.m"];
$NC$CurrentTest$ = $NC$TestReferences$;
Get["NCGBTestCreate.m"];
