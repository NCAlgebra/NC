(* :Title: 	NCMakeRelations // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NCMakeRelations` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
		:9/1/99: Juan added PseudoInverse and Perp relations
*)

BeginPackage["NCMakeRelations`",
        "Global`","HereditaryCalculus`","Errors`"]; 

Clear[NCMakeRelations];

NCMakeRelations::usage = 
     "NCMakeRelations usage statement not yet written.";

Begin["`Private`"];

Clear[NCMakeRelationsAux];
Clear[NCMakeRelationsAux2];

NCMakeRelations[someLists___List] :=
   Flatten[Map[Apply[NCMakeRelationsAux,#]&,{someLists}]];

NCMakeRelationsAux[Global`SetPairwiseCommutative,thearguments___] := 
Block[{L,result,i,j},
  L = {thearguments};
  Do[ 
    Do[ AppendTo[result,L[[i]]**L[[j]]==L[[j]]**L[[i]]];
    ,{j,i+1,Length[L]}];
  ,{i,1,Length[L]}];
  Return[Flatten[result]];
];

NCMakeRelationsAux[theAction_,thearguments___] := 
   Map[NCMakeRelationsAux2[theAction,#]&,{thearguments}];

NCMakeRelationsAux2[Global`Unitary,anArgument_] := 
           {NCMakeRelationsAux2[Global`Isometry,anArgument],
            NCMakeRelationsAux2[Global`CoIsometry,anArgument]};

NCMakeRelationsAux2[anAction_,anArgument_?MatrixQ] := 
Block[{temp,result,flag},
     flag=True;
     If[flag, temp  = Alternate[anAction];
                       If[Head[temp]=!= Alternate, 
                          result = NCMakeRelationsAux2[Alternate[anAction],
                                                      Aj[anArgument]];
                         flag=False;
                       ];
     ];
     If[flag, temp  = Poly[anAction];
                       If[Head[temp]=!= Poly,
                          result = NCMakeRelationsAux2[temp,anArgument];
                          flag=False;
                       ];
     ];
     If[flag, temp  = Form[anAction];
                       If[Head[temp]=!= Form, 
                            ToExpression[
                              StringJoin["result = Map[",
                                         ToString[Format[temp,InputForm]],
                                         ",{",
                                         ToString[Format[anArgument,InputForm]],
                                         "}]"
                                        ]
                            ];
                          flag=False;
                       ];
     ];

     If[flag, result = HereditaryCalculus`Hereditary[anAction,
                                                              anArgument];
                       result = Flatten[{result}];
                       result = Map[(#==0)&,result];
     ];
     result = result/.aj->Aj;
     result = result/.MatMult->NonCommutativeMultiply;
     Return[result]
];

NCMakeRelationsAux2[anAction_,anArgument_] := 
Module[{temp,flag,result},
     flag=True;
     If[Head[anArgument] === Symbol, SetNonCommutative[anArgument]];
     If[flag, temp  = Alternate[anAction];
                       If[Head[temp]=!= Alternate, 
                          result = NCMakeRelationsAux2[Alternate[anAction],
                                                      Aj[anArgument]];
                          flag=False;
                       ];
     ];

     If[flag, temp  = Poly[anAction];
                       If[Head[temp]=!= Poly,
                          result = NCMakeRelationsAux2[temp,anArgument];
                          flag=False;
                       ];
     ];
     If[flag, temp  = Form[anAction];
                       If[Head[temp]=!= Form, 
                            ToExpression[
                              StringJoin[ToString[Format[result,InputForm]],
                                         " = Map[",
                                         ToString[Format[temp,InputForm]],
                                         ",{",
                                         ToString[Format[anArgument,InputForm]],
                                         "}]"
                                        ]
                            ];
                          flag=False;
                       ];
     ];

     If[flag, result = HereditaryCalculus`Hereditary[anAction,
                                                              anArgument];
                       result = Flatten[{result}];
                       result = Map[(#==0)&,result];
     ];
     result = result/.aj->Aj;
     result = result/.MatMult->NonCommutativeMultiply;
     Return[result]
];

NCMakeRelationsAux2[x___] := BadCall["NCMakeRelationsAux2",x]; 

Alternate[Global`CoIsometry] = Global`Isometry;
Alternate[Global`CoIsymmetry] = Global`Isomsymmetry; 

Poly[Global`Isometry] = Global`y Global`x - 1;
Poly[Global`Isometry[m_?NumberQ]] := (Global`y Global`x - 1)^m;;
Poly[Global`SelfAdjoint] = Global`y - Global`x;
Poly[Global`Symmetry[m_?NumberQ]] := (Global`y - Global`x)^m;
Poly[Global`Isosymmetry] = (Global`y Global`x - 1)(Global`y - Global`x);
Poly[Global`NCProjection] = Global`x Global`x - Global`x;

Form[Global`InvL] := {Global`InvL[#]**#==1}&;
Form[Global`InvR] := {#**Global`InvR[#]==1}&;
Form[Global`Inv] := {#**Global`Inv[#]==1,Global`Inv[#]**#==1}&;
Form[Global`Rt] := {Global`Rt[#]^2==#}&;
Form[Global`Pinv] := { 	#**Global`Pinv[#]**#==#,
			Global`Pinv[#]**#**Global`Pinv[#]==Global`Pinv[#],
			Tp[#]**Tp[Global`Pinv[#]]==Global`Pinv[#]**#,
			Tp[Global`Pinv[#]]**Tp[#]==#**Global`Pinv[#],
			Tp[Global`Pinv[#]] == Global`Pinv[Tp[#]]
			}&;
Form[Global`PerpL]:= {Global`PerpL[#]**#}&;
Form[Global`PerpR]:= {#**Global`PerpR[#]}&;
Form[Global`PerpL2]:= {1 - #**Global`Pinv[#]==Global`PerpL2[#],
                        Tp[Global`PerpL2[#]]-Global`PerpL2[#]}&;
Form[Global`PerpR2]:= {1 - Global`Pinv[#]**#==Global`PerpR2[#],
                        Tp[Global`PerpR2[#]]-Global`PerpR2[#]}&;

End[];
EndPackage[]

SetNonCommutative[Rank1,Aj,Kernel];

Rank1[h_,k_ + m_] := Rank1[h,k] + Rank1[h,m];
Literal[Rank1[h_,NonCommutativeMultiply[a__,b_]]] := 
    NonCommutativeMultiply[a]**Rank1[h,b];
Rank1[h_,0] := 0;
Rank1[h_,c_?CommutativeAllQ k_] := c Rank1[h,k];
Rank1[h_,c_] := c Rank1[h,1] /; And[c=!=1,CommutativeAllQ[c]]

Rank1[ComplexPlane,1] := 1;

Aj[Aj[x_]] := x;
Aj[c_?CommutativeAllQ x_.] := Conjugate[c] Aj[x];
Aj[1] := 1;

