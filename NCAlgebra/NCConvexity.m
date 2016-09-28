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

Options[NCConvexityRegion] = {
    NCSimplifyDiagonal -> False, 
    DiagonalSelection -> False,
    ReturnPermutation -> False, 
    ReturnBorderVector -> False,
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

    NCConvexityRegion[f_, list_, opts___Rule] :=
        Module[{dimoflist = Dimensions[{list}],Tmphes,LUdata,Hdata,Hdata1,
                simplifyDiagonal,diagonalSelection,returnPermutation,allperm,numofperm,n,k,diaglist ={},
                permlist ={},Tmpdiag,Tmplist,Tmplist1,Tmplist2,
                Tmpvar,Tmplist3,h,returnBorderVec,lowestLeafCount,index,offDiagonal={},
                theDiagonal,dMatrix,dPerm,checker,Hdata1check,\[Lambda],Pull},


                simplifyDiagonal      = NCSimplifyDiagonal /. {opts} /. Options[NCConvexityRegion]; 
                diagonalSelection     = DiagonalSelection /. {opts} /. Options[NCConvexityRegion];
                returnPermutation  = ReturnPermutation /. {opts} /. Options[NCConvexityRegion];            
                returnBorderVec   = ReturnBorderVector /. {opts} /. Options[NCConvexityRegion];
                allPermutation     = AllPermutation /. {opts} /. Options[NCConvexityRegion];       

                (* Deprecate AllPermutation and DiagonalSelection *)
                If[allPermutation,
                   Message[NCDeprecated::OptionGone, "AllPermutation"];
                ];
                If[diagonalSelection,
                   Message[NCDeprecated::OptionGone, "DiagonalSelection"];
                ];

                (* Create temporary list of h's, {h1,h2,...hn} *)
                Pull[g_[x___]] := x;  
                Tmplist3 = ToString[ Array[h,{Length[list]}] ];
                Tmplist3 = StringReplace[Tmplist3, {"[" -> "", "]" -> ""}];
                Tmplist3 = ToExpression[Tmplist3]; 
                SetNonCommutative[Pull[Tmplist3] ];         

                        
                (* Calculate Hessian *)

                Tmphes = NCHessian[f, Pull[Thread[{list, Tmplist3}]]];
                If[ Tmphes === 0, 
                   Return[ {{0}} ];
                ];

                        
                (* Factor Hessian *)
                        
                Check[
                   Hdata = NCMatrixOfQuadratic[Tmphes, Tmplist3];
                  ,
                   Return[{}];
                  ,
                   NCMatrixOfQuadratic::NotSymmetric
                ];

                (******************************************)
                (* Determine which permutations to return for NCAll... *)   

                (* Find the maximum number of permutations for matrix  *)
                {n,k} = Dimensions[ Hdata[[2]] ];
                numofperm = 1;
                If[n <= 5,
                For[i = 1, i <= n, i++,
                    numofperm = numofperm*(i!);
                   ];
                ,(* else *)
                    numofperm = 5!*4!*3!*2;
                ];

                (* Set up permutation list *)
                diagonalSelection = {1};


                (* Calculate LDLDecomposition *)
                
                LUdata = NCLDLDecomposition[
                       Hdata[[2]], 
                       SelfAdjointMatrixQ -> (True&)];
                LUdata = Append[
                       GetLDUMatrices[LUdata[[1]], LUdata[[3]]], 
                       LUdata[[2]]];

                (* index should be the diagonal that we want to use *)
                dMatrix = LUdata[[2]];
                
                (* get the diagonal *)
                theDiagonal = Diag[ dMatrix ];

                (* get the offdiagonal and at the same time check for nonzero 
                   off-diagonal entries. *)

                checker = False;                 
                For[ i = 1, i + 1 <= n, i++,
                   If[ dMatrix[[i]][[i+1]] === 0, null;  , checker = True; ];
                   offDiagonal = Append[ offDiagonal, dMatrix[[i]][[i + 1]] ];
                ];

                (* If there were off-diagonal elements then.... *)
                If[ checker === True,

                  Print["L**D**tp[L] gave non-trivial blocks, so the output list is: { {diagonal},{subdiagonal},{-subdiagonal} }"];
                  theDiagonal = { theDiagonal, offDiagonal, -offDiagonal };
                ];

                (* Pertains to independence of the border vectors *)   
                If[returnBorderVec == True,
                   Hdata1 = Flatten[Hdata[[1]] ];
                   Hdata1 = NCBorderVectorGather[Hdata1,Tmplist3];
                   Hdata1check = NCIndependenceCheck[Hdata1,\[Lambda] ];
                   If[Hdata1check === Table[True,{Length[Hdata1check]}],
                      Print["Border vectors are independent."];          
                   ,(*else*)
                      Print["Border vectors may be dependent.  Use NCIndependenceCheck."];
                   ];(*end if*)
                 ];(*end if*)

                (* now we want to return our answer. *)

                (* check if we should return the permutations *)
                If[returnBorderVec == True,              
                   (* return the vector too. *)    
                   Return[ { theDiagonal ,  Hdata1} ];
                 ,(*else*)
                   Return[ { theDiagonal } ];
                ];
    ];



    NCIndependenceCheck[list_,y___] := 
         Module[{Tmpvar,Tmpvar2,Tmpexp,Tmpexp2,coeflist,equasolved,setozero,
                 n = Length[list],Tmplist,Tmplist2,Tmplist3,Finlist = {},
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


    NCBorderVectorGather[list_,var_] :=
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
