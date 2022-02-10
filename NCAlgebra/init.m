BeginPackage["NCAlgebra`",
	     {"NonCommutativeMultiply`",
              "NCCollect`",
              "NCDiff`",
              "NCDot`",
              "NCReplace`",
              "NCMatrixDecompositions`",
              "NCSimplifyRational`",
              "NCDeprecated`",
              "NCPolyInterface`",
              "NCOutput`"}];

Begin["Private`"];

  If [ !ValueQ[$NC$AlgebraLoaded]
      ,
       (* First time loading *)
       (* Print banner *)
       FilePrint[FindFile["banner.txt"]];
       $NC$AlgebraLoaded = True;
  ];

End[];

Begin["Global`"];

(* Sets all lower case letters to be NonCommutative *)
SetNonCommutativeHold[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

End[];

EndPackage[];
