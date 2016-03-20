(* :Title: 	NCInverses // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings:
*)

(* :History: 
  3/3/2016: clean up (mauricio)
*)


BeginPackage[ "NonCommutativeMultiply`" ];

Clear[Id];

Id::usage =
"Identity element. Actually Id is now set = 1.";

inv::usage =
"inv[x] is a 2-sided identity of x.";

Begin[ "`Private`" ]

  (* inv is NonCommutative *)
  SetNonCommutative[inv];

  (* identity *)
  Id = 1;
  (* NonCommutativeMultiply[a___,Id,c___] := NonCommutativeMultiply[a,c]; *)

  (* commutative inverse *)
  inv[a_?CommutativeQ] := a^(-1);
  inv[a_?NumberQ] := 1/a;

  (* inv is idempotent *)
  inv[inv[a_]] := a;

  (* tp threads over Times *)
  inv[a_Times] := inv /@ a;

  (* NC simplifications *)
  inv/:NonCommutativeMultiply[b___,a_,inv[a_],c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,inv[a_],a_,c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,a__,
                              inv[NonCommutativeMultiply[a__]],c___] :=
         NonCommutativeMultiply[b,c];
  inv/:NonCommutativeMultiply[b___,
                              inv[NonCommutativeMultiply[a__]],a__,c___] :=
         NonCommutativeMultiply[b,c];

  (* MAURICIO MAR 2016 *)
  (* THESE OLD RULES ARE UNECESSARY *)
  (* 
    inv/:NonCommutativeMultiply[b___,f_[x___],inv[f_[x___]],c___]:=
       NonCommutativeMultiply[b,Id,c]; 
    inv/:Literal[NonCommutativeMultiply[b___,inv[f_[x___]],f_[x___],c___]]:=
       NonCommutativeMultiply[b,Id,c];
  *)
  (*
    inv/:Literal[NonCommutativeMultiply[inv[a_],b_]] :=
                 NonCommutativeMultiply[b,inv[a]] /; 
                   Not[Head[b]==inv] && 
                   NonCommutativeMultiply[a,b] == NonCommutativeMultiply[b,a]

    Literal[inv[NonCommutativeMultiply[a___,b_,c_,d___]]] := 
	NonCommutativeMultiply[inv[NonCommutativeMultiply[c,d]], 
                               inv[NonCommutativeMultiply[a,b]]] /; 
                                                     ExpandQ[inv] == True;

    inv/:Literal[NonCommutativeMultiply[a___,inv[b_],inv[c_],d___]] :=
        NonCommutativeMultiply[a,inv[NonCommutativeMultiply[c,b]],d] /; 
                                                       ExpandQ[inv] == False;

    inv/:Literal[NonCommutativeMultiply[inv[b_],inv[c_]]] :=
  	inv[NonCommutativeMultiply[c,b]] /; ExpandQ[inv] == False;
  *)
  (* MAURICIO THINKS THESE RULES ARE MATHEMATICALLY INCORRECT 
    AND COULD LEAD TO PROGRAMMING MISTAKES *)
  (*
    inv/:Literal[Times[b___,a_,inv[a_],c___]]:=
       Times[b,Id,c];
    inv/:Literal[Times[b___,inv[a_],a_,c___]]:=
       Times[b,Id,c];
    inv/:Literal[Times[b___,f_[x___],inv[f_[x___]],c___]]:=
       Times[b,Id,c]; 
    inv/:Literal[Times[b___,inv[f_[x___]],f_[x___],c___]]:=
       Times[b,Id,c];
  *)
  (* END MAURICIO MAR 2016 *)

End[]

EndPackage[]
