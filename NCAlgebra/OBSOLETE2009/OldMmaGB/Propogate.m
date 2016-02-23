(* :Title: 	Propogate // Mathematica 2.0 *)

(* :Author: 	Mark Stankus (mstankus).*)

(* :Context: 	Propogate`*)

(* :Summary:
*)

(* :Warnings: 
*)

(* :History: 
   :3/13/93:  Wrote this function via the MakeRules.m file. (mstankus)
   :5/26/94:  Added rules for a**b**Inv[a] = c, and Inv[a]**b**a = c
              Added ability to propogate constants in relations.
              (yoshinob) 
*)

BeginPackage["Propogate`",
     "SimplePower`","NonCommutativeMultiply`","MoraData`",
     "ManipulatePower`","Tuples`",
     "Errors`"];

Clear[Propogate];

Propogate::usage = 
     "Propogate[aListOfNumbers] (where aListOfNumbers is a list \
      of numbers) generates the more general but equivalent symbolic \
      rule tuple which is passed back in terms of the data base..";

Clear[PropogatePlus];

PropogatePlus::usage = 
     "PropogatePlus[aListOfRuleTuples,vars] (where aRuleTuple is a rule tuple \
      generates the more general but equivalent symbolic \
      rule tuple.";


Begin["`Private`"];

Clear[PropogateAux];

Propogate[x_] := Propogate[x,0];

Propogate[aListOfNumbers:{___?NumberQ},
          bottom_?NumberQ] := 
Module[{len,aNumber,ans,ruletuple,j,triple,newruletuple,
        oldrule,theans,theoldrules,newans,newoldrules},
     listOfVariablesPropogated = {};
     len = Length[aListOfNumbers];
     Do[ aNumber = aListOfNumbers[[j]];
         ruletuple = DataElement[aNumber];
         ans[j] = {};
         oldrule[j] = {};
         If[Head[ruletuple[[1,1]]] === NonCommutativeMultiply,
               triple = PropogateAux[ruletuple[[1]],bottom];
               If[Not[triple==={}],
If[Length[triple] =!= 3,Print[triple];Abort[];];
                   newruletuple = Global`RuleTuple[triple[[1]],
                                            Join[ruletuple[[2]],triple[[2]]],
                                            Join[ruletuple[[3]],triple[[3]]]
                                           ];
                   newruletuple = CleanUpTuple[newruletuple];
                   newruletuple = SmartTupleUnion[
                                 FixPowerRuleTuple[newruletuple]
                                                 ];
                   newruletuple = CleanUpTuple[newruletuple];
                   ans[j] = MoraData`Private`AddToDataBaseAux[newruletuple];
                   oldrule[j] = aNumber;
               ];
         ];
     ,{j,1,len}];
     listOfVariablesPropogated = Flatten[listOfVariablesPropogated];
     theans = Union[Flatten[Table[ans[j],{j,1,len}]]];
     theoldrules = Union[Flatten[Table[oldrule[j],{j,1,len}]]];
Print["entering PropogatePlus"];
     {newans,newoldrules} =    
             PropogatePlus[Complement[aListOfNumbers,theoldrules],
                           listOfVariablesPropogated];
(*
Print["newans:",newans];
Print["newoldrules:",newoldrules];
*)
     Return[{Join[theans,newans],Join[theoldrules,newoldrules]}];
];

Propogate[x___] := BadCall["Propogate",x];

Literal[PropogateAux[
          NonCommutativeMultiply[a_?NotPower,b_?NotPower]->
          K_. NonCommutativeMultiply[b_,a_]
         ,bottom_?NumberQ]] := 
Module[{m,n},
     m = Global`UniqueMonomial["Propogate"];
     n = Global`UniqueMonomial["Propogate"];
     Return[{ Power[a,m]**Power[b,n] ->
              K ^(m n) Power[b,n]**Power[a,m],
              {m >= bottom, n >= bottom},{m,n}
            }]
];
Literal[PropogateAux[
          NonCommutativeMultiply[a_?NotPower,b_?NotPower]->
          K_. NonCommutativeMultiply[c_?NotPower,a_]
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     AppendTo[listOfVariablesPropogated,{a,b}];
     Return[{ Power[a,1]**Power[b,n] ->
              K^n Power[c,n]**Power[a,1],
              { n >= bottom},{n}
            }]
];
        
Literal[PropogateAux[
          NonCommutativeMultiply[a__,b_?NotPower]->
          K_. NonCommutativeMultiply[c_?NotPower,a__]
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     AppendTo[listOfVariablesPropogated,{c,b}];
     Return[{ NonCommutativeMultiply[a]**Power[b,n] ->
              K^n Power[c,n]**NonCommutativeMultiply[a],
              {n >= bottom},{n}
            }]
];

Literal[PropogateAux[
          NonCommutativeMultiply[c_?NotPower,a_?NotPower]->
          K_. NonCommutativeMultiply[a_,b_?NotPower]
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     AppendTo[listOfVariablesPropogated,{c,b}];
     Return[{ Power[c,n]**Power[a,1] ->
              K^n Power[a,1]**Power[b,n],
              {n >= bottom},{n}
            }]
];
        
Literal[PropogateAux[
          NonCommutativeMultiply[c_?NotPower,a__]->
          K_. NonCommutativeMultiply[a__,b_?NotPower]
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     AppendTo[listOfVariablesPropogated,{c,b}];
     Return[{ Power[c,n]**NonCommutativeMultiply[a] ->
              K^n NonCommutativeMultiply[a]**Power[b,n],
              {n >= bottom},{n}
            }]
];

Literal[PropogateAux[
          NonCommutativeMultiply[a_?NotPower,b_?NotPower,              
                                 Global`Inv[a_] ]->
          K_. c_?NotPower
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     Return[{ a**Power[b,n]**Global`Inv[a] ->
              K^n Power[c,n],
              {n >= bottom},{n}
            }]
];


Literal[PropogateAux[
          NonCommutativeMultiply[Global`Inv[a_],b_?NotPower, 
                                 a_?NotPower]->
          K_. c_?NotPower
         ,bottom_?NumberQ]] := 
Module[{n},
     n = Global`UniqueMonomial["Propogate"];
     Return[{ Global`Inv[a]**Power[b,n]**a ->
              K^n Power[c,n],
              {n >= bottom},{n}
            }]
];



PropogateAux[rule_Rule,num_?NumberQ] := 
Module[{},
(*
   Print["In default:",rule," ",num];
*)
   Return[{}];
];

PropogateAux[x___] := BadCall["PropogateAux",x];

NotPower[x_Power] := False;

NotPower[x_] := True;

NotPower[x___] := BadCall["NotPower",x];

PropogatePlus[aListOfNumbers:{___?NumberQ},
              aListOfVariables_List] :=
Module[{ruletuple,newvars,rule,LHS,RHS,modLHS,left,right,j,newvar1,
        newvar2,newineq,newruletuple,newans,newold},
(*
Print[""];
Print[""];
Print["In PropogatePlus"];
Print[""];
*)
     newans = {};
     newold = {};
     Do[ ruletuple = DataElement[aListOfNumbers[[j]]];
         newvars = {};
         rule = ruletuple[[1]];
         LHS = rule[[1]];
         RHS = rule[[2]];
         modLHS = NCMToList[LHS];
         left = modLHS[[1]];
         right = modLHS[[-1]];
         If[MemberQ[aListOfVariables,TheBase[left]],
              newvar1 = Unique["propogate"];
              LHS = LazyPower[TheBase[left],newvar1]**LHS; 
              RHS = LazyPower[TheBase[left],newvar1]**RHS;
              AppendTo[newvars,newvar1];
         ];
         If[MemberQ[aListOfVariables,TheBase[right]],
              newvar2 = Unique["propogate"];
              LHS = LHS**LazyPower[TheBase[right],newvar2]; 
              RHS = RHS**LazyPower[TheBase[right],newvar2];
              AppendTo[newvars,newvar2];
         ];
         If[Not[newvars==={}], 
              newineq = Map[(#>=0)&,newvars];
              newruletuple = RuleTuple[
                                       LHS->RHS,
                                       Join[ruletuple[[2]],newineq],
                                       Join[ruletuple[[3]],newvars]
                                      ];
              newans = Join[newans,Flatten[AddToDataBase[newruletuple]]];
              AppendTo[newold,aListOfNumbers[[j]]];
         ];
      ,{j,1,Length[aListOfRuleTuples]}];
      Return[{newans,newold}];
];


PropogatePlus[x___] := BadCall["PropogatePlus",x];


End[];
EndPackage[]

