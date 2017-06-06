BeginPackage["HereditaryCalculus`","Global`",
             "NCMatMult`","NonCommutativeMultiply`"];

UnProtect[Hereditary];

Clear[Hereditary];

Hereditary::usage = 
     "Hereditary[p,T] evaluates the polynomial p the  \
      block operator T,in the sense of Jim Agler. Hereditary \
      has two options:  Var1->symbol1 and Var2->symbol2 specify \
      which variables the polynomial is stated in. The defaults \
      are Var1->Global`x and Var2->Global`y.  For example, \
      Hereditary[x y^2,T] and Hereditary[z w^2 ,T,Var1->z,Var2->w] \
      both give the same result as MatrixMuliply[aj[T],aj[T],T] \
      from NCMatMult package.";

Unprotect[Her];

Clear[Her];

Unprotect[PowerMM];

Clear[PowerMM];

PowerMM::usage = "PowerMM[p,m] calculate T to the m power using
non-commutative multiplication (for m>=1)."

Clear[Zero];

Zero::usage = "Zero[m] creates an m by m zero matrix."

Clear[Var1];

Var1::usage="See explination for Hereditary."

Clear[Var2];

Var2::usage="See explination for Hereditary."

Begin["`Private`"];
(* -------------------------------------------------------- *)
(*    The actual code                                       *)
(* -------------------------------------------------------- *)
Options[Hereditary] = {Var1->Global`x,Var2->Global`y};
Hereditary[p_,T_,space___List,opts___Rule] :=  
Block[{temp,var1,var2},
     var1 = Var1/.{opts}/.Options[Hereditary];
     var2 = Var2/.{opts}/.Options[Hereditary];
     temp = Her[Expand[p],T,Flatten[List[space]],var1,var2];
     Return[ExpandNonCommutativeMultiply[temp]]
];
(* -------------------------------------------------------- *)
(*    Expand out the polynomial and break up sums and       *)
(*    constants                                             *)
(* -------------------------------------------------------- *)

Her[p_ + q_,other___] := Her[p,other] + Her[q,other];

(* -------------------------------------------------------- *)
(*    Replace var1 with T and var2 with the adjoint of T    *)
(* -------------------------------------------------------- *)

Her[var1_,T_,space_,var1_,var2_] := T;

Her[var1_^m_,T_,space_,var1_,var2_] := PowerMM[T,m] /; NumberQ[m]

Her[var2_,T_,space_,var1_,var2_] := aj[T];

Her[var2_^n_,T_,space_,var1_,var2_] := aj[PowerMM[T,n]] /; NumberQ[n]

Her[var1_ var2_^n_,T_,space_,var1_,var2_] :=  
                       NCMatMult`MatMult[aj[PowerMM[T,n]],T] /; NumberQ[n]

Her[var1_^m_ var2_,T_,space_,var1_,var2_] :=  
                       NCMatMult`MatMult[aj[T],PowerMM[T,m]] /; NumberQ[m]

Her[var1_ var2_,T_,space_,var1_,var2_] := NCMatMult`MatMult[aj[T],T];

Her[var1_^m_ var2_^n_,T_,space_,var1_,var2_] :=  
      NCMatMult`MatMult[aj[PowerMM[T,n]],PowerMM[T,m]] /; 
                                                NumberQ[n] && NumberQ[m]

Her[c_ p_,T_,space_,var1_,var2_] := c Her[p,T,space,var1,var2] /; NumberQ[c] 

Her[c_,T_,space_,var1_,var2_] := 
              c Her[1,T,space,var1,var2] /; NumberQ[c]&&Not[TrueQ[c==1]]

Her[1,T_,space_,var1_,var2_] := 
Block[{len,temp,result},
     len = Length[space];
     If[len > 0 && Not[len===Length[T]],
          Print["Warning from HereditaryCalculus.m"];
          Print["The decomposition of the space which was given"];
          Print["is not the same the size of the matrix given!!!"];
          Abort[];
     ];
     If[len===0, 
  (* THEN *) result = IdentityMatrix[First[Dimensions[T]]],
  (* ELSE *) result = Table[HerAux[space,j,k],{j,1,len},{k,1,len}];
     ];
     Return[result]
]                           /; Not[Dimensions[T]=={}]

Her[1,T_,{},var1_,var2_] := 1;

HerAux[space_,j_,k_] := 0 /; Not[j===k]

HerAux[space_,j_,j_] := 
Block[{result},
      If[space[[j]]===ComplexPlane, result = dyad[1,1];
                                  , result = 1;
      ];
      Return[result]
];

Her[- p_,T_,space_,var1_,var2_] := - Her[p,T,space,var1,var2];

Her[List[m_],other___] := 
Block[{temp,j,result},
    result = {};
    For[j=1,j<=Length[List[m]],j++,
        temp = Her[m[[j]],other];
        AppendTo[result,temp];
    ];
    Return[result]
];

Zero[n_] := Table[0,{i,1,n},{j,1,n}]

(* -------------------------------------------------------- *)
(*    PowerMM                                               *)
(* -------------------------------------------------------- *)
PowerMM[T_,k_] := 
Block[{result,j},
     If[k<=0,Abort[], 
             If[Length[T]===0,
(* THEN *)       result = 1;	
                 For[j=1,j<=k,j++,
                     result = NonCommutativeMultiply[result,T];
                 ];,
(* ELSE *)       result = IdentityMatrix[First[Dimensions[T]]];
                 For[j=1,j<=k,j++,
                     result = NCMatMult`MatMult[result,T];
                 ];
             ];
     ];
     Return[result]
] /; NumberQ[k]

Protect[Hereditary,Her];
End[];
EndPackage[];
