  (********* New NCInverse. JShopple 9/9/04  **********)
  (* Pivots on the 1-by-1 upper left element after pivoting (exchanging rows),
     and uses recursion on the n-1 by n-1 lower right block. *)

  NCInverse[InputMat_?MatrixQ] := 
      Module[{m, n, Mat = InputMat, PivotPosition, PivotRow, Ainv, AinvB, 
          CAinv, Minv},

        (*** Check if Mat is square ***)
        {m, n} = Dimensions[Mat];
        If[m != n, Message[NCInverse::NotSquare]; Return[Mat]];

        (*** Check if matrix is 1 - by - 1 ***)

        If[m == 1, If[Mat[[1, 1]] =!= 0, Return[{{inv[Mat[[1, 1]]]}}],
            (* else *) 
            Message[NCInverse::Singular]; Return[Null]]
          ];

        (*** Find a pivot ***)

        PivotPosition = 
          Position[Mat[[All, {1}]], x_?(Rationalize[#] =!= 0 &), {2}, 1, 
            Heads -> False]; 
            (* ??? OK to use Rationalize to check for 0.0*NCexpr and 0.0 ??? JShopple *)
            (* Assumes Rationalize[THE PIVOT] =!= 0 -- Shopple, Stankus *)



        (*** If first column all zero, then singular ***)

        If[Length[PivotPosition] == 0, Message[NCInverse::Singular]; 
          Return[]];

        (*** Swap rows ***)
        PivotRow = PivotPosition[[1, 1]];
        Mat[[{1, PivotRow}]] = Mat[[{PivotRow, 1}]];

        (*** Invert {{A, B}, {C, D}} where A is a 1 - by - 1 block ***)

        Ainv = NCInverse[ Mat[[{1}, {1}]] ];
        AinvB = MatMult[ Ainv, Mat[[{1}, Range[2, m]]] ];
        CAinv = MatMult[ Mat[[Range[2, m], {1}]], Ainv ];

        (*** M = D - C ** NCInverse[A] ** B     ***)

        Minv = NCInverse[ 
            Mat[[Range[2, m], Range[2, m]]] - 
              MatMult[Mat[[Range[2, m], {1}]], AinvB] ];

        (*** Was M singular? ***)

        If[Minv == Null, Return[]]; (*** M was singular ***)

        (*** The inverse of the row permuted input matrix ***)

        Mat = ArrayFlatten[{{Ainv + 
                  MatMult[AinvB, Minv, CAinv], -MatMult[AinvB, 
                    Minv]}, {-MatMult[Minv, CAinv], Minv}}];

        (*** Permute columns because of pivoting ***)

        Mat[[All, {1, PivotRow}]] = Mat[[All, {PivotRow, 1}]];

        Return[Mat];
             
  ];
  NCInverse[NotMat_] := Message[NCInverse::NotMatrix];
