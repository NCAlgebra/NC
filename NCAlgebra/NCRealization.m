(* : Name : NCRealization *)

(* : Title : Noncommutative Descriptor Realizations *)

(* : Author : John P. Shopple 2003-2004*)

(* : Summary : This package implements 
an algorithm due to N. Slinglend for producing minimal
realizations of NC rational functions in many NC variables: 
see his paper--
     "Toward Making LMIs Automatically"
It actually computes formulas similar to those used in  
 the paper Noncommutative Convexity Arises From Linear Matrix Inequalities
      by J William Helton, Scott A. McCullough, and Victor Vinnikov.
      In particular, there are functions for 
      calculating (symmetric) minimal descriptor realizations of 
      NC (symmetric) rational
      functions, and determinental representations of polynomials. *)

(* : Context : NCRealization` *)

(* : History : Originally written in summer 2003 and summer 2004
    :3/13/13: Deprecated LinearAlgebra`MatrixManipulation`. (mauricio)
*)

(* : Source : 
N. Slinglend paper:  FILLIN
and
Noncommutative Convexity Arises From Linear Matrix Inequalities
      by J. William Helton, Scott A. McCullough, and Victor Vinnikov *)


BeginPackage["NCRealization`", 
	     "NonCommutativeMultiply`", 
	     "NCMatMult`",
	     "NCLinearAlgebra`"]


Clear[NCDescriptorRealization,
      NCDeterminantalRepresentationReciprocal,
      NCMatrixDescriptorRealization,
      NCMinimalDescriptorRealization,
      NCSymmetrizeMinimalDescriptorRealization,
      NCSymmetricDescriptorRealization,
      NCSymmetricDeterminantalRepresentationDirect,
      NCSymmetricDeterminantalRepresentationReciprocal];




NCLinearQ::usage = "NCLinearQ[RationalExpression, UnknownVariables] returns True if 
RationalExpression is linear in (a list of) UnknownVariables, False
otherwise. NCLinearQ expands expressions using NCExpand first, then
determines linearity, so (inv[x]+A)**x is actually linear in x.";

NCLinearPart::usage = "NCLinearPart[RationalExpression,UnknownVariables] returns the part of
RationalExpression that is linear in (a list of) UnknownVariables.
RationalExpression is NOT expanded, SO in effect what gets returned is a sum
of monomial terms each of which is linear (NCLinearQ = True).
NCLinearPart[(inv[x] + A) ** x, {x}] returns (inv[x] + A) ** x which is
actually linear. But, NCLinearPart[(x + inv[x]) ** x, {x}] returns 0 since (x
+ inv[x]) ** x is not ENTIRELY linear. NCLinearPart + NCNonLinearPart =
original expression.";

NCNonLinearPart::usage = "NCNonLinearPart[RationalExpression,UnknownVariables] returns the part of
RationalExpression that is not linear in (a list of) UnknownVariables.
RationalExpression is NOT expanded, SO in effect what gets returned is a sum
of monomial terms each of which is not linear (NCLinearQ = False).
NCNonLinearPart[(inv[x] + A) ** x, {x}] returns 0 since (inv[x] + A) ** x is
actually linear. NCNonLinearPart[ y + (x + inv[x]) ** x, {x,y}] returns (x +
inv[x]) ** x since (x + inv[x]) ** x is nonlinear as a whole (but y isn't).
NCLinearPart + NCNonLinearPart = original expression.";

BlockDiagonalMatrix::usage = "BlockDiagonalMatrix[ListOfMatrices] returns the
 block diagonal matrix with the matrices in ListOfMatrix on the diagonal.
 Each matrix in ListOfMatrices can be arbitrary size. i.e. the output matrix
 doesn't have to be square.";

MatMultFromRight::usage = "MatMultFromRight[A,B,C,...]   It's often more efficient to perform multiplication
 of several matrices starting from the right. For example, if the last matrix is a vector (n-by-1) and the
  rest are square matrices (n-by-n).";

MatMultFromLeft::usage = "MatMultFromLeft[A,B,C,...] is the default of MatMult. If you want the matrix
 multiplications to start on the left. This is most efficient, for example, if the first matrix is a
  vector (1-by-n) and the rest are square matrices (n-by-n).";

CGBToPencil::usage = "CGBToPencil[CGB] takes the list of 3 matrices returned by NCDescriptorRealization
 and returns a matrix with linear entries which has a Schur Complement equivalent to the rational
  expression that the CGB realization represents.";

NCFindPencil::usage = "NCFindPencil[Expression,Unknowns] returns a matrix with linear entries in the
 Unknowns (Linear Pencil) such that a Schur Complement of the matrix is the original Expression.
  Expression can be a rational function or a matrix with rational function entries.";

CGBMatrixToBigCGB::usage = "CGBMatrixToBigCGB[MatrixOfCGB] returns a list of 3 matrices {C, G, B} such
 that CG^(-1)B is the original matrix that the MatrixOfCGB was derived from.";

NCPencilToList::usage = "NCPencilToList[Pencil,Unknowns] takes a matrix Pencil (linear in the Unknowns)
 and returns a list of matrices {A0,A1,A2,...} such that Pencil = A0 + A1*Unknowns[[1]] + A2*Unkowns[[2]] + ...";

NCListToPencil::usage = "NCListToPencil[ListOfMatrices,Unknowns] creates a linear pencil.
 For example, NCListToPencil[{A0,A1,A2},{1,x,y}] is A0 + A1**x + A2**y.";

NCMakeMonic::usage = "NCMakeMonic[{CC_,Pencil_,BB_},Unknowns_] returns a descriptor realization
 {C2,Pencil2,B2} that is monic. For this to be possible, the realization must represent a rational
  function that's not zero at the origin.";

NCFormLettersFromPencil::usage = "NCFormLettersFromPencil[A_List,B_]. Given a realization C.A^(-1).B,
 where A = A0 + A1*x1 + A2*x2 +...+An*xn, this returns the list { A0^(-1).A1, A0^(-1).A2,...,A0^(-1).An,A0^(-1).B}.
  These are the letters that are used when finding the controllability and observability spaces.";

NCFormControllabilityColumns::usage = "NCFormControllabilityColumns[A_List,B_,opts___]. Given the realization
 C.(I-A)^(-1).B, this returns a matrix such that the columns of its transpose span the controllability space.\n

With optional argument ReturnWordList->False, the output is {Matrix,ListOfWords} where ListOfWords is a
 list of the words used to make the spaning vectors. i.e. The output ListOfWords == {{},{1},{3,1}} would
  correspond to the vectors {B, A[[1]].B, A[[3]].A[[1]].B}

Optional argument Verbose->True, prints information as it's working.";

RJRTDecomposition::usage = \
"RJRTDecomposition[SymmetricMatrix_,opts___]. Returns {R,J} such that SymmetricMatrix == R.J.Transpose[R] and J
 is a signature matrix. Returns the answer in floating point unless the optional argument UseFloatingPoint->False is used.
  Floating point is necessary except for small examples because eigenvectors and eigenvalues are calculated in the algorithm.";

NonCommutativeLift::usage = \
"NonCommutativeLift[Rational_] returns a noncommutative symmetric lift of Rational.";

PinningSpace::usage = "PinningSpace[Pencil_,Unknowns_] returns a matrix whose columns span the pinning space of Pencil.
 Generally, either an empty matrix or a d-by-1 matrix (vector).";


PinnedQ::usage = "PinnedQ[Pencil_,Unknowns_] is True or False";

TestDescriptorRealization::usage = "TestDescriptorRealization[Rat,{C,G,B},Unknowns] checks if Rat == C.G^(-1).B
 by substituting random 2-by-2 matrices in for the unknowns. TestDescriptorRealization[Rat,{C,G,B},Unknowns,NumberOfTests]
  can be used to specify the NumberOfTests, the default being 5.";


SignatureOfAffineTerm::usage = "SignatureOfAffineTerm[Pencil,Unknowns] returns a list of the number of positive,
 negative and zero eigenvalues in the affine part of Pencil.";

(********** Optional Argument Definitions **********)

Options[NCRealization] = {Verbose -> False, 
      FloatingPointPrecision -> 20};
Options[NCFormControllabilityColumns] = {ReturnWordList -> False};
Options[RJRTDecomposition] = {UseFloatingPoint -> True};


Begin["`Private`"]

(********** NCLinearQ **********)

NCLinearQ[expr_, unknowns_] := 
    Module[{expr2, NumUnknowns, NumUnknownsInInv}, 
      expr2 = ExpandNonCommutativeMultiply[expr];
      If[Head[expr2] === Plus, 
        Return[And @@ (NCLinearQ[#, unknowns] &) /@ (List @@ expr2)]];
      NumUnknowns = Plus @@ (Count[expr2, #, {0, Infinity}] & /@ unknowns);
      SetNonCommutative[x];
      NumUnknownsInInv = 
        Plus @@ (Count[
                  Cases[expr2, 
                    HoldPattern[inv[x_]] -> x, {0, Infinity}], #, {0, 
                    Infinity}] & /@ unknowns);
      NumUnknowns <= 1 && NumUnknownsInInv == 0];


(********** NCLinearPart **********)

NCLinearPart[expr_, unknowns_] := 
    Module[{}, 
      If[Head[expr] === Plus, 
        Return[Select[expr, NCLinearQ[#, unknowns] &]]];
      (*** else expr is not a sum ***)If[NCLinearQ[expr, unknowns] === False, 
        0, expr]];


(********** NCNonLinearPart **********)

NCNonLinearPart[expr_, unknowns_] := 
    Module[{}, 
      If[Head[expr] === Plus, 
        Return[Select[expr, Not[NCLinearQ[#, unknowns]] &]]];
      (*** else expr is not a sum ***) 
      If[NCLinearQ[expr, unknowns], 0, expr]];


(********** BlockDiagonalMatrix **********)

BlockDiagonalMatrix[mats_] := Module[{m, n, p},
      If[Depth[mats] == 3, Return[mats]];
      {m, n} = Plus @@ Map[Dimensions, mats];
      p = 0;
      Flatten[
        Map[PadRight[#, {Length[#], n}, 
              0, {0, (p += Dimensions[#][[2]]) - Dimensions[#][[2]]}] &, 
          mats], 1]];
BlockDiagonalMatrix[mat1_, mat2__] := Print["Needs a LIST of matrices"];


(********** MatMultFromRight (Left) **********)

MatMultFromRight[x_, y_] := MatMult[x, y];
MatMultFromRight[x__, y_, z_] := MatMultFromRight[x, MatMult[y, z]];
MatMultFromLeft = MatMult;



(********** NCDescriptorRealization **********)

NCDescriptorRealization[expression_, unknowns_] := 
    Module[{LPLinearTerm, DiagonalMatrixSq, LPCombinePlus, LPCombineTimes, 
        LPInverse, LPCombineLeftScalarTimes, LPCombineRightScalarTimes, 
        LPTranspose, NoUnknownsQ, SubMR, CGB},
        
      LPLinearTerm[expr_] := 
        Return[  { {{0}, {1}}, {{-expr, 1}, {1, 0}}, {{0}, {1}} }  ];
      
      DiagonalMatrixSq[sms_] := 
        Module[{p = 0}, 
          Join @@ (PadRight[#, {Length[#], Plus @@ Length /@ sms}, 
                    0, {0, (p += Length[#]) - Length[#]}] & /@ sms)];
      
      (* LPCombinePlus, LPCombineNCM, LPCombineTimes, LPInverse all take A, 
        L,
         B and return A, L, B *)
      
      LPCombinePlus[ALB_] := Module[{n},
          Return[ {
              NCBlockMatrix[  Map[{#[[1]]} &, ALB]  ],
              DiagonalMatrixSq[  Map[#[[2]] &, ALB]  ],
              NCBlockMatrix[  Map[{#[[3]]} &, ALB]  ]
              } ]
          ];
      
      LPCombineTimes[ALB1_, ALB2_] := Module[{B1A2, m1, n1, m2, n2}, 
          B1A2 = MatMult[  ALB1[[3]], tpMat[ ALB2[[1]] ]  ];
          {m1, n1} = Dimensions[ALB1[[2]]];
          {m2, n2} = Dimensions[ALB2[[2]]];
          
          Return[ {
              NCBlockMatrix[ { { ALB1[[1]] }, { NCZeroMatrix[m2, 1] } } ],
              
              NCBlockMatrix[ {  { -ALB1[[2]], B1A2},  { NCZeroMatrix[m2, n1], 
                    ALB2[[2]] }  } ],
              NCBlockMatrix[ { { NCZeroMatrix[n1, 1] }, { ALB2[[3]]  } } ]
              } ]
          ];
      
      LPInverse[ALB_] := Module[{m, n},
          (* 
            Needs["LinearAlgebra`MatrixManipulation`"]; *)
          {m, n} = 
            Dimensions[ ALB[[2]] ];
          Return[
            {
              NCBlockMatrix[{   {  NCZeroMatrix[n, 1]  }, {  {{1}}  }   }],
              
              NCBlockMatrix[{   {  -ALB[[2]], ALB[[3]]  }, { 
                    tpMat[ ALB[[1]] ], {{0}}  }   }],
              NCBlockMatrix[{   {  NCZeroMatrix[n, 1]  }, {  {{1}}  }   }]
              }
            ];
          ];
      
      LPCombineLeftScalarTimes[K_, ALB_] := Module[{},
          Return[ { 
                Map[ K ** # &, ALB[[1]], {2}],
                ALB[[2]],
                ALB[[3]]
                } ];
          ];
      
      LPCombineRightScalarTimes[K_, ALB_] := Module[{},
          Return[ { 
                ALB[[1]],
                ALB[[2]],
                Map[ # ** K &, ALB[[3]], {2}]
                } ];
          ];
      
      LPTranspose[ALB_] := Module[{},
          Return[
              { tpMat[ALB[[3]]],
                tpMat[ALB[[2]]],
                tpMat[ALB[[1]]]
                }
              ];
          ];
      
      NoUnknownsQ[x_] := Apply[And, Map[FreeQ[x, #] &, unknowns]];
      
      (* SubMR is the recursive part of the function.
            This way, the unknowns don't have to keep being passed,          
        and the helper functions can be kept local inside NCDescriptorRealization. *)
      
      SubMR[expr_] := Module[{LinearPart, K, x},
          
          (* The base case of the recursion is a linear term. If expr
               is linear in the unknowns, then we return *)
          
          If[  NCLinearQ[expr, unknowns], Return[ LPLinearTerm[expr] ]  ];
          
          (* At this point, expr is not linear in the unknowns, so
              what we do depends on the head of the expression :
                Plus, inv, tp, NonCommutativeMultiply or Times *)
          
          Switch[Head[expr],
            
            (****** Head of expr is "Plus" ******)
            Plus, 
            LinearPart = 
              NCLinearPart[expr, unknowns] /. 
                HoldPattern[Times[0.0, x_]] :> 0;(* 
              Need to check for numerical zero (i.e. 0.0 * 
                    NCexpr )to prevent possible infinite recursion *)
        \
    
            If[ LinearPart =!= 0 && LinearPart =!= 0.0, 
                   (* 
                expr is a sum of a linear part and a nonlinear part *)
       \
             
              LPCombinePlus[  {LPLinearTerm[LinearPart] , 
                     SubMR[NCNonLinearPart[expr, unknowns]]}  ],
              
                   (* Else, 
                expr is a sum of nonlinear parts *)
                    
              LPCombinePlus[   Map[SubMR, Apply[List, expr]]   ]
              ], (* End If *) 
            
            (****** Head of expr is "tp" ******)
            tp, 
            LPTranspose[ Apply[SubMR, expr] ],
            
            (****** Head of expr is "inv" ******)
            inv, 
            LPInverse[ Apply[SubMR, expr]  ] ,
            
            (****** 
                Head of expr is "NonCommutativeMultiply" ******)
            
            NonCommutativeMultiply,
            (* 
              
              Pull off KNOWN NC stuff from the left or right and treat separately,
              so the matrices don't get bigger *)
            Which[ 
              NoUnknownsQ[First[expr]], 
              LPCombineLeftScalarTimes[  First[expr], SubMR[Rest[expr]]  ],
              NoUnknownsQ[Last[expr]], 
              LPCombineRightScalarTimes[  Last[expr], 
                SubMR[Take[expr, {1, -2}]]  ],
              True, 
              LPCombineTimes[  SubMR[ First[expr] ],  
                SubMR[ Rest[expr] ]  ]],
            
            (****** Head of expr is "Times" ******)
            Times, 
            expr /. K_?CommutativeQ * x_ :>
                  
                LPCombineLeftScalarTimes[ K,  SubMR[ x ] ],
            
            (****** 
                Head of expr is something unknown (error) ******)
            _,
            
            NCDescriptorRealization::BadHead = 
              "Error Head of expression is unknown. Head = `1`. Pretending `2` is linear.";\

            Message[NCDescriptorRealization::BadHead, Head[expr], expr];
            
            LPLinearTerm[expr] (* Shouldn't get here, 
              pretend expr is linear. *)
            
            ] (* End Switch. The value of the Switch statement is
                 what gets returned by SubMR *)
          ];(* 
        End SubMR *)
      
      CGB = SubMR[expression];
      Return[ {tpMat[CGB[[1]]], CGB[[2]], CGB[[3]]} ];
      ];


(********** CGBToPencil **********)

 CGBToPencil[CGB_] := 
    Module[{B, Bt, C, Ct, K, D, m, n, mC, nC, mG, nG, mB, nB, Z, O},
      Z = NCZeroMatrix;
      O[m_, n_] := Table[Table[1, {n}], {m}];
      
      {mC, nC} = Dimensions[tpMat[CGB[[1]]] ];
      {mG, nG} = Dimensions[CGB[[2]]];
      {mB, nB} = Dimensions[CGB[[3]]];
      
      C = NCBlockMatrix[{{Z[mC, nC]}, {tpMat[CGB[[1]]] }}];
      B = NCBlockMatrix[{{CGB[[3]]}, {Z[mB, nB]}}]/2;
      K = NCBlockMatrix[{{NCZeroMatrix[mG, nG], tpMat[CGB[[2]]]}, {CGB[[2]],
              NCZeroMatrix[mG, nG]}}];
      D = K + MatMult[B, tpMat[B]];
      
      (* Now construct the pencil using B, C and D *)
      {m, n} = 
        Dimensions[D];
      
      Bt = tpMat[B];(*B transpose*)
      
      Ct = tpMat[C];(*C transpose*)
      
      Return[NCBlockMatrix[
            {{Z[nC, nC], O[nC, nB], Ct, O[nC, nB], Z[nC, n], Z[nC, nB], Ct},
            {O[nB, nC], O[nB, nB], Bt, Z[nB, nB], Z[nB, n], Z[nB, nB], 
              Z[nB, n]},
            {C, B, D, Z[m, nB], Z[m, n], Z[m, nB], Z[m, n]},
            {O[nB, nC], Z[nB, nB], Z[nB, n], -O[nB, nB], -Bt, Z[nB, nB], 
              Z[nB, n]},
            {Z[m, nC], Z[m, nB], Z[m, n], -B, -D, Z[m, nB], Z[m, n]},
            {Z[nB, nC], Z[nB, nB], Z[nB, n], Z[nB, nB], 
              Z[nB, n], -O[nB, nB], -Bt},
            {C, Z[m, nB], Z[m, n], Z[m, nB], Z[m, n], -B, -D}}]
        ];
      ];


(********** NCMatrixDescriptorRealization **********)

NCMatrixDescriptorRealization[mat2_, unknowns2_] := 
    Map[NCDescriptorRealization[#, unknowns2] &, mat2, {2}];


(********** NCFindPencil **********)

NCFindPencil[expr_, unknowns_] := 
    Module[{}, CGBToPencil[NCDescriptorRealization[expr, unknowns]]];

(*For a matrix of rationals, this is used*)

NCFindPencil[mat_?MatrixQ, unknowns_] := 
    Module[{}, 
      CGBToPencil[
        CGBMatrixToBigCGB[NCMatrixDescriptorRealization[mat, unknowns]]]];


(********** CGBMatrixToBigCGB **********)

CGBMatrixToBigCGB[CGB_] := 
    Module[{m, n, C, G, B, s, t, BigC, BigG, BigB}, {m, n} = 
        Dimensions[CGB, 2];
      BigC = 
        tpMat[BlockDiagonalMatrix[
            Table[{Flatten[Table[tpMat[CGB[[i, j, 1]]], {j, n}]]}, {i, m}]]];
      BigC = 
        BlockDiagonalMatrix[
          Table[{Flatten[Table[tpMat[CGB[[i, j, 1]]], {j, n}]]}, {i, m}]];
      BigG = 
        BlockDiagonalMatrix[
          Flatten[Table[Table[CGB[[i, j, 2]], {j, n}], {i, m}], 1]];
      BigB = 
        Flatten[Table[
            BlockDiagonalMatrix[Table[CGB[[i, j, 3]], {j, n}]], {i, m}], 1];
      {BigC, BigG, BigB}];


(********** NCPencilToList **********)

NCPencilToList[pencil_, unknowns_] := Module[{A, n}, rule0[x_] := x -> 0;
      rule1[x_] := x -> 1;
      rr0 = Map[rule0, unknowns];
      rr1 = Map[rule1, unknowns];
      A = {pencil //. rr0};
      For[n = 1, n <= Length[unknowns], n++, 
        A = Append[A, (pencil //. ReplacePart[rr0, rr1, n, n]) - A[[1]]];];
      A];


(********** NCListToPencil **********)

NCListToPencil[Mats_, Unknowns_] := Module[{MultByUnknown, Z, x},
      MultByUnknown[Z_, x_] := Map[# ** x &, Z, {2}];
      Plus @@ MapThread[MultByUnknown, {Mats, Unknowns}]
      ];


(*** Unnecessary ***)
(*Takes the matrices returned from NCPencilToList {A0, 
      A1, A2, ...} and returns {A0^(-1).A1, A0^(-1).A2, ...}*)

(*FormLettersFromPencil[A_] := 
      Module[{}, Map[MatMult[Inverse[A[[1]]], #] &, Rest[A]]];*)



(********** NCMakeMonic **********)

NCMakeMonic[{CC_, Pencil_, BB_}, Unknowns_] := Module[{A, A0inv},
      A = NCPencilToList[Pencil, Unknowns];
      A0inv = Inverse[A[[1]]];
      {CC, MatMult[A0inv, Pencil], MatMult[A0inv, BB]}
      ];


(********** NCFormLettersFromPencil **********)

NCFormLettersFromPencil[A_List, B_, opts___] := Module[{A0inv},
      If[Verbose /. {opts} /. Options[NCRealization], 
        Print["Finding inverse of monic (affine) term"]];
      A0inv = Inverse[A[[1]]];
      {Map[MatMult[A0inv, #] &, Rest[A]], MatMult[A0inv, B]}];



(********** NCFormControllabilityColumns **********)

NCFormControllabilityColumns[A_List, B_, opts___] := Module[
    {Letters = Range[Length[A]],
      ListOfColumnWords = {{}},
      WordLength = 0,
      RowReducedTransposeOfControllabilityMatrix = RowReduce[Transpose[B]],
      AWordsTimesB,
      NeedToCheck = True,
      j,
      CandidateColumnWords,
      ZeroRowVector = Table[0, {Length[B]}],
      CandidateRowReducedTransposeOfControllabilityMatrix},
    
    
    AWordsTimesB[word_List] := 
      AWordsTimesB[word] = 
        If[Length[word] === 0, 
          B, (MatMult[A[[First[word]]], AWordsTimesB[Rest[word]]])];
    
    While[NeedToCheck,
      NeedToCheck = False;
      WordLength = WordLength + 1;
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["While NeedToCheck, WordLength = ", WordLength]];
      
      
      CandidateColumnWords = 
        Flatten[Outer[Prepend[#2, #1] &, Letters, 
            Select[ListOfColumnWords, Length[#] == WordLength - 1 &], 1], 1];
      
      
      If[Verbose /. {opts} /. Options[NCRealization], 
        Print[CandidateColumnWords]];
      
      For[j = 1, j <= Length[CandidateColumnWords], j = j + 1,
        
        CandidateRowReducedTransposeOfControllabilityMatrix = 
          RowReduce[  Append[
              RowReducedTransposeOfControllabilityMatrix,
              Flatten[
                Transpose[AWordsTimesB[CandidateColumnWords[[j]] ] ] 
                  ] ] ];
        
        If[
          Last[CandidateRowReducedTransposeOfControllabilityMatrix] != 
            ZeroRowVector,
          
          RowReducedTransposeOfControllabilityMatrix = 
            CandidateRowReducedTransposeOfControllabilityMatrix;
          
          ListOfColumnWords = 
            Append[ListOfColumnWords, CandidateColumnWords[[j]] ];
          NeedToCheck = True;
          ];(* If *)
        ];(* For *)
      ];(* While *)
    
    If[ReturnWordList /. {opts} /. Options[NCFormControllabilityColumns],
      {RowReducedTransposeOfControllabilityMatrix, ListOfColumnWords}, 
      RowReducedTransposeOfControllabilityMatrix]
    
    ](* NCFormControllabilityColumns *)



(********** NCMinimalDescriptorRealization **********)

NCMinimalDescriptorRealization[rat_, unknowns_, opts___] := 
    Module[{C, Pencil, B, ReduceUsingControllability, Gm, Cm, Bm},
      
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Finding some descriptor realization"]];
      {C, Pencil, B} = NCDescriptorRealization[rat, unknowns];
      (* Note : C, B column vectors *)
      
      ReduceUsingControllability[C_, G_, B_] := 
        Module[{A2, B2, ControllabilityColumns, MinimalSize, Q, Qinv, A0, 
            MultByUnknown, ListOfColumnWords},
          
          {A2, B2} = 
            NCFormLettersFromPencil[NCPencilToList[G, unknowns], B, opts];
          
          
          ControllabilityColumns = 
            NCFormControllabilityColumns[A2, B2, opts];
          MinimalSize = Length[ControllabilityColumns];
          
          (*Print[ControllabilityColumns // MatrixForm];*)
          
          
          Q = Transpose[
              Join[ControllabilityColumns, 
                NullSpace[ControllabilityColumns]]];
          Qinv = Inverse[Q];
          
          A0 = IdentityMatrix[ MinimalSize ];
          
          MultByUnknown[Z_, x_] := Map[# ** x &, Qinv.Z.Q, {2}];
          If[Verbose /. {opts} /. Options[NCRealization],
            Print["Reduced to size ", MinimalSize, " by ", MinimalSize]];
          
          
          (*Pencil Before Cutdown *)
          (*Print[
                IdentityMatrix[
                      Length[Q]] + (Plus @@ 
                        MapThread[MultByUnknown, {A2, unknowns}]) // 
                  MatrixForm];
            *)
          
          {MatMult[C, Q][[All, Range[MinimalSize]]], 
            A0 + (Plus @@ MapThread[MultByUnknown, {A2, unknowns}])[[Range[
                    MinimalSize], Range[MinimalSize]]], 
            MatMult[Qinv, B2][[Range[MinimalSize], All]]}
          
          ]; (*** ReduceUsingControllability ***)
      
      (*** Reduce using Controllability Space ***)
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Reducing using controllability"]];
      {Cm, Gm, Bm} = ReduceUsingControllability[C, Pencil, B];
      
      (*** Reduce using Observability Space ***)
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Reducing using observability"]];
      {Bm, Gm, Cm} = 
        ReduceUsingControllability[Transpose[Bm], Transpose[Gm], 
          Transpose[Cm]];
      
      Bm = Transpose[Bm];
      Gm = Transpose[Gm];
      Cm = Transpose[Cm];
      
      (* Print["Done"]; *)
      
      Return[{Cm, Gm, Bm}];
      (*** Note : MatMult[Cm, NCInverse[Gm], Bm] == rat ***)
      ];



(********** RJRTDecomposition **********)

RJRTDecomposition[Mat_?MatrixQ, opts___] := Module[{UseMat, EVecs, EVals, D},
      
      (*** 
            Precision for numerical calculation should be set higher than the \
default or else the decomposition may not be accurate. ***)
      
      If[UseFloatingPoint /. {opts} /. Options[RJRTDecomposition],
        UseMat = 
          N[Mat, FloatingPointPrecision /. {opts} /. 
              Options[NCRealization]],
        UseMat = Mat];
      
      EVecs = Eigenvectors[UseMat];
      EVecs = Map[#/Sqrt[Plus @@ (#^2)] &, EVecs];
      EVals = Eigenvalues[UseMat];
      
      D = Sqrt[Inner[Times, EVals, Sign[EVals], List]];
      EVecs = Inner[Times, Transpose[EVecs], D, List];
      {EVecs, DiagonalMatrix[Sign[EVals]]}
      ];



(********** NCSymmetrizeMinimalDescriptorRealization **********)

NCSymmetrizeMinimalDescriptorRealization[{Cmm_, Gmm_, Bmm_}, unknowns_, 
      opts___] := 
    Module[{A, B, AA, CC, Temp, ListOfColumnWords, AWordsTimesVector, Y, Z, S,
         R, J, Ctilda, Atilda, TransposeInverseR},
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Symmetrizing"]];
      
      AWordsTimesVector[word_List, A_, V_] := 
        AWordsTimesVector[word, A, V] = 
          If[Length[word] === 0, 
            V, (MatMult[A[[First[word]]], 
                AWordsTimesVector[Rest[word], A, V]])];
      
      {A, B} = NCFormLettersFromPencil[NCPencilToList[Gmm, unknowns], Bmm];
      A = -A;
      {AA, CC} = 
        NCFormLettersFromPencil[NCPencilToList[Transpose[Gmm], unknowns], 
          Transpose[Cmm]];
      AA = -AA;
      
      {Temp, ListOfColumnWords} = 
        NCFormControllabilityColumns[A, B, ReturnWordList -> True, opts];
      
      Y = NCAppendRows @@ Map[AWordsTimesVector[#, A, B] &, ListOfColumnWords];
      Z = 
        NCAppendRows @@ Map[AWordsTimesVector[#, AA, CC] &, ListOfColumnWords];
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Taking inverse of size ", Length[Y], " Matrix"]];
      S = Z.Inverse[Y] // Simplify;
      
      If[Verbose /. {opts} /. Options[NCRealization],
        Print["Finding RJR^T Decomposition"]];
      
      {R, J} = RJRTDecomposition[S, opts];
      
      TransposeInverseR = Transpose[Inverse[R]];
      
      Ctilda = Cmm.TransposeInverseR;
      Atilda = 
        MatMult[J, Transpose[R], (IdentityMatrix[Length[Gmm]] - Gmm), 
          TransposeInverseR];
      
      {Ctilda, J - Atilda}  (* The symmetric realization *)
      ];


(********** NCSymmetricDescriptorRealization **********)

NCSymmetricDescriptorRealization[rat_, unknowns_, opts___] := 
    NCSymmetrizeMinimalDescriptorRealization[
      NCMinimalDescriptorRealization[rat, unknowns, opts], unknowns, opts];


(********** NonCommutativeLift **********)

NonCommutativeLift[Rat_] := Module[{RatOut},
      RatOut = Rat //. Times :> NonCommutativeMultiply;
      RatOut = 
        RatOut //. 
          Power[x_, n_Integer?(# > 0 &)] :> 
            NonCommutativeMultiply[Sequence @@ Table[x, {n}]];
      RatOut = 
        RatOut //. 
          Power[x_, n_Integer?(# < 0 &)] :> 
            inv[NonCommutativeMultiply[Sequence @@ Table[x, {-n}]]];
      RatOut/2 + (tp[RatOut] /. tp :> Identity)/2
      ];


(********** PinningSpace **********)

PinningSpace[Pencil_, Unknowns_] := 
    Module[{NS}, 
      NS = NullSpace[ 
          NCAppendColumns @@ Rest[NCPencilToList[Pencil, Unknowns]] ];
      If[NS == {}, {{}}, tpMat[NS]]
      ];


(********** PinnedQ **********)

PinnedQ[Pencil_, Unknowns_] := PinningSpace[Pencil, Unknowns] =!= {{}};



(********** TestDescriptorRealization **********)

TestDescriptorRealization[Rat_, Descriptor : {C_, G_, B_}, unknowns_List, 
      NumberOfTests_:5] := 
    Module[{expr = {Rat, Descriptor}, expr2, dummyinv, dummyPlus, 
        dummyMatMult, dumb, n = 2, II, RandMat, rule1, CC, GG, BB, Iteration, 
        Correct = 0},
      SeedRandom[];
      RandMat := dumb[Table[Random[Real], {n}, {n}]];
      II = IdentityMatrix[n];
      
      For[Iteration = 1, Iteration <= NumberOfTests, Iteration++,
        
        rule1 = (# -> RandMat) & /@ (Union[Flatten[{unknowns}]]);
        
        expr2 = N[expr];
        expr2 = expr2 //. inv -> dummyinv;
        expr2 = expr2 //. NonCommutativeMultiply -> dummyMatMult;
        expr2 = expr2 //. Times -> dummyMatMult;
        expr2 = expr2 //. Plus -> dummyPlus;
        
        expr2 = 
          expr2 /. {x_Integer*b__ -> dummyMatMult[dumb[x II], b], 
              x_Integer -> dumb[x II]};
        expr2 = 
          expr2 /. {x_Rational*b__ -> dummyMatMult[dumb[x II], b], 
              x_Rational -> dumb[x II]};
        expr2 = 
          expr2 /. {x_Real*b__ -> dummyMatMult[dumb[x II], b], 
              x_Real -> dumb[x II]};
        
        expr2 = expr2 /. rule1;
        
        expr2 = expr2 /. dummyinv -> Inverse;
        expr2 = expr2 /. dummyMatMult -> MatMult;
        expr2 = expr2 /. dummyPlus -> Plus;
        
        expr2 = expr2 /. dumb -> Identity;
        
        CC = NCBlockMatrix[expr2[[2, 1]] ];
        GG = NCBlockMatrix[expr2[[2, 2]] ];
        BB = NCBlockMatrix[expr2[[2, 3]] ];
        
        (*
          Print[CC.Inverse[GG].BB - expr2[[1]] // MatrixForm];
          Print[CC.Inverse[GG].BB - expr2[[1]] // Norm];
          *) 
        
        If[NCZeroMatrix[n] == (CC.Inverse[GG].BB - expr2[[1]] // Chop), 
          Correct++];
        ]; (* end For *)
      
      Print[Correct, " out of ", NumberOfTests, " tests correct."];
      ];

SignatureOfAffineTerm[Mat_?MatrixQ, Unknowns_] := 
    Module[{SignsOfEigs}, 
      SignsOfEigs = 
        NCPencilToList[Mat, Unknowns][[1]] // Eigenvalues // Sign;
      {Count[SignsOfEigs, _?(# > 0 &)], Count[SignsOfEigs, _?(# < 0 &)], 
        Count[SignsOfEigs, _?(# == 0 &)]}
      ];


(********** NCDeterminantalRepresentationReciprocal **********)

NCDeterminantalRepresentationReciprocal[poly_, unknowns_, opts___] := 
    NCMinimalDescriptorRealization[inv[poly], unknowns, opts][[2]];


(********** NCSymmetricDeterminantalRepresentationReciprocal **********)

NCSymmetricDeterminantalRepresentationReciprocal[poly_, unknowns_, opts___] :=
     NCSymmetricDescriptorRealization[inv[poly], unknowns, opts][[2]];

(********** NCSymmetricDeterminantalRepresentationDirect **********)

NCSymmetricDeterminantalRepresentationDirect[poly_, unknowns_, opts___] := 
    Module[{C, Pencil, J, RR, JJ, RRinv},
      {C, Pencil} = 
        NCSymmetricDescriptorRealization[1 - poly, unknowns, opts];
      J = Pencil /. Map[(# -> 0) &, unknowns];
      {RR, JJ} = RJRTDecomposition[J - Transpose[C].C, opts];
      RRinv = Inverse[RR];
      JJ + RRinv.(Pencil - J).Transpose[RRinv]
      ];



End[]
EndPackage[]  (* NCRealization *)
