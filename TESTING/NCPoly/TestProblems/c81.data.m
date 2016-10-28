(* This is a test file created from relations in the a4 problem given to 
us by Ben Keller.
*)

ClearMonomialOrder[];
SetMonomialOrder[{b,a},{c}];
rels=
         {a**a + 5*a**b + 7*a**c + 11*b**a + 2*b**b + 31*b**c + 19*c**a + 
         13*c**b + 23*c**c,
         a**b + 5*a**c + 7*b**a + 11*b**b +  2*b**c + 31*c**a + 19*c**b + 
         13*c**c,
         a**c + 5*b**a +  7*b**b + 11*b**c +  2*c**a + 31*c**b + 19*c**c,
         b**a +  5*b**b +  7*b**c + 11*c**a +  2*c**b + 31*c**c
};
Iterations=5;
