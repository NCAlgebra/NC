(*SYSSpecialize.m *)
(*                    SYSTEMS specialization rules    *)

(* Some common conditions system satisfy
------------------------------------*)

SetNonCommutative[e1,e2];
      tp[e1[x_]]:=e1[x];
      tp[e2[x_]]:=e2[x];
      tp[e1]=e1;
      tp[e2]=e2;

rue= {tp[D12[x_]]**D12[x_]:>e1[x], D21[x_]**tp[D21[x_]]:>e2[x]};


(**********RULES FOR REDUCING SYSTEMS THEMSELVES TO  SPECIAL CASES **********)
(**********RULES FOR REDUCING SYSTEMS THEMSELVES TO  SPECIAL CASES **********)
(**********RULES FOR REDUCING SYSTEMS THEMSELVES TO  SPECIAL CASES **********)


(* use this if your system is "HOMOGENEOUS" *)

ruhomog = {A[0]->0, C1[0]->0, C2[0]->0, a[0]->0, c[0]->0,
aa[0]->0,k1[0]->0,k2[0]->0};


(* CONVERT IA SYSTEM TO LINEAR SYSTEM *)

rulinearsys = {A[x_]:>A**x, B1[x_]:>B1, B2[x_]:>B2, C1[x_]:>C1**x,C2[x_]:>C2**x,
  D21[x_]:>D21,  D12[x_]:>D12,
  a[x_]:>a**x, b[x_]:>b, c[x_]:>c**x, dd[x_]:>dd,
  aa[x_]:>aa**x, b1[x_]:>b1, b2[x_]:>b2, b3[x_]:>b3,
  k1[x_]:>k1**x, k2[x_]:>k2**x, k3[x_]:>k3**x,
 d11[x_]:>d11, d12[x_]:>d12, d21[x_]:>d21, d22[x_]:>d22,
  e1[x_]:>e1,e2[x_]:>e2};

LinSys[exp_]:=SubSym[exp,rulinearsys];


(*------------
The DOYLE GLOVER KHARGONEKAR FRANCIS SIMPLIFYING ASSUMPTIONS

A special class of IA systems are those satisfying

     tp[D12(x)]  C1(x)= 0       B1(x) tp[D21(x)]  = 0  
 
denoted as the Doyle-Glover-Kargonekar-Francis (DGKF) 
simplifying assumptions (see [DGKF]).
These simplify algebra substantially so are good for tutorial
purposes even though they are not satisfied in actual control problems.

The following rules implement the DGKF simplifying assumptions 
for IA systems: 
---------------------*)

rukille=Flatten[{{rue},{e1[x_]:>1,e2[x_]:>1}}];
ruDGKF1=tp[D12[x_]]**C1[x_]:>0;
ruDGKF2=B1[x_]**tp[D21[x_]]:>0;
ruDGKFNL=Flatten[{rukille,ruDGKF1,ruDGKF2}];


(* these rules implement the Doyle  Glover simplifying assumptions 
for linear systems *)

ruDGKF1lin=tp[D12]**C1->0;
ruDGKF2lin=B1**tp[D21]->0;
ruelin = rue//.rulinearsys;
ruDGKFlin = Flatten[{ ruelin,e1[x_]:>1,e1[x_]:>1,e1->1,e2->1,
                                      ruDGKF1lin,ruDGKF2lin}];



(*  SPECIAL FORMS OF ENERGY FUNCTIONS *)
(*  SPECIAL FORMS OF ENERGY FUNCTIONS *)
(*  SPECIAL FORMS OF ENERGY FUNCTIONS *)

(*
    Often an important role is played by two subsets of
the statespace of the closed loop system. These are

(4.1)      ZGEz:={(x,z): Grad[e,z]=0}
 and
(4.2)      Nz:= { (x,z): z=0 }.

Normalize ZGEz to equal {(x,x)}. This ASSUMES  that
ZGEz is a graph over x and that z has the same
dimension as x. We impose (4.1) by
-------------------------------------*)

               ruGEz0=GEz[x_,x_]:>0;

(*-----------
A common notational change is
---------------*)
SetNonCommutative[XX,YY,YYI];

	ruXXYYI={ruGEz0,ruXX, ruYYI};
	         ruXX = GEx[x_,x_]:>2*XX[x];
	         ruYYI = GEx[x_,0]:>2*YYI[x];

(*----------------------------------
To do experiments we introduce 
rules which correspond to the Ansatses 1 to 5 in [BHW]. 
These come from differentiating e by hand. The special forms of 
e impose rules on the Gradients GEx, GEz in x and z.
Ansatses 1 and 3 are given by:
-------------------*)

ruGEx1=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z];
ruGEz1=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z];
ruGE1={ruGEz0,Flatten[SubSym[{ruGEz0,ruGEx1,ruGEz1},ruXXYYI]]};
ruGE1 = Flatten[ruGE1];

SetNonCommutative[Grx,Gry];
ruGEx3=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z]+Grx[x,z];
ruGEz3=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z]+Grz[x,z];
ruGE3={ruGEz0,SubSym[{ruGEz0,ruGEx3,ruGEz3},ruXXYYI]};
ruGE3 = Flatten[ruGE3];



(*    
ENERGY FUNCTIONS FOR SPECIAL SYSTEMS

LINEAR SYSTEMS:
*)

	                      ruGEXY1=tp[GEx[x_,0]]:>tp[x]**inv[YY];
	                      ruGEXY2=tp[GEx[x_,x_]]:>tp[x]**XX;
	ruGEXY={ruGEXY1,ruGEXY2};

tp[XX]=XX;
tp[YYI]=YYI;
tp[YY]=YY;
        rulinearXY={XX[x_]:>XX**x,YY[p_]:>p**YY,YYI[x_]:>inv[YY]**x}
        ruinvYY= YYI->inv[YY];


	rulinearall={rulinearsys,ruGE1,ruGEXY,rulinearXY};
        rulinearall = Flatten[rulinearall];
        rulinearall = Union[rulinearall];

Lin[exp_]:=SubSym[exp,rulinearall];

(*****LESS USEFULL***********************)
(*****LESS USEFULL***********************)
(*****LESS USEFULL***********************)

             (****LINEAR CASE ENERGY----LESS USEFUL Y****)

SetNonCommutative[P11,P12,P21,P22];
SetNonCommutative[QQ,vv];

QQ={{P11,P12},{P21,P22}};
tp[P11]=P11;
tp[P22]=P22;
tp[P21]=P12;
tp[P12]=P21;

seLin= tp[x] ** P11 ** x + tp[x] ** P12 ** z + tp[z] ** P21 ** x + 
   tp[z] ** P22 ** z;

(*----------------------------------

Next we want to be able to substitute 
              p=Grad[eLin,x]  and PP= Grad[eLin,z]
for p and PP.  In other words,

{GEx[x_,z_]:>Grad[seLin,x],
 GEz[x_,z_]:>Grad[seLin,z]};

Executable formulas for this are  
------------------------------------*)

SetNonCommutative[GEx,GEz];
rulinearEB={
GEx[x_,z_]:> 2*(P11**x + P12**z),
GEz[x_,z_]:> 2*(P21**x + P22**z)};

(******GEz=0 on the diagonal******)
  rulinearGEz0={P12->-P22,P21->-P22};

LinSysEB[exp_]:=SubSym[exp,
Union[{rulinearsys,
rulinearEB,
rulinearGEz0}]];

(*

*)
(*-------------------------------------------------------*)
(* DUAL = In terms of dual variables p and PP, eLin is  *)
(*?? NEEDS WORK FINISH IT--low priority

SetNonCommutative[SS,S11,S22,S12,S21];

tp[S11]=S11;
tp[S22]=S22;
tp[S12]=S21;
tp[S21]=S12;
SS={{S11,S12},{S21,S22}};

rudualx=x->MatMult[SS,tpMat[{{p,PP}}]][[1,1]];
rudualz=z->MatMult[SS,tpMat[{{p,PP}}]][[2,1]];

rudualx=x->IGE1[p,PP];
rudualz=z->IGE2[p,PP];
rudual={rudualx,rudualz};

(* QQ and SS are related by *)

ruSS=SS->invMat2[QQ];
*) 


(***********************************************************)
(* *******************SPECIALIZED AND ESOTERIC**************)
(* These rules are simplifying to a "SEMI-LINEAR" system.  *)
ruconst = { B1[x_]:>B1, B2[x_]:>B2, D21[x_]:>D21, D12[x_]:>D12};

(* a generalized version of the DGKF rules sometimes needed if you
use ruconst  *)
ruecross = {tp[D12[x_]]**D12[z_]:>1,D21[x_]**tp[D21[z_]]:>1};
rukecross=Flatten[{ruecross,{e1[x_]:>1,e2[x_]:>1}}];
ruDGKFcross=Flatten[{rukecross,tp[D12[x_]]**C1[z_]:>0,
B1[x_]**tp[D21[z_]]:>0}];


