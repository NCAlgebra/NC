(* :Title: 	NCConvexity.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context: 	Hessian` *)

(* :Summary:

			It is included the Hessian code and
			the Building of the coeficient matrix
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
    :3/3/16: Remove dependence on Grabs. (mauricio)
    :3/13/13: Deprecated LinearAlgebra`MatrixManipulation`. (mauricio)
    :8/31/04: Fixed string error in usage statement (\it vs. \\it). (mstankus)
    :6/27/02: - (tony s.) Changed NCConvexityRegion.  Set Stop2by2Pivoting
              to be False in the call to NCAllPermutationLDU.  Fixed code 
              after it to read off the diagonal and off-diagonal.  If D is not diagonal
              then it returns a list with diagonal and off-diagonal entries.
    :7/17/02: - (tony s. ) Changed NCConvexityRegion.  Added an option called
              AllPermutation which defaults to False.  If you set it to True
              then it uses NCAllPermutationLDU and if it is False then it
              uses NCLDUDecomposition.
    :7/18/02: - (tony s.) Changed NCConvexityRegion.  Changed the ouput to not say anything 
              about permutations unless AllPermutation is set to True.
    :8/28/02: - (tony s.) Fixed NCMatrixOfQuadratic.  The problem before was that when
              it tried to reorder the left and right vectors it was removing all the 
              transposes in the tmpLvector and tmpRvector.  This creates a problem when the 
              user thinks of some of the variables as selfadjoint.  So now the code only  
              removes transposes of variables that are selfadjoint.  Anyways, I added tons 
              of comments to the old code so the next person that has to debug can understand it
              much faster.  An example that it bombed on before was:

              p = (3 + 5*x) ** inv[7 + 11*x] + tp[ (3 + 5*x) ** inv[7 + 11*x] ];
              hes = NCHessian[ NCExpand[p], {x, h} ]
              {l, m, r} = NCMatrixOfQuadratic[ hes, {h} ];
              
              In this case, m didn't come out symmetric because the left and right vectors were 
              not transposes of each other.  The code wasn't able to rearrange the left and right
              vectors because it was confused after it removed all the transposes and so it had
              double matches.  Anyways, this will only make sense if you run the old code and try 
              to see what it was doing.

              ALSO, the code should work with commutative variables thrown in.  But it did this
              before.  This isn't a fix, just a note to tell you.
    :8/28/02: - (tony s.) Changed NCMatrixOfQuadratic so that if you feed it 0 as the input it 
              will return the zero matrices and left and right vectors.  Before it would bomb.
              I also changed the comment if side = {} to something more user-friendly.
*)

 
BeginPackage["NCConvexity`",
             "NCLDUDecomposition`", 
             "NonCommutativeMultiply`", 
             "NCLinearAlgebra`",
             (* "Grabs`", *)
	     "NCSimplifyRational`",
             "NCDiff`",
             "NCMatMult`"];

Clear[NCHessian];

NCHessian::usage=
     "NCHessian[] computes the Hessian
of a function of noncommutting variables and coefficients.
The Hessian recall is the second derivative.
Here we are computing the noncommutative directional derivative of a 
noncommutative function."

Clear[NCMatrixOfQuadratic];

NCMatrixOfQuadratic::usage=
	"NCMatrixOfQuadratic[]
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


(* Code for the NCHessian *)

(* list should be entered as {{x1, h1}, {x2, h2}, ..., {xn, hn}} *)

(* Juan changed (standard) to  {x1, h1}, {x2, h2}, ..., {xn, hn} *)

NCHessian[f_, listtmp__] :=
    Module[{dimoflist = Dimensions[{listtmp}], n, k, iter, dirder, hessian,list},
      list = {listtmp};
      
     
      (* check for proper list inputed *)	  
      If[Not[Length[dimoflist] == 2],
        Print["Error in input list !!! \n"], (* else *)
        If[Not[dimoflist[[2]] == 2],
             Print["Error in input list!!!\n"]; ];
        ]; (* end if *)
        
      {n, k} = dimoflist;
       
      (* compute first derivative of f *)
      dirder =  0;
      For[iter = 1, iter <= n, iter++,
        dirder =  dirder + DirectionalD[f, list[[iter, 1]], list[[iter, 2]]];
        ]; (* end for *)
      (* compute hessian *)
       hessian = 0;
      For[iter = 1, iter <= n, iter++,
        hessian = 
            hessian + 
              DirectionalD[dirder, list[[iter, 1]], list[[iter , 2]]];
        ];  (* end for *)
      hessian = ExpandNonCommutativeMultiply[hessian];
     
      Return[hessian];
      ];



(* MANY MANY COMMENTS HAVE BEEN ADDED...8/28/02 *)
(* the order of the code is as follows: it makes the left and right border vectors.  
   then it fixes them so they are transposes of each other ( sometimes when it 
   makes them it puts them out of order...actually this almost always happens ).
   then it makes the middle matrix.  then its done.  note:  the code calls the 
   middle matrix the B matrix. *)

(* list should be entered in form {h1, h2, ...., hn}  *)
NCMatrixOfQuadratic[exp1_, list1_] :=
    Module[{Tp,sidevectors, bothSides, n = Length[list1], exp,list = list1,
            symcheck, symtrue, tmpLvector, tmpRvector, Removetps, permcount,
            tmpPos, tmpPerm, tmpElm, vars, terms, transposeRemovalRules},

       (* clear all variables to be used *)
       ClearAll[ left, middle, right];
       ClearAll[splitterm, side, i, bothSides, H, K];
       ClearAll[leftvector, rightvector, tmpRule, Bmat, n2];
       ClearAll[doRule, teste, j];
       (* end of variable clear *)


      (* If the expression is 0 then just return the zero vectors *)
      If[ exp1 === 0, 
         Return[{ {{0}}, {{0}}, {{0}} }];
      ];

    
      (* check that list is entered in proper form *)
      If[Not[list == Flatten[list] ] || Length[Flatten[list]] == 0,
        Print["List inputed improperly !!!"];
        Abort[];
        ];
      (* end check *)
      
      (* add transposes to list of variables *)
      For[i = 1, i <= n, i++,
          AppendTo[  list, tp[ list[[i]] ]  ];
         ]; (* end for *)
      n = Length[list];  
      
      exp = ExpandNonCommutativeMultiply[exp1];
                 
      SetNonCommutative[left, middle, right, H, K];
       
      Pull[f_[x___]] := x;             
      If[Head[exp] === Plus,	splitterm = List[Pull[exp]],	
      splitterm = {exp}]; (* turn sum of terms into list *)

 
      (* WHAT THE HELL IS GOING ON?
         The way the code works is as follows.  First it builds the left and right 
         vectors.  But it does it in a way that you need to reorder them so that they
         are transposes of one another.  Now when it reorders them it builds a temporary
         left and right vector.  In these vectors it removes the tranposes of variables
         that appear to be selfajoint from the input.  Then it uses this info to rearrange
         the left and right vectors so that they match up and are transposes of each other.
         there are many more comments in the code.
      *)


      (* Build the left and right vectors *)	
      side = {};
      For[j = 1, j <= n, j++,
         For[i = 1, i <= n, i++,

            bothSides =  { (number1_:1)*left___ ** list[[i]] ** middle___ ** list[[j]] ** right___ :> 
		      { NonCommutativeMultiply[ left ** H], NonCommutativeMultiply[K ** right ] }
                         };

            side = Join[Select[splitterm, MatchQ[#, bothSides[[1]][[1]] ] & ] 
                        //. bothSides  //. {H -> list[[i]], K ->  list[[j]]}, side];

          ];  (*  end inner for *)
        ]; (* end outer for *)
       
      If[ side == {}, 
	 Print["Something bad happened.  Possibly bad input?"]; 
	 Abort[]; 
      ]; (* end if *)
	 

      (* after the following line we will have the left and the right vectors *)
      {leftvector, rightvector} = Map[Union, Thread[side]];

      n2 = Length[Flatten[leftvector]];


      (* the symmetry checker below tries to reorder the left and right vectors 
         so that they are transposes of each other *)

      (* ******************** *)
      (* Begin Symmetry check *)
      If[n2 != Length[rightvector],   (* begin symmetry if *)
         Print["Left and right vector differ in length...symmetry impossible!"];
         
      , (* else *)
     
       (* must make sure vectors have proper order with respect to symmetry *)
       symcheck = Flatten[Table[False, {1}, {n2} ] ];
       
       (* because last term will not be checked by default *)
       symcheck[[n2]] = True;
       
       (* symtrue will be used to check if symmetrization worked *)
       symtrue  = Flatten[Table[True,  {1}, {n2} ] ];  
           
       tmpLvector = Flatten[ tpMat[{leftvector}] ];
      

       (* NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE *)
       (* Below is the new code that was added on 8/28/02 *)
       (* NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE *)


       (* We will now build the transformation rules.  
          We need to know which variables the user is thinking of being 
          selfadjoint and which are not.  Look for variables with transposes 
          and without and make a list of the ones that are considered selfadjoint by the user *)  
 

       (* BEGIN MAURICIO MAR 2016 *)
       (* Symmetric variable withour Grabs *)

       (* BEGIN OLD CODE *)
       (*
       ( * first grab the variables and indeterminants * )

       vars = Union[ GrabVariables[ splitterm ] ];
       terms = Union[ GrabIndeterminants[ splitterm ] ];

       ( * find the selfadjoint vars and add to the rules the rule 
           that takes the 
          transposes of them out * )

       transposeRemovalRules = {};
       
       For[ i = 1, i <= Length[ vars ], i++,
          theVar = vars[[i]];
     
          ( * See if theVar is in any of the indeterminants with a
              transpose around it * )
          num = Count[ terms, tp[theVar], Infinity ];
    
          ( * if num = 0 then theVar is selfajoint * )
          If[ num === 0,  
             ( * make a rule that replaces all tp[theVar] 
                 with theVar * )
             transposeRemovalRules = Insert[ transposeRemovalRules, {tp[theVar] -> theVar }, 1 ]; 
          ];
       ];

       *)
       (* END OLD CODE *)

       (* BEGIN NEW CODE *)
               
       vars = DeleteCases[Union[ NCGrabSymbols[ splitterm ] ], _?CommutativeQ];
       terms = Union[ NCGrabSymbols[ splitterm, tp|aj ] 
                      /. tp -> Identity /. aj -> Identity];

       ajvars = Complement[vars, terms];
       transposeRemovalRules = Map[{tp[#]->#}&, ajvars];

       (* END NEW CODE *)
               
       (* END MAURICIO MAR 2016 *)

       (* now apply the rules to the tmpLvector and tmpRvector *)
       (* need to make the tmpRvector first *)
       tmpRvector = rightvector;

       For[ i = 1, i <= Length[ transposeRemovalRules ] , i++, 
          tmpLvector = tmpLvector //. transposeRemovalRules[[i]];
          tmpRvector = tmpRvector //. transposeRemovalRules[[i]];

       ];

       (* END END END END END END END END END END END END END END END END END END *)
       (* NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE *)
       (* Above is the new code that was added on 8/28/02 *)
       (* NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE NEW CODE *)


       (* Here is the old code that the above code replaces *)
       (*****************************************************
       Clear[Removetps]; 
       SetNonCommutative[Removetps];
       Removetps[x_] := x;		
       tmpLvector = tmpLvector //. {tp -> Removetps};
       tmpRvector = rightvector //. {tp -> Removetps};
       ******************************************************)


       (* nothing below was changed on 8/28/02 ( except some comments were added ).
          supposedly it is josh's code *)


       (* ok...this is where we want to try to match up the left and right vectors so they
          are transposes of each other *)       
       permcount = 0;
       For[i = 1, i <= n2 - 1, i++,

         (* this code loops through the tmpLvector and gets the element at position
            i and tries to find its transpose in the tmpRvector.  Note that its transpose
            may not really be its transpose since some variables are selfadjoint.  but the 
            tmpLvector and tmpRvector reflect this fact even if the leftvector and rightvector
            do not. *)

         (* first we make a list that has as its components tmpLvector[[i]] minus
            the component in the tmpRvector.  Wherever there is a zero is where 
            the transpose of tmpLvector[[i]] is.  Note that if something went wrong
            there will be more than one zero.  But the fix above was supposed to take 
            care of that. *)
         tmpPos = NCSimplifyRational[tmpLvector[[i]] Table[1, {1}, {n2}] - {tmpRvector}];
         tmpPos = Flatten[Position[Flatten[tmpPos], 0] ]; 

	 (* tmpPos now reflects the positions of the zeros...ie, the positions in the 
            rightvector where the transpose of tmpLvector[[i]] is *)
          
        
         (* this first if is for when more than one zero is encountered above.  this 
            is bad since we don't know how to rearrange the left and right 
            vectors to match each other now. *)

         If[Length[tmpPos] != 1, 

            (* hopefully with the above fix this code will never get run.
               if it does then there is no guarantee of anything working.
               so if it ever gets here then there is some bug in the 
               8/28/02 fix. *)
               
            Print["Possible Problem in symmetry check"]; 
            symcheck[[i]] = tmpPos;

            (* Place bad matches at bottom of left vector *)
            tmpPerm = Flatten[{ Range[1,i-1],Range[i+1,n2],i } ]; 
            tmpRvector = tmpRvector[[tmpPerm]];     
            tmpLvector = tmpLvector[[tmpPerm]];
            leftvector = leftvector[[tmpPerm]];
            rightvector = rightvector[[tmpPerm]];
            permcount++;
            If[permcount+i >= n2,i = n2-1, (* else *) i--];

         , (* else switch elements in right vector to match left  *)
           (* this is what should happen.  we have found the transpose of tmpLvector[[i]]
              in the right vector.  now we just rearrange the rightvector and the tmpRvector
              to match with the leftvector/tmpLvector *)
           
            symcheck[[i]] = True;
            tmpPos = tmpPos[[1]];
            tmpPerm = Range[n2];
            tmpPerm[[tmpPos]] = i;
            tmpPerm[[i]] = tmpPos;
            rightvector = rightvector[[tmpPerm]];
            tmpRvector = tmpRvector[[tmpPerm]];            
           
         ]; (* end if *)
       ]; (* end for *)


       (* The symcheck and symtrue tables are used somehow to reflect the 
          fact that the above stuff worked.  If this ever happens then 
          it is not good.  there is a bug somewhere.  or maybe not.  *)       
       If[Not[symcheck === symtrue], 
          Print["Possible error in symmetry!!!"];
          Print["Possible trouble in last ", permcount +1," elements."];
          ];    
      ]; (* end symmetry if *)
      (* end of check for symmetry *)
      (* ************************* *)
	

      (* now that we have the left and right vectors we can construct the
         middle matrix by using the same pattern matching we used above *)
      (* Build matrix B *)
     
      tmpRule = { (number1_:1)*left ** middle___ ** right :> 
		  {NonCommutativeMultiply[number1 ** middle] } }; 
      Bmat = Array[a, {n2, n2}];
      Do[
	Do[ 
	   doRule = tmpRule //. { left -> leftvector[[i]], 
                                  right -> rightvector[[j]]};	
	   teste = Select[splitterm,
		          MatchQ[#, doRule[[1]][[1]] ] & ] //. doRule;
	   Bmat[[i, j]] =  Plus @@ Flatten[teste]
	  ,{j, n2} ]
       ,{i, n2} ];		

      (* done building the matrix B *)

      (* The following Do loop makes the rightvector into a column.
	 ie, into a list like: { { a1 }, { a2 }, { a3 }, ...., { an } } *)
      Do[	
         rightvector = ReplacePart[rightvector, {rightvector[[i]]}, i] 
      ,{i, n2}];

      (* give back the answer *)
      Return[{{leftvector}, Bmat, rightvector}];
];


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
