(*  NCSOS.m                                                                *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: April 2017                                                     *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCSOS`",
	      "NCPoly`",
              "NCReplace`",
              "NCUtil`",
	      "NonCommutativeMultiply`" ];

Clear[NCSOS];

Get["NCSOS.usage"];

Begin["`Private`"];

  Clear[NCSOSAux1];
  NCSOSAux1[q_, k_, d_] := 
    Table[If[i >= j, Subscript[q, k, i, j], 
                     Subscript[q, k, j, i]], {i, 0, d}, {j, 0, d}];

  Clear[deleteColumns];
  deleteColumns[m_, cols_] := Map[Delete[#, Map[List, cols]]&, m];

  Clear[deleteRows];
  deleteRows[m_, cols_] := Delete[m, Map[List, cols]];
  
  NCSOS[f_:{}, {a__NCPoly}, symbol_:x] := Block[
    {q, polys = {a}, M,
     xs, ds, qs, allVars,
     constraints, 
     b1, A1, A1perp, n1, x1, x1s, sol1,
     b2, A2, A2perp, n2, x2, x2s, sol2,
     zeroDiag, eqs,
     Q, sol},
      
    (* min f(x) s.t. a(x) is SOS *)
    
    M = Length[polys];
      
    (* Define one SOS polynomial per constraint *)

    (* polynomial size *)
    ds = Map[Length[NCPolyGramMatrix[#]]&, polys];
      
    (* Gram matrices *)
    qs = MapIndexed[NCSOSAux1[q, #2[[1]], #1]&, ds];

    (*
    Print["ds = ", ds];
    Print["qs = ", qs];
    *)
      
    (* Extract linear constraints *)
    xs = polys[[1]][[1]];
    constraints = polys - Map[NCPolyFromGramMatrix[#, xs]&, qs];

    (* Extract variables *)
    allVars = Variables[Map[Values[#[[2]]]&, constraints]];
    vars = Complement[allVars, Union[Flatten[qs]]];
      
    (* Solve the linear constraint *)
    {b1, A1} = CoefficientArrays[Flatten[Map[Values[#[[2]]]&, 
                                             constraints]], allVars];
    A1perp = NullSpace[A1];
    n1 = Length[A1perp];
    x1s = Table[Subscript[x1, i], {i, n1}];
    sol1 = Thread[allVars -> (Transpose[A1perp].x1s - LinearSolve[A1, b1])];

    (* 
    Print["allVars = ", allVars];
    Print["vars = ", vars];
    Print["xs = ", xs];
    Print["constraints = ", constraints];
    Print["b1 = ", b1];
    Print["A1 = ", A1];
    Print["A1perp = ", A1perp];
    Print["n1 = ", n1];
    Print["x1s = ", x1s];
    Print["sol1 = ", sol1];
    *)

    (* Substitute solution *)
    Q = qs /. sol1;
    sol = Thread[vars -> (vars /. sol1)];
  
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

           (*
           Print["zeroDiag = ", zeroDiag];
           Print["eqs = ", eqs];
           Print["Q = ", Q];
           *)

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
               
           (* 
           Print["b2 = ", b2];
           Print["A2 = ", A2];
           Print["A2perp = ", A2perp];
           Print["n2 = ", n2];
           Print["x2s = ", x2s];
           Print["sol2 = ", sol2];
           *) 
           
           Q = Q /. sol2 /. x2 -> x1;
           sol = sol /. sol2 /. x2 -> x1;
      
    ];
      
    Return[{Q, sol} /. x1 -> symbol];
      
  ];

End[]
EndPackage[]
