AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`
<< PrimalDualEmbedding.m

RunTest[example_String] := Block[{},
  
  Get[example];

  Print[""];
  Print["Problem file: ", example];
  Print[""];

  Print["* Data: "];
  Print["  A = ", Map[MatrixForm,A]];
  Print["  B = ", Map[MatrixForm,BB]];
  Print["  C = ", Map[MatrixForm,CC]];

  {FPrimalEval, FDualEval, SylvesterVecEval, SylvesterVecDiagonalEval} \
    = SDPFunctions[1.*A];

  logFile = OpenWrite[example <> ".log"];
  SetOptions[NCDebug, DebugLevel -> 1];
  SetOptions[NCDebug, DebugLogfile -> logFile];
  SetOptions[NCDebug, DebugLogfile -> Append[$Output, logFile]];

  {Yk, Xk, Sk, iters} = PrimalDual[ FPrimalEval, FDualEval, \
                SylvesterVecEval, SylvesterVecDiagonalEval,\
                1.*BB, 1.*CC, \
                Method -> LongStep, \
                SearchDirection -> NesterovTodd, \
		ScaleHessian -> True, \
                LeastSquares -> CG, \
                CGPreconditioner -> Diagonal, \
                GapTol -> 10.^(-12), \
                DebugLevel -> 0 ];

  Close[logFile];

  Print["* Results: "];
  Print["  Y = ", Map[MatrixForm, Yk]];
  Print["  S = ", Map[MatrixForm, Sk]];
  Print["  X = ", Map[MatrixForm, Xk]];
  Print["  |A(Y) + S - C| = ", Map[MatrixVectorFrobeniusNorm, (FDualEval @@ Yk) + Sk - CC]];
  Print["  |A*(X) - B| = ", Map[MatrixVectorFrobeniusNorm, (FPrimalEval @@ Xk) - BB]];
  Print["  l(S) = ", Min[Map[Eigenvalues, Sk]]];
  Print["  l(C - A(Y)) = ", Min[Map[Eigenvalues, CC - (FDualEval @@ Yk)]]];
  Print["  l(X) = ", Min[Map[Eigenvalues, Xk]]];

  Print[""];
  Print["------------------------------------------------------------"];

];
RunTest[example_List] := Map[RunTest, example];

examples = { 
  "data/sdp5.mat",
};

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

