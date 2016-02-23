If[Not[$NC$NCAlgebraLoaded$===True],
$NC$NCAlgebraLoaded$ = True;
(* :Title: 	NCAlgebra // Mathematica 1.2 and 2.0 *)

(* :Author: 	Bill Helton (helton).*)

(* :Context: 	none *)

(* :Summary:    See below.
*)

(* :Warnings:   See below.
*)

(* :History: 
   :6/10/92: Changed it to Summer code directory  (mstankus)
   :6/24/92: Added NCadjoints to NCM package (mstankus)
   :3/28/92: Turned off Alias::obsfn message in Math2.0 (dhurst)  
   :4/28/92: Added Gets to NCMora.m and NCTools.m  Also changed 
             the system path to be what it would be on oba (mstankus)
   :5/19/92: Moved NCMora.m to Extra.Mora  (mstankus)
   :7/11/92: Adjusted the position of NCDiff.m in the Get order.
             Adjusted for packaging (mstankus)                   
   :9/2/92:  Put in "AppendTo" command for $Path and 
             removed messy ("StringJoin") part of Get 	      
             statements. (mstankus)					      
   :6/10/92   Changed it to Summer code directory  (mstankus)

   :9/23/92:  Called NC1SetCommands after NCMultiplication.
              Removed calls to NCUsage.m and NCEndPackage.m
              do to restructuring. (mstankus)
   :3/13/93:  Added calls for NCFoias,NCFoiasRt and NCFoiasRtJ. 
              (mstankus)
   :3/15/93:  Added `Get` of NCSetRule.m (mstankus)
   :3/26/93:  Added `Get` of NCPInverses.m (mstankus)
              Added comment involving System`path. (mstankus)
   :3/27/93:  Added `Get` of Inequalties.m (mstankus)
   :5/19/93:  Stan coverted to DeclarePackage statements.
              Updated packages to deal with the Indirect stuff.
              (mstankus)
   :7/12/93:  Changed due to TeX type packaging. (yoshinob)
   :1/31/93:  Incorporated old change log into History.
              Isolated Get's associated to Mora into NC1MoraGets.m
              and NC2MoraGets.m.
              Removed really old and irrelevant comments. 
              See NCAlgebra.m.1.31.94.diffs for details. (mstankus)
*)


(* ------------------------------------------------------------------ *)
(*  Do not load either CONTENTS or SYSTEMS more than once per         *)
(*  Mathematica session.  Do not run NCTEST and SYSTEST during        *)
(*  the same Mathematica session.                                     *)
(* ------------------------------------------------------------------ *)
(* Change line to the absolute pathname of your NCAlgebra directory. *)
(* Note that the directories are specified using / and not \  EVEN   *)
(* in the DOS environment!!! (See explination of Get and $Path in a  *)
(* Mathematica manual.                                               *)
(*                                                                   *)
(* Examples are:                                                     *)
(*     System`path  = "/usr/joeshmo";                                *)
(*     System`path  = "/home/oba/joeshmo";                           *)
(*     System`path  = "/home/oba/joeshmo/NCAlgebraCode";             *)
(*     System`path  = "/A/DOS/PATH/HERE";                            *)
(*                                                                   *)
System`path  = "/home/ncalg/NC/NCAlgebra";
AppendTo[$Path,System`path]; 

Context[ $$OperatingSystem ] = "Global`";
(* ------------------------------------------------------------------ *)
(* Change "UNIX" to your generic operating system. *)
$$OperatingSystem = "UNIX";
(* ------------------------------------------------------------------ *)
(* 
       The right hand side of the following assignement should be 
       True or False.
*)
iIf[Not[MemberQ[{True,False},$NC$readInMora$]]
  , $NC$readInMora$ = False;
];
readInMora = $NC$readInMora$;
If[Not[MemberQ[{True,False},$NC$readInNonMora$]]
  , $NC$readInNonMora$ = True;
];
readInNonMora = $NC$readInNonMora$;
If[Not[MemberQ[{True,False},$NC$readInNF$]]
  , $NC$readInNF$ = False;
];
readInNF = $NC$readInNF$;
If[readInMora, Get["MoraSettings.m"];];

Get["Errors.m"]; (* For error traps *)

Get["NCMultiplication.m"];
Print["NCMultiplication.m loaded"];
Get["NC1SetCommands.m"];
Print["NC1SetCommands.m loaded"];
Get["NCInverses.m"];
Print["NCInverses.m loaded"];
Get["NCTransposes.m"];
Print["NCTransposes.m loaded"];
Get["NCAdjoints.m"];
Print["NCAdjoints.m loaded"];
Get["NCRoots.m"];
Print["NCRoots.m loaded"];
If[readInNonMora,
   Get["NC2SetCommands.m"];
   Print["NC2SetCommands.m loaded"];
];

If[$VersionNumber >= 2.0, Get["NCSetRule.m"];
                          Print["NCSetRule.m loaded"];
                          Get["NCPInverses.m"];
                          Print["NCPInverses.m loaded"];
];

If[$VersionNumber < 2.0, 
      DeclarePackage[x_,y_] := Block[{}, 
      If[Head[ContextToFilename[x]]===ContextToFilename
               , qqqqqqrr = Apply[StringJoin,
                                  Join[
                                   Take[Characters[x],{1,-2}],
                                   {".","m"}
                                      ]
                                  ];
               , qqqqqqrr = ContextToFilename[x]
       ];
       Get[qqqqqqrr];
       ];
];

NonCommutativeMultiply`SetNonCommutative[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

Get["NCCollect.m"];
Print["NCCollect.m loaded"];
Get["NCComplex.m"];
Print["NCComplex.m loaded"];
Get["NCCo.m"];
Print["NCCo.m loaded"];
Get["NCDoTeX.m"];
Print["NCDoTeX.m loaded"];
Get["NCSchur.m"];
Print["NCSchur.m loaded"];
Get["NCSubstitute.m"];
Print["NCSubstitute.m loaded"];
Get["NCMonomial.m"];
Print["NCMonomial.m loaded"];
Get["NCSolve.m"];
Print["NCSolve.m loaded"];
Get["NCMatMult.m"];
Print["NCMatMult.m loaded"];
Unprotect[ContextToFilename];

If[readInMora, Get["NC1MoraGets.m"];];

If[readInNonMora,
   Get["NCTools.m"];
   Print["NCTools.m loaded"];
];
(* NOT SUPPORTED
Unprotect[ContextToFilename];
ContextToFilename["BlockPartition`"]="NCBlockPartition.m";
DeclarePackage["BlockPartition`",{"ValueOf",
                                  "BlockQ",
                                  "SetBlock",
                                  "PartitionMatrix",
                                  "FormMatrix"
                                 }
              ];
Protect[ContextToFilename];
*)
   
Get["NC2SimplifyRational.m"];
Print["NC2SimplifyRational.m loaded"];
Get["NC1SimplifyRational.m"];
Print["NC1SimplifyRational.m loaded"];
Get["NC0SimplifyRational.m"];
Print["NC0SimplifyRational.m loaded"];
Get["NCSimplifyRational.m"];
Print["NCSimplifyRational.m loaded"];
Get["NCSR5.m"];
Print["NCSR5.m loaded"];
Get["NCDiff.m"];
Print["NCDiff.m loaded"];
Get["NCAliasFunctions.m"];
Print["NCAliasFunctions.m loaded"];
Get["NCAlias.m"];
Print["NCAlias.m loaded"];
Get["NCTaylorCoeff.m"];
Print["NCTaylorCoeff.m loaded"];
   
DeclarePackage["NCSave`",{"NCSave"
                         }
              ];

DeclarePackage["NCOutput`",{"SetOutput"
                           }
              ];

DeclarePackage["NCMessyFunction`",{"coexx",
                                   "coexz",
                                   "coezz",
                                   "DGXX",
                                   "DGYY",
                                   "inXY",
                                   "inYX",
                                   "resid",
                                   "A",
                                   "C1","C2","B1","B2",
                                   "XX","YY",
                                   "D12","D21",
                                   "d12","d21",
                                   "e1","e2" 
                                  }
              ];

If[readInMora, Get["NC2MoraGets.m"];];
                             
(*
Get["SYSTEMS"];
Print["SYSTEMS loaded"];
Print["SYSTEMS not loaded"];
*)



Print["
\n\n
                      NCALGEBRA\n
                      Version 1.1   \n
    J. William Helton              Robert L. Miller\n
     Math Dept, UCSD             General Atomic Corp.\n
             La  Jolla,  California 92093\n
 Copyright Helton and Miller June 1991 all rights reserved.\n
\n
If you want updates contact ncalg@osiris.ucsd.edu.\n
\n
The program was written by the authors and by \n
Mark Stankus, David Hurst, Daniel Lamm, Orlando Merino, Robert Obarr, \n
Henry Pfister, Mike Walker, John Wavrik, and Lois Yu.\n
The beginnings of the program come from eran@slac.\n
This program was written with support from the AFOSR, the NSF, \n
the Lab for Math and Statistics at UCSD and the UCSD Faculty\n
Mentor Program and the US Department of Education.\n
\n"];
Print["
If you (1) are a user, (2) want to be a user, (3) refer to NCAlgebra \n
in a publication, or (4) have had an interesting experience with NCAlgebra \n
let us know by sending an e-mail message to  \n
                ncalg@osiris.ucsd.edu. \n
We do not want to restrict access to NCAlgebra, but do want to \n
keep track of how it is being used. \n\n "];

, Print["You have already loaded NCAlgebra.m"];
];
