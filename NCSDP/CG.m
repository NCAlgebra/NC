(* :Title: 	CG.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context: 	CG` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "CG`",
              "Kronecker`",
              "MatrixVector`",
              "NCDebug`" 
]

Clear[CGLS];
CGLS::usage = "";

Clear[CGLSRES2];
CGLSRES2::usage = "";

Begin[ "`Private`" ]

CGLS[F_, G_, h1_, h2_, x0_, 
     tol_, maxiter_, inner_, J_, print_, printSkip_] := 
Module[
    {
      (* temporaries *)
      xl, sl, gammal, 
      xk, sk, gammak, pk, 
      pj,
      q, s, u, alpha, beta,
      k, res
    },

    If[ print, 
      Print["K\t||res||"]; 
      Print["..............."];
    ];

    (* CONVENTION l = k - 1, j = k + 1 *)
        
    (* Initialization *)
    xk = xl = x0;
    sk = sl = h2 + G[h1 - F[x0]];
    pk = J[sl];
    gammak = gammal = inner[pk,sl];

    NCDebug[ 1, 
	     xl, sl, pk, gammal];

    (* Iterations *)
    k = 0;
    res = tol + 1;
    While[( k < maxiter && res > tol ),
      
      (* Algorithm *)
      q = G[F[pk]];
      pkq = inner[pk,q];

      If [ Abs[pkq] == 0 (* < $MachineEpsilon *),
        res = Sqrt[gammak];
        Print["SNAG #1, |pkg| = 0., res = ", res];
	Break[];
      ];

      alpha = gammal / pkq;
      xk = xl + alpha * pk;
      sk = sl - alpha * q;
      u = J[sk];
      gammak = inner[u,sk];
      beta = gammak / gammal;
      pj = u + beta * pk;

      NCDebug[ 1, 
	       q, pkq, alpha, xk, sk, u, gammak, beta, pj];

      (* Stoping criterion *)
      res = Sqrt[gammak];
      
      NCDebug[ 1, 
	       res ];

      (* Updates *)
      k = k + 1;

      pk = pj;
      gammal = gammak;
      xl = xk;
      sl = sk;

      If[ print, 
        If[ k == 1 || Mod[k, printSkip] == 0, 
          Print[k, "\t", res]; 
        ]
      ];
     
    ];

    If[ print, 
      If[ Mod[k, printSkip] != 0, 
        Print[k, "\t", res]; 
      ]
    ];

    Return[{xk,{res,k}}]
];

CGLSRES2[F_, G_, h1_, h2_, x0_, 
         tol_, maxiter_, inner_, J_, print_, printSkip_] := 
Module[
    {
      (* temporaries *)
      xl, rl, gammal, 
      xk, rk, gammak, 
      pj,
      q, s, u, alpha, beta, 
      k, res
    },

    If[ print, 
      Print["K\t||res||"]; 
      Print["..............."];
    ];

    (* CONVENTION l = k - 1, j = k + 1 *)
        
    (* Initialization *)
    kReset = Max[50, Floor[Sqrt[Length[x0]]]];
    xk = xl = x0;
    rl = h1 - F[x0];
    s = h2 + G[rl];
    pk = J[s];
    gammal = inner[pk,s];

    NCDebug[ 1, 
             kReset, xl, rl, s, pk, gammal];

    (* Iterations *)
    k = 0;
    res = Sqrt[N[gammal]];
    While[( k < maxiter && res > tol ),
      
      (* Algorithm *)
      q = F[pk];
      alpha = gammal / inner[pk, G[q]];
      xk = xl + alpha * pk;
      rk = If[ Mod[k, kReset] == 0,
          h1 - F[xk]
          ,
          rl - alpha * q
      ];
      s = h2 + G[rk];
      u = J[s];
      gammak = inner[u,s];
      beta = gammak / gammal;
      pj = u + beta * pk;

      NCDebug[ 1, 
      	       q, alpha, xk, rk, s, u, gammak ,beta, pj];

      (* Stoping criterion *)
      res = Sqrt[N[gammak]];
      
      NCDebug[ 1, 
      	       res ];

      (* Updates *)
      k = k + 1;
      pk = pj;
      gammal = gammak;
      xl = xk;
      rl = rk;
      
      If[ print, 
        If[ k == 1 || Mod[k, printSkip] == 0, 
          Print[k, "\t", res]; 
        ]
      ];
     
    ];

    If[ print, 
      If[ Mod[k, printSkip] != 0, 
        Print[k, "\t", res]; 
      ]
    ];

    Return[{xk,{res,k}}]
];

End[]

EndPackage[]
