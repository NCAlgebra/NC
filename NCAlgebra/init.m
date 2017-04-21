(* Load NCAlgebra packages *)
<< NonCommutativeMultiply`

If [ !ValueQ[$NC$AlgebraLoaded],
    
    (* First time loading *)
     
    (* Print banner *)
    FilePrint[FindFile["banner.txt"]];
     
    $NC$AlgebraLoaded = True;
];

(* Sets all lower case letters to be NonCommutative *)
SetNonCommutativeHold[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

(* Load default packages *)
<< NCCollect`
<< NCDiff`
<< NCReplace`
<< NCDot`
<< NCMatrixDecompositions`
<< NCSimplifyRational`
<< NCDeprecated`

(* Load NCPoly interface with NCAlgebra *)
<< NCPolyInterface`

(* Configure output *)
<< NCOutput`
NCSetOutput[]
