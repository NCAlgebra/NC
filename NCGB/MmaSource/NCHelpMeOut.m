
Clear[NCHelpMeOut];
Clear[InFunctionalCalculus];
Clear[CommutesWith];
Clear[CommutesWith]; 
Clear[LookForCommutes];

(*
 * 
 * The function NCHelpMeOut takes a list of relations and
 * generates elements of the Groebner Basis which are
 * "easy" to generate. This is done because it is 
 * easy to do and because it speed up the process of
 * generating "interesting" relations.
 *
 *)


NCHelpMeOut[relations_List] :=
Module[{result,avar,j,k,i,len,comm,fnct,var1,var2,theCommVar,theFnctVar},  
  result = {};
  vars = GrabVariables[relations];
  len = Length[vars];
  Do[ avar = vars[[i]];
      comm = CommutesWith[avar,relations];
      fnct = InFunctionalCalculus[avar,vars];
      Do[ theCommVar = comm[[j]];
        Do[ theFnctVar = fnct[[k]];
          result = {result,theFnctVar**theCommVar-theCommVar**theFnctVar};
        ,{k,1,Length[fnct]}];
      ,{j,1,Length[comm]}];
      Do[ var1 = fnct[[j]];
        Do[ var2 = fnct[[k]];
          result = {result,var1**var2-var2**tvar1};
        ,{k,1,j-1}];
      ,{j,1,Length[fnct]}];

  ,{i,1,len}];
  result = Union[Flatten[result]]; 
  Return[result];
];

NCHelpMeOut[x___] := BadCall["NCHelpMeOut",x];

(*
 *
 * InFunctionalCalculus is a helper function for NCHelpMeOut.
 * InFuctionalCalculus[var1,var2] returns {var2} if
 * the code can determine that var2 is in the functional
 * calculus of var1. The code returns {} otherwise.
 * This function processes lists as the second argument
 * in the appropriate way.
 * 
 *)

InFunctionalCalculus[base_,aList_List] := 
     Union[Flatten[Map[InFunctionalCalculus[base,#]&,aList]]];

InFunctionalCalculus[base_,Inv[w_]] := 
Module[{temp,result},
  temp = InFunctionalCalculus[base,w];
  result = Map[Inv,temp];
  Return[result];
];

InFunctionalCalculusAux[base_,w_] :=
Module[{aList,temp,result},
  aList = Apply[List,w];
  temp = Flatten[Map[InFunctionalCalculus[base,#]&,aList]];
  If[temp===aList
    , result = {w};
    , result = {};
  ];
  Return[result];
];


InFunctionalCalculus[base_,w_Plus] := InFunctionalCalculusAux[base,w];
InFunctionalCalculus[base_,w_Times] := InFunctionalCalculusAux[base,w];
InFunctionalCalculus[base_,w_NonCommutativeMultiply] := 
     InFunctionalCalculusAux[base,w];

InFunctionalCalculus[base_,c_?NumberQ] := {c};

InFunctionalCalculus[base_,base_] := {base};
InFunctionalCalculus[base_,x_] := {};

InFunctionalCalculus[x___] := BadCall["InFunctionalCalculus",x];

(*
 * CommutesWith is a helper function for NCHelpMeOut.
 * CommutesWith[x,x**y-y**x] returns {y}
 * CommutesWith[y,x**y-y**x] returns {x}
 * CommutesWith most of the time returns {}
 *)

CommutesWith[x_,relations_List] := 
     Union[Flatten[Map[CommutesWith[x,#]&,relations]]];

CommutesWith[x_,relation_] := 
Module[{result},
  result = relation/.Equal->Subtract;
  If[Length[result]===2 && 
     Head[result]===Plus 
    , result = LookForCommutes[x,result[[1]],result[[2]]];
    , result = {};
  ];
  Return[result];
];

CommutesWith[x___] :=  BadCall["CommutesWith",x];

(*
 * LookForCommutes is a helper function for CommutesWith.
 *)

LookForCommutes[var_,c_?NumberQ x_,y_] := LookForCommutes[var,x,y];
LookForCommutes[var_,x_,c_?NumberQ y_] := LookForCommutes[var,x,y];
LookForCommutes[var_,x_,y_] := {};

(* 
 * Change z_ to z__ and {z} to {Apply[NonCommutativeMultiply,z]}
 * to do things with products which commute with a variable.
 * (MXS has not tested this change...)
 *)
 
Literal[LookForCommutes[var_,
                NonCommutativeMultiply[var_,z_],
                NonCommutativeMultiply[z_,var_]]] := {z};
Literal[LookForCommutes[var_,
                NonCommutativeMultiply[z_,var_],
                NonCommutativeMultiply[var_,z_]]] := {z};

LookForCommutes[x___] := BadCall["LookForCommutes",x];
