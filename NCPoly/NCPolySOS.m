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

Begin["`Private`"];

  Clear[NCPolySOSAux1];
  NCPolySOSAux1[q_, k_, d_] := 
    Table[If[i >= j, Subscript[q, k, i, j], 
                     Subscript[q, k, j, i]], {i, 0, d}, {j, 0, d}];

  NCPolySOS[p_NCPoly, symbol_:q] := 
    NCPolySOS[NCPolyDegree[p], p[[1]], symbol];

  NCPolySOS[degree_Integer, vars_List, symbol_:q] := Block[
    {d = NCPolyGramMatrixDimensions[degree, vars], Q},

    Q = Table[If[i >= j, 
                 Subscript[symbol, i, j], 
                 Subscript[symbol, j, i]], {i, 0, d}, {j, 0, d}];
      
    Return[{NCPolyFromGramMatrix[Q, vars], Q}];
  ];

  Clear[deleteColumns];
  deleteColumns[m_, cols_] := Map[Delete[#, Map[List, cols]]&, m];

  Clear[deleteRows];
  deleteRows[m_, cols_] := Delete[m, Map[List, cols]];
  
  NCPolySOSToSDP[f_:{}, {a__NCPoly}, qs_List, symbol_:x] := Block[
    {constraints = {a},
     allVars, qVars, vars,
     b1, A1, A1perp, n1, x1, x1s, sol1,
     Q, sol, solQ,
     b2, A2, A2perp, n2, x2, x2s, sol2,
     zeroDiag, eqs},
      
    (* min tr(C, Q) s.t. a(Q, x) = 0, Q >= 0 *)

    (* Extract variables *)
    allVars = Variables[Map[Values[#[[2]]]&, constraints]];
    qVars = Union[Flatten[qs]];
    vars = Complement[allVars, qVars];

    NCDebug[1, allVars, vars, qVars];
      
    (* Solve the linear constraint *)
    {b1, A1} = CoefficientArrays[Flatten[Map[Values[#[[2]]]&, 
                                             constraints]], allVars];
    A1perp = NullSpace[A1];
    n1 = Length[A1perp];
    x1s = Table[Subscript[x1, i], {i, n1}];
    sol1 = Thread[allVars -> (Transpose[A1perp].x1s - LinearSolve[A1, b1])];

    NCDebug[1, n1];
    NCDebug[2, Normal[b1], Normal[A1], x1s, sol1];
    NCDebug[3, Dimensions[A1], LinearSolve[A1, b1], Normal[A1perp]];

    (* Substitute solution *)
    Q = qs /. sol1;
    sol = Thread[vars -> (vars /. sol1)];
    solQ = Thread[qVars -> (qVars /. sol1)];
  
    NCDebug[1, Q, sol];
      
    (* Simplify based on the diagonal *)
    While[ True
          ,
           
           (* zero diagonals? *)
           zeroDiag = Map[Flatten[Position[Diagonal[#], 
                                           _?PossibleZeroQ]]&, Q];
           
           (* Impose row and column to be zero if diagonal is zero *)
           eqs = DeleteCases[
                   Flatten[MapThread[#1[[#2, All]]&, {Q, zeroDiag}]],
                   _?PossibleZeroQ
           ];

           (* delete rows *)
           Q = MapThread[deleteRows, {Q,zeroDiag}];
           Q = MapThread[deleteColumns, {Q,zeroDiag}];

           NCDebug[1, zeroDiag, eqs, Q];

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
           
           Q = Q /. sol2 /. x2 -> x1;
           sol = sol /. sol2 /. x2 -> x1; 
           solQ = solQ /. sol2 /. x2 -> x1;
     
    ];
      
    Return[{Q, sol, solQ} /. x1 -> symbol];
      
  ];

End[]
EndPackage[]
