(* :Title: 	SDPSeDuMi.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    SDPSeDuMi` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "SDPSeDuMi`",
              "MatrixVector`",
	      "NCDebug`"
]

Clear[SDPToSedumi];
SDPToSedumi::usage = "";

Clear[SDPFromSedumi];
SDPFromSedumi::usage = "";

Clear[SDPExport];
SDPExport::usage = "";

Clear[SDPImport];
SDPImport::usage = "";

Begin[ "`Private`" ]

  SDPToSedumi[{AA_, BB_, CC_}] := Module[
    {At, b, c, Kf, Kl, Kq, Kr, Ks}, 

    (* Convert data *)
    Kf = Kl = 0;
    Kq = Kr = {};
    Ks = Map[Part[Dimensions[#],1]&, CC];
    At = Transpose[SparseArray[Map[(Join @@ #)&, Map[Flatten, AA, {2}], {1}]]];
    c = Partition[Join @@ Map[Flatten, CC, {1}], 1];
    b = SparseArray[Partition[Flatten[BB], 1]];

    Return[{At, b, c, Kf, Kl, Kq, Kr, Ks}];
        
  ];

  SDPFromSedumi[{At_, b_, c_, Kf_, Kl_, Kq_, Kr_, Ks_}] := Module[
    {AA, BB, CC, dims, i, j, ni, nn, mm}, 

    (* Convert data *)
    {mm, nn} = Dimensions[At];
    dims = Transpose[{Ks, Ks}];
    AA = Map[ (MatrixVectorReshape[ Flatten[#], dims])&, Transpose[At] ];
    BB = {{Flatten[b]}};
    CC = MatrixVectorReshape[ Flatten[c], dims];

    Return[{AA,BB,CC}];
  
  ];

  SDPExport[{AA_, BB_, CC_}, filename_] := Module[
    {At, b, c, Kf, Kl, Kq, Kr, Ks, 
     info, n, nn, tmp}, 

    Print["SDPExport"];

    (* Convert to Sedumi format *)
    {At, b, c, Kf, Kl, Kq, Kr, Ks} = SDPToSedumi[{AA, BB, CC}];
    info = SparseArray[
             {Flatten[{Kf, Kl, 
                      Length[Kq], Kq, 
                      Length[Kr], Kr, 
                      Length[Ks], Ks} ]} ];
    n = Length[b];
    m = Length[c];
    nn = Max[n+1, Part[Dimensions[info],2]];

    (* Build compact storage *)
    tmp = Join[
            PadRight[
              Join[ 
                SparseArray[Transpose[Prepend[b, {n}]]] 
               ,Join[At, c, 2] 
              ]
             ,{m+1, nn}
            ]
           ,PadRight[info, {1, nn}]
          ];
     
    Print["> Exporting problem to file '" <> filename <> ".mm" <> "'"];

    (* Export to file *)
    Export[filename <> ".mm", tmp, "MTX"];

    Return[tmp];
  ];

  SDPImport[filename_] := Module[
    {At, b, c, Kf, Kl, Kq, Kr, Ks, 
     P, n, nn, mm, i}, 

    Print["SDPImport"];
    Print["> Importing problem from file '" <> filename <> ".mm" <> "'"];

    (* Import from file *)
    P = Import[filename <> ".mm"];

    (* Parse matrix *)
    {mm,nn} = Dimensions[P];
    n = Round[P[[1,1]]];
    Print["> Problem dimensions: (n, m) = (" <> 
          ToString[n] <> ", " <> ToString[mm-2] <> ")"];

    b = Partition[P[[1, 2 ;; n+1]], 1];
    At = P[[2 ;; mm-1, 1 ;; n]];
    c = Partition[P[[2 ;; mm-1, n+1]], 1];

    Kline = Round[Flatten[Normal[P[[mm, All]]]]];
    Kf = Kline[[1]];
    Kl = Kline[[2]];

    i = 3;
    m = Kline[[i]];
    Kq = Kline[[i+1 ;; i+m]];
    i = i + m + 1;

    m = Kline[[i]];
    Kr = Kline[[i+1 ;; i+m]];
    i = i + m + 1;

    m = Kline[[i]];
    Ks = Kline[[i+1 ;; i+m]];
    i = i + m + 1;

    Print["> Variables:"];
    If [kf > 0,
      Print["  Free = " <> ToString[Kf]];
    ];
    If [kl > 0,
      Print["  Positive = " <> ToString[Kl]];
    ];
    If [Length[Kq] > 0,
      Print["  Lorentz = " <> ToString[Length[Kq]]];
    ];
    If [Length[Kr] > 0,
      Print["  Rotated Lorentz = " <> ToString[Length[Kr]]];
    ];
    If [Length[Ks] > 0,
      Print["  Positive semidefinite = " <> ToString[Length[Ks]]];
    ];

    Return[SDPFromSedumi[{At, b, c, Kf, Kl, Kq, Kr, Ks}]];

  ];

End[]

EndPackage[]
