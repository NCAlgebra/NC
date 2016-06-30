AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->100];

<< SDP`
<< CG`

dH = {{{26526.724604026498, 1.4993272575298817*^-6}}};

pc = Function[# * dH];

Wkl = {{{3266.718874303779, -1633.3545026460758, -1633.3610202623763}, {-1633.3545026460763, 816.6797398142413, 816.6754004567358}, {-1633.3610202623765, 816.6754004567358, 816.6831729974348}}};

Wkr = {{{3266.718874303779, -1633.3545026460758, -1633.3610202623763}, {-1633.3545026460763, 816.6797398142413, 816.6754004567358}, {-1633.3610202623765, 816.6754004567358, 816.6831729974348}}};

FDualEval = SDPEval[{{{{3., 1., 5.}, {1., 0, 2.}, {5., 2., 8.}}}, {{{3., 1., 5.}, {1., 1., 2.}, {5., 2., 8.}}}}, ##1[[1]]] &;

FPrimalEval = {{SDPDualEval[{{{{3., 1., 5.}, {1., 0, 2.}, {5., 2., 8.}}}, {{{3., 1., 5.}, {1., 1., 2.}, {5., 2., 8.}}}}, {##1}]}} & ;

BBbar = {{{-11., -11.}}};

Cktheta = {{{1.6007167357548079*^7, -8.00356327778375*^6, -8.003590176649483*^6}, {-8.003563277783752*^6, 4.001771438448031*^6, 4.0017848878053576*^6}, {-8.003590176649485*^6, 4.001784887805357*^6, 4.0017983372748923*^6}}};

muk = 1.594322875621724*^-7;

cgTol = 0.001;

MatrixVectorEigenvalues[Wkl]
MatrixVectorEigenvalues[Wkr]

tol = Min[.1*muk/cgTol,1]*cgTol

debugLevel = 3

SetOptions[NCDebug, DebugLevel -> 1];
CGLS[
   MatrixVectorSymmetrize[MatrixVectorDot[Wkl, FDualEval @@ ##, Wkr]]&,
   (FPrimalEval @@ ##)&, 
   0*Cktheta, 
   (FPrimalEval @@ Cktheta) - BBbar, 
   0*BBbar,
   tol, Infinity, MatrixVectorFrobeniusInner, 
   pc, If[debugLevel < 2, False, True], 1]

CGLSRES2[
   MatrixVectorSymmetrize[MatrixVectorDot[Wkl, FDualEval @@ ##, Wkr]]&,
   (FPrimalEval @@ ##)&, 
   0*Cktheta, 
   (FPrimalEval @@ Cktheta) - BBbar, 
   0*BBbar,
   tol, Infinity, MatrixVectorFrobeniusInner, 
   pc, If[debugLevel < 2, False, True], 1]

$Echo = DeleteCases[$Echo, "stdout"];
