(* :Title: 	NCSetRelations // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NCSetRelations` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :7/30/93: changed code to use flags in NCSetRelationsAux2
             (yoshinob)
*)

BeginPackage["NCSetRelations`",
        "Global`","HereditaryCalculus`","Errors`"]; 

Clear[NCSetRelations];

NCSetRelations::usage = 
     "NCSetRelations usage statement not yet written.";

Begin["`Private`"];

Clear[NCSetRelationsAux];
Clear[NCSetRelationsAux2];

NCSetRelations[someLists___List] :=
   Flatten[Map[Apply[NCSetRelationsAux,#]&,{someLists}]];

NCSetRelationsAux[theAction_,thearguments___] := 
   Map[NCSetRelationsAux2[theAction,#]&,{thearguments}];

NCSetRelationsAux2[Global`Unitary,anArgument_] := 
           {NCSetRelationsAux2[Global`Isometry,anArgument],
            NCSetRelationsAux2[Global`CoIsometry,anArgument]};

NCSetRelationsAux2[anAction_,anArgument_?MatrixQ] := 
Block[{temp,result,flag},
     flag=True;
     If[flag, temp  = Alternate[anAction];
                       If[Head[temp]=!= Alternate, 
                          result = NCSetRelationsAux2[Alternate[anAction],
                                                      Aj[anArgument]];
                         flag=False;
                       ];
     ];
     If[flag, temp  = Poly[anAction];
                       If[Head[temp]=!= Poly,
                          result = NCSetRelationsAux2[temp,anArgument];
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

NCSetRelationsAux2[anAction_,anArgument_] := 
Module[{temp,flag,result},
     flag=True;
     If[Head[anArgument] === Symbol, SetNonCommutative[anArgument]];
     If[flag, temp  = Alternate[anAction];
                       If[Head[temp]=!= Alternate, 
                          result = NCSetRelationsAux2[Alternate[anAction],
                                                      Aj[anArgument]];
                          flag=False;
                       ];
     ];

     If[flag, temp  = Poly[anAction];
                       If[Head[temp]=!= Poly,
                          result = NCSetRelationsAux2[temp,anArgument];
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

Alternate[Global`CoIsometry] = Global`Isometry;
Alternate[Global`CoIsymmetry] = Global`Isomsymmetry; 

Poly[Global`Isometry] = Global`y Global`x - 1;
Poly[Global`Isometry[m_?NumberQ]] := (Global`y Global`x - 1)^m;;
Poly[Global`SelfAdjoint] = Global`y - Global`x;
Poly[Global`Symmetry[m_?NumberQ]] := (Global`y - Global`x)^m;
Poly[Global`Isosymmetry] = (Global`y Global`x - 1)(Global`y - Global`x);
Poly[Global`Projection] = Global`x Global`x - Global`x;

Form[Global`InvL] := {Global`InvL[#]**#==1}&;
Form[Global`InvR] := {#**Global`InvR[#]==1}&;
Form[Global`Inv] := {#**Global`Inv[#]==1,Global`Inv[#]**#==1}&;
Form[Global`Rt] := {Global`Rt[#]^2==#}&;

End[];
EndPackage[]

SetNonCommutative[Rank1,Aj,Kernel];

Rank1[h_,k_ + m_] := Rank1[h,k] + Rank1[h,m];
Literal[Rank1[h_,NonCommutativeMultiply[a__,b_]]] := 
    NonCommutativeMultiply[a]**Rank1[h,b];
Rank1[h_,0] := 0;
Rank1[h_,c_?CommutativeQ k_] := c Rank1[h,k];
Rank1[h_,c_] := c Rank1[h,1] /; And[c=!=1,CommutativeQ[c]]

Rank1[ComplexPlane,1] := 1;

Aj[Aj[x_]] := x;

Aj[c_?CommutativeQ x_.] := Conjugate[c] Aj[x];
Aj[1] := 1;


