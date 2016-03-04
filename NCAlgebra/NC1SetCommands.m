(* Modified for Agedi Boto *)
(* :Title: 	NC1SetCommands // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:    Code for setting functions to be linear,bilinear,
                sesquilinear,conjugate linear,idempotent,a 
                noncommutative multiplicative antihomomorphism 
                or to commute with another function.
*)

(* :Alias: *)

(* :Warnings: *)

(* :History: 
   :5/04/91:    Initial coding. (mstankus)
   :8/15/99:    Mark changed some stuff for Agedi Boto (dell) 
*)

BeginPackage[ "NonCommutativeMultiply`" ]

Clear[SetSesq];

SetSesq::usage=
     "Synonym for SetSesquilinear.";

Clear[SetSesquilinear];
SetSesquilinear::usage =
     "SetSequilinear[a,b,c,...] sets a,b,c,... to be functions \
      of two variables which are linear in the first variable \
      and conjugate linear in the second variable. See SetBilinear.";

Clear[SesquilinearQ];

SesquilinearQ::usage =
     "SesquilinearQ[x] will return true if SetSesquilinear[x] \
      was executed previously. See SetSesquilinear.";

Clear[SetBilinear];

SetBilinear::usage =
     "SetBilinear[b,c,d,...] sets b,c,d,... to be functions \
      of two variables which are linear in the first variable \
      and linear in the second variable. See SetSesquilinear.";

Clear[BilinearQ];

BilinearQ::usage =
     "BilinearQ[x] will return true if SetBilinear[x] was \
      executed previously. See SetBilinear.";

Clear[SetLinear];

SetLinear::usage =
     "SetLinear[b,c,d,...] sets b,c,d,... to be functions \
      of one variable which are linear.";

Clear[LinearQ];

LinearQ::usage =
     "LinearQ[x] will return true if SetLinear[x] was executed \
      previously. See SetLinear.";

Clear[SetConjugateLinear];

SetConjugateLinear::usage =
     "SetConjugateLinear[b,c,d,...] sets b,c,d ,...  to be functions \
      of one variable which are conjugate linear.";

Clear[ConjugateLinearQ];

ConjugateLinearQ::usage =
     "ConjugateLinearQ[x] will return true if SetConjugateLinear[x] \
      was executed previously. See SetConjugateLinear.";

Clear[SetIdempotent];

SetIdempotent::usage =
     "SetIdempotent[b,c,d,...] sets b,c,d,... to be functions of \
      one variable such that, for example, b[b[z_]]:=z; \
      Common examples are inverse,transpose and adjoint.";

Clear[IdempotentQ];

IdempotentQ::usage =
     "IdempotentQ[x] will return true if SetIdempotent[x] was \
      executed previously. See SetIdempotent.";

Clear[SetCommutingFunctions];

SetCommutingFunctions::usage =
     "SetCommutingFunctions takes exactly two parameters. \
      SetCommutingFunctions[b,c] will implement the \
      definitions b[c[z___]] := c[b[z]] /; Not[LeftQ[b,c]]; and \n \
      c[b[z___]] := b[c[z]] /; LeftQ[b,c]; \n \
      Common examples are the adjoint commuting with the transpose. \n \n \
      Note: The above implemention will NOT lead to infinite loops. \n \n \
      WARNING: If one says SetCommutingFunctions[b,c] and then \
      sets only LeftQ[c,b], then neither of the above rules \
      will be executed. Therefore, one must remember the order \
      of the two parameters in the statement. One obvious helpful \
      habit would be to use alphabetical order (i.e. say \
      SetCommutingFunctions[aj,tp] and not the reverse). \
      See CommuatingOperators and LeftQ.";

Clear[SetCommutingOperators];

SetCommutingOperators::usage =
     "SetCommutingOperators takes exactly two parameters. \
      SetCommutingOperators[b,c] will implement the definitions \
      which follow. They are is psuedo-code so that the meaning \
      will not be obscured \n \n
            b**c becomes c**b if !LeftQ[b,c]; and  \
            c**b becomes b**c if LeftQ[b,c];  \n \n
     Note: The above implemention will NOT lead to infinite loops. \n \n \
     WARNING: If one says SetCommutingOperators[b,c] and then \
     sets only LeftQ[c,b], then neither of the above rules \
     will be executed. Therefore, one must remember the order \
     of the two parameters in the statement. One obvious helpful \
     habit would be to use alphabetical order (i.e. say \
     SetCommutingOperators[a,b] and not the reverse). \
     See SetCommutingFunctions and LeftQ.";

Clear[LeftQ];

LeftQ::usage =
     "See SetCommutingFunctions and SetCommutingOpertors. \n \n \
      WARNING: LeftQ is shared by SetCommutingFunctions and \
      SetCommutingOperators.";

Clear[NonCommutativeMultiplyAntihomomorphism];

SetNonCommutativeMultiplyAntihomomorphism::usage = 
     "SetNonCommutativeMultiplyAntihomomorphism[b,c,d,...] \
      sets b,c,d,... to be functions of one variable \
      such that,for example, \n \
      b[anything1**anything2] becomes b[anything2]**b[anything1] \
                    if ExpandQ[b] is True; \n \
      b[anything2]**b[anything1] becomes b[anything1**anything2] \
                    if ExpandQ[b] is False; \
      Common examples are inverse,transpose and adjoint. \n \n \
      NOTE: The synonym NCAntihomo is easier to type.";

Clear[NCAntihomo];

NCAntihomo::usage =
     "Synonym for SetNonCommutativeMultiplyAntihomomorhism.";

Clear[NonCommutativeMultiplyHomomorphism];

SetNonCommutativeMultiplyHomomorphism::usage = 
     "SetNonCommutativeMultiplyHomomorphism[b,c,d,...] \
      sets b,c,d,... to be functions of one variable \
      such that,for example, \n \
      b[anything1**anything2] becomes b[anything1]**b[anything2] \
                    if ExpandQ[b] is True; \n \
      b[anything1]**b[anything2] becomes b[anything1**anything2] \
                    if ExpandQ[b] is False; \
      Common example is co. \n \n \
      NOTE: The synonym NCHomo is easier to type.";
      
Clear[NCHomo];

NCHomo::usage =
     "Synonym for SetNonCommutativeMultiplyHomomorhism.";
         
Clear[ExpandQ];

ExpandQ::usage =
     "See SetNonCommutativeMultiplyAntihomomrphism and \
      SetNonCommutativeMultiplyHomomrphism.";

Clear[SetExpandQ];

SetExpandQ::usage =
     "SetExpandQ[op, value] sets property ExpandQ[op] == value.";
      
Clear[TurnOffCommutingOperators];

TurnOffCommutingOperators::usage = 
      "After SetCommutingOperator[b,c], you may turn this functionality off by typing TurnOffCommutingOperators[b,c]; See also TurnOnCommutingOperators";

Clear[TurnOnCommutingOperators];

TurnOnCommutingOperators::usage = 
      "After using TurnOffCommutingOperators[b,c] (see TurnOnCommutingOperators) , you may turn this functionality back on by typing TurnOnCommutingOperators[b,c]; See also TurnOffCommutingOperators";

Begin[ "`Private`" ]

SetExpandQ[op_, value_] := (ExpandQ[op] ^= value);

SetSesq:=SetSesquilinear;

(* ------------------------------------------------------------ *)

SesquilinearQ[___] = False;

SetSesquilinear[a__]:=(Function[x,
        x[0,w_] := 0;
        x[z_,0] := 0;
        x[y_,z_+w_] := x[y,z] + x[y,w];
        x[y_+z_,w_] := x[y,w] + x[z,w];
        x[c_?NumberQ y_,z_] := c x[y,z];
        x[y_,c_?NumberQ z_] := Conjugate[c] x[y,z];
        (* x[y_/c_,z_] := (1/c) x[y,z] /; NumberQ[c]; *)
        (* x[y_,z_/c_] := (1/Conjugate[c]) x[y,z] /; NumberQ[c]; *)
        x[c_,z_] := c x[1,z] /; NumberQ[c]&& Not[TrueQ[c==1]];
        x[y_,c_] := Conjugate[c] x[y,1] /; NumberQ[c]&& Not[TrueQ[c==1]];
        x[-y_,z_] := -x[y,z];
        x[y_,-z_] := -x[y,z];
        SesquilinearQ[x] = True;
        ]
       /@{a});

(* ------------------------------------------------------------ *)

BilinearQ[___] = False;

SetBilinear[a__]:=(Function[x,
        x[0,w_] := 0;
        x[z_,0] := 0;
        x[y_,z_+w_] := x[y,z] + x[y,w];
        x[y_+z_,w_] := x[y,w] + x[z,w];
        x[c?NumberQ_ y_,z_] := c x[y,z];
        x[y_,c_?NumberQ z_] := c x[y,z];
        (* x[y_/c_,z_] := (1/c) x[y,z] /; NumberQ[c]; *)
        (* x[y_,z_/c_] := (1/c) x[y,z] /; NumberQ[c]; *)
        x[c_,z_] := c x[1,z] /; NumberQ[c]&& Not[TrueQ[c==1]];
        x[y_,c_] := c x[y,1] /; NumberQ[c]&& Not[TrueQ[c==1]];
        x[-y_,z_] := -x[y,z];
        x[y_,-z_] := -x[y,z];
        BilinearQ[x] = True;
        ]
       /@{a});

(* ------------------------------------------------------------ *)

LinearQ[___] = False;

SetLinear[a__]:=(Function[x,
        x[y_+z_] := x[y] + x[z];
        (* BEGIN MAURICIO MAR 2016 *)
        (* x[0] := 0; *)
        x[c_?NumberQ] := c;
        x[c_?NumberQ y_] := c x[y];
        (* x[y_/c_] := (1/c) x[y] /; NumberQ[c];  *)
        (* x[c_] := c x[1] /; NumberQ[c] && Not[TrueQ[c==1]]; *)
        (* x[-y_] := -x[y]; MAURICIO MAR 2016*)
        (* END MAURICIO MAR 2016 *)
        LinearQ[x] = True;
        ]
       /@{a});

(* ------------------------------------------------------------ *)

ConjugateLinearQ[___] = False;

SetConjugateLinear[a__]:=(Function[x,
        x[y_+z_] := x[y] + x[z];
        (* BEGIN MAURICIO MAR 2016 *)
        (* x[0] := 0; *)
        x[c_?NumberQ] := Conjugate[c];
        x[c_?NumberQ y_] := Conjugate[c] x[y];
        (* x[y_/c_] := (1/Conjugate[c]) x[y] /; NumberQ[c]; MAURICIO MAR 2016 *)
        (* x[c_] := Conjugate[c] x[1] /; NumberQ[c] && Not[TrueQ[c==1]]; *)
        (* x[-y_] := -x[y]; MAURICIO MAR 2016 *)
        (* END MAURICIO MAR 2016 *)
        ConjugateLinearQ[x] = True;
        ]
       /@{a});

(* ------------------------------------------------------------ *)

IdempotentQ[___] = False;

SetIdempotent[a__]:=(Function[x, x[x[z_]]:= z;
                                 IdempotentQ[x] = True;
                                 ] 
                                /@{a});

(* ------------------------------------------------------------ *)

(* BEGIN MAURICIO MAR 2016 *)

(*

SetCommutingFunctions[x_,y_] :=  
Function[{b,c},
          Literal[b[c[z___]]] := c[b[z]] /; Not[LeftQ[b,c]];  
          Literal[c[b[z___]]] := b[c[z]] /; LeftQ[b,c];
][x,y];

*)

SetCommutingFunctions[x_,y_] :=  
  Function[{opA,opB},
            opA[opB[z___]] := opB[opA[z]] /; Not[LeftQ[opA,opB]];
            opB[opA[z___]] := opA[opB[z]] /; LeftQ[opA,opB];
  ][x,y];

(* END MAURICIO MAR 2016 *)

(* ------------------------------------------------------------ *)

TurnOffCommutingOperators[b_,c_] := (
    CommutingOperatorsNow[b,c] := False;
    CommutingOperatorsNow[c,b] := False;
);

TurnOnCommutingOperators[x_,y_] := Function[{b,c},
  CommutingOperatorsNow[b,c] := True;
  CommutingOperatorsNow[c,b] := True;
][x,y];


(* ------------------------------------------------------------ *)

SetCommutingOperators[x_,y_] :=  
Function[{b,c},
  TurnOnCommutingOperators[b,c];
  SetNonCommutative[anything1,anything2];
  Literal[NonCommutativeMultiply[anything1___,b,c,anything2___]] :=
      NonCommutativeMultiply[anything1,c,b,anything2] /; 
         And[Not[LeftQ[b,c]],CommutingOperatorsNow[b,c]];  
  Literal[NonCommutativeMultiply[anything1___,c,b,anything2___]] :=
      NonCommutativeMultiply[anything1,b,c,anything2] /; 
         And[LeftQ[b,c],CommutingOperatorsNow[b,c]];  
][x,y];

(* ------------------------------------------------------------ *)

NCAntihomo = SetNonCommutativeMultiplyAntihomomorhism;

NCHomo = SetNonCommutativeMultiplyHomomorhism;

(* ------------------------------------------------------------ *)

(* BEGIN MAURICIO MAR 2016 *)

(*
SetNonCommutativeMultiplyAntihomomorhism[a__] := (Function[x,
    
          SetNonCommutative[anything1,anything2,anything3,anything4];

          x[y_^n_] := x[y]^n;

          x/:Literal[NonCommutativeMultiply[anything1___,
                                            x[anything2___],
                                            x[anything3___],
                                            anything4___]] :=
                  NonCommutativeMultiply[anything1,
                                         x[NonCommutativeMultiply[
                                            anything3,anything2]],
                                         anything4] /; ExpandQ[x]==False;

          x/:Literal[NonCommutativeMultiply[anything1___,
                                            x[NonCommutativeMultiply[anything3_,
                                              anything2___]],
                                            anything4___]] :=
                  NonCommutativeMultiply[anything1,
                                         x[NonCommutativeMultiply[anything2]],
                                         x[anything3],
                                         anything4] /; ExpandQ[x]==True;

          Literal[x[NonCommutativeMultiply[anything3_,anything2__]]] := 
                  NonCommutativeMultiply[x[NonCommutativeMultiply[anything2]],
                                         x[anything3]] /; ExpandQ[x]==True;
        ]
       /@{a});
*)

SetNonCommutativeMultiplyAntihomomorhism[ops__] := 
  ( Function[op,
      op/:NonCommutativeMultiply[left___, op[a___], op[b___], right___] :=
        NonCommutativeMultiply[left, 
                               op[NonCommutativeMultiply[b, a]],
                               right] /; ExpandQ[op]==False;

      (*
      op[NonCommutativeMultiply[a_, b__]] := 
        NonCommutativeMultiply[op[NonCommutativeMultiply[b]], 
                               op[a]] /; ExpandQ[op]==True;
      *)
             
      HoldPattern[op[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (op /@ Reverse[{a}])) /; ExpandQ[op]==True;
             
   ] /@{ops} );

SetNonCommutativeMultiplyHomomorhism[ops__] := 
  ( Function[op,
      op/:NonCommutativeMultiply[left___, op[a___], op[b___], right___] :=
        NonCommutativeMultiply[left, 
                               op[NonCommutativeMultiply[a, b]],
                               right] /; ExpandQ[op]==False;

      (*
      op[NonCommutativeMultiply[a_, b__]] := 
        NonCommutativeMultiply[op[a], 
                               op[NonCommutativeMultiply[b]]] /; ...
            ExpandQ[op]==True;
      *)

      HoldPattern[op[NonCommutativeMultiply[a__]]] := 
        (NonCommutativeMultiply @@ (op /@ {a})) /; ExpandQ[op]==True;
            
    ] /@{ops} );

(* END MAURICIO MAR 2016 *)

End[]

EndPackage[]

