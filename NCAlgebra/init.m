(* Load NCAlgebra packages *)
<< NonCommutativeMultiply`

If [ !ValueQ[$NC$Algebra$Loaded],
    
    (* First time loading *)
     
    (* Sets all lower case letters to be NonCommutative *)
    SetNonCommutative[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

    (* Print banner *)
    FilePrint[ToFileName[$NCDir$, "banner.txt"]];
     
    $NC$Algebra$Loaded = True;
];

(* Load default packages *)

<< NCCollect`
<< NCDiff`
<< NCReplace`
<< NCMatMult`
<< NCSimplifyRational`
<< NCOutput`
<< NCAlias`