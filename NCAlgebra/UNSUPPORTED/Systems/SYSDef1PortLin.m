(* SYSDef1portlin.m *)
(*************************************************************************)
(*  
The system definition is:
                        
                   dx/dt = F[x,W];
                    out1 = G1[x,W];

                      ______________
                      |            |
            W  ---->--| F     G1   |---->--- out1 
                      |____________|
                     

For linear systems this is:
*)
                   SetNonCommutative[W,U,Y,DW,DU,DY];
                   SetNonCommutative[A,x,B1,C1,G1]; 
                   SetNonCommutative[D11];

                   F[x_,W_,U_]:=A**x+B1**W;
                   G1[x_,W_,U_]:=C1**x+D11**W;
                            out1=G1[x,W,U];

(*
The energy Hamiltonian H is defined by 
*)
             SetNonCommutative[F,G1,G2,p]
   H = tp[out1]**out1 - tp[W]**W + (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2

(*  We may assume for linear systems 
that the energy function is a quadratic form *)
                   SetNonCommutative[e,XX]
              e[x_]:=tp[x]**XX**x  
                       tp[XX]=XX

(*
Thus  p=Grad[e[x]] equals
*)

       p=2 tp[XX**x]

(* 
BOUNDED REAL LEMMA: Assume inv[-K + tp[D11] ** D11] exists. Then the linear 
system above is finite-gain dissipative with gain =< K and energy function 
tp[x]**XX**x iff XX is a positive semidefinite solution to the Riccatti 
inequality 0>= ricd(XX).  Here the Riccatti operator is 
----------------*)

ricd=XX ** A + tp[A] ** XX + tp[C1] ** C1 + 
   (XX ** B1 + tp[C1] ** D11) ** inv[-K + tp[D11] ** D11] ** 
    (-tp[B1] ** XX - tp[D11] ** C1)

(*---------------
Proof.  See [AV].
*)
(*************************************************************************)
