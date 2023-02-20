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
(* COMMENTED OUT --- THIS IS FOR DEVELOPERS ONLY *)
(*$NC$Binary$Dir$ = "/home/mstankus/CurrentDistribution/Binary/SUNOS4.1.3/"; *)
(*$NC$Binary$Name$ = "p9c_r_new";*)
Get["NCGB.m"];
Get["TestingEnvironment.m"];
$NC$CurrentTest$ = $NC$TestResults$;
Get["NCGBTestCompare.m"];


(* OLD!!!!!!!!!
$NC$Binary$Dir$ = "/home/mstankus/CurrentDistribution/Binary/SOLARIS5.5/";
$NC$Binary$Name$ = "p9c_new";
*)
