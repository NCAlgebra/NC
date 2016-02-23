(* NCGBMaster.m *)

(* :Title: Master Declarations File for Special NCFunctions *)

(* :Summary:
This file contains declarations of all the major rarely used symbols
contained in files in this directory.  When loaded, it sets
up the symbols with attribute Stub, so the correct package
will be loaded when the symbol is called.
*)

(* :Author: This file was hacked from an automated system written in
	Mathematica by John M. Novak -dell *)


(* :Author: dell *)
(* :History:
		:9/8/99: Brought in (dell) 
*)


BeginPackage["NCGBMaster`"]
EndPackage[]

(*
Needs["ControlSystems`Resolver`"]
*)

(* Declarations for file ShortCuts` *)
DeclarePackage["NCShortCuts`",
     {"NCAddTranspose", "NCAutomaticOrder", \
       "NCSmartOrder","NCAddAdjoint" }];

(* Declarations for file test` *)
DeclarePackage["test`",
     {"TestIt" }];

(* Declarations for file test` *)
DeclarePackage["NCMakeRelations`",
     {"NCMakeRelations" }];

(* Declarations for file NCHilbertCoefficient` *)
DeclarePackage[ "NCHilbertCoefficient`", \
	{"NCX1VectorDimension", "NCHilbertCoefficient" \
	} ];

(* Declarations for file NCChangeOfVariables` *)
DeclarePackage[ "NCChangeOfVariables`", \
	{ "NCXPossibleChangeOfVariables", \
	"NCXFindChangeOfVariables", "NCXAllPossibleChangeOfVariables" \
	}];


(* Declarations for file ControlSystems`Connections` *)
(*
DeclarePackage["ControlSystems`Connections`",
     {"CompositeSystem", "DefaultInputPort", "DeleteSubsystem", "FeedbackConnec\
       t", "Merge", "ParallelConnect", "SeriesConnect", "StateFeedbackConnect"\
       , "Subsystem"}]
*)

(* End of NCGBMaster Package *)
