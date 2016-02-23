(* SYSDefWIA.m *)
(*************************************************************************)
(* ----------W-INPUT AFFINE SYSTEM DEFINITIONS -----------*)
(*
We assume here that the 2-port system (plant) is W-Input Affine while
the one-port (compensator) system is Input Affine.

                     __________________
                     |                |
           W  ---->--|             G1 |---->--- out1 
                     |  F             |
           U  ---->--|             G2 |---->--- Y
                     |________________|
                      ______________
                      |            |
               ----<--| g      f   |----<--- Y
                      |____________|

*)
(* A Input Affine (IA) one port system is *)                      
                   SetNonCommutative[f,g,a,b,c,dd,z]

                       f[z_,Y_]:=a[z]+b[z]**Y
                       g[z_,Y_]:=c[z]+dd[z]**Y

(* A W-Input Affine (WIA) two port system is *)
                   SetNonCommutative[W,U,Y,DW,DU,DY]
                   SetNonCommutative[AB,x,B1,B2,C1,C2,G1,G2] 
                   SetNonCommutative[D11,D22,D12,D21,out1,out2]
                     D11[x_]:=0  

(* This definition incorporates the assumption that G2 doesn't depend on U *) 
                    F[x_,W_,U_]:= AB[x,U]+B1[x]**W;
                           out1 = C1[x,U]+D11[x]**W;
                   G2[x_,W_,U_]:= C2[x]+D21[x]**W;
                           out2 = G2[x,W,U];
                   
(* Some symbols used above are superfluous for this problem.  They are 
only used to avoid conflict of rules with the IA case.  *)


(* See the documentation in SYSDefIA.m for further explanation
of the following symbols *)

(*  The Hamiltonian  *)

SetNonCommutative[F,G1,G2,f,g,p,PP];
HWUY = tp[out1]**out1-tp[W]**W+
                       (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2+
                                     (PP**f[z,Y]+tp[f[z,Y]]**tp[PP])/2;

(*


The following substitutions are explained in SYSDefIA.m

*)

HWU=HWUY/.Y->G2[x,W,U];
HWY=HWUY/.U->g[z,Y];
HW=HWY/.Y->G2[x,W,U];

SetNonCommutative[GEx,GEz];
ruxz={p->tp[GEx[x,z]], PP->tp[GEz[x,z]]};

          GEx[0,0]=0;
          GEz[0,0]=0;

sHWUY=HWUY/.ruxz;
sHWU=HWU/.ruxz;
sHWY=HWY/.ruxz;
sHW=HW/.ruxz;

(*                    CONVERTING TO DUAL VARIABLES

In terms of dual variables p and PP, H is 
evaluated by inserting the rule 
-----------------*)

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
IGE2[GEx[x_,z_],GEz[x_,z_]]:=x;
(*

                RESULTS STORED FOR FAST EXECUTION               

The following are redundant in that they can be computed from the 
above expressions.                                                    *)

(* The W which maximizes the Hamiltonian *)

ruCritW= {W -> tp[B1[x]] ** GEx[x, z]/2 + 
     tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/2}

CritW[x_,z_,b_]:= tp[B1[x]] ** GEx[x, z]/2 + 
                tp[D21[x]] ** tp[b] ** GEz[x, z]/2;

(* Hamiltonian after maximization in W *)
 
sHWoWIA = tp[AB[x, c[z]]] ** GEx[x, z]/2 + tp[C1[x, c[z]]] ** C1[x, c[z]] + 
  tp[GEx[x, z]] ** AB[x, c[z]]/2 + tp[GEz[x, z]] ** a[z]/2 + 
  tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
  tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
  tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4

(*************************************************************************)
