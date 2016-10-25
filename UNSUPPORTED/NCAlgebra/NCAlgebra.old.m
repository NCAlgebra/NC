(* :Title:  NCAlgebra // Mathematica 1.2 and 2.0 *)

(* :Author:     Bill Helton (helton). Plus lotsa others *)

(* :Context:    none *)

(* :Summary:    See below.
*)

(* :WARNINGS:   Settings for different operating systems are about line 80.  See below.
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

   :9/16/99:  Included Get of NCMaster.m to support automatic loading
              of files.   Refered to as "stubs"    (dell)
   :8/16/01:  Added get command for NCConvexity, NCMatMult, and NCGuts 
        (Tony Mendes)
    7/25/02   Vastly cleaned up by deleteing many old things: all Mora calls,
               all  LongLoad options - done by  (Bill H)
   :9/25/04:  Added Get["NC2SetCommands.m"]; into file
              so that the demo works.
   :9/9/04:   Added Get["NCRealizationFunctions.m"] (J Shopple)
   :10/7/04:  Get["NCOutput.m"] instead of declaring a package. (Mark Stankus)
*)


(* ------------------------------------------------------------------ *)
(*  Do not load either CONTENTS or SYSTEMS more than once per         *)
(*  Mathematica session.  Do not run NCTEST and SYSTEST during        *)
(*  the same Mathematica session.                                     *)
(* ------------------------------------------------------------------ *)
(* Change line to the absolute pathname of your NCAlgebra directory. *)
(* Note that the directories are specified using / and not \  EVEN   *)
(* in the DOS environment!!! (See explination of Get and $Path in a  *)
(* Mathematica manual.)                                               *)
(*                                                                   *)
(* Examples are:                                                     *)
(*     System`path  = "/usr/joeshmo";                                *)
(*     System`path  = "/home/oba/joeshmo";                           *)
(*     System`path  = "/home/oba/joeshmo/NCAlgebraCode";             *)
(*     System`path  = "/A/DOS/PATH/HERE";                            *)
(*                                                                   *)

(*
System`path  = "";
AppendTo[$Path,System`path];

Context[ $$OperatingSystem ] = "Global`";
*)

(* 

(* ------------------------------------------------------------------ *)
(* Change "UNIX" to your generic operating system. *)
$$OperatingSystem = "UNIX";
(* ------------------------------------------------------------------ *)

*)

(* This stops Loading NCAlgebra twice: If statement concludes at last  ] 
 in the file *)
If[ Not[$NC$Loaded$NCAlgebra$===True],
    $NC$Loaded$NCAlgebra$ = True;


   (*#################################################*)
   (*#################################################*)

   (* LOAD MAIN PACKAGES  *)

   (* Get["Errors.m"]; ( * For error traps * ) *)

   (*#################################################*)
   (* Basic algebra operations like  ** and tp and inv.  Also NCExpand *)
 
   Get["NCMultiplication.m"];
   Print["NCMultiplication.m loaded"];
   (* Undid it!
     Get["NC1SetCommands.m"];
     Print["NC1SetCommands.m loaded"];
     Get["NC2SetCommands.m"]; 
     Print["NC2SetCommands.m loaded"];

     Get["NCInverses.m"];
     Print["NCInverses.m loaded"];
   *)

   Get["NCOptions.m"];
   Print["NCOptions.m loaded"];
   Get["NCSymmetric.m"];
   Print["NCSymmetric.m loaded"];
   Get["NCSelfAdjoint.m"];
   Print["NCSelfAdjoint.m loaded"];

   (* 
      Get["NCConjugates.m"];
      Print["NCConjugates.m loaded"];
      Get["NCRoots.m"];
      Print["NCRoots.m loaded"];
    *)

   (*#################################################*)
   (* Sets lower case letters to be NonCommutative by default  *)

   NonCommutativeMultiply`SetNonCommutative[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

   (*
     Get["NC2SetCommands.m"];
     Print["NC2SetCommands.m loaded"];
   *)

   (*#################################################*)
   (* Functions which MANIPULATE EXPRESSIONS *)

   Get["NCCollect`"];
   Print["NCCollect.m loaded"];
   Off[NCCollect`NCDecompose::notsum, NCCollect`NCCollect::notsum];

   Get["NCSubstitute.m"];
   Print["NCSubstitute.m loaded"];
   Get["NCMonomial.m"];
   Print["NCMonomial.m loaded"];
   Get["NCSolve.m"];
   Print["NCSolve.m loaded"];

   (*#####*)
   Get["NCTools.m"];   (* David Hurst Package *)
   Print["NCTools.m loaded"];




   (*#####*)
   (* SIMPLIFY COMMANDS- USE PRE STORED RULES    *)
   Get["NC2SimplifyRational.m"];
   Print["NC2SimplifyRational.m loaded"];
   Get["NC1SimplifyRational.m"];
   Print["NC1SimplifyRational.m loaded"];
   (* NOT SUPPORTED  Get["NC0SimplifyRational.m"];        *)
   (* Print["NC0SimplifyRational.m loaded"];  *)
   Get["NCSimplifyRational.m"];
   Print["NCSimplifyRational.m loaded"];

  (*#################################################*)
  (* Pakages which do fancy things     *)    

  (* Get["NCComplex.m"];    ( *moved 2002 * )    
    Print["NCComplex.m loaded"];
  *)

  Quiet[
    Get["NCMatMult.m"];    (*moved 2002 *)    
    ,
    {General::obspkg, General::newpkg, General::compat}
  ];
  Print["NCMatMult.m loaded"];

   
  Get["NCDiff.m"];
  Print["NCDiff.m loaded"];


  (*
    Get["NCSchur.m"];   (* BILL INSERTED Aug 25 97*)
    Print["NCSchur.m loaded"];
  *)

  (*#######*)
  Get["NCAlias.m"]; (* bill is scared to move this to a logical place *)
  Print["NCAlias.m loaded"];

  (*
     Get["Grabs.m"]; ( * added 2002 * )
     Print["Grabs.m loaded"];
     Get["NCTaylorCoeff.m"];
     Print["NCTaylorCoeff.m loaded"]; 
  *)

  Get["NCConvexity.m"]; (* Inserted Aug 16 2001 *)
  Get["NCGuts.m"];      (* Inserted Aug 16 2001 *)
  Print["NCConvexity.m and NCGuts.m loaded"];

  Get["NCRealizationFunctions.m"];
  Print["NCRealizationFunctions.m loaded"];

  (*#################################################*)
  (*   TeX production *) 

  (*
     Get["NCDoTeX.m"];
     (* Print["NCDoTeX.m loaded"]; *)
   
     Get["NCTeXForm.m"];    (* BILL INSERTED Aug 25 97*)
     Print["NCDoTex.m, NCTeXForm.m loaded"];
  *)

  Get["NCTeXForm.m"];
  Print["NCTeXForm.m loaded"];

  Get["NCTeX.m"];
  SetOptions[NCTeX`NCTeX, NCTeX`TeXProcessor -> NCTeXForm`NCTeXForm];
  Print["NCTeX.m loaded"];

  (*#################################################*)
  (*#################################################*)

  (*            DECLARE  PACKAGES HERE                    *)  

  (*
    Get["NCMaster.m"]; (* Dells file which declares various packges *)
    Print["NCMaster.m loaded" ];
  *)

  (* DeclarePackage["NCSave`",{"NCSave"} ]; *)

  (*DeclarePackage["NCOutput`",{"SetOutput"} ]; *)
  Get["NCOutput.m"];
  Print["NCOutput.m loaded" ];

  (*
    Get["SYSTEMS"];
    Print["SYSTEMS loaded"];
    Print["SYSTEMS not loaded"];
  *)


  (*#################################################*)
  (*#################################################*)


  (* JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ   *)
  (* UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU   *)
  (* NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN   *)
  (* KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK   *)

  (*  NOT SUPPORTED   NOT SUPPORTED   NOT SUPPORTED   *)

  (* TEST 2 -looks safe too delete- 2002
     Unprotect[ContextToFilename];
  END TEST 2 *)

  (* 
     NOT SUPPORTED
     NOT SUPPORTED
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
    NOT SUPPORTED
  *)


  (* BILL KILLED aug 12 97  you can still load seperately 
    If[$NC$LongLoadTime$
      , DeclarePackage["NCMessyFunction`",{"coexx",
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
    ];
     END  BILL KILLED
  *)



  (*  END NOT SUPPORTED    *)

  (* END  JUNK  END JUNK  *)

  (*#################################################*)
  (*#################################################*)
  (*#################################################*)

  FilePrint[ToFileName[$NCDir$, "banner.txt"]];

 , 
  Print["You have already loaded NCAlgebra.m"];
];  (* This  ];  closes  If[Not[$NC$Loaded$NCAlgebra$  ETC far far above  *)
