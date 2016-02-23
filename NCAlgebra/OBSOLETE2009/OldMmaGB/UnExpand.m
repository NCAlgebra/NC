Clear[UnExpand];

UnExpand[x_] := x//. 
 { 
   a_?CommutativeAllQ b_NonCommutativeMultiply +
   c_?CommutativeAllQ b_
      -> (a+c) b,
   d_?CommutativeAllQ e_(And[Head[#]===Symbol,Not[CommutativeAllQ[#]]])& + 
   f_?CommutativeAllQ e_
      -> (d+f) e
 };

UnExpand[x___] := BadCall["UnExpand",x];
