(* SYSDef2x2.m *)
(*************************************************************************)
(* ----------INPUT AFFINE SYSTEM DEFINITIONS -----------*)

(*
  This file loads in basic definitions of the system and of 
the energy balance relations various connections of the 
systems satisfy. 

                     __________________
                     |                |
           W  ---->--|             G1 |---->--- out1 
                     |  F             |
           U  ---->--|             G2 |---->--- Y
                     |________________|
                      ______________
                      |            |
            U  ----<--| g      f   |----<--- Y
            V  ---->--|____________|--->--out3
                     
                 dx/dt  =  F[x,W,U]
                  out1  =  G1[x,W,U]
                    Y   =  G2[x,W,U]

                 dz/dt  =  f[z,Y,V]
                    U   =  g[z,Y,V]
                    out3=  g2[z,Y,V]

 An Input Affine (IA) one port system is                       
---------------------------------------- *)
                   SetNonCommutative[f,g,a,b,c,dd,z];
               SetNonCommutative[aa,k1,k2,d12,d11,d22,d21,b1,b2];
                   SetNonCommutative[Y,V,W,U,out3];

                       f[z_,Y_,V_]:=aa[z]+b1[z]**Y + b2[z]**V;
                       g[z_,Y_,V_]:=k1[z]+d11[z]**Y + d12[z]**V;
                     g2[z_,Y_,V_]:= k2[z] + d21[z]**Y + d22[z]**V;
                       out3=g2[z,Y,V];

(* An Input Affine (IA) two port system is *)

                   SetNonCommutative[W,U,Y,DW,DU,DY];
                   SetNonCommutative[A,x,B1,B2,C1,C2,G1,G2] ;
                   SetNonCommutative[D11,D22,D12,D21];
                     D11[x_]:=0 ; 
                     D22[x_]:=0 ;                        
                        
                   F[x_,W_,U_]:=A[x]+B1[x]**W+B2[x]**U;
                   G1[x_,W_,U_]:=C1[x]+D11[x]**W+D12[x]**U;
                            out1=G1[x,W,U];
                   G2[x_,W_,U_]:=C2[x]+D21[x]**W+D22[x]**U;
                            out2=G2[x,W,U];
                            G2I[x_,Y_,U_]:=inv[D21[x]]**Y-inv[D21[x]]**C2[x];
                   
(*----------------------------------------
		ENERGY BALANCE EQUATIONS

We begin with notation for analyzing the DISSIPATIVITY of the 
systems  obtained by 
connecting f,g to F,G in several different ways. 
The energy function on the statespace is denoted by e.
HWUYV below is the Hamiltonian of the two decoupled
systems where inputs are W,U, and Y. 

(3.1)       HWUYV=  out^2 - in^2 + PP f(z,Y,V)+p F(x,W,U)

-----------------------------------------*)

SetNonCommutative[F,G1,G2,f,g,p,PP];
HWUYV = tp[out1]**out1 + tp[out3]**out3 - tp[W]**W - tp[V]**V+
                       (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2+
                                     (PP**f[z,Y,V]+tp[f[z,Y,V]]**tp[PP])/2;


(*----------------------------------------

                 CONNECTING INPUT AND OUTPUT

The closed loop system is gotten from applying the connection rule:
*)
ruconnect={ 
d22[z_]:>0, d11[z_]:>0,
U->g[z,Y,V],Y->G2[x,W,U]
};

(*
Here we assume d11 and d22 are 0.


- If we connect the Y output of the 2 port to the f,g input then 
the resulting system has Hamiltonian function HWU.

           HWUV=HWUYV with the substitution Y -> G2(x,W,U).
----------------------*)
HWUV=HWUYV/.Y->G2[x,W,U];
(*--------------------

- If we connect the U input of the 2 port to the 
f,g output then the resulting system has Hamiltonian function HWYV.

           HWYV=HWUYV with the substitution U -> g(z,Y,V).
----------------------*)
HWYV=HWUYV/.U->g[z,Y,V];
(*--------------------

- If we connect the two systems in feedback, that is tie off U and Y, 
then the resulting Hamiltonian function is 

           HWV=HWYV with the substitution Y -> G2(x,W,U).
----------------------*)
HWV=HWYV/.Y->G2[x,W,U];
(*--------------------

By definition (see Section I) the closed loop system being e-DISSIPATIVE 
corresponds to the energy balance function HWV above being negative.

Note that the function HWUYV contains both state and dual variables. Dual 
variables are defined by the gradient of the energy function, as follows: 

              p=tp[Grad[e,x]]  and PP= tp[Grad[e,z]]

In the following, when we impose the IA assumptions (see (1.5) and (1.6)),
we will often specialize to a plant which satisfies
(3.2)      D_11(x)= D_22(x) = 0,
           tp[D_12(x)] D_12(x) = e_1(x) > 0,
           D_21(x) tp[D_21(x)] = e_2(x) > 0.
and a compensator with d(z)=0.  We now write out energy balance formulas for 
the plant (1.4) and compensator (1.5) (under these assumptions) 
purely in terms of state space variables x and z (designated by the prefix
s for state space).



                      PURE STATESPACE VARIABLES

STATESPACE -x,z. While the HWUYV formulas mix x's and  p 's , the next ones are
purely on statespace variables x and z.  
Executable formulas for   

              p=tp[Grad[e,x]]  and PP= tp[Grad[e,z]]

are inserted by the rule 
-----------------*)

SNC[GEx,GEz];
ruxz={p->tp[GEx[x,z]], PP->tp[GEz[x,z]]};
(* The storage function e is homogeneous   *)
          GEx[0,0]=0;
          GEz[0,0]=0;

sHWUYV=HWUYV/.ruxz;
sHWUV=HWUV/.ruxz;
sHWYV=HWYV/.ruxz;
sHWV=HWV/.ruxz;


(* --------------------------------
                        CONVERTING TO DUAL VARIABLES

In terms of dual variables p and PP, H is 
evaluated by inserting the rule 
------------------------------------*)

rudualx=x->IGE1[p,PP];
rudualz=z->IGE2[p,PP];
rudual={rudualx,rudualz};

dHWUYV=HWUYV//.rudual;
dHWUV=HWUV//.rudual;
dHWYV=HWYV//.rudual;
dHWV=HWV//.rudual;

(*-----------------
The relationship between GE (Gradient of energy) and IGE (inverse of Gradient
of energy) is 
------------------*)
GEx[IGE1[p_,PP_],IGE2[p_,PP_]]:=p;
GEz[IGE1[p_,PP_],IGE2[p_,PP_]]:=PP;
IGE1[GEx[x_,z_],GEz[x_,z_]]:=x;
IGE2[GEx[x_,z_],GEz[x_,z_]]:=x;

(*-----------------------------------

                RESULTS STORED FOR FAST EXECUTION               

The following are redundant in that they can be computed from the 
above expressions.                                                    
*)
