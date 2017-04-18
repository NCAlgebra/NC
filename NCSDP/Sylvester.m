(* :Title: 	Sylvester.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    Sylvester` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "Sylvester`",
              "Kronecker`",
	      "NCDebug`"
]

Clear[SylvesterEntryPrimalMultiply];
SylvesterEntryPrimalMultiply::usage="";

Clear[SylvesterEntryDualMultiply];
SylvesterEntryDualMultiply::usage="";

Clear[SylvesterEntryPrimalVectorize];
SylvesterEntryPrimalVectorize::usage="";

Clear[SylvesterEntryDualVectorize];
SylvesterEntryDualVectorize::usage="";

Clear[SylvesterEntrySylvesterVectorize];
SylvesterEntrySylvesterVectorize::usage="";

Clear[SylvesterEntryScale];
SylvesterEntryScale::usage="";

Clear[SylvesterEntrySymmetrize];
SylvesterEntrySymmetrize::usage="";

Clear[SylvesterLeftSymmetricProjection];
SylvesterLeftSymmetricProjection::usage="";

Clear[SylvesterRightSymmetricProjection];
SylvesterRightSymmetricProjection::usage="";

Clear[SylvesterSymmetrize];
SylvesterSymmetrize::usage="";

Clear[SylvesterPrimalEval];
SylvesterPrimalEval::usage="";

Clear[SylvesterDualEval];
SylvesterDualEval::usage="";

Clear[SylvesterPrimalVectorize];
SylvesterPrimalVectorize::usage="";

Clear[SylvesterDualVectorize];
SylvesterDualVectorize::usage="";

Clear[SylvesterSylvesterVecEval];
SylvesterSylvesterVecEval::usage="";

Begin[ "`Private`" ]

  SylvesterEntryPrimalMultiply[{L_,R_},Y_]:=Module[
    {m,n,p,Np,q,Nm,N},

    (* 
	Dimensions:
	Y: m x n
        R: n x N p
        L: q x N m
     *)
     {m,n}=Dimensions[Y];
     {n,Np}=Dimensions[R];
     {q,Nm}=Dimensions[L];
     N=Nm/m;
     p=Np/N;

     (* Computes \sum_i L_i Y R_i *)
     Return[
       L.ArrayFlatten[Transpose[Partition[Y.R,{m,p}]]]
     ];
  ];

  SylvesterEntryDualMultiply[{L_,R_},X_] := 
    Transpose[SylvesterEntryPrimalMultiply[{R,L},X]];

  SylvesterEntryScale[{L_,R_},W_]:=Module[
    {m,n,p,Np,q,Nm,N},

    (* 
	Dimensions:
	W: p x q
        R: n x N p
        L: q x N m
     *)
     {p,q}=Dimensions[W];
     {n,Np}=Dimensions[R];
     {q,Nm}=Dimensions[L];
     N=Np/p;
     m=Nm/N;

     (* Computes {W L_i, R_i W} *)
     Return[
       {W . L, ArrayFlatten[Map[(#1 . W)&, Partition[R,{n,p}]]] }
     ];
  ];

  SylvesterEntryScale[{L_,R_},Wl_,Wr_] := (
    Message[PrimalDual`PrimalDual::Error, 
            SylvesterEntryScale,
            "Asymmetric scalings are not supported yet."];
    Return[{L, R}];) /; Wl =!= Wr;
  
  SylvesterEntryScale[{L_,R_},Wl_,Wr_]:=Module[
    {m,n,p,Np,q,Nm,N},

    (* 
	Dimensions:
	W: p x q
        R: n x N p
        L: q x N m
     *)
     {p,q}=Dimensions[Wl];
     {n,Np}=Dimensions[R];
     {q,Nm}=Dimensions[L];
     N=Np/p;
     m=Nm/N;

     (* Computes {Wl L_i, R_i Wr} *)
     Return[
       {Wl . L, ArrayFlatten[Map[(#1 . Wr)&, Partition[R,{n,p}]]] }
     ];
  ];

  SylvesterEntryPrimalVectorize[{L_,R_},{m_,n_},
                              symmetric_:False,reduced_:False] := 
  Module[
    {nn,p,Np,q,Nm,N,A},

    (* 
	Dimensions:
	R: n x N p
 	L: q x N m
    *)
    {nn,Np}=Dimensions[R];
    {q,Nm}=Dimensions[L];
    N=Nm/m;
    p=Np/N;

    (* Computes \sum_i R_i^T \otimes L_i *)
    A = Flatten[Apply[Plus,
        MapThread[KroneckerProduct,
          { Map[Transpose,Partition[R,{n,p}],{2}],
            Partition[L,{q,m}] }, 2], {1}], 1];

    (* Compute (1/2)(I + K_{p,p}) \sum_i R_i^T \otimes L_i  *)
    A += Part[A,TransposePermutation[q,p],All];
    A /= 2;

    (* Reduction is on the right! *)

    Return[

      If[ reduced && symmetric,

	 SylvesterRightSymmetricProjection[A, m, n]

	,

         A

      ]

    ];

  ];

  SylvesterEntryDualVectorize[{L_,R_},{m_,n_},
                                symmetric_:False,reduced_:False] := 
  Module[
    {nn,p,Np,q,Nm,N,A},

    (* 
	Dimensions:
	R: n x N p
 	L: q x N m
    *)
    {nn,Np}=Dimensions[R];
    {q,Nm}=Dimensions[L];
    N=Nm/m;
    p=Np/N;

    (* Computes \sum_i R_i \otimes L_i^T *)
    A = Flatten[Apply[Plus,
        MapThread[KroneckerProduct,
          { Partition[R,{n,p}],
            Map[Transpose,Partition[L,{q,m}],{2}] }, 2], {1}], 1];

    (* Reduction is on the left! *)

    Return[

      If[ symmetric,

         If[ reduced, 

(*
            A += Part[A,All,TransposePermutation[q,p]];

	    ( Part[A, LowerTriangularProjection[m,n],All] +
              Part[A, UpperTriangularProjection[m,n],All] ) / 4
*)
            SylvesterLeftSymmetricProjection[
	      (A + Part[A,All,TransposePermutation[q,p]]) / 2
              , m, n]

           ,

	     (A + Part[A, TransposePermutation[m,n], 
      		          TransposePermutation[q,p] ])/2

         ]
        ,

	 A

      ]

    ];

  ];

  SylvesterEntrySylvesterVectorize[{L1_,R1_},{L2_,R2_},{m1_,n1_},{m2_,n2_}] := 
  Module[
    {nn,
     p1,Np1,q1,Nm1,N1,
     p2,Np2,q2,Nm2,N2,
     k1,k2,
     H1,H2,
     Rk1,Lk1T,Rk2T,Lk2},

    (*
	Dimensions:
	R: n x N p
	L: q x N m
    *)
    {nn,Np1}=Dimensions[R1];
    {q1,Nm1}=Dimensions[L1];
    N1=Nm1/m1;
    p1=Np1/N1;

    {nn,Np2}=Dimensions[R2];
    {q2,Nm2}=Dimensions[L2];
    N2=Nm2/m2;
    p2=Np2/N2;

    (*
      Print["p1,q1,N1 =",p1,",",q1,",",N1];
      Print["p2,q2,N2 =",p2,",",q2,",",N2];
    *)

    H1=0;
    H2=0;
    For[k1=1,k1<=N1,k1++,

	(* Print["k1 =",k1]; *)

	Rk1=Part[R1,All,(k1-1)p1+1;;k1 p1];
	Lk1T=Transpose[Part[L1,All,(k1-1)m1+1;;k1 m1]];

	(*
	  Print["Rk1 =",Rk1];
	  Print["Lk1T =",Lk1T];
	*)

	For[k2=1,k2<=N2,k2++,

	    (*Print["k2 =",k2];*)

	    Rk2T=Transpose[Part[R2,All,(k2-1)p2+1;;k2 p2]];
	    Lk2=Part[L2,All,(k2-1)m2+1;;k2 m2];

	    (*
	      Print["Rk2T =",Rk2T];
	      Print["Lk2 =",Lk2];
	    *)

	    (* Computes 
  	       \sum_{k_i} \sum_{k_j} R_{k_i} R_{k_j}^T \otimes L_{k_i}^T L_{k_j}
     	    *)
	    H1+=KroneckerProduct[Rk1.Rk2T,Lk1T.Lk2];

	    (* Computes 
  	       \sum_{k_i} \sum_{k_j} R_{k_i} L_{k_j} \otimes L_{k_i}^T R_{k_j}^T
     	    *)
	    H2+=KroneckerProduct[Rk1.Lk2,Lk1T.Rk2T];

	    (*
	      Print["H1 =",H1];
	      Print["H2 =",H2];
	    *)

	];

    ];

    Return[{H1,H2}];
  ];


  (* Symmetrization *)

  SylvesterEntrySymmetrize[x_] := (x + Transpose[x])/2;

  SylvesterSymmetrize[x_, symmetry_] := 
    MapThread[If[#2, SylvesterEntrySymmetrize[#1], #1] &, {x, symmetry}];

  (* Symmetric Projections *)

(*

  SylvesterRightSymmetricProjection[A_, m_, n_] := 
    ( Part[A, All, LowerTriangularProjection[m,n]] +
      Part[A, All, UpperTriangularProjection[m,n]] ) / 2;

  SylvesterLeftSymmetricProjection[A_,m_,n_] :=
    ( Part[A, LowerTriangularProjection[m,n], All] +
      Part[A, UpperTriangularProjection[m,n], All] ) / 2;

*)

  SylvesterLeftSymmetricProjection[A_, m_, n_] := Module[
    {tmp = Part[A, LowerTriangularProjection[m,n], All]
         + Part[A, UpperTriangularProjection[m,n], All],
     dindex = Table[1 + (1 + 2 m - j) j/2, {j, 0, Min[m, n] - 1}] },

    Part[tmp, dindex, All] /= 2; 

    Return[ tmp ];

  ];

  SylvesterRightSymmetricProjection[A_, m_, n_] := Module[
    {tmp = Part[A, All, LowerTriangularProjection[m,n]]
         + Part[A, All, UpperTriangularProjection[m,n]],
     dindex = Table[1 + (1 + 2 m - j) j/2, {j, 0, Min[m, n] - 1}] },

    Part[tmp, All, dindex] /= 2; 

    Return[ tmp ];

  ];

  (* The Eval's and Vec's *)

  SylvesterPrimalEval[AA_,x_]:=
    Map[ 
      SylvesterEntrySymmetrize[
        Plus@@MapThread[SylvesterEntryPrimalMultiply,{#,x}]
      ]&, AA];

  SylvesterDualEval[AA_,x_,symmetry_]:=
    SylvesterSymmetrize[
      Apply[ 
        Plus
        , Map[MapThread[SylvesterEntryDualMultiply,{#,x}]&,Transpose[AA]]
        , {1}
      ]
      ,
      symmetry
  ];

  SylvesterPrimalVectorize[AA_,dims_,symmetric_,reduced_:False] :=
    Map[ 
      ArrayFlatten[{
        MapThread[(SylvesterEntryPrimalVectorize[#1,#2,#3,reduced]&),
          {#,dims,symmetric}]
      }]&
     ,AA];

  SylvesterDualVectorize[AA_,dims_,symmetric_,reduced_:False] :=
    Map[ArrayFlatten[{#}]&, 
      Transpose[
        Map[
          MapThread[
            (SylvesterEntryDualVectorize[#1,#2,#3,reduced])&,
            {#,dims,symmetric}]&
        ,AA]]];

  SylvesterSylvesterVecEval[AA_,Wl_,Wr_,dims_,symmetry_,reduced_:False] := (
    Message[PrimalDual`PrimalDual::Error, 
            SylvesterSylvesterVecEval,
            "Asymmetric scalings are not supported yet."];
    Return[{{-1}}];) /; Wl =!= Wr;
    
  SylvesterSylvesterVecEval[AA_,Wl_,Wr_,dims_,symmetry_,reduced_:False] := Module[
    {H,n,m,iota,i,j,jmax,
     dimi,dimj,
     Aiota,Wliota,Wriota,
     U,V,
     LRj,LRi},

    (* Number of inequalities *)
    m=Length[AA];

    (* Number of variables *)
    n=Length[Part[AA,1]];

    (* 
       Print["n = ",n];
       Print["m = ",m];
    *)

    H=ConstantArray[0,{n,n}];
    For[iota=1,iota<=m,iota++,

	Aiota=Part[AA,iota];
        Wliota=Part[Wl,iota];
        Wriota=Part[Wr,iota];

	For[i=1,i<=n,i++,

	   (* scale Li and Ri *)
	   LRi=SylvesterEntryScale[Part[Aiota,i],Wliota,Wriota];
       	   jmax = If[ reduced, i, n ];
(*	   jmax = n; *)

	   For[j=1,j<=jmax,j++,

	      NCDebug[4, i, j];
 	      NCDebug[4, symmetry[[i]], symmetry[[j]] ];

	      LRj=Part[Aiota,j];
	      {U,V} = SylvesterEntrySylvesterVectorize[LRi, LRj, 
                         dims[[i]], dims[[j]]];

 	      NCDebug[4, U, V ];

	      H[[i,j]] += 

                If[reduced,

		   (* REDUCED *)

	      	   If[!symmetry[[i]]&&!symmetry[[j]],

		      NCDebug[4, i, j];

		      (* !i && !j symmetry *)
		      (U + Part[V, All,
                         TransposePermutation[dims[[j,2]], dims[[j,1]] ]])/2

                     ,

		      (* U += V; *)
		      U += Part[V, All, 
                           TransposePermutation[dims[[j,2]], dims[[j,1]]] ];
		      U /= 2;

		      If[ symmetry[[j]],

		         U = SylvesterRightSymmetricProjection[
			        U, dims[[j,1]], dims[[j,2]] ]


		      ];

		      If[ symmetry[[i]],

		         U = SylvesterLeftSymmetricProjection[
			        U, dims[[i,1]], dims[[i,2]] ]


		      ];

		      U

	      	   ]

	          ,

	      	   (* NOT REDUCED *)

	      	   If[!symmetry[[i]],

		      (* !i symmetry *)
		      (U + Part[V, All, 
                           TransposePermutation[dims[[j,2]], dims[[j,1]]] ])/2

                     ,

		      (* i symmetry *)
		      U += Part[V, All,
                           TransposePermutation[dims[[j,2]], dims[[j,1]]] ];
		      (U + Part[U,TransposePermutation @@dims[[i]], All])/4


	           ]

              ];

           ];

       ];

    ];

    If[ (*False && *) reduced, 

       (* Complete transpose *)

	For[i=1,i<=n,i++,

	   For[j=i+1,j<=n,j++,

              H[[i, j]] = Transpose[H[[j, i]]];

           ];

        ];

    ];

    (* Flatten *)
    H = ArrayFlatten[H];
      
    Return [ H ];

  ];

End[]

EndPackage[]
