(* SYSHinfFormulas.m *)

Print[" USE OF THIS FILE REQUIRES THAT SYSSpecialize.m BE ALREADY LOADED. "];


(*                    SYSTEMS Hinfinity control 

   Utilities for manipulating expressions typically found in analyzing
H-infinity control systems


                           OFTEN USED EXPRESSIONS 
-------------------------------------*)


IAX[x_]:=(-tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] + tp[A[x]]) ** XX[x]+
 tp[C1[x]] ** C1[x] + tp[XX[x]] ** 
   (A[x] - B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]) + 
  tp[XX[x]] ** (B1[x] ** tp[B1[x]] - B2[x] ** inv[e1[x]] ** tp[B2[x]]) ** 
   XX[x] - tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x];

IAYI[x_]:=(-tp[C2[x]]**inv[e2[x]]**D21[x]**tp[B1[x]] + tp[A[x]])**YYI[x] + 
  tp[C1[x]] ** C1[x] + tp[YYI[x]] ** 
   (A[x] - B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x]) - 
  tp[C2[x]] ** inv[e2[x]] ** C2[x] + 
  tp[YYI[x]] ** (B1[x] ** tp[B1[x]] - 
     B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]]) ** YYI[x];

(*------------------
The c minimizing sHWo when x=z can be computed explicitly to be:   
---------------------*)

ruc = c[z_]:> -inv[e1[z]]**(tp[B2[z]]**XX[z] + tp[D12[z]]**C1[z]);

(*----------------------
The b minimizing sHWo when z=0 is: 

(4.5d)    tp[GEz[x,0]]**b = -(2 tp[C2[x]] + tp[GEx[x, 0]] ** B1[x] 
                                    ** tp[D21[x]]) ** inv[e2[x]] 

    The function a in the compensator is determined by the
separation principle ([BHW])  
----------------------*)

rua = a[z_]:> A[z] + B2[z]**c[z] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z]//.ruc ;

(* these are used in linear case *)
(*
In SYSSpecialize.m
SetNonCommutative[XX,YY,YYI];
tp[XX]=XX;
tp[YYI]=YYI;
tp[YY]=YY;
ruinvYY=YYI->inv[YY];
*)

DGX=(-tp[C1] ** D12 ** inv[e1] ** tp[B2] + tp[A]) ** XX+
 tp[C1] ** C1 + 
tp[XX] ** (A - B2 ** inv[e1] ** tp[D12] ** C1) + 
  tp[XX] ** (B1 ** tp[B1] - B2 ** inv[e1] ** tp[B2]) ** XX - 
tp[C1] ** D12 ** inv[e1] ** tp[D12] ** C1;

DGYI=(-tp[C2]**inv[e2]**D21**tp[B1] + tp[A])**YYI + 
  tp[C1] ** C1 + tp[YYI] ** (A - B1 ** tp[D21] ** inv[e2] ** C2) - 
  tp[C2] ** inv[e2] ** C2 + 
  tp[YYI] **(B1**tp[B1] - B1**tp[D21]**inv[e2]**D21**tp[B1]) ** YYI;

rublin={b-> - inv[YY**XX-1]**YY**(tp[C2] ** inv[e2] + inv[YY] ** B1 ** tp[D21] ** inv[e2])}

(*-----------------------
 the following rules may be used to simplify expressions under the 
assumption IAX = 0, IAYI = 0   
-------------------------*)

ruIAX = tp[A[x_]] ** XX[x_] + tp[XX[x_]] ** A[x_] :> 
  tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] ** XX[x] - 
  tp[C1[x]] ** C1[x] + tp[XX[x]] ** B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]- 
  tp[XX[x]] ** (B1[x] ** tp[B1[x]] - B2[x] ** inv[e1[x]] ** tp[B2[x]]) ** 
   XX[x] + tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x];

ruIAYI = tp[A[x]] ** YYI[x] + tp[YYI[x]] ** A[x] :> 
tp[C2[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] ** YYI[x] - 
  tp[C1[x]]**C1[x] + tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x]+
  tp[C2[x]] ** inv[e2[x]] ** C2[x] - tp[YYI[x]] ** (B1[x] ** tp[B1[x]] - 
     B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]]) ** YYI[x];

ruIAXYI={ruIAX,ruIAYI};
    
(* ????????
WIAX[x] = tp[C1[x,c*[x]]|^2 + tp[XX[x]] B1[x] tp[B1[x]] XX[x]
                 + tp[XX[x]] AB[x,c*[x]] +  tp[AB[x,c*[x]]] XX[x].

and 

 WIAYI[x]=[tp[AB[x,0]] - tp[C2[x]] inv[e2[x]] D21[x] tp[B1[x]]] YYI[x]
       + tp[YYI[x]] [AB[x,0] - B1[x] tp[D21[x]] inv[e2[x]] C2[x]] 
       + |C1[x,0]|^2 - tp[C2[x]] inv[e2[x]] C2[x] + 
tp[YYI[x]][B1[x] tp[B1[x]]-B1[x] tp[D21[x]] inv[e2[x]] D21[x] tp[B1[x]]] YYI[x].
*)

ruaWIA = a[z_]:> AB[z,c[z]] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z];

k[x_,z_] := tp[A[x]] ** GEx[x, z]/2 + tp[A[z]] ** GEz[x, z]/2 + 
   tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 + 
   (tp[GEx[x, z]] ** B2[x]/2 + tp[GEz[x, z]] ** B2[z]/2) ** inv[e1[z]] ** 
    (-tp[B2[z]] ** XX[z] - tp[D12[z]] ** C1[z]) + 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** 
    (-tp[B2[z]] ** XX[z] - tp[D12[z]] ** C1[z]) + 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** 
    (-tp[B2[x]] ** GEx[x, z]/2 - tp[B2[z]] ** GEz[x, z]/2 - 
      tp[D12[x]] ** C1[x]) + 
   tp[C2[x]] ** inv[e2[x]] ** 
    (-C2[x] + C2[z] - D21[x] ** tp[B1[x]] ** GEx[x, z]/2 + 
      D21[z] ** tp[B1[z]] ** XX[z]) + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** 
    (-C2[x] + C2[z] - D21[x] ** tp[B1[x]] ** GEx[x, z]/2 + 
      D21[z] ** tp[B1[z]] ** XX[z])/2 +
   (tp[XX[z]] ** B1[z] ** tp[D21[z]] + tp[C2[z]]) ** inv[e2[x]] ** 
    (C2[x] - C2[z] + D21[x] ** tp[B1[x]] ** GEx[x, z]/2 - 
      D21[z] ** tp[B1[z]] ** XX[z]) + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 + 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** e1[x] ** 
    inv[e1[z]] ** (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]);

(*---------------
When a*,c* are given by (4.4e) and (4.8) ([BHW]), then

(4.12)  sHWo[x,z,a*[z,b[z]],b[z],c*[z]] = bterm**e2[x]**tp[bterm] + k[x,z]

where 
-----------------*)

bterm = (tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] - 
       2*tp[XX[z]] ** B1[z] ** tp[D21[z]] + 2*tp[C2[x]] - 2*tp[C2[z]]) ** 
     inv[e2[x]]/2+ tp[GEz[x, z]]**b[z]/2;

(*-----------------

 this is the value of b1 which minimizes 
-------------------*)

ruqb = tp[b[z_]] ** GEz[x_, z_] :> q[x, z];     (* for standard problem *)
ruqb1 = tp[b1[z_]] ** GEz[x_, z_] :> q[x, z];   (* for "W-access" problem *)

ruCritqb={q[x, 0] -> -2*inv[e2[x]] ** C2[x] - 
    2*inv[e2[x]] ** D21[x] ** tp[B1[x]] ** YYI[x]};  (* for standard problem *)

ruCritqb1 = {q[x_, z_] :> -tp[B1] ** GEx[x, z] + 2*tp[B1] ** XX[z] - 
    tp[D21] ** tp[b2[z]] ** GEz[x, z]};      (* for "W-access" problem *)


(*----------------------
To do experiments we introduce 
rules which correspond to the Ansatses 1 to 5 of [BHW].
These come from differentiating e by hand. The special forms of 
e impose rule on the Gradients GEx, GEz in x and z.
Ansatzes 1 and 3 are given by:
THESE FORTMULAS ARE IMPLEMENTED IN  THE FILE SYSSpecialize.m

ruGEx1=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z];
ruGEz1=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z];
ruGE1=Flatten[{ruGEz0,SubstituteSymmetric[{ruGEz0,ruGEx1,ruGEz1},ruXXYYI]}];

SetNonCommutative[Grx,Gry];
ruGEx3=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z]+Grx[x,z];
ruGEz3=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z]+Grz[x,z];
ruGE3=Flatten[{ruGEz0,SubstituteSymmetric[{ruGEz0,ruGEx3,ruGEz3},ruXXYYI]}];

The following formulas are more specialized.
-------------------*)


EnergyGuess[ruleGE_]:= EnergyGuess2[ruleGE,rua];

EnergyGuess2[ruleGE_,rua_]:=
Block[{ Hnoc, Hnoac, Hqnoac, Hb1, Hb2},
      Hnoc=ExpandNonCommutativeMultiply[SubstituteSymmetric[sHWo,ruc]];
      Hnoac=ExpandNonCommutativeMultiply[SubstituteSymmetric[Hnoc,rua]];
      Hqnoac=SubstituteSymmetric[Hnoac,tp[GEz[x_,z_]]**b[z_]:>q[x,z]];
      Hb1=SubstituteSymmetric[Hqnoac,ruleGE];
      Hb2=SubstituteSymmetric[Hb1,rue];
      Return[Hb2];
];

EnergyGuessDGKF[ruleGE_]:= EnergyGuess2DGKF[ruleGE,ruaDGKF];

EnergyGuess2DGKF[ruleGE_,rua_]:=
Block[{sHWo2, HDGKFnoac, HDGKFqnoac,sHWo22, HbDGKF1},
    sHWo2=SubstituteSymmetric[sHWo,ruDGKFNL];
    HDGKFnoc=ExpandNonCommutativeMultiply[SubstituteSymmetric[sHWo2,ruCRcDGKF]];
    HDGKFnoac=ExpandNonCommutativeMultiply[SubstituteSymmetric[HDGKFnoc,rua]];
    HDGKFqnoac=SubstituteSymmetric[HDGKFnoac,tp[GEz[x_,z_]]**b[z_]:>q[x,z]];
    HbDGKF1=SubstituteSymmetric[HDGKFqnoac,ruleGE];
    HbDGKF=SubstituteSymmetric[HbDGKF1,ruDGKFNL];
    Return[HbDGKF];
];
