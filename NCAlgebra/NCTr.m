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

  SortCyclicPermutation[perm_List /; Length[perm] <= 1] := perm;
  SortCyclicPermutation[perm_List] := Module[
    {pos = {}, n = 0},
    While[n == 0 || Length[pos] != 1,
      pos = SortCyclicPermutation[perm, pos, n++];
    ];
    Return[RotateLeft[perm, pos[[1]] - 1]];
  ];
  SortCyclicPermutation[perm_List, offset_, n_] := Module[
    {list, min, pos},
    list = If[offset == {},
      perm,
      perm[[Mod[offset + n - 1, Length[perm]] + 1]]
    ];
    min = Ordering[list, 1][[1]];
    pos = Flatten[Position[list, list[[min]], 1]];
    Return[If[offset == {}, pos, offset[[pos]]]];
  ];

  SortedCyclicPermutationQ[perm_List /; Length[perm] <= 1] := True;
  SortedCyclicPermutationQ[perm_List] := Module[
    {pos = {}, n = 0},
    While[n == 0 || Length[pos] != 1,
      pos = SortCyclicPermutation[perm, pos, n++];
      If[pos[[1]] != 1, Return[False]];
    ];
    Return[True];
  ];

  SetCommutativeFunction[tr];
  tr[l_Plus] := tr /@ l;
  tr[tp[a_]] := tr[a];
  tr[NonCommutativeMultiply[l__]] := 
    tr[NonCommutativeMultiply @@ SortCyclicPermutation[{l}]] /; !SortedCyclicPermutationQ[{l}];
  tr[NonCommutativeMultiply[a_, b___, tp[c_]]] :=
    tr[NonCommutativeMultiply[c, Sequence@@Map[tp, Reverse[{b}]], tp[a]]] /; !SortedCyclicPermutationQ[{a,c}];
  tr[a_?CommutativeQ] := a;
  tr[a_?CommutativeQ b_] := a tr[b];

End[];

EndPackage[];
