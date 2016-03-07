
(* ------------------------------------------------------------------ *)
(*    NCSave.m                                                        *)
(* ------------------------------------------------------------------ *)

(* ------------------------------------------------------------------ *)
(*                         Prolog                                     *)
(*                                                                    *)
(*    Purpose: NCSave saves an expression and all the settings        *)
(*        associated to it.                                           *)
(*                                                                    *)
(*        For example, if we have A**x and A is non commutative       *)
(*        and self adjoint, then these facts will be recorded         *)
(*        if one executes NCSave["grapefruit",A**x];                  *)
(*                                                                    *)
(*    Alias:                                                          *)
(*                                                                    *)
(*    Description:                                                    *)
(*                                                                    *)
(*    Arguments:                                                      *)
(*                                                                    *)
(*    Comments/Limitations:                                           *)
(*                                                                    *)
(*                                                                    *)
(* ------------------------------------------------------------------ *)
BeginPackage["NCSave`","NonCommutativeMultiply`"];

NCSave::usage =  "NCSave[str,expr] saves expr (an expression)
        and all the settings associated to it to a file whose
        filename is given by the string str. "
    
Begin["`Private`"];

NCSave[filerec_String,expr_] := Block[{},
        channel = OpenAppend[filerec];
        PrintDataForAnExpression[expr,channel];
        Write[channel,expr];
        Close[filerec];
];

PrintDataForAnExpression[expr_,channel_]:= Block[{variables},
      variables = Union[ListVariables[expr]];
      If[variables != {},
           For[n=1,n<Length[variables]+1,++n,
                      PrintDataForAVariable[variables[[n]],channel];
              ];
        ];
];

ListVariables[f_[p_,q___]] := Union[ListVariables[p],ListVariables[f[q]]];
ListVariables[f_[p_]] := ListVariables[p];
ListVariables[c_] := {} /; NumberQ[c]
ListVariables[x_] := {x};

PrintDataForAVariable[x_,channel_] := Block[{},
        WriteString[channel,PrintDataAux[x,CommutativeQ]];
        WriteString[channel,PrintDataAux[x,SelfAdjointQ]];
        WriteString[channel,PrintDataAux[x,IsometryQ]];
        WriteString[channel,PrintDataAux[x,CoIsometryQ]];
        WriteString[channel,PrintDataAux[x,UnitaryQ]];
        WriteString[channel,PrintDataAux[x,ProjectionQ]];
        WriteString[channel,PrintDataAux[x,SignatureQ]];
        WriteString[channel,PrintDataAux[x,invQ]];
];

PrintDataAux[x_,func_] :=
      StringJoin[ToString[func],"[",
                 ToString[x],"]=",
                 ToString[func[x]],";\n"];
End[];
EndPackage[]
