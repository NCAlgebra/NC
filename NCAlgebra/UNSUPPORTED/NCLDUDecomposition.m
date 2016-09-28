(* :Title: 	NCLDUDecomposition.m *)

(* :Author: 	Mauricio *)

(* :Context: 	NCLDUDecomposition` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :07/19/99: Added LDU decomposition and Inverse. (Juan)
   :08/19/99: Added Diag (Juan)
   :09/09/04: Put a new NCInverse function in. JShopple
*)

BeginPackage["NCLDUDecomposition`",
             "Combinatorica`",
	     "NCMatMult`",
	     "NonCommutativeMultiply`",
	     "NCLinearAlgebra`",
	     "NCSimplifyRational`"];

Clear[NCLDUDecomposition];
NCLDUDecomposition::usage=
       "NCLDUDecomposition[X] yields the LDU decomposition for a
	square matrix X.  It returns a list of four elements,
	namely L,D,U, and P such that P X P^T = L D U.
	The first element is the lower triangular matrix L, the 
	second element is the diagonal matrix D, the third element 
	is the upper triangular matrix U, and the fourth is
	the permutation matrix P (the identity is returned if no
	permutation is needed).  As an option, it may also return 
	a list of the permutations used at each step of the LDU 
	factorization as a fifth element.
	Suppose X is given by {{a,b,0},{0,c,d},{a,0,d}}. \n
	Then NCLDUDecomposition[X] gives \n
	  { {{1,0,0},{0,1,0},{1,-b**inv[c],1}},\n
            {{a,0,0},{0,c,0},{0,0,d+b**inv[c]**d}},\n
	    {{1,inv[a]**b,0},{0,1,inv[c]**d},{0,0,1}},\n
            {{1,0,0},{0,1,0},{0,0,1}} }.";

Clear[NCAllPermutationLDU];
NCAllPermutationLDU::usage=
        "NCAllPermutationLDU[X] returns the LDU decomposition of a ...
         square matrix X for all possible permutations.  
         The code cycles through all possible 
	 permutations and calls NCLDUDecomposition for each one.  As an
	 option, the permutations used for each LDU decomposition can
	 also be returned. \n \n 
         For example, if X = {{a, 0},{b, c}}, then NCAllPermutationLDU gives \n
	 {{{{1,0},{b**inv[a],1}},{{a,0},{0,c}},{{1,0},{0,1}},{{1,0},{0,1}}},\n 
	 {{{1,0},{0,1}},{{c,0},{0,a}},{{1,inv[c]**b},{0,1}},{{0,1},{1,0}}}}.";

Clear[ReturnPermutation];

Options[NCLDUDecomposition] =
        {Permutation -> False, CheckDecomposition -> False,
         NCSimplifyPivots -> False, StopAutoPermutation -> False,
         ReturnPermutation -> False, Stop2by2Pivoting -> False};

Options[NCAllPermutationLDU] = 
        {PermutationSelection -> False, CheckDecomposition -> False,
         NCSimplifyPivots -> False, StopAutoPermutation -> False,
         ReturnPermutation -> False, Stop2by2Pivoting -> False}; 

Begin["`Private`"];

  (* Diag[m_?MatrixQ] := Flatten[MapIndexed[Part,m]]; *)
  Diag[m_?MatrixQ] := Tr[m, List];
        
  (* ---------------------------------------------------------------- *)
  (*  This is the formula for 2 by 2 block gauss elimination          *)
  (*  It assumes that a the top diagonal entry is invertible. That    *)
  (*  is the default. Also we make one for the bottom                 *)
  (* ---------------------------------------------------------------- *)

  GaussElimination[{{a_,b_},{c_,d_}}] := 
     GaussElimination[{{a,b},{c,d}},top];

  (* ------------------------------------------------------------------ *)
  (*     left pivot, diag, right pivot                                  *)
  (* ------------------------------------------------------------------ *)
  GaussElimination[{{a_,b_},{c_,d_}},top] :=
                   {{{Id,0},{c**inv[a],Id}},
                    {{a,0},{0,d-c**inv[a]**b}},
                    {{Id,inv[a]**b},{0,Id}}};

  GaussElimination[{{a_,b_},{c_,d_}},btm] :=
                   {{{Id,b**inv[d]},{0,Id}},
                    {{a-b**inv[d]**c,0},{0,d}},
                    {{Id,0},{d**c,Id}}};

  (* ---------------------------------------------------------------- *)
  (*  This is the formula for n by n LDU Decomposition                *)
  (*  The code for inverse is also given here                         *)
  (*  Some auxiliary functions are also declared                      *)
  (* ---------------------------------------------------------------- *)

  NCPermutationMatrix[ list_ ] := 
    Transpose[IdentityMatrix[Length[list]][[list]]];

  NCMatrixToPermutation[ mat_ ] := 
    Thread[Position[Transpose[ mat ], 1]][[2]];

  Perm[ nfix_, n_, perm_ ] := Module[
    {p},

    p = IdentityMatrix[n];
    If[Not[perm === False]
       ,
       {p = NCPermutationMatrix[perm[[nfix-n+1]]];
        p = NCSubMatrix[p, {nfix-n+1,nfix-n+1},{n,n}];}
    ];
    Return[p];
  ];

  CheckPermutation[ n_, p_] := Module[
    {i,j,pdim},
    
    errorlist = False;
    pdim = Dimensions[p];
    If[Not[pdim == {n-1,n}]
       , errorlist = True;
    ];
    m = Range[n];
    Do[{ If[Not[Intersection[p[[i]],m] == m]
            ,
            errorlist = True;
         ]; }
       ,{i,1,n-1}
    ];
    Do[{ If[Not[p[[i,j]]==j]
            ,errorlist = True;
         ]; }
       ,{i,n-1,2,-1}, {j,1,i-1}
    ];
    (* for special 1X1 case *)
    If[n == 1
       ,
       If[Not[p === {{1}}]
          ,
          errorlist = True;
          ,(* else *)
          errorlist = False;
       ];(* end if *)
    ]; (* end if *)
        
    Return[errorlist];
  ];

  NCCheckPermutation[ n_, p_] := Module[
    {check},
    check = CheckPermutation[n,p];
    If[check
       , 
       Print["Not valid permutation list!"],
       Print["Valid permutation list!"] 
    ];
    Return[];
  ];

  Simplifypivot[exp1_] := Module[
    {exp},        

    exp = BeginCommuteEverything[exp1];
    exp = Together[exp];
    exp = Numerator[exp];
    exp = Expand[exp];
    EndCommuteEverything[];
      
    Return[exp];
  ];
  
  LDUrec[nfix_, mat_, opts___Rule ] := Module[
    {output,n = Length[mat], submata,submatb,submatc,submatd,
     subgauss, dtil, binvsubmata,cinvsubmata,lleft,rright,diagon,
     checkit,perm,newperm,p, matp, P,optpiv,leafct,Tmpleafct,Tmpdiag,
     Tmptrue,Tmpelm,pivottype,pivpos,pivfound,loopcheck,pivotcheck,
     leafsort,stopauto,stop2by2,invsubmata},
      
    checkit = CheckDecomposition /. {opts} /. Options[NCLDUDecomposition];
    perm = Permutation /. {opts} /. Options[NCLDUDecomposition];
    pivotcheck = NCSimplifyPivots /. {opts} /. Options[NCLDUDecomposition];
    stopauto  = StopAutoPermutation /. {opts} /. Options[NCLDUDecomposition];
    stop2by2  = Stop2by2Pivoting /. {opts} /. Options[NCLDUDecomposition];

    If [n == 1,  (* if #4 *)                                
      Return[{ {{1}},mat,{{1}},{{1}},{ Range[nfix]} }];
    ];
      
    If [n<3 (* if #1 *)
        ,
        If[n == 1  (* if #4 *)                                
           ,
            Return[{ {{1}},mat,{{1}},{{1}},{ Range[nfix]} }];
           , (* Else *)
               
            p = Perm[nfix, n, perm];  
            matp = p . mat . Transpose[p];
                
            If[stopauto  === False (* stopauto matic permutations if *)
               ,
               (* pivot with smallest smallest leaf count diagonal *)
               If[perm === False
                  ,
                  leafct = Map[LeafCount,Diag[matp]];
                  If[leafct[[2]] < leafct[[1]]
                     ,
                     oldp = p; 
                     p = NCPermutationMatrix[{2, 1}];
	             matp = p . matp . Transpose[p];
	             p = p.oldp;                     
                  ]; (* end if *)
               ]; (*  end if *)    

               (* Make sure pivot is not convoluted zero with CE *)
               If[pivotcheck === False
                  ,                       
                  Tmpelm = Simplifypivot[ matp[[1,1]] ];
                  If[Tmpelm === 0
                     ,
                     Tmpelm = Simplifypivot[ matp[[2,2]] ];
                     If[Tmpelm === 0
                        , 
                        pivotcheck = Tmptrue; (* revert to NC below *)
                        , (* else *)
                        If[perm === False
                           ,
                           oldp = p;
                           p = NCPermutationMatrix[{2,1}];
                           matp = p . matp . Transpose[p];
                           p = p.oldp;
                           , (* else *)
                           pivotcheck = Tmptrue; (* revert to NC below *)
                        ]; (* end if *)                            
                     ]; (* end if *)
                  ];  (* end if *)
               ]; (* end if *)

               (* Make sure pivot is not convoluted zero with NC *)      
               If[Not[pivotcheck === False]
                  ,
                  If[pivotcheck === Tmptrue
                     ,
                     pivotcheck = False
                  ];    
                  Tmpelm = matp[[1,1]]//NCSimplifyRational;
                  If[Tmpelm === 0
                     ,
                     matp[[1,1]] = 0;
                     Tmpelm = matp[[2,2]]//NCSimplifyRational;
                     If[Tmpelm === 0
                        ,
                        matp[[2,2]] = 0;
                     ];
                  ]; (* end if *)
               ]; (* end if *)
               
	       If[matp[[1,1]] === 0    (* if #2 *)
                  ,
  		  If[matp[[2,2]] === 0      (* if #3 *) 
                     ,
         	     p = IdentityMatrix[2];         	  
		     Return[{p,matp,p,p,{Range[nfix]} }];	 
                     , (* Else *)
                     If[Not[perm === False]
                        ,
                        Print["Permutation Disregarded 1"];  
                     ]; 
		     oldp = p; 
		     p = NCPermutationMatrix[{2, 1}];
		     matp = p . matp . Transpose[p];
		     p = p.oldp;
		     newperm = NCMatrixToPermutation[p];
		     newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};
                     newperm = Flatten[newperm];
                     subgauss = GaussElimination[matp];
                     lleft = Transpose[p] . subgauss[[1]];
                     rright = subgauss[[3]] . p;                  
                     Return[{lleft, subgauss[[2]], rright,p, {newperm}}];
                  ]; (* end if #3 *)                    
                  , (* Else *)
                  newperm = NCMatrixToPermutation[p];
                  newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};
                  newperm = Flatten[newperm];
                  subgauss = GaussElimination[matp];
                  lleft = Transpose[p] . subgauss[[1]];
                  rright = subgauss[[3]] . p;
                  Return[{lleft, subgauss[[2]], rright,p,{newperm}}];
               ]; (* end if #2 *)
               ,(* Else for block if *) 
               newperm = NCMatrixToPermutation[p];
               newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};
               newperm = Flatten[newperm];
               subgauss = GaussElimination[matp];
               lleft = Transpose[p] . subgauss[[1]];
               rright = subgauss[[3]] . p;
               Return[{lleft, subgauss[[2]], rright,p,{newperm}}];
            ]; (* end block automatic permutations if *)
         ];  (* end if #4 *)
         ,(* Else (for if #1) *)
         (*   Find pivot  *)
         (*****************)
         p = Perm[nfix, n, perm];
         matp = p . mat . Transpose[p];
         pivfound = True; 
         If[stopauto  === False  (* if for block automatic permutation *)
            ,
            (*   Find pivot  *)
            (*****************)
            If[pivotcheck === False && perm === False
               ,
               Tmpelm = Simplifypivot[ matp[[1,1]] ];
               , (* else *)
               Tmpelm = NCSimplifyRational[ matp[[1,1]] ];
            ]; (* end if *)
          
            (* pivot with smallest smallest leaf count diagonal *)
            If[Tmpelm === 0 || perm === False
               ,
               leafct = Map[LeafCount,Diag[matp]];
               pivfound = False; (* becomes true when nonzero pivot found *)
               loopcheck = 1;
               leafsort = Union[Sort[leafct]]; (* sort leafct from smallest to \
largest *)
               For[i = 1, i <= Length[leafsort], i++,
                   pivpos = Flatten[Position[leafct, leafsort[[i]]]]; 
                   For[j = 1, j <= Length[pivpos], j++,
                       k = pivpos[[j]];                 
                       If[pivotcheck === False && loopcheck <= n
                          ,
                          loopcheck++;
                          Tmpelm =  Simplifypivot[  matp[[k,k]]  ];
                          If[Not[Tmpelm === 0]
                             ,                          
                             pivfound = True;                          
                             , (* else *)
                             If[loopcheck > n
                                ,
                                i = 0;
                                j = 0; 
                             ];
                          ]; (* end if *)
                          , (* else *)                                        
                          Tmpelm =  NCSimplifyRational[  matp[[k,k]]  ];
                          If[Not[Tmpelm === 0]
                             ,                           
                             pivfound = True;
                             , (* else *)                          
                             matp[[k,k]] = 0;
                          ]; (* end if *)
                       ]; (* end if *) 
                       If[pivfound === True
                          ,
                          If[k != 1 && Not[perm === False]
                             ,
                             Print["Permutation Disregarded 7"];  
                          ];                
                          j = Length[pivpos];
                          i = Length[leafsort];
                          oldp = p;
                          p = Range[n];
                          p[[1]] = k; p[[k]] = 1;
                          p = NCPermutationMatrix[p];
                          matp = p . matp . Transpose[p];
                          If[matp[[1,1]] === 0
                             ,
                             Print["Error!"]; 
                             Abort[] 
                          ];
                          p = p.oldp;
                          pivfound = True;
                       ]; (* end if *)                    
                   ];  (* end for *)                  
               ]; (* end for *)           
            ]; (* end if *)
         
            (*  pivot check *)  
            If[Not[pivfound]
               ,
               If[Not[ Diag[matp] === Flatten[NCZeroMatrix[n,1]] ]
                  ,
                  Print["Error!!!!"];
                  Abort[];
               ];
            ];

            (*  end pivot check  *)
            (*  end find pivot   *)
            (*********************)
         ]; (* end if for block automatic permutation *)
                             	         
         Which[pivfound (* test 1 *)
               ,
               (* Submatrices *)
               submata = NCSubMatrix[matp, {1, 1}, {1, 1}];
               submatb = NCSubMatrix[matp, {1, 2}, {1, n-1}];
               submatc = NCSubMatrix[matp, {2, 1}, {n-1, 1}];
               submatd = NCSubMatrix[matp, {2, 2}, {n-1, n-1}];
              
               (* Recursive steps on matrices size n-1 *)
               dtil = submatd-MatMult[submatc,
                                {{inv[ submata[[1,1]] ] }},submatb];
               cinvsubmata= MatMult[submatc , {{inv[submata[[1,1]] ]}} ];
               binvsubmata= MatMult[{{inv[submata[[1,1]] ]}} , submatb];
               (*    Print[inv[ submata[[1,1]] ]]; *)
               subgauss = LDUrec[nfix, dtil,
                                 CheckDecomposition -> checkit, 
                                 Permutation -> perm, 
                                 NCSimplifyPivots -> pivotcheck, 
                                 StopAutoPermutation -> stopauto,
                                 Stop2by2Pivoting -> stop2by2];
               (* Outside recursive loop *)
            
               (* Lower Matrix *)
               lleft = NCBlockMatrix[{{ {{1}}, NCZeroMatrix[1,n-1]},
                                     {cinvsubmata, subgauss[[1]] }}  ];
               (* Upper matrix *)
               rright = NCBlockMatrix[ {{ {{1}},binvsubmata},
                              { NCZeroMatrix[n-1,1], subgauss[[3]] }} ];
               (* Diagonal Matrix *)
               diagon =  NCBlockMatrix[ {{ submata, NCZeroMatrix[1,n-1] },
                              { NCZeroMatrix[n-1,1], subgauss[[2]] }} ];
               (* Permutation Matrix *)
               P = NCBlockMatrix[ {{ {{1}}, NCZeroMatrix[1,n-1] },
                                 { NCZeroMatrix[n-1,1], subgauss[[4]] }} ].p;
   
               newperm = NCMatrixToPermutation[p];         
               newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};
               newperm = Flatten[newperm];
               newperm = PrependTo[subgauss[[5]], newperm];               
                
               (* Output *)
               output = {Transpose[p].lleft, diagon, rright.p, P,newperm};
               Return[output];
               ,
               matp === NCZeroMatrix[n]   (* test 2 *),
               Print["Returning Zero Matrix"];
               P = IdentityMatrix[n];
               newperm = {};
               For[i = 1, i <= n-1,i++,
                   newperm = AppendTo[newperm, Range[nfix]];
               ]; (* end for *)
               output = {P,NCZeroMatrix[n],P,P,newperm};
               Return[output];
               ,
               True (* test 3 *)
               ,
               (* if stop2by2 is true then we return block left over *)
               If[stop2by2 === True
                  ,                        
                  newperm = NCMatrixToPermutation[p];
                  newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};
                  newperm = {Flatten[newperm]};
                  For[i = 1, i <= n-2,i++,
                      newperm = AppendTo[newperm, Range[nfix]];
                  ]; (* end for *)
                  output = {Transpose[p],matp,p,p,newperm};
                  Return[output];
               ]; (* end 2by2 if *)
                                             
               oldp = p;           
               (* search for non-zero entry *)
               (* for now assume matrix is symetric *)                
               For[j = 1, j <= n-1, j++,
                   For[i = j+1, i <=n, i++,
                       Tmpelm = matp[[i,j]]//NCSimplifyRational;
                       If[Tmpelm === 0
                          ,
                          matp[[i,j]] = 0;
                       ];
                       If[Not[matp[[i,j]] === 0]
                          ,
                          If[Not[perm === False]
                             ,
                             Print["Permutation Disregarded 4"];  
                          ];                          
                          p1 = Range[n];
                          p2 = Range[n];
                          p1[[1]] = j ; p1[[j]] = 1;
                          p2[[2]] = i ; p2[[i]] = 2;
                          p1 = NCPermutationMatrix[p1];
                          p2 = NCPermutationMatrix[p2];                       \
    
                          p = p2.p1;
                          Clear[p1,p2];                    
                          j = n; 
                          i = n;
                       ];  (* end if *)
                   ];  (* end inner for *)
               ]; (* end outer for *)
               matp = p . matp . Transpose[p];
               p = p.oldp;
               (* Print["matp = ",MatrixForm[matp], "P = ", MatrixForm[p]]; *)
               (* check permutation works *)
               If[NCSimplifyRational[matp[[2,1]]] === 0
                  ,
                  matp = NCSimplifyRational[matp];
                  If[matp === NCZeroMatrix[n]
                     ,
                     Print["Returning Zero Matrix"];
                     P = IdentityMatrix[n];
                     newperm = {};
                     For[i = 1, i <= n-1,i++,
                         newperm = AppendTo[newperm, Range[nfix]];
                     ]; (* end for *)
                     output = {P,NCZeroMatrix[n],P,P,newperm};
   
                     Return[output];
                     , (* else *)   

                     Print["2X2 permutation failed!!"];
                     Abort[];
                  ]; (* end if *)
               ];  (* end if *)
               (* end check *)
                
               (* *******pivot with 2X2 block****** *)
               (* Submatrices *)
              
               submata = NCSubMatrix[matp, {1, 1}, {2, 2}];
                 
               submatb = NCSubMatrix[matp, {1, 3}, {2, n-2}];
               submatc = NCSubMatrix[matp, {3, 1}, {n-2, 2}];
               submatd = NCSubMatrix[matp, {3, 3}, {n-2, n-2}];
                
               invsubmata = {{0, inv[submata[[2,1]] ]},
                             {inv[submata[[1,2]] ],0}};
                 
               (* Recursive steps on matrices size n-2 *)
                
               dtil = submatd-MatMult[submatc,invsubmata,submatb];
               cinvsubmata= MatMult[submatc , invsubmata ];
               binvsubmata= MatMult[invsubmata , submatb];
                              
               subgauss = LDUrec[nfix, dtil,
                                 CheckDecomposition -> checkit, 
                                 Permutation -> perm,
                                 NCSimplifyPivots -> pivotcheck,
                                 StopAutoPermutation -> stopauto,
                                 Stop2by2Pivoting  -> stop2by2 ]; 
                                    
               (* Outside recursive loop *)
            
               (* Lower Matrix *)
               lleft = NCBlockMatrix[{{IdentityMatrix[2], NCZeroMatrix[2,n-2]},
                                      {cinvsubmata, subgauss[[1]] }} ];
               (* Upper matrix *)
               rright = NCBlockMatrix[{{IdentityMatrix[2] ,binvsubmata},
                                       {NCZeroMatrix[n-2,2], subgauss[[3]]}}];
               (* Diagonal Matrix *)
               diagon =  NCBlockMatrix[{{submata, NCZeroMatrix[2,n-2]},
                                        {NCZeroMatrix[n-2,2], subgauss[[2]]}}];
               (* Permutation Matrix *)
               P = NCBlockMatrix[{{IdentityMatrix[2], NCZeroMatrix[2,n-2] },
                                  {NCZeroMatrix[n-2,2], subgauss[[4]] }} ].p;
                
               newperm = NCMatrixToPermutation[p];
               newperm = {Range[nfix-n], Range[nfix-n+1,nfix][[newperm]]};   \
             
               newperm = Flatten[newperm];
               newperm = {Range[nfix],newperm};
               newperm = PrependTo[subgauss[[5]], newperm];
               newperm = AppendTo[newperm,"2by2 permutation"];
               
               (* Output *)
               output = {Transpose[p].lleft, diagon, rright.p, P,newperm};
               Return[output];
         ];   (* End Which *)    
     ]; (* end if #1 *)
  ];
 
  NCLDUDecomposition[mat_?MatrixQ, opts___Rule ] := Module[
    {l,d,u,P,checkit,perm,output,checkresult,nfix,pivotcheck,
     stopauto,returnperm,stop2by2},

    checkit = CheckDecomposition /. {opts} /. Options[NCLDUDecomposition];
    perm = Permutation /. {opts} /. Options[NCLDUDecomposition];
    pivotcheck = NCSimplifyPivots /. {opts} /. Options[NCLDUDecomposition];
    stopauto   = StopAutoPermutation /. {opts} /. Options[NCLDUDecomposition];
    returnperm = ReturnPermutation /. {opts} /. Options[NCLDUDecomposition];
    stop2by2  = Stop2by2Pivoting /. {opts} /. Options[NCLDUDecomposition];
        
    If [Length[perm]==0,perm=False];
    If [Not[perm === False],
      If [CheckPermutation[Length[mat], perm]
          ,{Print["Not valid permutation list!"]; Abort[]}
      ];
    ];
    nfix = Length[mat];
    output = LDUrec[nfix, mat,
                    CheckDecomposition -> checkit, Permutation -> perm,
                    NCSimplifyPivots -> pivotcheck,
                    StopAutoPermutation -> stopauto ,
                    ReturnPermutation -> returnperm,
                    Stop2by2Pivoting -> stop2by2];
    P = output[[4]];
    output[[1]] = P.output[[1]];
    output[[3]] = output[[3]].Transpose[P];
    If [checkit
        ,
        Print["Check..."];
        checkresult = NCSimplifyRational[MatMult[
                             output[[1]],output[[2]],output[[3]] ] ];
        If[Not[checkresult === NCSimplifyRational[P.mat.Transpose[P] ] ]
           ,Print[
           "Warning: The LDU decomposition did not work!"]; 
        ];
    ];
    If [returnperm === True
        ,
         Return[output];
        ,(*else*)
         Return[output[[{1,2,3,4}]]];
    ];
  ];

  NCAllPermutationLDU[ mat_, opts___Rule ]:=
          Module[{n = Length[mat],allperm,permset,i,f,x,h,res={},permres = {},
                  permselect,checkit,pivotcheck,stopauto,returnperm},
          checkit = CheckDecomposition /. {opts} /. Options[NCAllPermutationLDU];      \

          pivotcheck = NCSimplifyPivots /. {opts} /. \
  Options[NCAllPermutationLDU];  
          stopauto   = StopAutoPermutation /. {opts} /.  \
  Options[NCAllPermutationLDU]; 
          returnperm = ReturnPermutation /. {opts} /.  \
  Options[NCAllPermutationLDU];
          stop2by2  = Stop2by2Pivoting /. {opts} /. \
  Options[NCAllPermutationLDU];         	
          permselect = PermutationSelection /. {opts} /.  \
  Options[NCAllPermutationLDU]; 
          (*NOTE:  To select a range of permutations, say m through n, enter      *)
          (*PermutationSelection -> {{m},{n}}.  To select specific permutations   *)
          (*from the list of all permutations constructed by this program         *)
          (*enter PermutationSelection -> {i1,i2,i3,...,in} .                     *)
          If[Length[ Dimensions[permselect] ] == 2 ,
             permselect = Range[ permselect[[1,1]],permselect[[2,1]] ];
            ]; (* end if *)



          If[n <= 5,
             allperm = Sort[MinimumChangePermutations[Range[n]]];
             permset={allperm};
             Do[ permset = Append[permset,  Take[allperm, Factorial[i]] ];
                    , {i, n-1, 2, -1} ];
             Pull[f_[x__]]:=x;		
             permset=Flatten[Outer[f,Pull[permset],1],n];
             permset=permset /. f[x___] -> List[x];
          ,(* else *)
            allperm = Sort[MinimumChangePermutations[Range[5]]];
            permset={allperm};
            Do[ permset = Append[permset,  Take[allperm, Factorial[i]] ];
                    , {i, 5-1, 2, -1} ];
            Pull[f_[x__]]:=x;		
            permset=Flatten[Outer[f,Pull[permset],1],5];
            permset=permset /. f[x___] -> List[x];

            Clear[ExpandPermutation];
            ExpandPermutation[list_] := 
                   Module[{tmplist, tmplist2, tmpfun},
                      tmpfun[x_] := Flatten[{x, Range[5 + 1, n]}];
                      tmplist = Map[tmpfun, list];             
                       For[i = 1, i < n - 5 + 1, i++,
                           tmplist = AppendTo[tmplist, tmpfun[Range[5]]  ];     \

                          ];        
                     Return[tmplist];              
                         ];
            permset = Map[ExpandPermutation,permset];
            ]; (* end if *)

          (* check selection list *)
          If[Not[permselect === False],
             permselect = Flatten[permselect]; (* safe guard list *)	    
             If[Length[permselect] > Length[permset],
                Print["Improper permutation selection: List too long!"];
                Print["There are only ",Length[permset]," permutations possible."];
                Abort[];
               ]; (*end if*)
             If[Max[permselect] > Length[permset]  || Min[permselect] < 1,
                Print["Improper permutation selection: Incorrect range in \
  selection!"];
                Print["There are only ",Length[permset]," permutations possible."];
                Abort[];
               ]; (*end if*)
            ]; (*end check selection if*)

          h[x_]:=Block[{st1,output},
                  st1 = Check[output =
                          NCLDUDecomposition[mat,Permutation -> x, 
                          CheckDecomposition -> checkit,
                          NCSimplifyPivots -> pivotcheck,
                          StopAutoPermutation -> stopauto,
                          ReturnPermutation -> returnperm,
                          Stop2by2Pivoting -> stop2by2  ],False];                         	 

          If[SameQ[st1,False]
                  ,Null, 
             AppendTo[res,st1];
             If[returnperm === True,
                AppendTo[permres, st1[[5]] ]; 
               ];(*end if*)
            ];(*end if*)
          ];(*end block*)
          If[permselect === False,
             Map[(h[#1])&,permset];
          ,(*else*)
             Map[(h[#1])&, permset[[permselect]] ];
          ];
          If[returnperm === True,
             permres = Union[permres];
             res = AppendTo[res,permres];
            ];(* end if *)
          Return[res];
          Print["I also made it this far\n"];
  ] /; MatrixQ[mat]
      
End[];
EndPackage[];

