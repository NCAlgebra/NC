(* ------------------------------------------------------------------ *)
(*     Some people like to use the abbreviation co for aj[tp[x]].     *)
(*     See also complex.m                                             *)
(* ------------------------------------------------------------------ *)

(* Mark Stankus 9/9/2004 -- Added Literal since CommutativeAllQ[x_] is True *)
Literal[aj[tp[x_]]] := co[x];
Literal[tp[aj[x_]]] := co[x];
