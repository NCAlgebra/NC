BeginPackage["NCMSolve`",
      "NonCommutativeMultiply`","Errors`","Lazy`"];

Clear[NCMSolve];

NCMSolve::usage = 
      "NCMSolve[x,y] (where x and y are NonCommutative \
       products) determines whether they are equal. \
       It does this by calling OneElementNCMSolve (See).";

Clear[NCMSolveAux];

NCMSolveAux::usage = 
      "See NCMSolve. NCMSolveAux routine is called by NCMSolve. \
       Its arguments are lists so that a product with one \
       element can be handeled gracefully.";

Clear[OneElementNCMSolve];

OneElementNCMSolve::usage = 
        "OneElementNCMSolve[x^n,x^m] gives {n+NCMDummy==m+NCMDummy}.\
         OneElementNCMSolve[x^n,x] gives {n+NCMDummy==1+NCMDummy}. \
         OneElementNCMSolve[x,x^m] gives {1+NCMDummy==1+NCMDummy}. \
         OneElementNCMSolve[x,x] gives {True}. \
         OneElementNCMSolve[x,y] gives {False}. \
         NCMDummy is used so that the evaluation of == is \
         postponed for work in Moras Algorithm.";

Clear[NCMSolveDummy];

NCMSolveDummy::usage = 
        "See OneElementNCMSolve";

Begin["`Private`"];

OneElementNCMSolve[Power[U_,m_],Power[U_,n_]] := 
        {m + NCMSolveDummy==n + NCMSolveDummy};
OneElementNCMSolve[Power[U_,m_],U_] := 
        {m + NCMSolveDummy==1 + NCMSolveDummy};
OneElementNCMSolve[U,Power[U_,m_]] := 
        {m + NCMSolveDummy==1 + NCMSolveDummy};

Literal[OneElementNCMSolve[LazyPower[U_,m_],LazyPower[U_,n_]]] := 
        {m + NCMSolveDummy==n + NCMSolveDummy};

OneElementNCMSolve[x_,x_] := {True};
OneElementNCMSolve[x_,y_] := {False};

OneElementNCMSolve[x___] := BadCall["OneElementNCMSolve",x];

NCMSolveAux[FirstList_List,SecondList_List,j_Integer,k_Integer,len_Integer] := 
Module[{m,result},
   result = Table[OneElementNCMSolve[FirstList[[j+m-1]],
                                     SecondList[[k+m-1]]
                                     ],{m,1,len}];
   Do[result[[m]] = result[[m]]/.Literal[Equal[x_,y_]]:>Equal[x-y,0]
   ,{m,2,len-1}];
   result = Apply[Join,result];
   If[MemberQ[result,False],result = {False}];
   Return[result]
];

NCMSolveAux[x___] := BadCall["NCMSolveAux",x];

NCMSolve[term1_NonCommutativeMultiply,term2_NonCommutativeMultiply] :=
     If[Not[Length[term1]===Length[term2]],
(* THEN *)   {False},
(* ELSE *)   NCMSolveAux[Apply[List,term1],
                         Apply[List,term2],1,1,Length[term1]];
     ];

NCMSolve[x___] := BadCall["NCMSolve",x];

End[];
EndPackage[]
