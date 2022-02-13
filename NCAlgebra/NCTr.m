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

Get["NCTr.usage"];

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

(* Perhaps SortCyclicPermutation[perm_, aj|tp] can be made mode efficient
   by avoiding the double sorting *)
  SortCyclicPermutation[perm_, op:(aj|tp)] :=
    Sort[{SortCyclicPermutation[perm],
	  SortCyclicPermutation[op /@ Reverse[perm]]}][[1]];
  SortCyclicPermutation[perm_ /; Length[perm] <= 1] := perm;
  SortCyclicPermutation[perm_] := Module[
    {pos = {}, n = 0},
    While[n == 0 || Length[pos] != 1,
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
    {pos = {}, n = 0},
    While[n == 0 || Length[pos] != 1,
      pos = OrderingCyclicPermutation[perm, pos, n++];
      If[pos[[1]] != 1, Return[False]];
    ];
    Return[True];
  ];

  Clear[SortedCyclicPermutationExtendedQ];
  SortedCyclicPermutationExtendedQ[perm_] :=
    If[ FreeQ[perm, aj|co]
       ,
        If[ FreeQ[perm, tp]
           ,
            SortedCyclicPermutationQ[perm]
           ,
            SortedCyclicPermutationQ[perm, tp]
        ]
      ,
       SortedCyclicPermutationQ[perm, If[FreeQ[perm, aj], co, aj]]
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
    ] /; ! SortedCyclicPermutationExtendedQ[l];
  tr[a_?CommutativeQ] := a;
  tr[a_?CommutativeQ b_] := a tr[b];

End[];

EndPackage[];
