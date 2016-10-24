AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`
<< PrimalDual`

RunTest[example_String] := Block[{},
  
  Get[example];

  Print[""];
  Print["Problem file: ", example];
  Print[""];

  Print["* Data: "];
  Print["  A = ", Map[MatrixForm,A]];
  Print["  B = ", Map[MatrixForm,BB]];
  Print["  C = ", Map[MatrixForm,CC]];

  {FPrimalEval, FDualEval, \
   SylvesterVecEval, SylvesterVecDiagonalEval, FSylvesterSolve}	\
    = SDPFunctions[{A, BB, CC}];

  {Yk, Xk, Sk, iters} = PrimalDual[ FPrimalEval, FDualEval, \
                SylvesterVecEval, SylvesterVecDiagonalEval,\
                BB, CC, \
                Method -> LongStep, \
                RationalizeIterates -> True, \
                RationalizeTol -> GapTol/10, \
                SearchDirection -> KSH (* NesterovTodd *), \
  		LeastSquares -> Direct, \
                CGPreconditioner -> Identity, \
                GapTol -> 10^(-12), DebugLevel -> 0];

  Print["* Results: "];
  Print["  Y = ", Map[MatrixForm, Yk]];
  Print["  S = ", Map[MatrixForm, Sk]];
  Print["  X = ", Map[MatrixForm, Xk]];
  Print["  |A(Y) + S - C| = ", N[Map[MatrixVectorFrobeniusNorm, (FDualEval @@ Yk) + Sk - CC]]];
  Print["  |A*(X) - B| = ", N[Map[MatrixVectorFrobeniusNorm, (FPrimalEval @@ Xk) - BB]]];
  Print["  l(S) = ", Min[N[Map[Eigenvalues, Sk]]]];
  Print["  l(X) = ", Min[N[Map[Eigenvalues, Xk]]]];

  Print[""];
  Print["------------------------------------------------------------"];

];
RunTest[example_List] := Map[RunTest, example];

(* Examples *)
examples = { 
  "data/sdp1.mat",
  "data/sdp2.mat",
  "data/sdp3.mat",
  "data/sdp4.mat",
  "data/sdp5.mat",
  "data/sdp6.mat",
  "data/sdp7.mat",
  "data/sdp8.mat",
  "data/sdp9.mat"
};

RunTest[examples];

$Echo = DeleteCases[$Echo, "stdout"];
