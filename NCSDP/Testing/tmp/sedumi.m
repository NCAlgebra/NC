AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< SDP`
<< PrimalDual`

lmi = {x - 2, {{y, x}, {x, 1}}, {{z, y}, {y, 1}}}
vars = {x, y, z}

{Y, X, S, iters} = SDPSolve[z, lmi, vars];
Y

{At, b, c, Kf, Kl, Kq, Kr, Ks} = SDPToSedumi[z, lmi, vars]

SDPExport[z, lmi, vars, "sedumi"]

{At, b, c, Kf, Kl, Kr, Kq, Ks} = SDPImport["sedumi"]

{At, b, c, Kf, Kl, Kr, Kq, Ks} = SDPToSedumi[z, lmi, vars]

Map[MatrixVectorFrobeniusNorm, SDPMatrices[z, lmi, vars] - SDPFromSedumi[At, b, c, Kf, Kl, Kr, Kq, Ks]]

{Y, X, S, iters} = SDPSolve[SDPFromSedumi @@ SDPImport["sedumi"]];
Y

$Echo = DeleteCases[$Echo, "stdout"];
