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

Clear[NCDirectionalD, DirectionalD, NCGrad, NCHessian];

Get["NCDiff.usage"];

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
               
  NCDirectionalD[f_, xhs__List] := 
    Plus @@ Map[(DirectionalD @@ Prepend[##, f])&, {xhs}];

  (* NCHessian *)
               
  NCHessian[f_, xhs__List] := 
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
                      Map[NCPCoefficients[df, {#}]&, hs], {2}], {1}];
      
    (* Terms in tp[hs] *)
    grad += Map[tp, 
                Apply[Plus, 
                      Map[NCGradAux, 
                          Map[NCPCoefficients[df, {#}]&, Map[tp,hs]], {2}], {1}]];

    (* Terms in aj[hs] *)
    grad += Map[aj, 
                Apply[Plus, 
                      Map[NCGradAux, 
                          Map[NCPCoefficients[df, {#}]&, Map[aj,hs]], {2}], {1}]];
      
    (* Print["hs = ", hs];
       Print["df = ", df];
       Print["grad = ", grad]; *)

    Return[If [n > 1, grad, Part[grad, 1]] ];
      
  ];
      
End[];

EndPackage[];
