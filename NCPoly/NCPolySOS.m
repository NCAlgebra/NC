(*  NCPolySOS.m                                                            *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: April 2017                                                     *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCPolySOS`",
              "NCDebug`",
	      "NCPoly`" ];

Clear[NCPolySOSToSDP,
      NCPolySOS];

Get["NCPolySOS.usage"];

NCPolySOS::NotSOS = "Polynomial is not a sum-of-squares.";

Begin["`Private`"];

  Clear[NCPolySOSAux1];
  NCPolySOSAux1[q_, k_, d_] := 
    Table[If[i >= j, Subscript[q, k, i, j], 
                     Subscript[q, k, j, i]], {i, 0, d}, {j, 0, d}];

  NCPolySOS[p_NCPoly, symbol_:Unique[]] := Block[
    {chipset = NCPolyQuadraticChipset[p], 
     index, Q},

    (* Generate Gram matrix only at chipset *)
    index = Sort[
      Flatten[
        Drop[
          Keys[
            ArrayRules[
              NCPolyCoefficientArray[chipset]
            ]
          ],
          -1]]];

    (* Print["index = ", index]; *)

    Q = SparseArray[
      Thread[
        Flatten[Outer[List, index, index], 1] ->
          Flatten[
            Outer[If[#1 >= #2, 
                     Subscript[symbol, #1, #2], 
                     Subscript[symbol, #2, #1]]&, index, index ]]
      ] 
    ];

    Return[{NCPolyFromGramMatrix[Q, p[[1]]], Q, symbol, chipset}];
  ];

  NCPolySOS[degree_Integer, vars_List, symbol_:Unique[]] := Block[
    {d = NCPolyGramMatrixDimensions[degree, vars], Q},

    Q = Table[If[i >= j, 
                 Subscript[symbol, i, j], 
                 Subscript[symbol, j, i]], {i, 0, d}, {j, 0, d}];
      
    Return[{NCPolyFromGramMatrix[Q, vars], Q, symbol}];
  ];

  Clear[deleteColumns];
  deleteColumns[m_SparseArray, cols_] := Transpose[deleteRows[Transpose[m], cols]];
  deleteColumns[m_List, cols_] := Map[Delete[#, Map[List, cols]]&, m];

  Clear[deleteRows];
  deleteRows[m_, cols_] := Delete[m, Map[List, cols]];
  
  NCPolySOSToSDP[{a__NCPoly}, qqs_List, symbol_:Unique[]] := Block[
    {constraints = {a}, ps,
     allVars, qVars, vars,
     b1, A1, A1perp, n1, x1, x1s, sol1,
     Q, sol, solQ,
     qs = Map[SparseArray, qqs],
     b2, A2, A2perp, n2, x2, x2s, sol2,
     zeroDiag, eqs},

    (* min tr(C, Q) s.t. a(Q, x) = 0, Q >= 0 *)

    (* Extract variables *)
    ps = Map[Values[#[[2]]]&, constraints];
    allVars = Variables[ps];
    qVars = Rest[Union[Flatten[qs]]];
    vars = Complement[allVars, qVars];

    NCDebug[1, allVars, vars, qVars];

    (* Solve the linear constraint *)
    {b1, A1} = CoefficientArrays[Flatten[ps], allVars];
    A1perp = NullSpace[A1];
    n1 = Length[A1perp];
    x1s = Table[Subscript[x1, i], {i, n1}];
    Quiet[
       Check[
          sol1 = Thread[allVars -> 
                        If[ n1 > 0
                           ,
                            Transpose[A1perp].x1s - LinearSolve[A1,b1]
                           ,
                            - LinearSolve[A1,b1]
                        ]]
         ,
          Message[NCPolySOS::NotSOS];
          Return[{$Failed, $Failed, $Failed, $Failed}];
       ];
      ,
       LinearSolve::nosol
    ];

    NCDebug[1, n1];
    NCDebug[2, Normal[b1], Normal[A1], x1s, sol1];
    NCDebug[3, Dimensions[A1], LinearSolve[A1, b1], Normal[A1perp]];

    (* Substitute solution *)
    Q = SparseArray[ArrayRules[qs] /. sol1];
    sol = Thread[vars -> (vars /. sol1)];
    solQ = Thread[qVars -> (qVars /. sol1)];

    NCDebug[1, sol, solQ];
    NCDebug[2, Map[MatrixForm, Q]];

    (* Simplify based on the diagonal *)
    While[ True
          ,

           (* zero diagonals? *)
           zeroDiag = Map[Flatten[Position[Normal[Diagonal[#]], 
                                           _?PossibleZeroQ]]&, Q];

           (* Impose row and column to be zero if diagonal is zero *)
           eqs = DeleteCases[
                   Flatten[MapThread[#1[[#2, All]]&, {Q, zeroDiag}]],
                   _?PossibleZeroQ
           ];

           (* delete rows *)
           Q = MapThread[deleteRows, {Q,zeroDiag}];
           Q = MapThread[deleteColumns, {Q,zeroDiag}];

           NCDebug[1, zeroDiag, eqs];
           NCDebug[2, Map[MatrixForm, Q]];

           (* No more zero diagonals? *)
           If[ eqs === {}, Break[] ];

           {b2, A2} = CoefficientArrays[eqs, x1s];
           A2perp = NullSpace[A2];
           n2 = Length[A2perp];
           x2s = Table[Subscript[x2, i], {i, n2}];

           sol2 = Thread[x1s -> 
                    If[ n2 > 0
                       ,
                        Transpose[A2perp].x2s - LinearSolve[A2,b2]
                       ,
                        - LinearSolve[A2,b2]
                    ]];

           NCDebug[1, n2];
           NCDebug[2, Normal[b2], Normal[A2], x2s, sol2];
           NCDebug[3, Normal[A2perp]];

           Q = SparseArray[ArrayRules[Q] /. sol2 /. x2 -> x1];
           sol = sol /. sol2 /. x2 -> x1; 
           solQ = solQ /. sol2 /. x2 -> x1;

    ];

    Q = SparseArray[ArrayRules[Q] /. x1 -> symbol];
    Return[{Q, Variables[ArrayRules[Q][[All,2]]], sol, solQ} /. x1 -> symbol];

  ];

End[]
EndPackage[]
