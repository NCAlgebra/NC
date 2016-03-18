(* :Title: 	NCDiff *)

(* :Author: 	mauricio *)

(* :Context: 	NCDiff` *)

(* :Summary:    NCDiff is a package containing several functions that 
		are used in noncommutative differention of functions,
		and polynomials.
*)

(*
*)

(* :Warnings:
*)

(* :History: *)

BeginPackage[ "NCDiff`", 
              "NCPolynomial`",
              "NonCommutativeMultiply`"];

Clear[DirectionalD];
DirectionalD::usage = "\
DirectionalD[f, var, h] takes the directional derivative of \
expression f with respect to variable var in direction h.

See NCDirectionalD.";

Clear[NCDirectionalD];
NCDirectionalD::usage = "\
NCDirectionalD[f, {var1, h1}, ...] takes the directional \
derivative of expression f with respect to variables var1, \
var2, ... successively in the directions h1, h2, ....

See DirectionalD.";

Clear[NCGrad];
NCGrad::usage = "\
NCGrad[f, var1, ...] gives the nc gradient of the expression f with \
respect to variables var1, .... If there is more than one variable \
then NCGrad returns the gradient in a list.

The transpose of the gradient of the nc expression f is the derivative \
with respect to the trace of the directional derivative of f \
in the direction h.

For example, if
\tf = x**a**x**b + x**c**x**d
then its directional derivative in the direction h is 
\tdf = h**a**x**b + x**a**h**b + h**c**x**d + x**c**h**d
and its nc gradient is
\tgradf = a**x**b + b**x**a + c**x**d + d**x**c
      
IMPORTANT: The expression returned by NCGrad is the transpose or the \
adjoint of the standard gradient. This is done so that no assumption \
on the symbols are needed. The calculated expression is correct even \
if symbols are self-adjoint or symmetric.
       
See also NCDirectionalD.";

Clear[NCHessian];
NCHessian::usage = "\
NCHessian[f, {var1, h1}, ...] takes the second directional \
derivative of expression f w.r.t. variables var1, var2, ... \
successively in the directions h1, h2, ....

See also NCDiretionalD, NCGrad."

Begin["`Private`"];

  (* DirectionalD *)
               
  Clear[NCDAux];
  NCDAux[inv[f_], x_] := -inv[f] ** NCDAux[f, x] ** inv[f];
  NCDAux[f_Plus, x_] := Map[NCDAux[#,x]&, f];
  NCDAux[f_NonCommutativeMultiply, x_] := 
    Plus @@ 
      MapIndexed[NonCommutativeMultiply @@ 
                 ReplacePart[List @@ f, 
                             First[#2] -> NCDAux[#1,x]]&, List @@ f];
  NCDAux[f_Times, x_] :=
    Plus @@ 
      MapIndexed[Times @@ 
                 ReplacePart[List @@ f, 
                             First[#2] -> NCDAux[#1,x]]&, List @@ f];
  NCDAux[f_, x_] := D[f, x];
          
  DirectionalD[f_, x_, h_] := Module[
     {T},
     SetCommutative[T];
     (* Print["f = ", f]; *)
     tmp = f /. x -> x + T h /. Conjugate[T] -> T;
     (* Print["tmp1 = ", tmp]; *)
     tmp = NCDAux[tmp, T] /. T -> 0;
     (* Print["tmp2 = ", tmp]; *)
     Return[tmp];
  ];

  (* NCDirectionalD *)
               
  NCDirectionalD[f_, xhs__] := 
    Plus @@ Map[(DirectionalD @@ Prepend[##, f])&, {xhs}];

  (* NCHessian *)
               
  NCHessian[f_, xhs__] := 
    NCDirectionalD[NCDirectionalD[f, xhs], xhs];
               
  (* NCGradAux *)
  Clear[NCGradAux];
  NCGradAux[{scalar_, term1_, term2_}] := scalar * term2 ** term1;

  (* NCGrad *)
  NCGrad[f_, xs__] := Module[
    {n = Length[{xs}], hs, df, grad, tmp},

    (* Create directions *)
    hs = Table[Unique["$h"], n];
    SetNonCommutative[hs];

    (* Calculate directional derivative *)
    df = NCToNCPolynomial[
            NCDirectionalD @@ Prepend[Transpose[{{xs},hs}], f], hs];

    (* Inititalize gradient *)
    grad = ConstantArray[0, n];
      
    (* Terms in hs *)
    grad += Apply[Plus, 
                  Map[NCGradAux, 
                      Map[NCPTerm[df, #]&, hs], {2}], {1}];
      
    (* Terms in tp[hs] *)
    grad += Map[tp, 
                Apply[Plus, 
                      Map[NCGradAux, 
                          Map[NCPTerm[df, #]&, Map[tp,hs]], {2}], {1}]];

    (* Terms in aj[hs] *)
    grad += Map[aj, 
                Apply[Plus, 
                      Map[NCGradAux, 
                          Map[NCPTerm[df, #]&, Map[aj,hs]], {2}], {1}]];
      
    (* Print["hs = ", hs];
       Print["df = ", df];
       Print["grad = ", grad]; *)

    Return[If [n > 1, grad, Part[grad, 1]] ];
      
  ];
      
End[];

EndPackage[];
