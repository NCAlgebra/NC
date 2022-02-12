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

  SortCyclicPermutation[perm1_, perm2_] := Sort[{perm1, perm2}][[1]];
  (* Perhaps SortCyclicPermutation[perm_, aj] and SortCyclicPermutation[perm_, tp]
     can be made mode efficient by avoiding the double sorting *)
  SortCyclicPermutation[perm_, aj] := 
    SortCyclicPermutation[SortCyclicPermutation[perm], 
                          SortCyclicPermutation[aj /@ Reverse[perm]]];
  SortCyclicPermutation[perm_, tp] := 
    SortCyclicPermutation[SortCyclicPermutation[perm], 
                          SortCyclicPermutation[tp /@ Reverse[perm]]];

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
  SortedCyclicPermutationQ[perm_, aj] :=
    (SortedCyclicPermutationQ[perm] && 
     Ordering[{perm, SortCyclicPermutation[aj /@ Reverse[perm]]}, 1][[1]] == 1);
  SortedCyclicPermutationQ[perm_, tp] :=
    (SortedCyclicPermutationQ[perm] && 
     Ordering[{perm, SortCyclicPermutation[tp /@ Reverse[perm]]}, 1][[1]] == 1);
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
    If[ FreeQ[perm, aj]
       ,
        If[ FreeQ[perm, tp]
           ,
            SortedCyclicPermutationQ[perm]
           ,
            SortedCyclicPermutationQ[perm, tp]
        ]
      ,
       SortedCyclicPermutationQ[perm, aj]
  ];

  SetCommutativeFunction[tr];
  tr[l_Plus] := tr /@ l;
  tr[tp[a_]] := tr[a];
  tr[l_NonCommutativeMultiply] :=
    If[ FreeQ[l, aj]
       ,
        If[ FreeQ[l, tp]
           ,
            tr[SortCyclicPermutation[l]]
           ,
            tr[SortCyclicPermutation[l, tp]]
        ]
       ,
        tr[SortCyclicPermutation[l, aj]]
    ] /; ! SortedCyclicPermutationExtendedQ[l];
  tr[a_?CommutativeQ] := a;
  tr[a_?CommutativeQ b_] := a tr[b];

End[];

EndPackage[];
