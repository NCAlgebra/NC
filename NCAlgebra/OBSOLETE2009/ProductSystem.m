(*

Computes the product system

           --------             ---------
         !         !           !         !
    ---> ! A,B,C,D ! --------> ! a,b,c,d ! --->
         !         !           !         !
          ---------             ---------

*)

ProductSystem[{{A_,B_},{C_,D_}},{{a_,b_},{c_,d_}}] :=
Module[{ans,an1,an2,an3,an4},
   ans = {{an1,an2},{an3,an4}};
   an1 = {{A,0},{DeepMatMult[b,C],a}};
   an2 = {{B},{DeepMatMult[b,D]}};
   an3 = {{DeepMatMult[d,C],c}};
   an4 = DeepMatMult[d,D];
   Return[ans];
];
