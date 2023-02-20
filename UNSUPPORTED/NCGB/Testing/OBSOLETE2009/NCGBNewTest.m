(* mauricio, nov 2009 *)
(* runs our main test of NCMakeGB and NCProcess *)

AppendTo[$Path, StringJoin[ $NCDir$, "NCGB/Testing" ] ];

(* Get["TestingEnvironment.m"]; *)
Get["NCGB.m"];
(*
Get["NCGBTestCompare.m"];
Get["NCGBTestCreate.m"];
 *)

$NC$workDir=Directory[];
SetDirectory[$NC$TestCreations$];

QuietDeleteFile["Conclusions"];

(* input data *)
Clear[low,high];
low=0;
high=86;   (* 86 is max *)
If[low>high, idt=high; high=low; low=idt;];
If[low<0, low=0];
If[high>86, high=86];

low=45;
high=86;

Print["low = ", low];
Print["high = ", high];

NCGBTestCreate[low, high]; 

NCGBTestCreate[low, high, NCMakeGBFunction];
 
Print[""];
Print[""];
Print["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
Print[""];
Print[""];

QuietDeleteFile[ "TestResults.file" ]; 

"Results for NCGB:"      >>> TestResults.file;
Print["Results for NCGB:"];
NCGBTestCompare[low,high,"GB"];

"Results for NCProcess:" >>> TestResults.file;
Print["Results for NCProcess:"];
NCGBTestCompare[low,high];

Clear[low,high];
SetDirectory[$NC$workDir];
