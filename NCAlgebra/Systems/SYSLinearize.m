(* SYSLinearize.m *)

(*      LINEARIZATION OF NONLINEAR SYSTEM AROUND THE DIAGONAL    *)

SetNonCommutative[V,O,zmx, zmx2];
SetNonCommutative[d2edz2, d3edz3, d3edz2dx];
SetNonCommutative[phi1,phi2,Dphi1];

(*  In the following formulas, expressions are formally linearized
in the variable z at the value x.  The symbols f[x,zmx] and
f[x,zmx2] stand for functions evaluated at x whose image is a
linear, respectively bilinear, functional which is in turn
evaluated at z-x (zmx) and (z-x)^2 (xmz2).  Only terms through
2nd order are kept for each Taylor expansion.  These are multiplied
out in the expression in which they are substituted, and then
rukillhot ("kill higher order terms") is used to eliminate all
products which are of order 3 or higher in z-x.

All of this is done for you by using the function
	linearizeatx
defined below.
*)

rulinsys = {
A[z]->A[x]+DA[x,zmx]+D2A[x,zmx2]/2, 
XX[z]->XX[x]+DXX[x,zmx]+D2X[x,zmx2]/2,
C2[z]->C2[x]+DC2[x,zmx]+D2C2[x,zmx2]/2, 
B2[z]->B2[x]+DB2[x,zmx]+D2B2[x,zmx2]/2, 
B1[z]->B1[x]+DB1[x,zmx]+D2B1[x,zmx2]/2, 
e2[z]->e2[x]+De2[x,zmx]+D2e2[x,zmx2]/2, 
e1[z]->e1[x]+De1[x,zmx]+D2e1[x,zmx2]/2, 
inv[e1[z]]->inv[e1[x]]+Dinve1[x,zmx]+D2inve1[x,zmx2]/2, 
inv[e2[z]]->inv[e2[x]]+Dinve2[x,zmx]+D2inve2[x,zmx2]/2, 
b2[z]->b2[x]+Db2[x,zmx]+D2b2[x,zmx2]/2,
D12[z]->D12[x]+DD12[x,zmx]+D2D12[x,zmx2]/2, 
D21[z]->D21[x]+DD21[x,zmx]+D2D21[x,zmx2]/2, 
C1[z]->C1[x]+DC1[x,zmx]+D2C1[x,zmx2]/2};

runrgord2 = { GEx[x_,z_]:>2 XX[x] - 2 V1[x,zmx] + V2[x,zmx2],
GEz[x_,z_]:> 2 V1[x,zmx] };

runrgord3 = 
{ GEx[x_,z_]:>2 XX[x] - 2 V1[x,zmx] + V2[x,zmx2] - 3 T[x,zmx2],
GEz[x_,z_]:> 2 V1[x,zmx] + 3 T[x,zmx2] };

(* use either one of these energy functions or your own to
linearize the system at z=x  *)

(* kill the terms of order 3 or higher *)
rukillhot = {
f_[x,zmx2]**a___**g_[x,zmx]:>0, 
f_[x,zmx]**a___**g_[x,zmx2]:>0,
tp[f_[x,zmx2]]**a___**g_[x,zmx]:>0, 
tp[f_[x,zmx]]**a___**g_[x,zmx2]:>0,
f_[x,zmx]**a___**g_[x,zmx]**b___**h_[x,zmx]:>0, 
tp[f_[x,zmx]]**a___**g_[x,zmx]**b___**h_[x,zmx]:>0, 
f_[x,zmx]**a___**tp[g_[x,zmx]]**b___**h_[x,zmx]:>0, 
f_[x,zmx]**a___**g_[x,zmx]**b___**tp[h_[x,zmx]]:>0, 
f_[x,zmx2]**a___**g_[x,zmx2]:>0, 
tp[f_[x,zmx2]]**a___**g_[x,zmx2]:>0,
f_[x,zmx2]**a___**tp[g_[x,zmx2]]:>0
};

(*This requires an expression to be linearized and a rule
which sends the generic GEx, GEz to some particular form of
energy function gradient.*)

Linearizeatx[expr__, energy_] := 
   Block[ {rulinatx, out}, 
	rulinatx = Flatten[ energy, rulinsys];
	temp = NCE[Sub[expr, rulinatx]];
	out = SubSym[temp, rukillhot];
	Return[out]
];


(* linearize a function of x at the value of z  - restricted to functions of special form*)
(* This doesn't do what you need it to yet. *)
(*linearize[expr_,x_,z_]:=
     Block[{temp},  
          temp = Diff[expr,x];
          SetNonCommutative[Df];
          temp = Sub[temp, DF[f_[x],x]:>f[z]^d ];
          temp = Sub[temp, DF[f_[x,z],x]:>f[z,z]^d ];
          temp = Sub[temp, x->z];
          temp = Sub[temp, ruXXYYI];
          temp = Sub[temp, Df[0]->0];
          Return[temp];
     ]; 

*)

