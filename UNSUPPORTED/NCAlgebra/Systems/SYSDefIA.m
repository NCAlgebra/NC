(* SYSDefIA.m *)
(*************************************************************************)
(* ----------INPUT AFFINE SYSTEM DEFINITIONS -----------*)

(* This file loads in basic definitions of the system and of 
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
                      |____________|
                     
                 dx/dt  =  F[x,W,U]
                  out1  =  G1[x,W,U]
                    Y   =  G2[x,W,U]

                 dz/dt  =  f[z,Y]
                    U   =  g[z,Y]

 An Input Affine (IA) one port system is                       
---------------------------------------- *)
                   SetNonCommutative[f,g,a,b,c,dd,z]

                       f[z_,Y_]:=a[z]+b[z]**Y
                       g[z_,Y_]:=c[z]+dd[z]**Y

(* An Input Affine (IA) two port system is *)

                   SetNonCommutative[W,U,Y,DW,DU,DY]
                   SetNonCommutative[A,x,B1,B2,C1,C2,G1,G2] 
                   SetNonCommutative[D11,D22,D12,D21]
                     D11[x_]:=0  
                     D22[x_]:=0                         
                        
                   F[x_,W_,U_]:=A[x]+B1[x]**W+B2[x]**U
                   G1[x_,W_,U_]:=C1[x]+D11[x]**W+D12[x]**U;
                            out1=G1[x,W,U];
                   G2[x_,W_,U_]:=C2[x]+D21[x]**W+D22[x]**U;
                            out2=G2[x,W,U];
                            G2I[x_,Y_,U_]:=inv[D21[x]]**Y-inv[D21[x]]**C2[x];
                   
(*----------------------------------------
		ENERGY BALANCE EQUATIONS

We begin with notation for analyzing the DISSIPATIVITY of the systems  obtained by 
connecting f,g to F,G in several different ways. The energy function on the 
statespace is denoted by e.  HWUY below is the Hamiltonian of the two decoupled
systems where inputs are W,U, and Y. 

(3.1)       HWUY=  out^2 - W^2 + PP f(z,Y)+p F(x,W,U)

-----------------------------------------*)

SetNonCommutative[F,G1,G2,f,g,p,PP];
HWUY = tp[out1]**out1-tp[W]**W+
                       (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2+
                                     (PP**f[z,Y]+tp[f[z,Y]]**tp[PP])/2;
(*----------------------------------------

                 CONNECTING INPUT AND OUTPUT

- If we connect the Y output of the 2 port to the f,g input then 
the resulting system has Hamiltonian function HWU.

           HWU=HWUY with the substitution Y -> G2(x,W,U).
----------------------*)
HWU=HWUY/.Y->G2[x,W,U];
(*--------------------

- If we connect the U input of the 2 port to the 
f,g output then the resulting system has Hamiltonian function HWY.

           HWY=HWUY with the substitution U -> g(z,Y).
----------------------*)
HWY=HWUY/.U->g[z,Y];
(*--------------------

- If we connect the two systems in feedback, that is tie off U and Y, 
then the resulting Hamiltonian function is 

           HW=HWY with the substitution Y -> G2(x,W,U).
----------------------*)
HW=HWY/.Y->G2[x,W,U];
(*--------------------

By definition (see Section I) the closed loop system being e-DISSIPATIVE 
corresponds to the energy balance function HW above being negative.

Note that the function HWUY contains both state and dual variables. Dual 
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

STATESPACE -x,z. While the HWUY formulas mix x's and  p 's , the next ones are
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

sHWUY=HWUY/.ruxz;
sHWU=HWU/.ruxz;
sHWY=HWY/.ruxz;
sHW=HW/.ruxz;


(* --------------------------------
                        CONVERTING TO DUAL VARIABLES

In terms of dual variables p and PP, H is 
evaluated by inserting the rule 
------------------------------------*)

rudualx=x->IGE1[p,PP];
rudualz=z->IGE2[p,PP];
rudual={rudualx,rudualz};

dHWUY=HWUY//.rudual;
dHWU=HWU//.rudual;
dHWY=HWY//.rudual;
dHW=HW//.rudual;

(*-----------------
The relationship between GE (Gradient of energy) and IGE (inverse of Gradient
of energy) is 
------------------*)
GEx[IGE1[p_,PP_],IGE2[p_,PP_]]:=p;
GEz[IGE1[p_,PP_],IGE2[p_,PP_]]:=PP;
IGE1[GEx[x_,z_],GEz[x_,z_]]:=x;
IGE2[GEx[x_,z_],GEz[x_,z_]]:=z;

(*-----------------------------------

                RESULTS STORED FOR FAST EXECUTION               

The following are redundant in that they can be computed from the 
above expressions.                                                    

This is the W which maximizes Hamiltonian 
---------------------------------------*)

ruCritW= {W -> tp[B1[x]] ** GEx[x, z]/2 + 
     tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/2}

CritW[x_,z_,b_]:= tp[B1[x]] ** GEx[x, z]/2 + 
                tp[D21[x]] ** tp[b] ** GEz[x, z]/2;

(*  and you get  *)

sHWo = tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + 
  tp[GEz[x, z]] ** a[z]/2 + tp[a[z]] ** GEz[x, z]/2 + 
  tp[C1[x]] ** D12[x] ** c[z] + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
  tp[GEx[x, z]] ** B2[x] ** c[z]/2 + tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
  tp[c[z]] ** e1[x] ** c[z] + tp[c[z]] ** tp[B2[x]] ** GEx[x, z]/2 + 
  tp[c[z]] ** tp[D12[x]] ** C1[x] + 
  tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4


(* This is the U which minimizes Hamiltonian *)
ruCritU = {U -> -inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
     inv[e1[x]] ** tp[D12[x]] ** C1[x]};

CritU[x_,z_]:=-inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
     inv[e1[x]] ** tp[D12[x]] ** C1[x];

(*************************************************************************)
