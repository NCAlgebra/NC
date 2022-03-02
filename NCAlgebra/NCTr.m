(* :Title: 	NCTr.m *)

(* :Author: 	mauricio *)

(* :Context: 	NCTr` *)

(* :Summary: 
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage[ "NCTr`",
	     {"NonCommutativeMultiply`"}];

Clear[tr,
      SortCyclicPermutation,
      SortedCyclicPermutationQ];

Get["NCTr.usage", CharacterEncoding->"UTF8"];

Begin["`Private`"];

  Clear[OrderingCyclicPermutation];
  OrderingCyclicPermutation[perm_, index_, n_] := Module[
    {list, min, pos},
    list = If[index == {},
      perm,
      perm[[Mod[index + n - 1, Length[perm]] + 1]]
    ];
    min = Ordering[list, 1][[1]];
    pos = Flatten[Position[list, list[[min]], 1]];
    Return[If[index == {}, pos, index[[pos]]]];
  ];

  (* MAURICIO: FEBRUARY 2022
     With the new cannonization of a**a as Power[a, 2], an infinite loop is possible
     if working with the original heading NonCommutativeMultiply
  *)
  (* Clear[SortedCyclicPermutationExtendedQ]; *)
  SortCyclicPermutation[perm_NonCommutativeMultiply, op:(aj|tp|co)] :=
    NonCommutativeMultiply @@ SortCyclicPermutation[NCToList @ perm, op];
  SortCyclicPermutation[perm_NonCommutativeMultiply] :=
    NonCommutativeMultiply @@ SortCyclicPermutation[NCToList @ perm];
  SortedCyclicPermutationQ[perm_NonCommutativeMultiply] := Module[
    {list = NCToList @ perm},
    If[ FreeQ[list, aj|co]
       ,
        If[ FreeQ[list, tp]
           ,
            SortedCyclicPermutationQ[list]
           ,
            SortedCyclicPermutationQ[list, tp]
        ]
      ,
       SortedCyclicPermutationQ[list, If[FreeQ[list, aj], co, aj]]
    ]
  ];

  (* Perhaps SortCyclicPermutation[perm_, aj|tp] can be made mode efficient
     by avoiding the double sorting *)
  SortCyclicPermutation[perm_, op:(aj|tp)] :=
    Sort[{SortCyclicPermutation[perm],
	  SortCyclicPermutation[op /@ Reverse[perm]]}][[1]];
  SortCyclicPermutation[perm_ /; Length[perm] <= 1] := perm;
  SortCyclicPermutation[perm_] := Module[
    {pos = {}, m = Length[perm], n = 0},
    While[(n == 0 || Length[pos] != 1) && n < m,
      pos = OrderingCyclicPermutation[perm, pos, n++];
    ];
    Return[RotateLeft[perm, pos[[1]] - 1]];
  ];

  (* Perhaps SortedCyclicPermutationQ[perm_, aj] and SortedCyclicPermutationQ[perm_, tp]
     can be made mode efficient by avoiding the double sorting *)
  SortedCyclicPermutationQ[perm_, op:(aj|tp|co)] :=
    (SortedCyclicPermutationQ[perm] && 
     Ordering[{perm, SortCyclicPermutation[op /@ Reverse[perm]]}, 1][[1]] == 1);
  SortedCyclicPermutationQ[perm_ /; Length[perm] <= 1] := True;
  SortedCyclicPermutationQ[perm_] := Module[
    {pos = {}, m = Length[perm], n = 0},
    While[(n == 0 || Length[pos] != 1) && n < m,
      pos = OrderingCyclicPermutation[perm, pos, n++];
      If[pos[[1]] != 1, Return[False]];
    ];
    Return[True];
  ];

  Clear[trAjAux];
  trAjAux[perm_] := Module[
    (* perm is already sorted *)
    {permAj = SortCyclicPermutation[If[FreeQ[perm, aj], co, aj] /@ Reverse[perm]]},
    Return[
      If[ Ordering[{perm, permAj}][[1]] == 1
         ,
	  tr[perm]
         ,
          Conjugate[tr[permAj]]
      ]
    ];
  ];

  SetCommutativeFunction[tr];
  tr[l_Plus] := tr /@ l;
  tr[tp[a_]] := tr[a];
  tr[aj[a_]] := Conjugate[tr[a]];
  tr[co[a_]] := Conjugate[tr[a]];
  tr[l_NonCommutativeMultiply] :=
    If[ FreeQ[l, aj|co]
       ,
        If[ FreeQ[l, tp]
           ,
            tr[SortCyclicPermutation[l]]
           ,
            tr[SortCyclicPermutation[l, tp]]
        ]
       ,
	(* aj/co case requires conjugation *)
	trAjAux[SortCyclicPermutation[l]]
    ] /; !SortedCyclicPermutationQ[l];
  tr[a_?CommutativeQ] := a;
  tr[a_?CommutativeQ b_] := a tr[b];

End[];

EndPackage[];
