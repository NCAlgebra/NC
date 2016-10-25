(* SYSDefWaccess.m *)
(*************************************************************************)
(* ----------INPUT AFFINE SYSTEM DEFINITIONS -----------*)

(* This analyzes the hinf prob with W fed directly into the comensator*)
(* this first part is derivations assuming b1, b2 free *)
(* the feedback law has the form

	dz/dt = f[z,W,Y]
	(where f[z,W,Y] = a(z) + b1(z)**W + b2[z]**Y)
	U = c[z]

                     __________________
                     |                |
           W ----->--|             G1 |---->--- out1 
           |         |  F             |
           |   U  ->-|             G2 |---->--- Y
           |         |________________|
           |          ______________
           |   U --<--|            |
           |          | g      f   |----<--- Y
           \------->--|____________|

An Input Affine (IA) one port system is
--------------------------------------------*)

                   SetNonCommutative[f,g,a,b1,b2,c,dd,z]

                       f[z_,W_,Y_]:=a[z]+b1[z]**W + b2[z]**Y
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
                   
(*------------------------------------
 the Hamiltonian is 
--------------------------------------*)
SetNonCommutative[F,G1,G2,f,g,p,PP];
HWUY = tp[out1]**out1-tp[W]**W+
                       (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2+
                                  (PP**f[z,W,Y]+tp[f[z,W,Y]]**tp[PP])/2;

HWU=HWUY/.Y->G2[x,W,U];
HWY=HWUY/.U->g[z,Y];
HW=HWY/.Y->G2[x,W,U];

(*-----------------------------------

                   PURE STATE VARIABLES                
--------------------------------------*)

SetNonCommutative[GEx,GEz];
ruxz={p->tp[GEx[x,z]], PP->tp[GEz[x,z]]};
(* The storage function e is homogeneous   *)
          GEx[0,0]=0;
          GEz[0,0]=0;

sHWUY=HWUY/.ruxz;
sHWU=HWU/.ruxz;
sHWY=HWY/.ruxz;
sHW=HW/.ruxz;

(*------------------------------------
                   PURE DUAL VARIABLES

In terms of dual variables p and PP, H is 
evaluated by inserting the rule 
-------------------------------------*)

rudualx=x->IGE1[p,PP];
rudualz=z->IGE2[p,PP];
rudual={rudualx,rudualz};

dHWUY=HWUY//.rudual;
dHWU=HWU//.rudual;
dHWY=HWY//.rudual;
dHW=HW//.rudual;

(*-------------------------------------
The relationship between GE (Gradient of energy) and IGE (inverse of Gradient
of energy) is 
--------------------------------------*)
GEx[IGE1[p_,PP_],IGE2[p_,PP_]]:=p;
GEz[IGE1[p_,PP_],IGE2[p_,PP_]]:=PP;
IGE1[GEx[x_,z_],GEz[x_,z_]]:=x;
IGE2[GEx[x_,z_],GEz[x_,z_]]:=x;

(*----------------------------------------

                RESULTS STORED FOR FAST EXECUTION               

The following are redundant in that they can be computed from the 
above expressions.                                                    

 W which maximizes the Hamiltonian is:
------------------------------------------*)
ruCritW = {W -> (tp[B1[x]] ** GEx[x, z] + tp[b1[z]] ** GEz[x, z] + 
      tp[D21[x]] ** tp[b2[z]] ** GEz[x, z])/2};

(* This is sHW with CritW (above) plugged in *)
(*
sHWo = Sub[NCE[Sub[sHW,{dd[z]->0,ruCritW}]],rue];
*)
sHWo = 
tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 +
  tp[GEz[x, z]] ** a[z]/2 + tp[a[z]] ** GEz[x, z]/2 + 
  tp[C1[x]] ** D12[x] ** c[z] + tp[C2[x]] ** tp[b2[z]] ** GEz[x, z]/2 + 
  tp[GEx[x, z]] ** B2[x] ** c[z]/2 + tp[GEz[x, z]] ** b2[z] ** C2[x]/2 + 
  tp[c[z]] ** e1[x] ** c[z] + tp[c[z]] ** tp[B2[x]] ** GEx[x, z]/2 + 
  tp[c[z]] ** tp[D12[x]] ** C1[x] + 
  tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[b1[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b1[z] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b1[z] ** tp[b1[z]] ** GEz[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b2[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b1[z] ** tp[D21[x]] ** tp[b2[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b2[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b2[z] ** D21[x] ** tp[b1[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b2[z] ** e2[x] ** tp[b2[z]] ** GEz[x, z]/4

(*-----------------------------------------
The critical c at x=z is identical to the old and gives IAX[x] also as the
min of sHWo along x=z (use existing ruc and IAX[x] equations)   

  To find the correct a, use the separation principle argument with

	C2 = [C2 0]^T

	D21 = [D21 I]^T

Here's what you get:
---------------------------------------------*)

rua = a[z_] :> (A[z] + B2[z] ** (-inv[e1[z]] ** 
           (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]))) - b2[z] ** C2[z] + 
    ((B1[z] - b2[z] ** D21[z] - b1[z]) ** tp[B1[z]]) ** XX[z];

(*  A special form for the energy function  *)

SetNonCommutative[V];
ruV = {GEx[x_,z_]:>2 XX[x] + 2 V[x-z], GEz[x_,z_]:>-2 V[x-z]};

(*-------------------------------------
 new rule for V 

ruV = {GEx[x_,z_]:>2 XX[x] + 2 V[z,x-z], GEz[x_,z_]:>-2 V[z,x-z] + 2 DFV[x,z]};

The following rule is forced if we require 
that the error dynamics be stable 
--------------------------------------------*)

rub1 = b1[z]->B1[z] - b2[z]**D21[z];

(* ------------------------------------------
f[z,W,Y] with rua, ruc, and rub1 is given by

A[z] + B1[z]**W + B2[z] ** (-inv[e1[z]] ** 
           (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]))) + b2[z] ** (Y- C2[z]-D21[z]**W) 

These are the resulting dynamics:

xdot = A[x] + B1[x]**W + B2[x]**c[z]/.ruc;

zdot = A[z] + (b2[z] ** D21[x] + b1[z]) ** W + 
  b2[z] ** (C2[x] - C2[z] - D21[z] ** tp[B1[z]] ** XX[z]) + 
  B1[z] ** tp[B1[z]] ** XX[z] - b1[z] ** tp[B1[z]] ** XX[z] - 
  B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
  B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z];

(* this is xdot - zdot  = the error dynamics which we want stable *)

errordot =A[x] - A[z] - b2[z] ** (C2[x] - C2[z]) +
             (B1[x] - b2[z] ** D21[x] - b1[z]) ** W - 
  (B1[z] ** tp[B1[z]] - b1[z] ** tp[B1[z]] + 
     (B2[x] - B2[z]) ** inv[e1[z]] ** tp[B2[z]] - 
              b2[z] ** D21[z] ** tp[B1[z]]) ** XX[z] + 
   (-B2[x] + B2[z]) ** inv[e1[z]] ** tp[D12[z]] ** C1[z]
-------------------------------------*)
     
(*********************************************************************)
