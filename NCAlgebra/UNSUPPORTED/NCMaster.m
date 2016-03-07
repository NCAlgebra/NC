(* NCMaster.m *)
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


BeginPackage["NCMaster`"]
EndPackage[]

(*
Needs["ControlSystems`Resolver`"]
*)

(* Declarations for file Represent` *)
DeclarePackage[ "NCRepresent`", \
	{ "MakeMtx", "FunctionMatMake", \
	"NCXRepresent", "PrimeMat" } ];

(*   Don't know how to make this work   :
These functions are really in Bakshee's context ControlSystems`Common`

(* Declarations for file NCControl` *)
DeclarePackage[ "NCControl`", \
	{ "SeriesConnect", "FeedbackConnect","ParallelConnect", \
"ContinuousTimeQ", "DiscreteTimeQ", "TransferFunction", \
"Dual",  "InverseSystem" } ];
*)


(* End of NCMaster Package *)
