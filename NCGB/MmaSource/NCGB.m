(* NCGB.m *)

(* History : 

     : long and sordid : 
     : 9/16/99 : Added Get[ "NCGBMaster" ]; to support autoatic loading
              of files.   Refered to as "stubs"    (dell)

*)


(*
   See multi-line comments below for the use of $NC$Binary$Dir$ 
   and $NC$Binary$Name$. If you are using the configuration from
   the standard distribution, then you must not set these 
   variables equal to character strings!!!!
*) 

(* $NCGB$Summer1999$Setup = TrueQ[$NCGB$Summer1999$Setup]; *)

(* MAURICIO - BEGIN *)
(*
If[False
  , Get["NCGBPlatformSpecific.m"];
  , Get["NCGBTeXSettings.m"];
    Get["NCGBTeXSetUp.m"];
];
*) 
(* MAURICIO - END *)
    
If[Not[$NC$Loaded$NCGB$===True],
$NC$Loaded$NCGB$ = True;


(********************************** 
BILL MOVED THIS TO NCAlgebra.m August 12, 1997
THAT WAS SO NCAlgebra.m would work by itself

(*
   LOAD NCAlgebra type files 
*)

$NC$readInMora$ = False;
$NC$readInNonMora$ = True;
$NC$readInNF$ = False;
If[Not[MemberQ[{True,False},$NC$LongLoadTime$]]
  ,  $NC$LongLoadTime$ = True;
];
(*
If[$NC$LongLoadTime$
    , file = "NCAlgebra.m";
    , file = "shortNCAlgebra.m";
];
*)
END OF BILL's MOVING
************************************************)

(*
   LOAD NCAlgebra type files 
*)

Get["NCGBNCAlgebra.m"];
Get["NCMPolynomialQ.m"];

(*
   LOAD C++ type files 
*)
Get["newerC++MoraAlg.m"];

(* Get["NCProcess.m"]; *)

Get["newReduction.m"];
immediate = True;
Get["NCGBMaster.m"];

(* 
   If your binary DOES NOT lie in the directory with the name
   StringJoin[$NCDir$,"NCGB/Binary/"], then set
   $NC$Binary$Dir$ to the string with the name of the correct
   directory.

   Example: To use the binaries in the directory

       /home/mstankus/CurrentDistribution/Binary/SUNOS4.1.3/

   have $NC$Binary$Dir$ set equal to the string

       "/home/mstankus/CurrentDistribution/Binary/SUNOS4.1.3/"

   BEFORE you load this file.
*)

If[Head[$NC$Binary$Dir$]=!= String
  , $NC$Binary$Dir$ = StringJoin[$NCDir$,"NCGB/Binary/"];
];
(* 
   If your binary is NOT NAMED p9c, then set
   $NC$Binary$Name$ to the string with the name of the correct
   directory.

   Example: To use the binaries in the directory

       /home/mstankus/CurrentDistribution/Binary/SUNOS4.1.3/p9c_r_new

   have $NC$Binary$Dir$ set equal to the string

       "/home/mstankus/CurrentDistribution/Binary/SUNOS4.1.3/"
  
   and have $NC$Binary$Name$ set equal to the string
    
       "p9c_r_new"

   BEFORE you load this file.
*)

If[Head[$NC$Binary$Name$]=!= String, 
  (* if its the empty set then we are in unix *)
  If[ StringPosition[ $OperatingSystem, "indows" ] == {},
     $NC$Binary$Name$ = "p9c";
  , (* else in Windows *)
     $NC$Binary$Name$ = "p9c.exe";     
  ];
];
If[immediate
  , Check[
      (* MARK, WHY DELAYED EVALUATION FOR INST ??? *)
      inst := (alink = Install[$NC$Binary$Name$]);
      (* MARK, WHY DO YOU USE UNINSTALL ??? *)
      uninst:=(Uninstall[alink]);
      (* MARK, WHY INSTALL AGAIN ??? *)
      Print[inst];
      , 
      Print["Error loading NCGB: could not find NCGB binary."];
      Print["> Make sure file 'p9c' exists under directory:"];
      Print["> '", $NC$Binary$Dir$, $NC$Binary$Name$, "/", $SystemID, "'"];
      Print["> If this directory does not exist you will need to compile NCGB."];
      ,
      LinkOpen::linke
    ]; 
    (* CLEANED UP BY MAURICIO JUNE 2009 *)
    (*
      If[$NCGB$Summer1999$Setup
        , If[Head[NCGBStartUpMma[]]===NCGBStartUpMma
          , Print["The matlink does not work!?"];
            Exit[];
          ];
      ];
    *)
  , Print[(addlink = LinkOpen["5000",LinkMode->Listen])];
    Print["In UNIX session type:"];
    Print[" gdb p9c"];
    Print[" run -linkmode connect -linkname 5000\n"];
    Input["Then enter an innocuous expression in this window."];
];

(* CLEANED UP BY MAURICIO JUNE 2009 *)
(* If[$NCGB$Summer1999$Setup, *)
Get["frontend.m"];
(* ]; *)

If[Head[SetGlobalPtr[]]===SetGlobalPtr
  , Print["There is something wrong with the mathlink"];
    Exit[];
];

SetGlobalPtr[];

Get["DigestedRelations.m"];

Get["supress.m"];
Needs["NCTime`"];
Get["GBTest.m"];

Get["SmallBasis.m"];
Get["SmallBasisByCategory.m"];
Get["SmallBasisRR.m"];
Get["RemoveRedundent2.m"];
Get["RemoveRedundentProtect.m"];
(*
Get["RR.m"];
*)

Get["RemoveRedundentByCategory2.m"];
Get["Categories.m"];
Get["OutputArray.m"];
Get["TypesOfStrategyOutput.m"];
Get["NCCollectOnVariables.m"];
Get["NCShortCuts.m"];
(* MAURICIO - BEGIN *)
(* Get["NCXPUtil.m"]; *)
(* MAURICIO - END *)

Get["NCProcess.m"];

mxson := TurnOnMmaCplusRecord[];
mxsoff:= TurnOffMmaCplusRecord[];
Get["Memory.m"];
Get["NCSRX1.m"];
Get["UnixUtilities.m"];

(* MAURICIO - BEGIN *)
(* This is not used *)
(* Get["Backward.m"]; *)
(* END - BEGIN *)

Get["NCProcessGame.m"];
Get["Diagnostics.m"];
, Print["You have already loaded NCGB.m"];
];

ElapsedTime = Subtract;
