(* :Title: 	NCNotation // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus).*)

(* :Context: 	NCNotation` *)

(* :Summary:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage["NCNotation`",
     "Errors`","Lazy`","Tuples`"];

Clear[NCNotation];

NCNotation::usage = 
    "NCNotation[aList] (where aList is a list of PolynomialTuples or RuleTuples) \
     returns the first elements of the tuples. If information will be lost \ 
     because of this, a warning message is printed to the screen.";

Begin["`Private`"];

NCNotation[x:{___Tuples`RuleTuple}]:=
Module[{},
     If[Not[aTest[x]], Print["Your list of RuleTuples has free variables."];
                       Print["The output of this routine may be misleading."];
     ];
     Return[LazyPowerToPower[Map[First,x]]]
];

NCNotation[x:{___Tuples`PolynomialTuple}] :=
Module[{},
     If[Not[aTest[x]], Print["Your list of PolynomialTuples has free variables."];
                       Print["The output of this routine may be misleading."];
     ];
     Return[LazyPowerToPower[Map[First,x]]]
];

NCNotation[x___] := BadCall["NCNotation",x];

aTest[x_] := Union[Flatten[Map[And[#[[2]]==={},#[[3]]==={}]&,x]]]==={True};

End[];
EndPackage[]
