(* :Title: 	Verbose // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	Verbose` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["Verbose`","Errors`"];

Clear[VerboseQ];

VerboseQ::usage = 
     "VerboseQ[aSymbol] is False by default and set to True \
      or False depending on whether or not SetVerbose[aSymbol] \
      or UnSetVerbose[aSymbol] was called. The idea is that \
      aSymbol is the name of a routine and if one wants \
      debugging type statements in your program \
      and do not want to invoke them via an option (like
      debug->True) then you use VerboseQ. See MoraAlg.m
      for an example.";

Clear[SetVerbose];

SetVerbose::usage =
     "After SetVerbose[aSymbol] is exectued, VerboseQ[aSymbol] \
      will return True.";

Clear[UnSetVerbose];

UnSetVerbose::usage =
     "After UnSetVerbose[aSymbol] is exectued, VerboseQ[aSymbol] \
      will return False.";

Begin["`Private`"];

VerboseQ[x_Symbol] := False;
VerboseQ[x___] := BadCall["Verbose",x];

SetVerbose[routine_Symbol] := VerboseQ[routine] = True;
UnSetVerbose[routine_Symbol] := VerboseQ[routine] = False;

End[];
EndPackage[]
