(*  SYSHinf2x2Formulas.m *)

(* THE FORMULAS (LINEAR CASE) WHICH MAKE THE f,g,g2 SUBSYSTEM IN SYSDef2x2.m 
PARAMETERIZER FOR ALL SOLUTIONS TO THE HINF CONTROL PROBLEM:
WE give the formulas ONLY in very special cases defined by val1 below. This file is very primative. 
It corresponds to the one block problem. That would be easy to
extend to the 2 block problem. *)

Print["SYSDef2x2.m MUST BE LOADED"];
Print["SYSSpecialize.m MUST BE LOADED"];

(*********************************************************)


SNC[o3,d1];
vals1={
D12[z_]:>1,
D21[z_]:>1,
d12[z_]:>1,
d21[z_]:>1,
e1[z_]:>1,
e2[z_]:>1,
e2->1,
e1->1,
e2->1,
D21->1,
D12->1,
d1->1};

Lin[expr_]:=SubSym[expr,rulinearall];

(* THE REVOUTER- which is the parameterizer is the system f,g 
in SYSDef2x2.m with the rule below substituted in*)

rurevouter= {
d22[z_]:>0,
d11[z_]:>0,
aa[z_] :> A[z] + B2[z] ** (-inv[e1[z]] ** 
       (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z])) - b1[z] ** C2[z] + 
   ((B1[z] - b1[z] ** D21[z]) ** tp[B1[z]]) ** XX[z],

(*linear only*)
b1[z_]:>  -inv[YY**XX - 1]**(YY**tp[C2] ** inv[e2] + 
     B1 ** tp[D21] ** inv[e2]),

b2[z]:> -inv[YY**XX - 1] ** (B2 ** d1 + 
     YY**tp[C1] ** D12 ** d1),

(*non linear *)
(*ruc gives k1[z]*)
k1[z_]:> -inv[e1[z]] ** (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]),

k2[z_]:> -(D21[z]**tp[B1[z]]**XX[z] +C2[z])

};

(* THE REVOUTER- which is the parameterizer is *)
roust=f[z,Y,V];
rouout={g[z,Y,V],g2[z,Y,V]};
router={roust,rouout};
linrouter=Lin[(router//.rurevouter)//.vals1];
Print["ROUTER IS LOADED"];
(* THIS PRODUCES OTHER FORMULAS *)

(* THE CLOSED LOOP SYSTEM IS LOSSLESS ; THAT IS J -INNER*)
(*INNER*)
innerst={F[x,W,U]//.ruconnect, f[z,Y,V]//.ruconnect};
innerout={G1[x,W,U]//.ruconnect,g2[z,Y,V]//.ruconnect};
inner={innerst,innerout};
lininner=Lin[(inner//.rurevouter)//.vals1];
Print["INNER IS LOADED"];

(* ALL FORMULAS WE HAVE LISTED ARE IN CASCADE FORM: NOW WE CONVERT THESE
TO THE CHAIN FORMALISM *)
(*REV ARROW RULES*)
rurevWo3= NCSolve[NCE[lininner[[-1,2]]]==o3,W];
rurevYo3= NCSolve[NCE[linrouter[[-1,2]]]==o3,Y];
Print["REV ARROW IS LOADED"];

(*LINEAR JINNER OUTER FACTORS ARE*)
linJinner=({lininner//.rurevWo3,rurevWo3})//.vals1;
linouter={linrouter//.rurevYo3,rurevYo3}//.vals1;
Print["JINNER OUTER IS LOADED"];

(*****************************************************)
(*****************************************************)
(*-----------------------------------
                RESULTS STORED FOR FAST EXECUTION               

The following are redundant in that they can be computed from the 
above expressions.                                                    
*)

(*
ANSWERS
ANSWERS
ANSWERS
ANSWERS
*)
(*

lininner=
  {{A ** x + B1 ** W + B2 ** (V - C1 ** z - tp[B2] ** XX ** z), 
    A ** z - B2 ** (C1 ** z + tp[B2] ** XX ** z) - 
     inv[-1 + YY ** XX] ** (B2 + YY ** tp[C1]) ** V - 
     inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** (W + C2 ** x) + 
     inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** C2 ** z + 
     (B1 + inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2])) ** tp[B1] ** XX ** z}, 
   {V + C1 ** x - C1 ** z - tp[B2] ** XX ** z, 
    W + C2 ** x - C2 ** z - tp[B1] ** XX ** z}};

linrouter=
  {A ** z - B2 ** (C1 ** z + tp[B2] ** XX ** z) - 
    inv[-1 + YY ** XX] ** (B2 + YY ** tp[C1]) ** V - 
    inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** Y + 
    inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** C2 ** z + 
    (B1 + inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2])) ** tp[B1] ** XX ** z, 
   {V - C1 ** z - tp[B2] ** XX ** z, Y - C2 ** z - tp[B1] ** XX ** z}};

linJinner=
  {{{A ** x + B1 ** (o3 - C2 ** x + C2 ** z + tp[B1] ** XX ** z) + 
      B2 ** (V - C1 ** z - tp[B2] ** XX ** z), 
     A ** z - B2 ** (C1 ** z + tp[B2] ** XX ** z) - 
      inv[-1 + YY ** XX] ** (B2 + YY ** tp[C1]) ** V - 
      inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** 
       (o3 + C2 ** z + tp[B1] ** XX ** z) + 
      inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** C2 ** z + 
      (B1 + inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2])) ** tp[B1] ** XX ** z}\
     , {V + C1 ** x - C1 ** z - tp[B2] ** XX ** z, o3}}, 
   {W -> o3 - C2 ** x + C2 ** z + tp[B1] ** XX ** z}};

linouter=
  {{A ** z - B2 ** (C1 ** z + tp[B2] ** XX ** z) - 
     inv[-1 + YY ** XX] ** (B2 + YY ** tp[C1]) ** V - 
     inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** 
      (o3 + C2 ** z + tp[B1] ** XX ** z) + 
     inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2]) ** C2 ** z + 
     (B1 + inv[-1 + YY ** XX] ** (B1 + YY ** tp[C2])) ** tp[B1] ** XX ** z, 
    {V - C1 ** z - tp[B2] ** XX ** z, o3}}, 
   {Y -> o3 + C2 ** z + tp[B1] ** XX ** z}};

(*****************************************************)
(*****************************************************)

*)

