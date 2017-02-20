(* :Title: 	NCConvexity.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	Hessian` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

BeginPackage["NCConvexity`",
             "NCSelfAdjoint`",
             "NCQuadratic`",
             "NCMatrixDecompositions`",
             "MatrixDecompositions`",
             "NCLinearAlgebra`",
	     "NCSimplifyRational`",
             "NCDiff`",
             "NCDot`",
             "NCUtil`",
             "NCDeprecated`",
             "NonCommutativeMultiply`"];

Clear[NCConvexityRegion];
Clear[NCIndependent];

NCIndependent::Inconclusive = "Linear dependence analysis was inconclusive. Further investigation recommended.";


NCConvexity::DependentBorder = "Border vector may be linearly dependent";
NCConvexity::NotSymmetric = "Expression is not symmetric.";

Options[NCConvexityRegion] = {
    SimplifyDiagonal -> False,
    CheckBorderIndependence -> True,
    DiagonalSelection -> False,
    AllPermutation -> False 
};

Begin["`Private`"];

    Get["NCConvexity.usage"];

    Clear[NCBorderVectorGather];

    Get["NCConvexity.private.usage"];

    (* BEGIN MAURICIO MAR 2016 *)
      Diag[x_] := Tr[x, List];
    (* END MAURICIO MAR 2016 *)

    (* list should be in form {x1,x2,...,xn}  *)

    NCConvexityRegion[expr_, vars_, opts___Rule] := Module[
      {simplifyDiagonal,checkBorderIndependence,
       isSymmmetric,symVars,pos,
       h,hs,xhs,hessian,
       ldl,p,s,rank,l,d,u,
       left,middle,right,tmp,independent},

       simplifyDiagonal = SimplifyDiagonal 
                                 /. {opts} /. Options[NCConvexityRegion];
       checkBorderIndependence = CheckBorderIndependence
                                 /. {opts} /. Options[NCConvexityRegion];
       
       (* Deprecate AllPermutation and DiagonalSelection *)
       If[AllPermutation /. {opts},
          Message[NCDeprecated::OptionGone, "AllPermutation"];
       ];
       If[DiagonalSelection /. {opts},
          Message[NCDeprecated::OptionGone, "DiagonalSelection"];
       ];

       (* Test symmetry *)
       {isSymmmetric, symVars} = NCSymmetricTest[expr];
       If[ isSymmetric, 
          Message[NCMatrixOfQuadratic::NotSymmetric];
 	  Return[{$Failed}];
       ];

       (* Create directions {h1,h2,...hn} *)
       hs = Table[Unique[h], Length[vars]];
       SetNonCommutative[hs];

       (* Determined symmetric variables *)
       pos = Flatten[Position[vars /. Thread[symVars -> True], True]];
       symVars = Join[symVars, hs[[pos]]];

       (* Create sequence of vars and directions {x1,h1}, {x2, h2}, ... *)
       xhs = Sequence @@ Transpose[{vars, hs}];

       (* Calculate Hessian *)
       hessian = NCHessian[expr, xhs];
       If[ hessian === 0, 
           Return[ {0} ];
       ];
                        
       (* Factor Hessian *)
       Quiet[
          Check[
             {left,middle,right} = NCMatrixOfQuadratic[hessian, hs,
  	                            SymmetricVariables -> symVars];
            ,
             Return[{$Failed}];
            ,
             NCMatrixOfQuadratic::NotSymmetric
          ];
         ,
           NCSymmetricQ::SymmetricVariables
       ];

       (* LDLDecomposition *)
       (* SelfAdjointMatrixQ -> (True&)] dispense with symmetry tests 
          already performed by NCMatrixOfQuadratic *)
       {ldl,p,s,rank} = NCLDLDecomposition[middle, 
                             SelfAdjointMatrixQ -> (True&)];
       {l,d,u} = GetLDUMatrices[ldl, s];

       (* Pertains to independence of the border vectors *)
       If[ checkBorderIndependence, 
	   If[ Not[NCIndependent[left]],
	       Message[NCConvexity::DependentBorder];
	   ];
       ];

       Return[ Map[Normal, GetDiagonal[d, s]] ];
    ];
    
    NCIndependent[list_] := Module[
        {y,vars,
         symbols,sum,
         commsum,coeffs,eqn,eqnsol},

        (* Print["*** NCIndependent ***"]; *)
        
        (* if zero is an element than already dependent *)
        If[ Length[Cases[list, 0]] > 0,
            Return[False];
        ];

        (* if list is a single non-zero entry, then independent *) 
        If[ Length[list] <= 1,
            Return[True];
        ];
        
        (* create list of scalars using argument "y" *) 
        vars = Table[Unique[Global`y], Length[list]];
        
        (* grab list of symbols in list *)
        symbols = DeleteCases[NCGrabSymbols[list], _?CommutativeQ]; 

        (* set up sum for independence check *)
        sum = vars. list;

        (* 
        Print["vars = ", vars];
        Print["symbols = ", symbols];
        Print["sum = ", sum];
        *)
        
        Quiet[

          (* turn rational independence check into *)
          (* polynomial independence check *)
          commsum = CommuteEverything[sum];
          commsum = Expand[Numerator[Together[commsum]]];

          (* gather coefficent infront of unique monomials *) 
          coeffs = Flatten[CoefficientList[commsum,symbols]];
          coeffs = DeleteCases[coeffs,0];

          EndCommuteEverything[];
         ,
          CommuteEverything::Warning
        ];

        (* set all entries of coeffs == 0 and then solve *)
        (* linear system of equations.                   *)
        eqn = Thread[coeffs == 0];
            
        Quiet[ eqnsol = Solve[eqn][[1]];
              ,
               Solve::svars
        ];

        (* apply solution to vars *)
        vars = vars //. eqnsol;

        (*
        Print["commsum = ", commsum];
        Print["coeffs = ", coeffs];
        Print["eqn = ", eqn];
        Print["eqnsol = ", eqnsol];
        Print["vars = ", vars];
        *)
                       
        If[ And @@ Map[(#===0)&, vars],
            (* all variables are zero *)
            Return[True];
        ];

        (*else not all variables are zero *)
        (* apply solution to original expression *)
        sum = sum //. eqnsol;

        (*
        Print["sum = ", sum]; 
        *)

        sum = NCSimplifyRational[sum];
        
        (*
        Print["sum = ", sum];
        *)
        
        If[ sum === 0,
            Return[False];
        ];

        (* undetermined, further analysis needed *)
        Message[NCIndependent::Inconclusive];
        Return[True];
        
    ];
     
End[];
EndPackage[];
