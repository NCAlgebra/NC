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
	      "NCUtil`",
              "NonCommutativeMultiply`"];

Clear[NCDirectionalD, DirectionalD, NCGrad, NCHessian, NCIntegrate];

NCGrad::Failed = "Do not know how to calculate NCGrad. Expression `1` is most likely not rational or invalid.";
NCIntegrate::NotIntegrable = "Expression `1` is not integrable";

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
    Check[
      df = NCToNCPolynomial[
              NCDirectionalD @@ Prepend[Transpose[{{xs},hs}], f], 
           hs];
      ,
      Message[NCGrad::Failed, f];
      Return[$Failed];
      ,
      NCPolynomial::NotPolynomial
    ];

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

  (* NCIntegrate *)
  
  NCIntegrate[poly_, xhs__] := Module[
     {vars, directions, polyRule,
      antiderivative, remainder, rule,
      monomials, firstmon, symbols, dir,
      isRat, intMon, intMonD,
      nbrOfTerms, nbrOfDTerms,
      ratRule,ratPattern,x,h,
      a,b,c,A,B},

     vars = {xhs};
     directions = vars[[All, 2]];
     vars = vars[[All, 1]];

     polyRule = Thread[directions -> vars];
   
     (* Rational rules *)
     SetNonCommutative[a,b,c,x];
     SetCommutative[A,B];
     ratPattern[h_] := (A_:1) * left___ ** inv[a_] ** b___ ** (h|tp[h]) ** c___ ** inv[a_] ** right___;
     ratRule[x_, h_] := {
         (A_:1) * left___ ** inv[(a_:0) + (B_:1) x] ** h ** inv[(a_:0) + (B_:1) x] ** right___ :> -A/B left ** inv[a + B x] ** right,
         (A_:1) * left___ ** inv[(a_:0) + (B_:1) tp[x]] ** tp[h] ** inv[(a_:0) + (B_:1) tp[x]] ** right___ :> -A/B left ** inv[a + B tp[x]] ** right,
         (A_:1) * left___ ** inv[(a_:0) + (B_:1) b___ ** x ** c___] ** b___ ** h ** c___ ** inv[(a_:0) + (B_:1) b___ ** x ** c___] ** right___ :> -A/B left ** inv[a + B b ** x ** c] ** right,
         (A_:1) * left___ ** inv[(a_:0) + (B_:1) b___ ** tp[x] ** c___] ** b___ ** tp[h] ** c___ ** inv[(a_:0) + (B_:1) b___ ** tp[x] ** c___] ** right___ :> -A/B left ** inv[a + B b ** tp[x] ** c] ** right
     };
  
     (* TODO: CHECK LINEARITY OF poly *)
   
     remainder = NCExpand[poly];
     monomials = MonomialList[remainder];
     antiderivative = 0;

     (*
     Print["*** NCIntegrate ***"];
     Print["poly = ", poly];
     Print["vars = ", vars];
     Print["directions = ",directions];
     Print["remainder = ", remainder]; 
     Print["monomials = ", monomials];
     Print["antiderivative = ", antiderivative]; 
     Print["polyRule = ", polyRule];
     *)
   
     While[ !PossibleZeroQ[remainder],

	 (* Current number of terms *)    
	 nbrOfTerms = Length[monomials];

         (* Get first monomial *)
	 firstmon = First[monomials];

         (* Grab symbols in the first monomial *)
         symbols = NCGrabSymbols[firstmon];

	 (* Picks out the direction variable in the first monomial *)
         dir = Intersection[symbols, directions];
	 If[ Length[dir] != 1, 
             Message[NCIntegrate::NotIntegrable, poly];
             Return[$Failed];
	 ];
	 dir = First[dir];

	 (* Is rational *)
	 isRat = False;
	 rule = If[ MatchQ[firstmon, ratPattern[dir]],
	     (* rational *)
	     (* Print["### Possibly rational derivative ###"]; *)
	     isRat = True;
	     dirVar = vars[[First[Flatten[Position[directions, dir]]]]];
             ratRule[dirVar, dir]
	    ,
	     (* polynomial *)
             polyRule
	 ];

	 (* Integrate (polynomial) *)
	 intmon = firstmon /. rule;

	 (* Calculate the derivative *)
         intmonD = NCExpand[NCDirectionalD[intmon, xhs]];
	 nbrOfDTerms = Length[MonomialList[intmonD]];

	 (* update the polynomial by subtracting off the directional
            derivative of the integrated monomial *)

	 remainder = NCExpand[remainder - intmonD];
	 monomials = MonomialList[remainder];

         (*
	 Print["rule = ", rule];
         Print["nbrOfTerms = ", nbrOfTerms]; 
         Print["firstmon = ", firstmon]; 
         Print["symbols = ", symbols]; 
         Print["dir = ", dir];
         Print["intmon = ", intmon]; 
         Print["intmonD = ", intmonD]; 
         Print["nbrOfDTerms = ", nbrOfDTerms]; 
         Print["remainder = ", remainder]; 
         Print["monomials = ", monomials]; 
         *)
    
	 (* Checks to see if the number of terms decreases by the
            "right amount" upon subtracting the derivative *)
	 If[ !PossibleZeroQ[remainder] &&
             Length[monomials] != nbrOfTerms - nbrOfDTerms
            ,
             Message[NCIntegrate::NotIntegrable, poly];
             Return[$Failed];
	  ];

	  antiderivative += intmon;

    ];

    (*
    Print["antiderivative = ", antiderivative];
    Print["remainder = ", remainder];
    *)

    Return[antiderivative];
   
];
  
End[];

EndPackage[];
