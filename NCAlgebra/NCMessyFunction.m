(* :Title: 	NCMessyFunction.m // Mathematica 1.2 and 2.0 *)

(* :Author: 	Bill Helton (helton). *)

(* :Context: 	Global` *)

(* :Summary:	These are expressions to test our simplification tools on.
		they originated in the optimal energy expression of peterson
		anderson jonckeere -they are parts of it . This is irrelevant to
		playing with them. Various expressions for your pleasure are 
		coexx, coexz, coezz, DGXX, DGYY, resid
*)

(* :Warnings: 	These expressions are Protected so that a user
		does not use their names inadvertently.
*)

(* :History: 
   :4/15/92	Created.
   :8/16/92	Packaged under Global` Context and Protecting
		coexz, coezz, etc. (dhurst)
   :11/18/92:   Changed DGX to DGXX and DGY to DGYY.(mstankus)
*)

BeginPackage[ "NCMessyFunction`", 
     "NonCommutativeMultiply`" ];


Clear[coexx,coexz1,coexz,coezz,DGXX,DGYY,resid];
Clear[X,Y, inXY,inYX,C1,C2,B1,B2,XX,YY,D12,D21];
Clear[d12,d21,e1,e2];
coexx::usage = "No usage statement for coexx";
coexz1::usage = "No usage statement for coexz1";
coexz::usage = "No usage statement for coexz";
coezz::usage = "No usage statement for coezz";
DGXX::usage = "No usage statement for DGXX";
DGYY::usage = "No usage statement for DGYY";
inXY::usage = "No usage statement for inXY";
inYX::usage = "No usage statement for inYX";
resid::usage = "No usage statement for resid";
A::usage = "No usage statement for A";
C1::usage = "No usage statement for C1";
C2::usage = "No usage statement for C2";
B1::usage = "No usage statement for B1";
B2::usage = "No usage statement for B2";
X::usage = "No usage statement for X";
Y::usage = "No usage statement for Y";
XX::usage = "No usage statement for XX";
YY::usage = "No usage statement for YY";
D12::usage = "No usage statement for D12";
D21::usage = "No usage statement for D21";
d12::usage = "No usage statement for d12";
d21::usage = "No usage statement for d21";
e1::usage = "No usage statement for e1";
e2::usage = "No usage statement for e2";


Begin["`Private`"];


(* The next line sets the variables we use to be noncommutative *)

SetNonCommutative[A,C1,C2,B1,B2,XX,YY,D12,D21,d12,d21,e1,e2];
SetNonCommutative[x,a,b];
SetNonCommutative[X,Y];

tp[X]=X;
tp[Y]=Y;

coexz1= -tp[C1] ** C1 - X ** B2 ** C1 - tp[C1] ** tp[B2] ** X - 
 
    X ** B2 ** tp[B2] ** X - X ** inv[1 - Y ** X] ** B1 ** C2 + 
 
    inv[Y] ** inv[1 - Y ** X] ** B1 ** C2 - 
 
    X ** inv[1 - Y ** X] ** B1 ** tp[B1] ** X - 
 
    X ** inv[1 - Y ** X] ** Y ** tp[C2] ** C2 + 
 
    inv[Y] ** inv[1 - Y ** X] ** B1 ** tp[B1] ** X + 
 
    inv[Y] ** inv[1 - Y ** X] ** Y ** tp[C2] ** C2 - 
 
    X ** inv[1 - Y ** X] ** Y ** tp[C2] ** tp[B1] ** X + 
 
    inv[Y] ** inv[1 - Y ** X] ** Y ** tp[C2] ** tp[B1] ** X;




tp[XX]=XX;
tp[YY]=YY;
inXY=inv[Id-XX**YY];
inYX=inv[Id-YY**XX];

coexz=-tp[C1] ** C1 - XX ** B2 ** inv[d12] ** C1 - 
   tp[C1] ** inv[tp[d12]] ** tp[B2] ** XX - 
   XX ** inv[Id - YY ** XX] ** B1 ** inv[d21] ** C2 - 
   XX ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** XX + 
   inv[YY] ** inv[Id - YY ** XX] ** B1 ** inv[d21] ** C2 + 
   inv[YY] ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** XX - 
   XX ** B2 ** inv[d12] ** inv[tp[d12]] ** tp[B2] ** XX - 
   XX ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** inv[d21] ** 
    C2 - XX ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** 
    tp[B1] ** XX + inv[YY] ** inv[Id - YY ** XX] ** YY ** tp[C2] ** 
    inv[tp[d21]] ** inv[d21] ** C2 + 
   inv[YY] ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** tp[B1] ** 
    XX;

(* Here is a toughy- the coeficient of tp[z] z in EHpajopt . Simplify it *)
coezz= -XX ** A + inv[YY] ** A - tp[A] ** XX + tp[A] ** inv[YY] + 
   tp[C1] ** C1 - 2*XX ** B1 ** tp[B1] ** XX + 
   XX ** B1 ** tp[B1] ** inv[YY] + 2*XX ** B2 ** inv[d12] ** C1 - 
   inv[YY] ** B1 ** inv[d21] ** C2 + inv[YY] ** B1 ** tp[B1] ** XX - 
   inv[YY] ** B1 ** tp[B1] ** inv[YY] - inv[YY] ** B2 ** inv[d12] ** C1 + 
   2*tp[C1] ** inv[tp[d12]] ** tp[B2] ** XX - 
   tp[C1] ** inv[tp[d12]] ** tp[B2] ** inv[YY] - 
   tp[C2] ** inv[tp[d21]] ** inv[d21] ** C2 - 
   tp[C2] ** inv[tp[d21]] ** tp[B1] ** inv[YY] + 
   XX ** B1 ** tp[B1] ** inv[Id - XX ** YY] ** XX - 
   XX ** B1 ** tp[B1] ** inv[Id - XX ** YY] ** inv[YY] + 
   XX ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** XX - 
   XX ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** inv[YY] - 
   inv[YY] ** B1 ** tp[B1] ** inv[Id - XX ** YY] ** XX + 
   inv[YY] ** B1 ** tp[B1] ** inv[Id - XX ** YY] ** inv[YY] - 
   inv[YY] ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** XX + 
   inv[YY] ** inv[Id - YY ** XX] ** B1 ** tp[B1] ** inv[YY] + 
   3*XX ** B2 ** inv[d12] ** inv[tp[d12]] ** tp[B2] ** XX - 
   XX ** B2 ** inv[d12] ** inv[tp[d12]] ** tp[B2] ** inv[YY] - 
   inv[YY] ** B2 ** inv[d12] ** inv[tp[d12]] ** tp[B2] ** XX + 
   XX ** B1 ** inv[d21] ** C2 ** YY ** inv[Id - XX ** YY] ** XX - 
   XX ** B1 ** inv[d21] ** C2 ** YY ** inv[Id - XX ** YY] ** inv[YY] + 
   XX ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** tp[B1] ** XX - 
   XX ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** tp[B1] ** 
    inv[YY] - inv[YY] ** B1 ** inv[d21] ** C2 ** YY ** inv[Id - XX ** YY] ** 
    XX + inv[YY] ** B1 ** inv[d21] ** C2 ** YY ** inv[Id - XX ** YY] ** 
    inv[YY] - inv[YY] ** inv[Id - YY ** XX] ** YY ** tp[C2] ** 
    inv[tp[d21]] ** tp[B1] ** XX + 
   inv[YY] ** inv[Id - YY ** XX] ** YY ** tp[C2] ** inv[tp[d21]] ** tp[B1] ** 
    inv[YY];

(* THe tp[x] x term of EHpajopt is already simple *)

coexx=tp[x] ** XX ** A ** x + tp[x] ** tp[A] ** XX ** x + 
  tp[x] ** tp[C1] ** C1 ** x + tp[x] ** XX ** B1 ** tp[B1] ** XX ** x;

(* The next expressions might be fun to play with because eventually we
will want to use the information DGXX==0 and DGYY==0.
*)

DGXX= XX ** (A - B2 ** inv[e1] ** tp[D12] ** C1) + 
   (-tp[C1] ** D12 ** inv[e1] ** tp[B2] + tp[A]) ** XX + 
   XX ** (B1 ** tp[B1] - B2 ** inv[e1] ** tp[B2]) ** XX +
  tp[C1] ** (1 - D12 ** inv[e1] ** tp[D12]) ** C1;

DGYY= YY ** (tp[A] - tp[C2] ** inv[e2] ** D21 ** tp[B1]) + 
     (A - B1 ** tp[D21] ** inv[e2] ** C2) ** YY + 
   YY ** (tp[C1] ** C1 - tp[C2] ** inv[e2] ** C2) ** YY +
   B1 ** (1 - tp[D21] ** inv[e2] ** D21) ** tp[B1];

resid= inv[Id-a]**(a-b)**inv[Id-b]-inv[Id-a]+inv[Id-b];

End[];
EndPackage[ ]

