(* :Title: 	Resol // Mathematica 2.0 *)

(* :Author: 	Stan Yoshniobu (yoshinob) and Mark Stankus (mstankus).*)

(* :Context: 	Resol` *)

(* :Summary:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage["Resol`",
     "NonCommutativeMultiply`","NCSetRelations`",
     "Sets`","Global`","Errors`"];

RESOL::usage =
     "RESOL[x,y] defines the inverse relations for x and y and \
      some of the relations which would define a Groebner basis \
      for this set of relations.";
 
Begin["`Private`"];

RESOLAux1[a_,0] := {};

RESOLAux1[a_,S_] := 
  Join[NCSetRelations[{Inv,a,S-a}],
       {Inv[S-a]**a==S Inv[S-a] - 1,
        a**Inv[S-a]==S Inv[S-a]-1,
        Inv[S-a]**Inv[a]==(S^-1)(Inv[S-a] + Inv[a]),
        Inv[a]**Inv[S-a]==(S^-1)(Inv[S-a] + Inv[a])
       }];

RESOLAux2[a_,0] := {};

RESOLAux2[a_,S_] := 
  Join[NCSetRelations[{Inv,a,S+a}],
       {Inv[S+a]**a== -S Inv[S+a] + 1, 
        a**Inv[S+a]== -S Inv[S+a] + 1,
        Inv[S+a]**Inv[a]==(S^-1)(-Inv[S+a] + Inv[a]),
        Inv[a]**Inv[S+a]==(S^-1)(-Inv[S+a] + Inv[a])
       }];

RESOL[x_,y_] := 
Module[{result},
     result = {};
     If[NonCommutativeMultiply`CommutativeAllQ[x+y], 
               AppendTo[result,RESOLAux1[x,x+y]]
      ];
     If[NonCommutativeMultiply`CommutativeAllQ[y-x],
               AppendTo[result,RESOLAux2[x,y-x]]
     ];
     result = Union[Flatten[result]];
     Return[result]
];

RESOL[aList_List] := 
Module[{temp,result},
    temp = CartesianProduct[aList,aList];
    result = Map[Apply[RESOL,#]&,temp];
    result = Union[Flatten[result]];
    Return[result]
];
               

RESOL[x___] := BadCall["RESOL",x];

End[];
EndPackage[]
