(* :Title: 	RationalApproximate.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    RationalApproximate` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "RationalApproximate`" ]

Clear[RationalApproximate];
RationalApproximate::usage = "";

Begin[ "`Private`" ]

  RationalApproximate[x_List, eps_] := 
    Map[RationalApproximate[#, eps] &, x];

  RationalApproximate[x_?NumberQ, eps_] := 
    Quiet[
      Check[
        RationalApproximate[ x, 
                             Quiet[
                               ContinuedFraction[x, 20], 
                               ContinuedFraction::incomp ],
                             eps],
        Rationalize[N[x]],
        ContinuedFraction::start ],
      ContinuedFraction::start ];

  RationalApproximate[x_, {y_}, eps_] := y;

  RationalApproximate[x_, y_List, eps_] := Module[
    {z = Drop[y, -1], w, error},

    w = FromContinuedFraction[z];
    error = Abs[N[x] - N[w]];
    Return[
      If[error > eps,
        FromContinuedFraction[y],
        RationalApproximate[x, z, eps]
      ]
    ];
  ];

End[]

EndPackage[]
