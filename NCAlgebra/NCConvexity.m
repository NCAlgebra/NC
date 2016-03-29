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
             "NonCommutativeMultiply`", 
             "NCLDUDecomposition`", 
             "NCLinearAlgebra`",
             "NCQuadratic`",
	     "NCSimplifyRational`",
             "NCDiff`",
             "NCMatMult`"];

Clear[NCHessianOld];

NCHessianOld::usage=
     "NCHessian[] computes the Hessian
of a function of noncommutting variables and coefficients.
The Hessian recall is the second derivative.
Here we are computing the noncommutative directional derivative of a 
noncommutative function."

Clear[NCMatrixOfQuadraticOld];

NCMatrixOfQuadraticOld::usage=
	"NCMatrixOfQuadraticOld[]
	gives a vector matrix factorization of a symmetric quadratic
	function in noncommutative variables and their transposes."
      
Clear[NCConvexityRegion];

NCConvexityRegion::usage=
      "NCConvexityRegion is a function which can be used to determine where
	a noncommutative function is convex."

Clear[NCIndependenceCheck];

NCIndependenceCheck::usage=
      "NCIndependenceCheck is aimed at verifying whether
or not a given set of polynomials are independent or not.  It analyzes each
list of polynomials in {\\it aListofLists} separately."  
   
Clear[NCBorderVectorGather];

NCBorderVectorGather::usage=
      "NCBorderVectorGather can be used to gather  
the polynomial coefficents preceeding the elements given in a 
variable list whenever they occur in the list."
   

Options[NCConvexityRegion] = 
       {NCSimplifyDiagonal -> False, DiagonalSelection -> False,
        ReturnPermutation -> False, ReturnBorderVector -> False,
        AllPermutation -> False };
       
 
Begin["`Private`"];

(* BEGIN MAURICIO MAR 2016 *)
  NCGrabSymbols[exp_] := Union[Cases[exp, _Symbol, Infinity]];
  NCGrabSymbols[exp_, pattern_] := 
    Union[Cases[exp, (pattern)[_Symbol], Infinity]];
  
  Diag[x_] := Tr[x, List];
  
(* END MAURICIO MAR 2016 *)

(* list should be in form {x1,x2,...,xn}  *)

NCConvexityRegion[f_, list_, opts___Rule] :=
    Module[{dimoflist = Dimensions[{list}],Tmphes,LUdata,Hdata,Hdata1,
            simpiv,diagsel,returnperm,allperm,numofperm,n,k,diaglist ={},
            permlist ={},Tmpdiag,Tmplist,Tmplist1,Tmplist2,
            Tmpvar,Tmplist3,h,returnvec,lowestLeafCount,index,offDiagonal={},
            theDiagonal,dMatrix,dPerm,checker,Hdata1check,\[Lambda],Pull},
            
          
            simpiv      = NCSimplifyDiagonal /. {opts} /. Options[NCConvexityRegion]; 
            diagsel     = DiagonalSelection /. {opts} /. Options[NCConvexityRegion];
            returnperm  = ReturnPermutation /. {opts} /. Options[NCConvexityRegion];            
            returnvec   = ReturnBorderVector /. {opts} /. Options[NCConvexityRegion];
            allperm     = AllPermutation /. {opts} /. Options[NCConvexityRegion];       
     
            Pull[g_[x___]] := x;  
            (* Create temporary list of h's, {h1,h2,...hn} *)
            Tmplist3 = ToString[ Array[h,{Length[list]}] ];
            Tmplist3 = StringReplace[Tmplist3, {"[" -> "", "]" -> ""}];
            Tmplist3 = ToExpression[Tmplist3]; 
            SetNonCommutative[Pull[Tmplist3] ];         
            (* Get Hessian *)                     
            
             
            Tmphes = NCHessian[f, Pull[Thread[{list,Tmplist3}]]  ];
            

            (* In case they feed a linear function or something where the hessian
               is zero.  NCMatrixOfQuadratic will bomb on that input.  So just
               return 0 which is the correct output *)

            If[ Tmphes === 0, 
               Return[ {{0}} ];
            ];

  
            (* Factor Hessian *)          
            Hdata =  NCMatrixOfQuadratic[   Tmphes, Tmplist3  ];
                         
            (*******************************************************)
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

            If[ allperm === True,

               Print["Middle matrix is size ", n,"X",n ];
               Print["At most ", numofperm, " permutations possible."];

            ];


            (* Set up permutation list *)
            (* diagsel is the value of the option DiagonalSelection.
               diagsel is the list of permutations to give to 
               NCAllPermutationLDU.  It is given to NCConvexityRegion in the 
               form {n} or {n,k}.  Below {n} is changed to {1,....,n} and
               {n,k} is changed to {n,...k}.  These are then fed to 
               NCAllPermutationLDU.  If nothing is passed to NCConvexityRegion
               under DiagonalSelection, then the default is to use the permutation
               list {1}. *)
            If[diagsel === False,
               diagsel = {1};
            ,(*else*) 
               If[Length[diagsel] == 2,                   
                  diagsel = Range[diagsel[[1]],Min[diagsel[[2]],numofperm] ];
               ,(*else*)
                  diagsel = Range[Min[diagsel[[1]],numofperm] ];
               ];(*end if*)
            ];(*end if*)
            (* Now diagsel has the correct permutation selection    *)
            (********************************************************)

            If[ allperm === True,

               Print[diagsel];

            ];


            (* based on the AllPermutation option we decide what LDU decomposition
               to call.  There are two choices, based on whether AllPermutation is 
               True or False.  True means to run NCAllPermutationLDU and False
               means to run NCLDUDecomposition.  False is the default.  If it was 
               true then we also feed the Permutations to look at.  That was
               computed above. *)
            If[ allperm === True,

               (* Find LDU decompositon for diagsel permutations  *)
               LUdata = NCAllPermutationLDU[ Hdata[[2]], 
                            Stop2by2Pivoting -> False,
                            NCSimplifyPivots -> simpiv,
                            PermutationSelection -> diagsel,
                            ReturnPermutation -> True]; 

             ,
               LUdata = NCLDUDecomposition[ Hdata[[2]], 
                            Stop2by2Pivoting -> False,
                            NCSimplifyPivots -> simpiv,
                            ReturnPermutation -> True]; 

               LUdata = { LUdata };
             ];


(* OLD CODE...NOT USED NOW...WAS CHANGED ON 6/27/02 ----------------------------
                 
            (* Make a list of Diagonals and corresponding permutations *)                       
            For[i = 1, i <= Length[LUdata] - 1, i++,
                Tmpdiag = LUdata[[i]][[2]];   
                         
                (* Incase LDU decomposition is incomplete *)
                (* i.e. 2by2 permutation was needed       *)
                If[Tmpdiag[[n,n]] === 0,
                   (* find positon of diagonal block with *)
                   (* zeros along diagonal                *)
                   Tmplist = Diag[Tmpdiag];
                   Tmplist1 = Flatten[ Position[Tmplist, 0] ];
                   Tmplist2 = Tmplist1 - 
                      Range[Length[Tmplist] - Length[Tmplist1]+1,Length[Tmplist] ];
                   Tmpvar = Position[Tmplist2,0][[1,1]];
                   Tmpvar = Tmplist1[[Tmpvar]];
                  
                   (* (Tmpvar,Tmpvar) is the position of the top *)
                   (* left corner of diagonal block.              *)
                   n = Length[Tmpdiag];
                   Tmplist = Tmpdiag[[Range[Tmpvar,n], Range[Tmpvar,n] ]]; 
                   Tmpdiag = Diag[Tmpdiag][[Range[Tmpvar-1] ]]; 
                   If[Tmplist === NCZeroMatrix[n - Tmpvar + 1],
                      Tmplist = Diag[Tmplist];
                      Tmpdiag = AppendTo[Tmpdiag,Tmplist];
                      Tmpdiag = Flatten[Tmpdiag];
                   ,(* else *)
                      Tmpdiag = AppendTo[Tmpdiag,Tmplist[[1]]];
                     ]; (*end if*)                                      
                 ,(*else*)
                   Tmpdiag = Diag[Tmpdiag];
                  ];(* end if *)
                
                diaglist = AppendTo[diaglist, Tmpdiag];
                permlist = AppendTo[permlist, LUdata[[i]][[5]] ];
               ]; (* end for *)
            

END OF OLD CODE ----------------------------------------------------- *)

(* NEW CODE 6/27/02 *)

            (* find the simpliest diagonal by seeing which matrix
               has the lowest leafcount *)
                        
            lowestLeafCount = LeafCount[ LUdata[[1]][[2]] ];
            index = 1;
            For[i = 1, i <= Length[LUdata] - 1, i++,               
              If[ LeafCount[ LUdata[[i]][[2]] ] < lowestLeafCount,                  
                  index = i;
              ];    
            ];

            (* index should be the diagonal that we want to use *)
            dMatrix = LUdata[[index]][[2]];
            dPerm = LUdata[[index]][[5]];

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


(* END NEW CODE *)



            (* Tmplist = Union[permlist][[1]];
               Print[Length[Tmplist], " permutations return"];  *)
            
            (* Pertains to independence of the border vectors *)   
            If[returnvec == True,
               Hdata1 = Flatten[Hdata[[1]] ];
               Hdata1 = NCBorderVectorGather[Hdata1,Tmplist3];
               Hdata1check = NCIndependenceCheck[Hdata1,\[Lambda] ];
               If[Hdata1check === Table[True,{Length[Hdata1check]}],
                  Print["Border vectors are independent."];                  
               ,(*else*)
                  Print["Border vectors may be dependent.  Use NCIndependenceCheck."];
               ];(*end if*)
             ];(*end if*)


(* OLD CODE...NOT USED NOW...WAS CHANGED ON 6/27/02 ----------------------------
            If[returnperm === True,
               diaglist = Thread[{diaglist,permlist}];
               diaglist = Sort[diaglist,(LeafCount[#2] > LeafCount[#1])&];
               If[returnvec == True,                  
                  Return[{diaglist,  Hdata1} ];
               ,(*else*)
                  Return[diaglist];
               ];(*end if*)
            ,(*else*)
               diaglist = Sort[diaglist,(LeafCount[#2] > LeafCount[#1])&];
               If[returnvec == True,                  
                  Print[Hdata1];
                  Return[{diaglist, Hdata1} ];
               ,(*else*)
                  Return[diaglist];
               ];(*end if*)                
            ]; (*end if *)              
END OF OLD CODE  --------------------------------------------------------------*)

(* NEW CODE ------------ *)

            (* now we want to return our answer.  I just copied the old code from above and
               took some stuff out...since we are only returning one answer now instead
               of all the answers. *)

            (* check if we should return the permutations *)
            If[returnperm === True,
               If[returnvec == True,              
                  (* return the vector too. *)    
                  Return[ { theDiagonal ,  Hdata1} ];
               ,(*else*)
                  Return[ { theDiagonal } ];
               ];(*end if*)
            ,(*else*)
               If[returnvec == True,                  
                  Print[Hdata1];
                  Return[{ theDiagonal, Hdata1} ];
               ,(*else*)
                  Return[ { theDiagonal } ];
               ];(*end if*)                
            ]; (*end if *)              

(* END OF NEW CODE -----*)



];(*end NCConvexityRegion Module*)



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
               Tmpvar2 = Variables[CommuteEverything[Tmplist]  ];                
               
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
