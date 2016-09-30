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
             "NCMatMult`",
             "NCUtil`",
             "NCDeprecated`",
             "NonCommutativeMultiply`"];

Clear[NCConvexityRegion];

NCConvexity::DependentBorder = "Border vector may be linearly dependent";
NCConvexity::NotSymmetric = "Expression is not symmetric.";

Options[NCConvexityRegion] = {
    SimplifyDiagonal -> False,
    CheckBorderIndependence -> False,
    DiagonalSelection -> False,
    AllPermutation -> False 
};

Begin["`Private`"];

    Get["NCConvexity.usage"];

    Clear[NCIndependenceCheck,
          NCBorderVectorGather];

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
	   tmp = NCBorderVectorGather[left, hs];
	   independent = NCIndependenceCheck[tmp, \[Lambda] ];

	   (*
	   Print["left = ", left];
	   Print["tmp = ", tmp];
	   Print["independent = ", independent];
	   *)

	   If[ Not[And @@ independent],
	       Message[NCConvexity::DependentBorder];
	   ];
       ];

       Return[ Map[Normal, GetDiagonal[d, s]] ];
    ];

    NCIndependenceCheck[list_,y___] := 
         Module[{Tmpvar,Tmpvar2,Tmpexp,Tmpexp2,coeflist,equasolved,setozero,
                 n = Length[list],Tmplist,Tmplist2,dirs,Finlist = {},
                 Tmpfun,\[Lambda]},

                (* check for proper input of list *)
                If[Not[Head[list[[1]] ] === List],
                   Print["Error in input list"];
                   Abort[];
                  ];(*endif*)            
                (* end check of list *)

                For[i = 1, i <= n, i++,
                    Tmplist = list[[i]];
                    (* if Tmplist is a number, then obviously independent *) 

                    (* if zero is an element than already dependent *)
                    If[Not[Length[Tmplist] == Length[DeleteCases[Tmplist,0]] ],
                       Finlist = AppendTo[Finlist,False];
                    ,(*else*)

                   (* create list of scalars using argument "y" *) 
                   If[Length[{y}] > 0,
                      Tmpfun[x_] := Subscript[y,x];
                   ,(*else*)
                      Tmpfun[x_] := Subscript[\[Lambda],x];
                   ];(*endif*)
                   Tmpvar = Map[Tmpfun,Range[Length[Tmplist]] ];                                       
		   Quiet[

                   (* create a list of all variables in argument "list" *)
                   Tmpvar2 = Variables[CommuteEverything[Tmplist]]; 

                   (*set up sum for independence check *)
                   Tmpexp2 = ({Tmpvar}.Transpose[{Tmplist}])[[1,1]];              

                   (* turn rational independence check into *)
                   (* polynomial independence check *)
                   Tmpexp = CommuteEverything[Tmpexp2];
                   Tmpexp = Together[Tmpexp];
                   Tmpexp = Numerator[Tmpexp];
                   Tmpexp = Expand[Tmpexp];

                   (* gather coefficent infront of unique monomials *) 
                   coeflist = Flatten[{CoefficientList[Tmpexp,Tmpvar2]}];
                   coeflist = DeleteCases[coeflist,0];

                   (* set all entries of coeflist == 0 and then solve *)
                   (* linear system of equations.  This returns       *)
                   (* solutions in form of rules.  Next we apply      *)
                   (* rules to Tmpexp2 (the noncommuting one)         *)
                   setozero[x_] := x == 0;               
                   Off[Solve::svars];
                   equasolved = Solve[Map[setozero,coeflist] ][[1]];
                   On[Solve::svars];

                   EndCommuteEverything[];

		   ,
		   CommuteEverything::Warning
		   ];

                   Tmplist2 = Tmpvar //. equasolved;                           
                   If[Tmplist2 === NCZeroMatrix[ Length[Tmplist2] ][[1]],
                      (* all variables must be zero, implying *)
                      (* independence                         *)
                       Finlist = AppendTo[Finlist,True];

                   ,(*else not all lambda's are set to zero  *)

                      Tmpexp2 = Tmpexp2 //. equasolved;
                      Tmpexp2 = NCSimplifyRational[Tmpexp2];
                      If[Tmpexp2 === 0,                     
                         Finlist = AppendTo[Finlist,{False,Tmplist2}];
                      ,(*else undetermined, further analysis needed *)
                         Finlist = AppendTo[Finlist,{"Undetermined",Tmpexp2,Tmplist2}];
                        ];(*endif*)
                     ];(* end all var zero if*)                 
                  ];(*end zero is an element if*)  
                ];(*endfor*) 
                Return[Finlist];                 
    ];(*end module*) 


    NCBorderVectorGather[list_, var_] :=
         Module[{Tmpvar,Tmplist1,Tmplist2,firstelm,Finlist = {}},

                For[i=1, i<= Length[var], i++,

                    Tmpvar = var[[i]];
                    firstelm[xlist_] := {xlist[[1]]};
                    Tmplist1 = Position[list,Tmpvar];

                    Tmplist1 = Map[firstelm, Tmplist1];

                    Tmplist2 = Position[list,tp[Tmpvar]];
                    Tmplist2 = Map[firstelm,Tmplist2];

                    Tmplist1 = Complement[Tmplist1,Tmplist2];


                    Tmplist1 = Extract[list,Tmplist1];

                    Tmplist2 = Extract[list,Tmplist2];

                    Tmplist1 = Tmplist1 //.{Tmpvar -> 1};
                    Tmplist2 = Tmplist2 //.{tp[Tmpvar] -> 1};


                    If[Length[Tmplist1] > 0,
                       Finlist = AppendTo[Finlist,Tmplist1];
                      ];(*endif*)
                    If[Length[Tmplist2] > 0,
                       Finlist = AppendTo[Finlist,Tmplist2];
                      ];(*endif*)

                   ];(*end for*) 
                 Return[Finlist];

    ];(*end module*)
     
End[];
EndPackage[];
