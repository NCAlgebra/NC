<< SDP`
<< SDPFlat`
<< SDPSeDuMi`

Module[
  {test, k,
   
   A, b, y, sdp,
   X, Y, S, iters,
   lmi, vars
  },

  k = 1;
  test = "SDPSedumi";

  NCTest[0, 0, test, k++];
    
  lmi = {x - 2, {{y, x}, {x, 1}}, {{z, y}, {y, 1}}};
  vars = {x, y, z};

  sdp = SDPMatrices[z, lmi, vars];
    
  (* 
  {Y, X, S, iters} = SDPSolve[sdp];
 *)
    
];

If[ 0,
    
      {At, b, c, Kf, Kl, Kq, Kr, Ks} = SDPToSedumi[z, lmi, vars];

  SDPExport[z, lmi, vars, "Testing/sedumi"];

  {At, b, c, Kf, Kl, Kr, Kq, Ks} = SDPImport["Testing/sedumi"];

  {At, b, c, Kf, Kl, Kr, Kq, Ks} = SDPToSedumi[z, lmi, vars];

  Map[MatrixVectorFrobeniusNorm, SDPMatrices[z, lmi, vars] - SDPFromSedumi[At, b, c, Kf, Kl, Kr, Kq, Ks]];

  {Y, X, S, iters} = SDPSolve[SDPFromSedumi @@ SDPImport["Testing/sedumi"]];

    ];