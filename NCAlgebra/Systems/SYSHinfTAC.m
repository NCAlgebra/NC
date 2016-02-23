(* A VARIATIONAL APPROACH TO NON-LINEAR H-INFINITY CONTROL   *)
(*                                                           *)
(*      A file for doing linear and non-linear               *)
(*         H-infinity control calculations                   *)
(*         -very preliminary (but it runs)-                  *)
(*  Joeseph A. Ball   J. William Helton   Michael L. Walker  *) 


Print["                     TABLE OF CONTENTS               "];

(*
PART I.      BASIC RESULTS FOR IA SYSTEMS

I.   INTRODUCTION
II.  DISSIPATIVE SYSTEMS
III. OUTPUT FEEDBACK TO MAKE SYSTEMS DISSIPATIVE
IV.  NECESSARY CONDITIONS FOR SOLUTIONS OF e-DISFBK
V.   ENERGY ANSATZES 

PART II.     GREATER GENERALITY

VI.  W-INPUT AFFINE SYSTEMS 
VII. SEPARATION PRINCIPLE

APPENDIX.    COMPUTATIONS

GLOSSARY FOR SYSTEM ENERGY CALCULATIONS 
*)
(*

*)
Print["                 SECTION I                     "]
Print["               INTRODUCTION                    "]
(*
  We wish to analyse the dissipativity condition on 2 port systems
with a one port system in feedback. The basic question is
when does feedback exist which makes the full system dissipative 
and internally stable?  This while an interesting question about circuits 
is also the central question in Hinfinity control.
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
                      |____________|
                     
                 dx/dt  =  F[x,W,U]
(1.1)             out1  =  G1[x,W,U]
                    Y   =  G2[x,W,U]

(1.2)            dz/dt  =  f[z,Y]
                    U   =  g[z,Y]

The document is organized as follows. Section II recalls the theory of 
dissipative systems, Section III analyzes the nonlinear H-infinity 
control problem from the point of view of dissipative systems. 
Section IV develops some interchanges of max. and min. to obtain some 
necessary conditions for solutions to exist. Section
V develops the consequences of assuming the energy function has some special
forms and presents our recipe with sufficient conditions for it to yield a
solution. Section VI presents Theorems for WIA systems analogous to those 
derived in Section 4 for IA systems.  Finally Section VII presents a 
generalization of the separation principle to a general nonlinear setting.
Various proofs and technical points are collected in the appendix. 

We begin by recalling the theory of dissipative systems.
*)

(*###########################################################*)
(*************************************************************)
(*

*)

Print["               SECTION II            " ];
Print["           DISSIPATIVE SYSTEMS   " ];

(*  First we recall the bounded real lemma but we do so 
at a high level of generality.  The system definition is:
                        
(2.1)              dx/dt = F[x,W];
                    out1 = G1[x,W];

                      ______________
                      |            |
            W  ---->--| F     G1   |---->--- out1 
                      |____________|
                     

For linear systems this is:

                   SetNonCommutative[W,U,Y,DW,DU,DY];
                   SetNonCommutative[A,x,B1,C1,G1]; 
                   SetNonCommutative[D11];

                   F[x_,W_,U_]:=A**x+B1**W;
                   G1[x_,W_,U_]:=C1**x+D11**W;
*)
(*---------------------------------------------------------------*)

(*  Define a finite-gain dissipative system to be a system for
which 
               t1                          t1
(2.3)    Integral ([out1^2]) dt <= K Integral ([W^2]) dt
               t0                          t0
where K is a constant, and x(t0)=0. If K=1 the system will be called 
dissipative. In circuit theory these would be called passive.  This agrees
with the notion of dissipative in [W],[HM] with respect to the supply
rate W^2 - out^2.

Define a storage or energy function on the state space to be a nonnegative
function e satisfying

               t1
(2.4)    Integral ([out1^2]- [W^2]) =< e[x[t0]]-e[x[t1]]
               t0

and e(0)=0.  Hill-Moylan ([HM]) showed that a system is dissipative iff an 
energy (storage) function (possibly extended real valued) exists.  Under 
controllability assumptions, there exists an energy function with finite values.

We find it convenient to say that a system of the above form is 
e-dissipative provided that the energy Hamiltonian H defined by 
*)
(*
             SetNonCommutative[F,G1,G2,p]
(*(2.5)*)    H = tp[out1]**out1 - tp[W]**W + (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2
*)
(* is nonpositive where  p=Grad[e[x]].
That is, 0 >= H for all W and all x in the set of states reachable 
from 0 by the system. 

THEOREM 2.1 (see [W],[HM]) Let e be a given differentiable 
function. Then a system is e-dissipative if and only if e is a 
storage function for the system.  In this case, the system is dissipative.

Proof of Theorem 2.1. Assume e is a storage function.
For an input function W the energy exchanged at the in 
out ports from time t_1 to t_2 is less than the change in potential energy 
of the state, i.e.
        t2
  Integral ([out1^2]- [W^2]) =< e[x[t1]]-e[x[t2]]
        t1
Divide by t_2-t_1>0, let t_2 go to t_1 and set t_1=t to get

         out1[t]^2-W[t]^2 =< -(DirectionalDerivative[e[x[t]],x'[t]])

This gives the desired inequality on H.  The argument is easily reversible.

Therefore the key issue in determining dissipativity in many cases 
is to find a nonnegative energy function e which makes a system e-dissipative. 
Note in the linear case the energy function is quadratic:

*)
(*
                   SetNonCommutative[e,XX]
              e[x_]:=tp[x]**XX**x  
                       tp[XX]=XX
*)
(*
(To see this, use the Hill-Moylan minimal energy function; 
the infimum of quadratics is quadratic.)
Thus  p=Grad[e[x]] equals
*)
(*
       p=2 tp[XX**x]
*)
(* 
COROLLARY(2.2)
BOUNDED REAL LEMMA: Assume inv[-K + tp[D11] ** D11] exists. Then the linear 
system above is finite-gain dissipative with gain =< K and energy function 
tp[x]**XX**x iff XX is a positive semidefinite solution to the Riccatti 
inequality 0>= ricd(XX).  Here the Riccatti operator is 
----------------*)

ricd=XX ** A + tp[A] ** XX + tp[C1] ** C1 + 
   (XX ** B1 + tp[C1] ** D11) ** inv[-K + tp[D11] ** D11] ** 
    (-tp[B1] ** XX - tp[D11] ** C1);

(*---------------
Proof.  See [AV].
*)
(*

*)
(*############################################################*)
(**************************************************************)
(*  OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK *)
(*  OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK *)
(*  OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK   OUTPUT FEEDBACK *)


Print["                SECTION III                              "];
Print["     OUTPUT FEEDBACK TO MAKE SYSTEMS DISSIPATIVE         "];   

(*
  We wish to analyse the dissipativity condition on 2 port systems
with a one port system in feedback. The basic question is
when does feedback exist which makes the full system dissipative 
and internally stable?  This is the central question in 
Hinfinity control.
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
                      |____________|
                     
                 dx/dt  =  F[x,W,U]
                  out1  =  G1[x,W,U]
                    Y   =  G2[x,W,U]

                 dz/dt  =  f[z,Y]
                    U   =  g[z,Y]

a. Energy balance equations

We begin with notation for analyzing the DISSIPATIVITY of the 
systems  obtained by 
connecting f,g to F,G in several different ways. 
The energy function on the statespace is denoted by e.
HWUY below is the Hamiltonian of the two systems where inputs are W,U, and
Y. 

(3.1)       HWUY=  out^2 - W^2 + PP f(z,Y)+p F(x,W,U)

- If we connect the Y output of the 2 port to the f,g input then 
the resulting system has Hamiltonian function HWU.

           HWU=HWUY with the substitution Y -> G2(x,W,U).

- If we connect the U input of the 2 port to the 
f,g output then the resulting system has Hamiltonian function HWY.

           HWY=HWUY with the substitution U -> g(z,Y).

- If we connect the two systems in feedback, that is tie off U and Y, 
then the resulting Hamiltonian function is 

           HW=HWY with the substitution Y -> G2(x,W,U).

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
-------------------*)

SetNonCommutative[W,U,Y,DW,DU,DY];
SetNonCommutative[F,G1,G2,f,g,p,PP];

HWUY = tp[out1]**out1-tp[W]**W+
                       (p**F[x,W,U]+tp[F[x,W,U]]**tp[p])/2+
                                     (PP**f[z,Y]+tp[f[z,Y]]**tp[PP])/2;


HWU=HWUY/.Y->G2[x,W,U];
HWY=HWUY/.U->g[z,Y];
HW=HWY/.Y->G2[x,W,U];

(*****************************************************************)

(*                    PURE STATESPACE VARIABLES

STATESPACE -x,z. While the HWUY formulas mix x's and  p 's , the next ones are
purely on statespace variables x and z.  
Executable formulas for   

              p=tp[Grad[e,x]]  and PP= tp[Grad[e,z]]

are inserted by the rule 
-----------------*)

SetNonCommutative[GEx,GEz];
ruxz={p->tp[GEx[x,z]], PP->tp[GEz[x,z]]};
(* The storage function e is homogeneous   *)
          GEx[0,0]=0;
          GEz[0,0]=0;

sHWUY=HWUY/.ruxz;
sHWU=HWU/.ruxz;
sHWY=HWY/.ruxz;
sHW=HW/.ruxz;

(*----------------
b. H-infinity problem.

Find f=f[z,Y],g=g[z,Y] which make the closed loop system dissipative and 
internally stable.  

This discussion and results about the linear problem notably 
Peterson-Anderson-Jonckheere lead us to formulate our main computational 
problem as:

The Hinfinity control problem or dissipative feedback problem is:
Find a non-negative function e on X x Z with e[0]=0, so that 

(e-DISFBK)                   0>=min   max    sHW   
                                f,g   x,z,W

where the minimum i over functions f and g.  Also find formulas for or 
properties of the minimizing functions f,g. 

We refer to (e-DISFBK) as the e-DISFBK problem.
To meet the internal stability constraint, it is often useful to have
e proper or positive away from 0.  In our formulation of e-DISFBK, 
we make no such stipulation.  In this paper we shall separate the requirement 
that e be positive and proper from other restrictions on e.
As we shall see this is natural and informative.

In practice, it may be difficult or nonessential that we find functions f,g
so that max_W sHW_f,g(W,x,z) =< 0 for all x,z; we will 
be satisfied if max_W sHW_f,g(W,x,z) =< 0 for all x,z in
some large region Omega contained in X x Z containing the equilibrium
point (0,0).  Then the closed loop system still satisfies the input-output
dissipation inequality as long as the state trajectory stays inside Omega
(see the end of Section II).  We refer to this modification of (e-DISFBK)
as the regional (e-DISFBK) problem.

Positivity and properness are essential to the Hinfinity control problem 
because they guarantee stability (but not necessarily asymptotic stability) 
of the closed loop system for arbitrary L^2 inputs.

(Here and always we assume that G2[x,W,U] does not depend on U)
Often we specialize to IA systems in which case we require the
f we find to be an IA system.
Below the main formulas for studying it are recorded for loading in. 
*)


(****************************************************************)
(*

The following lemma illustrates the connection between the H-infinity 
problem and e-dissipativity in the case that the feedback is to be
an IA system. 

LEMMA 3.2. Let F,G1,G2 define an arbitrary (plant) system. 
The following are equivalent:

(3.1a) There exists an homogeneous IA system (compensator) 
f*(z,Y)=a*(z)+b*(z)Y,   g*(z,Y)=c*(z)+d*(z)Y 
such that the closed-loop system is e-dissipative.

(3.1b) min    max  max  max  sHW_a,b,c,d(W,x,z) =< 0, 
     a,b,c,d   x    z    W  

where a,b,c, and d are functions of z, with a and c homogeneous.

(3.1c) max    min    max  max  sHW_a,b,c,d(W,x,z)=<0 
     z.ne.0 a,b,c,d   x    W

and min  max  max  sHW_0,b,0,d(W,x,0)=<0, 
    b,d   x    W 

where a,b,c, and d are parameters.


Proof of Theorem 3.2.  Apply Theorem 1.1. Statement (3.1b) implies the 
existence of functions a(z), b(z), c(z), and d(z) such that sHW =< 0 for 
all x,z,and W, i.e. the closed loop system is e-dissipative and thus 
(3.1a) holds.  Conversely, if the closed loop system is e-dissipative 
for some choice of homogeneous functions f*,g* as in (3.1a), then

0 >= max  max  max  sHW(x,z,W,f*,g* ) >= min  max  max  max  sHW(x,z,W,f,g) 
      x    z    W                        f,g   x    z    W
and thus (3.1b) holds.  Similarly, (3.1a)=>(3.1b) by writing

0 >= max max max sHW(x,z,W,f*,g* ) >= max  min   max max sHW(x,z,W,a,b,c,d) 
      z   x   W                        z a,b,c,d  x   W

For the converse, fix z.ne.0 and define a*(z), b*(z), c*(z), d*(z) by

    a*(z),b*(z),c*(z),d*(z) = argmin  max max sHW
                             a,b,c,d   x   W
Similarly for z=0, set a*(0)=c*(0)=0, and define b*(0),d*(0) by

    b*(0),d*(0) = argmin  max max sHW
                   b,d     x   W

Then (3.1a) is satisfied by a*,b*,c*,d*.

c.  The max/min of sHW in W

In the following (with the exception of Section VII, the Separation Principle),
 we will specialize to IA compensators only with d(z)=0. Often one finds that 

(3.6)   sHWo_{a,b,c}(x,z):= max_W sHW_{a,b,c,0}(W,x,z)

is well behaved and is the first max taken in many approaches to solving 
the problem.  We sometimes relax the notation and write

(3.7)   sHWo = sHWo_{a,b,c}(x,z). 

In light of the disscussion in section 1, sHWo has a physical
interpretation. For a system with energy function e, 
one fixes a state (x,z) and drives the system with the input W making
the energy balance sHWo for the system the least dissipative (at that instant).
Thus it is appropriate to call sHWo the worst e-dissipation rate,
which we abbreviate to worst e-dissipation.

sHWo can be computed concretely for IA and WIA systems by taking the gradient of
sHW in W and setting it to 0 to find the critical point CritW. Substitute this 
back into sHW to get sHWo. In our language CritW can be computed for IA systems by

        ruCritW=Crit[HW,W];   (Calculate critical value for HW w.r.t. W)
        HWo=HW//.ruCritW;     (Substitute critical W back in HW)
        sHWo=HWo//.ruxz;      (Convert to state-space coordinates)

since p,PP are independent of W.  We shall make life easy by setting dd=0. 

A program which does this on days when our Crit function actually works:
         HW0=HW//.dd[x_]:>0;
         ruCritW=Crit[HW0,W];
         HWo=HW0//.ruCritW;
         sHWo=HWo//.ruxz;

         CRWpxz=W//.ruCritW;
         CRW=CRWpxz//.ruxz;

One obtains the following for both IA and WIA systems:
(THE ANSWER IS STORED HERE TO SPEED UP LOADING.)
-------------------*)

ruCritW= {W -> tp[B1[x]] ** GEx[x, z]/2 + 
     tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/2};

CritW[x_,z_,b_]:= tp[B1[x]] ** GEx[x, z]/2 + 
                tp[D21[x]] ** tp[b] ** GEz[x, z]/2;

sHWo = tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + 
  tp[GEz[x, z]] ** a[z]/2 + tp[a[z]] ** GEz[x, z]/2 + 
  tp[C1[x]] ** D12[x] ** c[z] + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
  tp[GEx[x, z]] ** B2[x] ** c[z]/2 + tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
  tp[c[z]] ** e1[x] ** c[z] + tp[c[z]] ** tp[B2[x]] ** GEx[x, z]/2 + 
  tp[c[z]] ** tp[D12[x]] ** C1[x] + 
  tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4;

sHWoWIA = tp[AB[x, c[z]]] ** GEx[x, z]/2 + tp[C1[x, c[z]]] ** C1[x, c[z]] + 
  tp[GEx[x, z]] ** AB[x, c[z]]/2 + tp[GEz[x, z]] ** a[z]/2 + 
  tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
  tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
  tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
  tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4;

(* ------------------
           This is how ruCritW and sHWo were derived:

In[2]:= <<SYSTEMSNL

In[3]:= sHW//.z->0

Out[4]= -tp[W] ** W + (tp[c[z]] ** tp[D12[x]] + tp[C1[x]]) ** 
    (C1[x] + D12[x] ** c[z]) + ((tp[W] ** tp[B1[x]] + tp[c[z]] ** tp[B2[x]] + 
         tp[A[x]]) ** GEx[x, z] + 
      tp[GEx[x, z]] ** (A[x] + B1[x] ** W + B2[x] ** c[z]))/2 + 
   (tp[GEz[x, z]] ** (b[z] ** (C2[x] + D21[x] ** W) + a[z]) + 
      ((tp[W] ** tp[D21[x]] + tp[C2[x]]) ** tp[b[z]] + tp[a[z]]) ** GEz[x, z])
     /2

In[5]:= Crit[%,W]

Out[5]= {W -> tp[B1[x]] ** GEx[x, z]/2 + 
     tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/2}

In[6]:= NCE[SubSym[%4,%]]

The output is sHWo recorded above.  Note that neither sHWo nor sHWoWIA depends
on a or c.

d. The min/max in U

Also useful is the optimum CritU for 

         Hopt:= min  max  sHW = min sHWo = max  min sHW. 
                 U    W          U          W    U  

For WIA systems there is not an elegant formula for CritU and possibly 
is not unique. For IA systems, one gets the concrete formula:
-----------------*)

ruCritU = {U -> -inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
     inv[e1[x]] ** tp[D12[x]] ** C1[x]};

CritU[x_,z_]:=-inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
     inv[e1[x]] ** tp[D12[x]] ** C1[x];

(* ---------------
An explicit formula for Hopt appears later in the Appendix. 
 Note that c*[z]=CritU[z,z] *)

(***************************************************************************)
Print["                   PURE DUAL VARIABLES                    "];
(*

DUAL p, PP. In terms of dual variables p and PP, H is 
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
(**************************************************************)
(*
e.  Special Classes of Systems 

Linear Energy Balance Equations

Now we describe the linear case. The key observation 
is that the energy function on the statespace, eLin,
is a quadratic form in (x,z) given by

       |x  z || P_{11}  P_{12}| | x |
eLin =        |               | |   |
              | P_{21}  P_{22}| | z |

where P_{ij} is a matrix for 1=<i,j=<2.  Thus 
p=Grad[eLin,x] = 2(P_{11}x + P_{12}z) PP= Grad[eLin,x] = 2(P_{21}x + P_{22}z) 

To specialize to the linear case, just apply

                    rulinearEB 

defined below also rudual for dual variables.
---------------*)

SetNonCommutative[P11,P12,P21,P22];
SetNonCommutative[QQ,vv];

QQ={{P11,P12},{P21,P22}};
tp[P11]=P11;
tp[P22]=P22;
tp[P21]=P12;
tp[P12]=P21;

seLin= tp[x] ** P11 ** x + tp[x] ** P12 ** z + tp[z] ** P21 ** x + 
   tp[z] ** P22 ** z;

(*--------------
The Doyle Glover Kargonekar Francis Simplifying Assumptions

A special class of IA systems are those satisfying

     tp[D12(x)]  C1(x)= 0       B1(x) tp[D21(x)]  = 0  
 
denoted in this paper as the Doyle-Glover-Kargonekar-Francis (DGKF) 
simplifying assumptions (see [DGKF]).
These simplify algebra substantially so are good for tutorial
purposes even though they are not satisfied in actual control problems.

The following rules implement the DGKF simplifying assumptions 
for IA systems: (Recall
rue = {tp[D12[x_]] ** D12[x_]:> e1[x], D21[x_] ** tp[D21[x_]] :> e2[x]}) 
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
 
(*---------------------------------------------------------------*)
(*
Next we want to be able to substitute 
              p=Grad[eLin,x]  and PP= Grad[eLin,z]
for p and PP.  In other words,

{GEx[x_,z_]:>Grad[seLin,x],
 GEz[x_,z_]:>Grad[seLin,z]};

Executable formulas for this are  
---------------------*)

SetNonCommutative[GEx,GEz];
rulinearEB={GEx[x_,z_]:> 2*(P11**x + P12**z),
            GEz[x_,z_]:> 2*(P21**x + P22**z)};

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
(*#################################################################*)
(********************************************************************)
(*

*)

Print["                SECTION IV                                " ];
Print["        NECESSARY CONDITIONS FOR SOLUTIONS OF DISFBK      "];

(*
  One might expect that since we have a min max problem the
success of the linear solutions which are known might be explained
in terms of intechanging mins and maxes. For the linear case
and for close to linear cases carefully chosen interchanges of 
mins and maxes might be justified. We found this to be true but
even in the linear case it is delicate; most orderings of the 
7 possible mins and maxes do not work (interchange gives no 
information).

    An important role will be played by two subsets of
the statespace of the closed loop system. These are

(4.1)      ZGEz:={(x,z): Grad[e,z]=0}
 and
(4.2)      Nz:= { (x,z): z=0 }.

Normalize ZGEz to equal {(x,x)}. This ASSUMES  that
ZGEz is a graph over x and that z has the same
dimension as x.
-----------------*)
               ruGEz0=GEz[x_,x_]:>0;
(*----------------

In this section we deal exclusively with IA systems.  We summarize the 
assumptions which are used throughout the section.
(4.3a)  energy functions are differentiable.
(4.3b)  Vectors z and x are of the same dimension so the compensator state
        space Z can be identified with the plant state space X.
(4.3c)  GEz[x,z]=0 if and only if x=z.
(4.3d)  G2[x,W,U] is independent of U,
        G1[x,W,U] is independent of W. (i.e. D11[x]=D22[x]=0).
(4.3e)  Maxes and mins are all achieved (i.e. max, min instead of sup, inf)
(4.3f)  e1[x]=tp[D12[x]]**D12[x] > 0, e2[x]=D21[x]**tp[D21[x]] > 0.

THEOREM 4.1  Fix x,z, then

(4.4a) min  min  sHWo   = min  min  sHWo   = min  min  sHWo= 
       a,b   c            b,c    a            a   b,c 
                       _
                      |  -infinity,  if z is not x or 0.
   min  min  sHWo   = |     IAX[x],  if z=x
   c    a,b           |_   IAYI[x],  if z=0 

Here we define
-------------------*)

(* 4.4b *)
IAX[x_]:=(-tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] + tp[A[x]]) ** XX[x]+
 tp[C1[x]] ** C1[x] + tp[XX[x]] ** 
   (A[x] - B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]) + 
  tp[XX[x]] ** (B1[x] ** tp[B1[x]] - B2[x] ** inv[e1[x]] ** tp[B2[x]]) ** 
   XX[x] - tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x];

(* 4.4c *)
IAYI[x_]:=(-tp[C2[x]]**inv[e2[x]]**D21[x]**tp[B1[x]] + tp[A[x]])**YYI[x] + 
  tp[C1[x]] ** C1[x] + tp[YYI[x]] ** 
   (A[x] - B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x]) - 
  tp[C2[x]] ** inv[e2[x]] ** C2[x] + 
  tp[YYI[x]] ** (B1[x] ** tp[B1[x]] - 
     B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]]) ** YYI[x];

(*------------------
 Here the relationship of XX and YYI to e is given by the rules 
-------------------*)

              ruXX = GEx[x_,x_]:>2*XX[x];
(* (4.4d) *)  ruYYI = GEx[x_,0]:>2*YYI[x];
              ruXXYYI={ruGEz0,ruXX, ruYYI};

(*------------------
The minimizing c when x=z can be computed explicitly to be:   

(4.4e)    c*[z]= = -inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
                    inv[e1[z]] ** tp[D12[z]] ** C1[z] = CritU(z,z)

The minimizing b when z=0 is computed in the proof: 

(4.5d)    tp[GEz[x,0]]**b = -(2 tp[C2[x]] + tp[GEx[x, 0]] ** B1[x] 
                                    ** tp[D21[x]]) ** inv[e2[x]] 

Proof: see [BHW].

Note that for a linear system 
       IAX[x]==0        IAYI[x]==0
are the Doyle Glover Riccati equations for X and for the inverse of Y 
respectively (for the case where Y is invertible).  Indeed for linear 
systems the gradient of e can be expressed entirely in terms of the 
Doyle Glover XX and YY:

        1/2 GEx[x,0] = YYI(x) =  inv[YY] x  
        1/2 GEx[x,x] = XX(x) = XX x  

Also, in the linear case, the solution b*(x,0) of (4.5d) below turns out to be
independent of x and gives the input function b for the central compensator
(see e.g. [PAJ]).

Also useful are rules which invoke the equations 
       IAX[x]==0        IAYI[x]==0
in a natural way for simplifying expressions in circumstances 
when we know they hold.
------------------------*)
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
(*----------------------
    
COROLLARY 4.2.  If there is an IA compensator system a,b,c 
solving (e-DISFBK), then the inequalities

       IAX[x]=<0  and  IAYI[x]=<0 for all x

for all x have solutions XX and YYI given by 

      XX[x]=GEx[x,x]/2 and YYI[x]=GEx[x,0]/2.

Conversely, suppose that (e-DISFBK) has a saddlepoint in x, 
that is, for each fixed z

(4.6)   min   max  max sHW = max  min  max sHW.
       a,b,c   x    W         x  a,b,c  W

If a particular e satisfies IAX(x)=< 0 and IAYI(x)=< 0
for all  x and minimizing a,b,c exist, then there is a solution to
e-DISFBK. Moreover, the minimizing c is given by (4.4e), while a
is given below by (4.8).  

Proof of Corollary 4.2:  
This corollary follows from  (4.4a) and the fact that
min max >=max min. To be more explicit, if (e-DISFBK) has
a solution, then for fixed z

   0>=  min   max   sHW >=   max  min  min  sHWo = 
       a,b,c  x,W             x   a,b   c          
                       _
                      |  -infinity,  if z is not x or 0.
                 max  |     IAX[x],  if z=x
                  x   |_   IAYI[x],  if z=0 

Consequently, IAX[x]=<0  and  IAYI[x]=<0 for all x as required.

The next result gives certain conditions which force the form of a(z) and
c(z) for the compensator (a,b,c) to be a solution of (e-DISFBK).

THEOREM 4.3. Separation Principle

Assume that the energy function e(x,z) is normalized so 
that 

     (4.7a)  IAX(x) = 0 for all x.

     (4.7b)  GEx[x,z]|     = 0 as usual.
                     |z=x

     (4.7c)  D_z{GEx[x,z] + GEz[x,z] }|     = 0.
                                      |z=x

     (4.7d)  D_z(GEz[x,z])|      has full rank. 
                          |z=x

     (4.7e)  There is an a,b,c solving (e-DISFBK). 

Then a,c are given by 

(4.8)  a[z]=F[z,CritW[z,z,b[z]],c*[z]]+ b[z]**(-G2[z,CritW[z,z,b[z]]]).

       c[z]=CritU[z,z]

More explicitly, for IA systems this is
---------------------*)

ruc = c[z_]:> -inv[e1[z]]**(tp[B2[z]]**XX[z] + tp[D12[z]]**C1[z]);

rua = a[z_]:> A[z] + B2[z]**c[z] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z]//.ruc ;

ruaWIA = a[z_]:> AB[z,c[z]] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z];

(*-------------------
The Theorem has a physical interpretation. The key hypothesis
(4.7a) says that if one chooses memoryless state 
feedback which produces the most negative e-dissipation rate possible
and obtains an e-dissipation rate equal to 0 (recall, this means
sHWo_{a,b,c*}(x,x)=IAX(x)=0, for all states), then any 
solution to (e-DISFBK) has a and c prescribed as above.  
In the linear case, the result has the interpretation that the output feedback
problem can be split into two separate pieces: the state feedback problem 
and the problem of state estimation via output injection (see [PAJ],[DGKF]).

*)

(*----------------------------------------------------*)
(*
THEOREM(4.4) A necessary condition for the system a*,b,c* with a*,c* given
by (4.8) to solve DISFBK is

                k[x,z]=<0  for all x,z

where k is:
----------------------*) 
(*(4.11)*) 
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

(*----------------------
Proof of Theorem 4.3: The computation in Appendix says that when a*,c*
are given by (4.4e) and (4.8), then

(4.12)  sHWo[x,z,a*[z,b[z]],b[z],c*[z]] = bterm**e2[x]**tp[bterm] + k[x,z]

where 
-----------------*)
bterm = (tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] - 
       2*tp[XX[z]] ** B1[z] ** tp[D21[z]] + 2*tp[C2[x]] - 2*tp[C2[z]]) ** 
     inv[e2[x]]/2+ tp[GEz[x, z]]**b[z]/2;
(*---------------
Since bterm**e2[x]**tp[bterm] >= 0 for any b,x,z and sHWo =< 0 by
assumption, the conclustion follows. 
*)
(**********************************************************)
Print["            SPECIAL  SYSTEMS                   "]; 
Print["             LINEAR SYSTEMS            "]; 

(* In terms of GE the conversion law is  
------------------*)

ruGEXY1=tp[GEx[x_,0]]:>2*tp[x]**inv[YY];
ruGEXY2=tp[GEx[x_,x_]]:>2*tp[x]**XX;
ruGEXY={ruGEXY1,ruGEXY2};

(* In terms of XX and YY the conversion law is  *)

rulinearXY={XX[x_]:>XX**x,YY[p_]:>p**YY,YYI[x_]:>inv[YY]**x};
rulinearall=Union[rulinearsys,ruGEXY,rulinearXY];

(*----------------------------------------------------*)
Print["     DOYLE GLOVER KHARGONEKAR FRANCIS SIMPLIFYING ASSUMPTIONS        "]; 

 
ruCRcDGKF=c[z_]:>-tp[B2[z]]**XX[z];
ruCRqDGKF=q[x_,z_]:>-tp[C2[x-z]];

SetNonCommutative[cheat];
ruaDGKF = a[z_]:>A[z]+B1[z]**tp[B1[z]]**XX[z] - 
B2[z]**tp[B2[z]]**XX[z] - b[z]**C2[z]+cheat[z];

ruaDGKF2=a[z_]:> AA1[z,z]-b[z]**C2[z];

(*--------------------
  To this point we have not used or concluded  positivity of e.
Positivity is a strong property which imposes serious restrictions.
For this we refer the reader to section V since more hypotheses 
than we now have are needed.

*)

(*########################################################*)      
(******************************************************)
(*

*)

Print["                  SECTION V                             "]; 
Print["              ENERGY ANSATZES                        "]; 

(*
     To make further progress we make assumptions on the
storage functins which we permit. It is a valid question to ask
whether we can find feedback f,g to make the system e dissipative where
e is restricted in some way. Of course we hope the restriction 
not only makes computation possible but that optimal or 
near optimal storage functions have this form.

     In order of liberality natural conditions are:

(5.1) e[x,z]=e1[x] + e2[x-z]

(5.2) e[x,z]=e1[x] + e2[x-z] + SUM Ej[z] ej[x-z]
                               j>2

(5.3) Same as 5.4 but add in the stipulation that
Dz[Grad[r,diagonal]] vanishes on the diagonal.

(5.4) e[x,z]=e1[x] + e2[x-z] + r[x,z]
where r is a nonnegative functions such that r and
its gradient vanish on z=o and on the diagonal x=z.

(5.5) e[x,z]=e1[x] + e2[x-z] + SUM Ej[x,z] ej[x-z]
                               j>2

(5.6) e[x,z]=e1[x] + e2[x-z] + r[x,z]
where r s a nonnegative functions such that r together with 
Grad[r,z] and Dz[Grad[r,diagonal]] vanish on the diagonal x=z.

In all cases we shall assume that each function ek , Ek
is nonnegative, smooth, and vanishing at 0.  
Here Grad[r,diagonal]=Grad[r,x]+Grad[r,z].  The following proposition
describes the relationships between these "energy ansatzes".  
For a proof, see [BHW].

Proposition(5.1) An energy function satisfying condition (5.m) 
also satisfies condition (5.n) if m<n=<4 or m=5,n=6.

Note that the hypotheses (4) and (5) of the separation principle 
(Section VII) are implied by  (5.3). 

Ansatzes on e convert directly to conditions on gradients 
which come from differentiating e.  For example, in 
(5.1) we recover e1 and e2 from e1(x)= e(x,x) and e2(z) = e(0,-z).
Thus 

(5.7)  GEx[x,z] = (GEx[x,x] + GEx[x - z,0]) - GEx[x - z,x - z] 
       GEz[x,z] = - GEx[x - z,0] +  GEx[x - z,x - z]  

By assuming an Ansatz for e, we get necessary conditions for the solution
of the H-infinity problem which do not involve the unknown function e, but
rather only solutions of certain Hamiltonian-Jacobi inequalities.

THEOREM 5.2  If (e-DISFBK) has a positive definite solution e 
for the closed-loop IA system, where e is of the form

   a. (5.3), then there exist solutions XX(x) and YYI(x) of
        IAX[x]=<0   and  IAYI[x]=<0 
(see (4.4b) and (4.4c)) such that XX(x), YYI(x), and YYI(x)-XX(x)
are gradients of positive functions.        

   b. (5.1) and IAX(x)=0 is satisfied, then 

0 >= (tp[XX[x - z]] ** (B1[z] ** tp[B1[z]] + B2[x] ** tp[B2[z]] - 
        B2[z] ** tp[B2[z]]) + tp[YYI[x - z]] ** 
      (-B1[z] ** tp[B1[z]] - B2[x] ** tp[B2[z]] + B2[z] ** tp[B2[z]])) ** 
   XX[z] + (-tp[XX[x - z]] ** B1[x] ** tp[B1[x]] - 
     tp[XX[z]] ** B2[z] ** tp[B2[x]] + tp[YYI[x - z]] ** B1[x] ** tp[B1[x]] + 
     tp[A[x]]) ** XX[x] + (tp[A[x]] - tp[A[z]]) ** YYI[x - z] + 
  (-tp[YYI[x - z]] ** B1[x] ** tp[B1[x]] - tp[A[x]] + tp[A[z]]) ** 
   XX[x - z] + tp[C1[x]] ** C1[x] - tp[C2[x]] ** C2[x] + tp[C2[x]] ** C2[z] + 
  tp[C2[z]] ** C2[x] - tp[C2[z]] ** C2[z] + 
  tp[XX[x]] ** (A[x] - B1[x] ** tp[B1[x]] ** XX[x - z] + 
     B1[x] ** tp[B1[x]] ** YYI[x - z] - B2[x] ** tp[B2[z]] ** XX[z]) + 
  tp[XX[x - z]] ** (-A[x] + A[z] - B1[x] ** tp[B1[x]] ** YYI[x - z]) + 
  tp[XX[z]] ** ((B1[z] ** tp[B1[z]] + B2[z] ** tp[B2[x]] - 
        B2[z] ** tp[B2[z]]) ** XX[x - z] + 
     (-B1[z] ** tp[B1[z]] - B2[z] ** tp[B2[x]] + B2[z] ** tp[B2[z]]) ** 
      YYI[x - z]) + tp[YYI[x - z]] ** (A[x] - A[z]) + 
  tp[XX[x]] ** B1[x] ** tp[B1[x]] ** XX[x] + 
  tp[XX[x - z]] ** B1[x] ** tp[B1[x]] ** XX[x - z] + 
  tp[XX[z]] ** B2[z] ** tp[B2[z]] ** XX[z] + 
  tp[YYI[x - z]] ** B1[x] ** tp[B1[x]] ** YYI[x - z]

provided the DGKF simplifying assumptions hold.


Proof of Theorem 5.2:

a.  We have
XX(x) = 1/2 GEx[x,x] = 1/2 Grad[e1(x)]
YYI(x) = 1/2 GEx[x,0]= 1/2 Grad[e1(x)]+1/2 Grad[e2(x)]

using the assumption Grad[r(x,x)] = Grad[r(x,0)] = 0. 
Then YYI(x)-XX(x)= 1/2 Grad[e2(x)] and 
the theorem follows, since e1, e2, and e1+e2 are positive.

b.  The expression in (b) is  
just the condition k =< 0 in Theorem 4.4  with 
expressions (5.7) substituted in for the respective gradients
of e, where the DGKF simplifying assumptions and the substitution
(4.4b) were used to simplify some expressions.  

To this point our results have been in the direction of necessary 
conditions for a solution. We now suggest some constructions 
to the reader for producing solutions. They probably are not optimal at all, 
since there is a considerable gap between our necessary and our sufficient 
conditions. The main weakness in our understanding lies with b(z), so the 
recipe below just picks it in one sensible way. Often there will be better 
ways. The solution given in the linear case is the maximum entropy solution.

RECIPE
   (1)  Find a solution XX(x) to IAX(x) =< 0, where IAX(x) is given by (4.4b).

   (2) Choose c*(z) (and thus a*(z) also) as in (4.4e) and (4.8), that is:. 

ruc = c[z_]:> -inv[e1[z]]**(tp[B2[z]]**XX[z] + tp[D12[z]]**C1[z]);
rua = a[z_]:> A[z] + B2[z]**c[z] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z]//.ruc ;

   (3) For a suitable energy function e, define b(z) by

tp[b(z)]  = 

    -2 inv[D_x GEz[x,z]|   ] D_x[inv[e2(x)](1/2 D21(x) tp[B1(x)] GEx[x,z]
                       |x=z 

        - D21(z) tp[B1(z)] XX(z) + C2(x) - C2(z) )]|
                                                   |x=z

Here we assume that D_x GEz[x,z]| is invertible so that we can solve for b(z). 
                                |x=z


Remarks.

(1)  Motivation for the formulas in the RECIPE for a* and c* 
arises as follows. First of all,
in the linear case, the maximum entropy or central solution arises via the
recipe with IAX(x)=0, IAYI(x)=0 and with e of the form (5.1) with

e1(x)=tp[x]XX(x),  e2(x)=tp[x](YYI(x)-XX(x))

where XX(x) and YYI(x) are linear. For the general nonlinear case, if e
has the form (5.3) with XX(x)=1/2 GEx[x,x] 
and YYI(x)=1/2 GEx[x,0] and
if IAX(x)=0, then the form of a* and c* is forced on us by the
Separation Principle, so it is natural to look for solutions of this form even
if we only have IAX(x)=< 0. 

(2)  We would like to choose
b(z) so that the dissipation inequality sHWo =< 0, i.e. (4.12)

               bterm e_2(x) tp[bterm] + k(x,z) =< 0
 
holds in as large a neighborhood of (0,0) in X x X as possible. Note
that bterm vanishes for x=z. Hence, given that the necessary
condition k(x,z) =< 0 holds for all x,z, sHWo =< 0 is automatic for any choice
of b on the diagonal z=x. 
We would like to choose b(z) in such a way to
make bterm=0 at all x and z; in the linear case indeed this is
possible. However in the general nonlinear case obtaining bterm=0 is
only possible if one allows b to depend on both x and z; unfortunately we
are allowed only to let b be a function of z. The idea then is, for each
fixed z, to choose b(z) so that bterm vanishes to maximum possible
order (order 2) at x=z as a function of x. In this way we expect sHWo =< 0 to
remain true on a large neighborhood surrounding the origin. This leads directly
to the formula for b in Step 3 which we obtain by differentiating tp[bterm]
in (4.13) with respect to x and evaluating at x=z.

(3)  One sensible way to define e to place in the formula for
b(z) in Step (3) of the RECIPE is as follows: 
Assume that e has the form (5.3), i.e.
e(x,z)=e1(x)+e2(x-z)+r(x,z)
where e1, e2, r are defined by

       1/2 Grad[e1(x)] = XX(x),  e1(0)=0
       1/2 Grad[e2(x)] = YYI(x)-XX(x), e2(0)=0
r(x,z)is any perturbation satisfying the assumptions in (5.3).
The free r term gives one added flexibility to use to try to
increase the size of the region on which sHWo =< 0 remains true.

(4) If e satisfies (5.3) and we set 

    XX(x)=1/2 GEx[x,x], YYI(x)=1/2 GEx[x,0]

and if a*,b,c* are as in the RECIPE, then k(x,x)=IAX(x) and

 sHWo_{a,b,c*}(x,0)-IAY(x)=bterm e_2(x) tp[bterm] + k(x,0) - IAY(x)

vanishes to the second order as a function of x at x=0. In the linear case
this latter expression is linear and hence vanishes identically.

(5) The inequality IAX(x) =< 0 and related equation IAX(x)=0
are nonlinear generalizations of Riccati equations well known in classical
mechanics as Hamilton-Jacobi equations (or inequalities). They also appear in
various forms in nonlinear optimal control and game theory. There are a number
of methods of solution; for a discussion, especially the connection between
solutions of Hamilton-Jacobi equations and Lagrangian invariant manifolds of
Hamiltonian vector fields, see [V2].

THEOREM  5.3.   Assume that the Hamiltonian-Jacobi inequalities IAX(x) < 0 
and IAYI(x) =<  0 (see (4.4b) and (4.4c)) have solutions XX(x) and
YYI(x) such that each of XX(x), YYI(x), and YYI(x)-XX(x) is the gradient 
of a positive definite function. Let e be as in Remark 3 above.
Then the RECIPE produces a solution to the regional (e-DISFBK) problem on 
the set 
     STAB={ (x,z): x,z  in state space satisfying (4.12) =<  0}. 

Proof.  see [BHW].

We next give sufficient conditions for the compensator contructed via our
RECIPE to meet the stability condition of the H-infinity problem as well.

THEOREM  5.4.  Assume that XX(x) and YYI(x) are solutions of
XX(x) =< 0, YYI(x) =< 0 such that each of XX(x), YYI(x) and
YYI(x)-XX(x) is the gradient of a positive definite function. 
Let e be as in Remark 3 above, and a*,b,c* be constructed as in the 
RECIPE. Let STAB be as in Theorem 5.3 and choose rho>0 so that

      S_rho ={(x,z) in X x X: e(x,z)=< rho} is contained in STAB.

(1)  Then if (x(t),z(t)) is a trajectory of the closed loop system subject 
to zero input signal W(t)=0 for t>=0, then (x(t),z(t)) in S_rho whenever
(x(0),z(0)) in S_rho. 

(2)  Assume in addition: 

    (a)  The DGKF simplifying assumptions

          tp[D12(x)] C1(x) = 0,  B1(x) tp[D21(x)] = 0


    (b)  (C1,A) is detectable, i.e. 

                 d/dt x(t) = A(x(t)) C1(x(t)) = 0 for all t>=0

implies x(t)-> 0 as t -> infinity

    (c)  The system
                          
d/dt z = A(z)+B1(z) tp[B1(z)] XX(z)-b(z)C2(z)

is asymptotically stable.

    (d)  e is proper and positive definite.

Then whenever (x(t),z(t)) is a trajectory of the closed loop system
subject to zero input signal W(t)=0 and (x(0),z(0)) in S_rho, then
(x(t),z(t)) -> 0 as t -> infinity.

To prove results like Theorem(5.1) and to do experiments we introduce 
rules which correspond to the Ansatses (5.1) to (5.5).  
These come from differentiating e by hand. The special forms of 
e impose rule on the Gradients GEx, GEz in x and z.
(5.1) and (5.3) are given by:
-------------------*)
ruGEx1=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z];
ruGEz1=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z];
ruGE1=Flatten[{ruGEz0,SubstituteSymmetric[{ruGEz0,ruGEx1,ruGEz1},ruXXYYI]}];

SetNonCommutative[Grx,Gry];
ruGEx3=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z]+Grx[x,z];
ruGEz3=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z]+Grz[x,z];
ruGE3=Flatten[{ruGEz0,SubstituteSymmetric[{ruGEz0,ruGEx3,ruGEz3},ruXXYYI]}];
(*----------------
The next function automatically inserts your guess ruleGE at the  
storage function (such as ruGE1) into sHWo with c chosen to equal c*
and a[z] given by rua. Furthermore q[x,z] replaces tp[GEz[x,z]]**b[z] 
throughout.  We actually implement this with two functions to give greater
flexibility.  Also one version  applies the DGKF simplifying assmptions 
to everything. 
-----------------*)

EnergyGuess[ruleGE_]:= EnergyGuess2[ruleGE,rua];

EnergyGuess2[ruleGE_,rua_]:=
Block[{ Hnoc, Hnoac, Hqnoac, Hb1, Hb2},
    Hnoc=ExpandNonCommutativeMultiply[SubstituteSymmetric[sHWo,ruc]];
    Hnoac=ExpandNonCommutativeMultiply[SubstituteSymmetric[Hnoc,rua]];          
    Hqnoac = SubstituteSymmetric[Hnoac,tp[GEz[x_,z_]]**b[z_]:>q[x,z]];
    Hb1=SubstituteSymmetric[Hqnoac,ruleGE];
    Hb2=SubstituteSymmetric[Hb1,rue];
    Return[Hb2];
];

EnergyGuessDGKF[ruleGE_]:= EnergyGuess2DGKF[ruleGE,ruaDGKF];

EnergyGuess2DGKF[ruleGE_,rua_]:=
Block[{sHWo2, HDGKFnoac, HDGKFqnoac,sHWo22, HbDGKF1},
     sHWo2=SubstituteSymmetric[sHWo,ruDGKFNL];
     HDGKFnoc=ExpandNonCommutativeMultiply[  
                        SubstituteSymmetric[sHWo2,ruCRcDGKF]
                                          ];
     HDGKFnoac=ExpandNonCommutativeMultiply[
                         SubstituteSymmetric[HDGKFnoc,rua]
                                           ];
     HDGKFqnoac=SubstituteSymmetric[HDGKFnoac,tp[GEz[x_,z_]]**b[z_]:>q[x,z]];
     HbDGKF1=SubstituteSymmetric[HDGKFqnoac,ruleGE];
     HbDGKF=SubstituteSymmetric[HbDGKF1,ruDGKFNL];
     Return[HbDGKF];
];
(*-----------------
Remark 1. In the proof of Theorem 5.4 we need assume that the
detectability assumption (b) and the asymptotic stability assumption (c) hold
only regionally, i.e. only for the case where (x(0),z(0)) in S_rho. Also
in the proof, no particular form for b was required.

Remark 2. Analogues of Theorems 5.3 and 5.4 hold if one replaces the
compensator a*,b,c* in the RECIPE by the linear compensator which solves
the H-infinity-problem for the linearization of the plant (F,G1,G2) at the
origin. We expect but do not know how to prove that the region (STAB) for the
compensator (a*,b,c* ) in the RECIPE is usually much larger than the
corresponding region associated with the linear compensator which solves the
linearized problem.

*)
(*##################################################################*)
(********************************************************************)
(*

*)
(*                             PART II                              *)
(*   GREATER GENERALITY   GREATER GENERALITY    GREATER GENERALITY  *)
(*   GREATER GENERALITY   GREATER GENERALITY    GREATER GENERALITY  *)
(*   GREATER GENERALITY   GREATER GENERALITY    GREATER GENERALITY  *)

(*##################################################################*)
(********************************************************************)
Print["                          SECTION VI               "]
Print["                   W-INPUT AFFINE SYSTEMS          "]

(*
We often consider a special class of systems called WIA systems.
These are affine in W but not necessarily in U.  
We make the same assumptions as for IA systems in this more general case. 
This includes the usual assumption that G1 is independent of W and
G2 is independent of U, so that (1.7) specializes to 

          F(x,W,U) = AB(x,U) + B1(x)W 
        G1(x,W,U) = C1(x,U) 
        G2(x,W,U) = C2(x) + D21(x)W. 

In fact, many of the results  are identical in form, but the resulting
equations are not as explicit as for the IA case.
(In particular, we obtain a nonlinear equation for CritU which must
be solved rather than an explicit formula.)

Expressions for CritW and sHWo for WIA systems were given by (3.8) and 
(3.9) respectively.  We have the following analogues of IA theorems.

THEOREM 4.1  for WIA Systems
Assume min_c sHWo |         exists.
                  |x=z
                  |a=b=0 

Fix x,z, then

(4.4a) min  min  sHWo   = min  min  sHWo   = min  min  sHWo= 
       a,b   c            b,c    a            a   b,c 
                       _
                      |  -infinity,  if z is not x or 0.
   min  min  sHWo   = |    WIAX[x],  if z=x
   c    a,b           |_  WIAYI[x],  if z=0 

Here we define 

 WIAX(x) = |C1(x,c*(x))|^2 + tp[XX(x)] B1(x) tp[B1(x)] XX(x)
                 + tp[XX(x)] AB(x,c*(x)) +  tp[AB(x,c*(x))] XX(x).
and 

 WIAYI(x)=[tp[AB(x,0)] - tp[C2(x)] inv[e2(x)] D21(x) tp[B1(x)]] YYI(x)
       + tp[YYI(x)] [AB(x,0) - B1(x) tp[D21(x)] inv[e2(x)] C2(x)] 
       + |C1(x,0)|^2 - tp[C2(x)] inv[e2(x)] C2(x) + 
tp[YYI(x)][B1(x) tp[B1(x)]-B1(x) tp[D21(x)] inv[e2(x)] D21(x) tp[B1(x)]] YYI(x).

where XX(x) and YYI(x) were defined by (4.4d).

The minimizing c when x=z is defined implicitly by (3.10):   

2 tp[C1(z,c*(z))] D_U C1(z,c*(z)) + tp[GEx(z,z)] D_U AB(z,c*(z))=0 

The minimizing b when z=0 is the same as for IA systems and is given
by (4.5d). 

THEOREM 4.3. Separation Principle for WIA Systems

Assume that the energy function e(x,z) is normalized so 
that 

      (4.7a)  WIAX(x) = 0 for all x (where it is assumed that the 
              critical c* exists).

     (4.7b)  GEx[x,z]|     = 0 as usual.
                     |z=x

     (4.7c)  D_z{GEx[x,z] + GEz[x,z] }|     = 0.
                                      |z=x

     (4.7d)  D_z(GEz[x,z])|      has full rank. 
                          |z=x

     (4.7e)  There is an a,b,c solving (e-DISFBK). 

Then a,c are given by 

(4.8)  a*(z)=F(z,CritW(z,z,b(z)),CritU(z,z))+
                         b(z)(-G2(z,CritW(z,z,b(z))))
       c*(z)=CritU(z,z)

THEOREM 4.4  for WIA systems. Under the hypotheses of Theorem 4.3  
a necessary condition for the system a*,b,c* with a*,c* 
given by Theorem 4.3  to
solve e-DISFBK is k(x,z) =< 0 for all x,z where k is 

 k(x,z):= 
1/2 tp[AB(x,c*(z))]  GEx(x, z) + 1/2 tp[AB(z,c*(z))] GEz(x, z) + 
  |tp[C1(x,c*(z))]|^2  + 1/2 tp[GEx(x, z)] AB(x,c*(z)) + 
 1/2 tp[GEz(x, z)]  AB(z, c*(z)) + 
 (1/2 tp[GEx(x, z)]  B1(x)  tp[D21(x)] + tp[C2(x)])  inv[e_2(x)]  
 (-C2(x) + C2(z) -1/2 D21(x)  tp[B1(x)]  GEx(x, z) + 
     D21(z)  tp[B1(z)]  XX(z)) + 
 (tp[XX(z)]  B1(z)  tp[D21(z)] + tp[C2(z)])  inv[e_2(x)]  
   (C2(x) - C2(z) +1/2 D21(x)  tp[B1(x)]  GEx(x, z) - 
 D21(z)  tp[B1(z)]  XX(z)) + 
 1/4 tp[GEx(x, z)]  B1(x)  tp[B1(x)]  GEx(x, z) + 
 1/2 tp[GEz(x, z)]  B1(z)  tp[B1(z)]  XX(z) + 
  1/2 tp[XX(z)]  B1(z)  tp[B1(z)]  GEz(x, z).

which is independent of b.
*)
(*########################################################*)
(**********************************************************)
(*

*)

Print["                 SECTION VII                   "]; 
Print["          SEPARATION PRINCIPLE             "]; 

(*
This section runs at at a higher level of generality 
than the previous sections; specifically, in this section we do 
not assume that our systems are affine in the inputs.
Consider the general feedback system (1.1) and (1.2)
defined in the introduction
with G1 independent of W and G2 independent of U.
We want to find a feedback system  d/dt z = f(z,Y), U=g(z)
which makes the closed loop system dissipative.  
Fix a candidate smooth storage function e(x,z) and define
 
sHW_{f,U}(W,x,z)= GEx(x,z)F(x,W,U) +tp[GEz(x,z)] f(z,G2(x,W))
                          + |G1(x,U)|^2 - |W|^2.

THEOREM 7.1 Separation Principle.  Assume W=CritW_{f,g}(x,z) solves

                0 = D_W sHW_f,g(W,x,z)

We will abbreviate CritW_{f,g}(x,z) to CritW(x,z).
Define

          sHWo_{f,g}(x,z) = sHW_{f,g}(CritW(x,z),x,z).

Assume there exists a function f* and an energy function
e(x,z) such that

      (1)  sHWo_{f*,g*(x)}(x,x)= min_U sHWo_{f*,U}(x,x)

has a differentiable solution g*.

      (2)  D_z sHWo_{f*,U}(x,z)|             =0.
                                |z=x,U=g*(x)

      (3) (f*,g* ) satisfies sHWo_{f*,g*}(x,z) =< 0 for all x,z.

      (4)  GEx[x,z]|     = 0 as usual.
                   |z=x

      (5)  D_z{GEx[x,z] + GEz[x,z] }|     = 0.
                                    |z=x

      (6)  D_z(GEz[x,z])|      has full rank. 
                        |z=x

Then f* has the form

(7.1)   f*(z,Y)=F(z,CritW(z,z),g*(z))+b(z,Y-G2(z,CritW(z,z)))

for some function b(z,Y) satisfying b(z,0)=0.

COROLLARY 7.2.  A condition which guarantees (2) in Theorem 7.1  when 
the other conditions are met is sHWo_{f*,g*}(z,z)=0  for all z. 
For IA systems this is equivalent to IAX(x)=0 for all x.

Remark 1. Theorem 7.1 can be interpreted as a nonlinear extension of the
so-called separation principle for the central solution of the linear
H-infinity-control problem (see [DGKF] and [PAJ]). In this context, the
separation principle amounts to the interpretation of the formula for the
compensator (f*,g* ) as follows. If we assume that g* is independent of Y,
the state feedback map g* is simply
the solution of the state-feedback problem under the assumption that the
compensator state z is the same as the plant state x. The first term in the
compensator dynamics f* is the same as the plant dynamics would be under the
assumption that the compensator state z is the same as the plant state x
and that the worst choice CritW(z,z) of W is fed in as input. The
 b function term in f* is used to make adjustments for the fact that 
z ne w. In the linear case, the dynamics f* is the solution of the
observer-based state estimation problem with the appropriate choice of b; in
the nonlinear case unlike the state feedback problem this latter problem has no
simple solution. In this way we see the output feedback problem as reducing to
the solution of two separate less complicated problems, the state feedback
problem and the state estimation problem. A problem having some elements in
common with the H-infinity-problem is the so-called output regulation problem,
where one seeks a feedback which guarantees that an error signal asymptotically
approaches zero in the presence of a disturbance but where there is no
quantitative measure of performance. A principle for this problem analogous to
the separation principle for the LQG and H-infinity-problem, called the 
internal model principle, has been extended to a nonlinear setting in [IB].

Remark 2.  There are other interpretations of the separation principle
which lead to different formulas even in the linear case.
One was mentioned earlier and it yields the maximum entropy
solution. It takes IAX(x)=0 which makes the D_z=0 condition (2)
correspond to x=z being a maximum of sHW_{a,b,c*}. However,
it is intriguing to pursue the strategy of taking z=x to be a
minimum. That is, instead of picking e to make IAX
as big as possible (least dissipative) subject to the constraint
IAX(x) =< 0, pick IAX to be very small. The objective is to
make Hopt very negative on the diagonal z=x indeed to make it a
minimum there. Thus D_z =0 there so condition (2) holds; this intuition
forces the formula (7.1) for f* to hold.

Remark 3. An interpretation of both the separation principle and the
internal model principle is that the compensator state z tries to duplicate
the plant state x. There is a special case where the compensator can do this
exactly. Namely, consider the feedback system (1.1), (1.2) where G1=G1(x,U)
is independent of W and G2=G2(W) is independent of both x and U. This
amounts to the model matching problem where there is no feedback; this is an
ancillary, derived problem rather than the physical problem but is nevertheless
interesting mathematically. Assume in addition that G2 is a diffeomorphism;
for the IA case our assumptions amount to C2(x)=0 and D21(x) is an
invertible constant. Then G2 has a smooth inverse inv[G2] and we can
solve explicitly for W from Y: W=inv[G2(Y)]. Assume also that
CritU= CritU(W,x,z)=argmin_U sHWU(W,U,x,z)
is independent of W (CritU=CritU(x,z)); this indeed is the
case for the IA case. Then a viable choice of compensator is

   f*(z,Y) = F(z,inv[G2(Y)],CritU(z,z))
     g*(z) = CritU(z,z).

Indeed, one can show by manipulation of the formulas that the central
controller in the linear case collapses to this formula under the above special
assumptions. In this case a very strong internal model principle holds in that
the compensator state z(t) reproduces the plant state x(t) exactly
regardless of the input signal W(t) once they agree initially (x(0)=z(0)).
The formula can be extended to the case where G2=G2(x,W) as long as we
assume that G2(x,W) is a diffeomorphism in the variable W for each choice
of state vector x (D21(x) should be invertible for each x for the IA
case); in the linear case this amounts to the 2-block case, a case which
includes many examples of physical interest. The only difference is that the
resulting compensator

           f*(z,Y) = F(z,G2^I(z,Y),CritU(G2^I(z,Y),z,z))
           g*(z,Y) = G2^I(z,Y)

is not strictly proper (g* depends on Y as well as on z). This is the
recipe analyzed in some detail in [BH4].

As in section 4 we get an alternate version of the separation principle
using different hypotheses which might some day prove useful.
This version uses U=CritU_{f,g}(x,z) defined as a solution 
to 

(7.3)         0 = D_U sHWU_{f}(CritW(x,z),U,x,z) 

Here CritW is defined as before.  The main observation is that one can replace 
g*(z) =CritU_{f,g}(z,z) by U=CritU_{f,g}(x,z) itself and the separation 
principle still holds. Namely,

THEOREM 7.5.  Separation Principle.  Let Hopt denote

        Hopt_f = sHWU_{f}(CritW(x,z),CritU(x,z),x,z)

Assume there exists a function f* and an energy function
e(x,z) such that

      (1)  CritU is a differentiable function solving (7.3)

      (2) D_z Hopt_f |    = 0 
                     |z=x

      (3) Hopt_{f*}(x,z) =< 0 for all x,z.

      (4)  GEz(x,z)|     = 0  as usual
                   |z=x

      (5)  D_z{GEx[x,z] + GEz[x,z] }|     = 0.
                                    |z=x

      (6)  D_z(GEz[x,z])|      has full rank. 
                        |z=x

Then f* has the form

f*(z,Y)=F(z,CritW(z,z),CritU(z,z))+b(z,Y-G2(z,CritW(z,z)))

for some function b(z,Y) satisfying b(z,0)=0.

*)
(*

*)
(*************************************************************)
(*  APPENDIX    APPENDIX    APPENDIX    APPENDIX    APPENDIX  *)  
(*  APPENDIX    APPENDIX    APPENDIX    APPENDIX    APPENDIX  *)  
(*  APPENDIX    APPENDIX    APPENDIX    APPENDIX    APPENDIX  *)  

Print["               APPENDIX               "]
Print["            COMPUTATIONS              "]

(*
 The following demo verifies IAX and IAYI are same as DGX DGYI 
the Doyle Glover X and inv[Y] Riccatti equations in
the special case of a linear system.  


In[25]:= NCE[IAX[x]//.rulinearall]

Out[25]= tp[x] ** XX ** A ** x + tp[x] ** tp[A] ** tp[x] ** XX + 
   tp[x] ** tp[C1] ** C1 ** x + tp[x] ** XX ** B1 ** tp[B1] ** tp[x] ** XX - 
   tp[x] ** XX ** B2 ** inv[e1] ** tp[B2] ** tp[x] ** XX - 
   tp[x] ** XX ** B2 ** inv[e1] ** tp[D12] ** C1 ** x - 
   tp[x] ** tp[C1] ** D12 ** inv[e1] ** tp[B2] ** tp[x] ** XX - 
   tp[x] ** tp[C1] ** D12 ** inv[e1] ** tp[D12] ** C1 ** x

In[26]:= Sub[%,x->1]

Out[26]= XX ** A + tp[A] ** XX + tp[C1] ** C1 + XX ** B1 ** tp[B1] ** XX - 
   XX ** B2 ** inv[e1] ** tp[B2] ** XX - 
   XX ** B2 ** inv[e1] ** tp[D12] ** C1 - 
   tp[C1] ** D12 ** inv[e1] ** tp[B2] ** XX - 
   tp[C1] ** D12 ** inv[e1] ** tp[D12] ** C1

In[27]:= NCE[%-DGX]

Out[27]= 0

In[28]:= NCE[IAYI[x]//.rulinearall]

Out[28]= tp[x] ** inv[YY] ** A ** x + tp[x] ** tp[A] ** tp[x] ** inv[YY] + 
   tp[x] ** tp[C1] ** C1 ** x - tp[x] ** tp[C2] ** inv[e2] ** C2 ** x + 
   tp[x] ** inv[YY] ** B1 ** tp[B1] ** tp[x] ** inv[YY] - 
   tp[x] ** inv[YY] ** B1 ** tp[D21] ** inv[e2] ** C2 ** x - 
   tp[x] ** tp[C2] ** inv[e2] ** D21 ** tp[B1] ** tp[x] ** inv[YY] - 
    tp[x] ** inv[YY] ** B1 ** tp[D21] ** inv[e2] ** D21 ** tp[B1] ** tp[x] ** 
    inv[YY]

In[29]:= Sub[%,x->1]

Out[29]= inv[YY] ** A + tp[A] ** inv[YY] + tp[C1] ** C1 - 
   tp[C2] ** inv[e2] ** C2 + inv[YY] ** B1 ** tp[B1] ** inv[YY] - 
   inv[YY] ** B1 ** tp[D21] ** inv[e2] ** C2 - 
   tp[C2] ** inv[e2] ** D21 ** tp[B1] ** inv[YY] - 
   inv[YY] ** B1 ** tp[D21] ** inv[e2] ** D21 ** tp[B1] ** inv[YY]

In[30]:= NCE[YY**%**YY-DGY]

Out[32]= 0

In[34]:= Quit
*)

(*****************************************************************)
(***************       DERIVATIONS                 ***************)
(********************** IAX DERIVATION ************************
          ( includes derivation of Hopt and ruCritU)

In[2]:= <<SYSTEMSNL

In[14]:= Sub[sHWo,rue]

Out[14]= tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[x, z]/2 + tp[C1[x]] ** D12[x] ** c[z] + 
   tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + tp[GEx[x, z]] ** B2[x] ** c[z]/2 + 
   tp[GEz[x, z]] ** b[z] ** C2[x]/2 + tp[c[z]] ** e1[x] ** c[z] + 
   tp[c[z]] ** tp[B2[x]] ** GEx[x, z]/2 + tp[c[z]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4

In[15]:= ruCritU = Crit[%,c[z]]

Out[15]= {c[z] -> 
    -inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
     inv[e1[x]] ** tp[D12[x]] ** C1[x]}

In[16]:= NCE[Sub[%14,%]]

Out[17]= tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
   tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]/2 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4

In[19]:= Hopt = Sub[%17,rue]

Out[19]= tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
   tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]/2 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4

In[21]:= Sub[Hopt,x->z]

Out[21]= tp[A[z]] ** GEx[z, z]/2 + tp[C1[z]] ** C1[z] + 
   tp[GEx[z, z]] ** A[z]/2 + tp[GEz[z, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[z, z]/2 + tp[C2[z]] ** tp[b[z]] ** GEz[z, z]/2 + 
   tp[GEz[z, z]] ** b[z] ** C2[z]/2 + 
   tp[GEx[z, z]] ** B1[z] ** tp[B1[z]] ** GEx[z, z]/4 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** GEx[z, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] + 
   tp[GEx[z, z]] ** B1[z] ** tp[D21[z]] ** tp[b[z]] ** GEz[z, z]/4 - 
   tp[GEx[z, z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** GEx[z, z]/4 - 
   tp[GEx[z, z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 + 
   tp[GEz[z, z]] ** b[z] ** D21[z] ** tp[B1[z]] ** GEx[z, z]/4 + 
   tp[GEz[z, z]] ** b[z] ** e2[z] ** tp[b[z]] ** GEz[z, z]/4

In[22]:= Sub[%,ruXXYYI]

Out[22]= tp[A[z]] ** XX[z] + tp[C1[z]] ** C1[z] + tp[XX[z]] ** A[z] + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** XX[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]

In[23]:= IAX = NCCSym[%, XX[z]]

Out[23]= (-tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] + tp[A[z]]) ** 
    XX[z] + tp[C1[z]] ** C1[z] + 
   tp[XX[z]] ** (A[z] - B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]) + 
   tp[XX[z]] ** (B1[z] ** tp[B1[z]] - B2[z] ** inv[e1[z]] ** tp[B2[z]]) ** 
    XX[z] - tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]

In[24]:= Quit

*)

(************************* IAYI DERIVATION ***********************   

In[2]:= <<SYSTEMSNL

In[3]:= sHWo//.z->0

Out[3]= tp[A[x]] ** GEx[x, 0]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, 0]] ** A[x]/2 + tp[GEz[x, 0]] ** a[0]/2 + 
   tp[a[0]] ** GEz[x, 0]/2 + tp[C1[x]] ** D12[x] ** c[0] + 
   tp[C2[x]] ** tp[b[0]] ** GEz[x, 0]/2 + tp[GEx[x, 0]] ** B2[x] ** c[0]/2 + 
   tp[GEz[x, 0]] ** b[0] ** C2[x]/2 + tp[c[0]] ** tp[B2[x]] ** GEx[x, 0]/2 + 
   tp[c[0]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, 0]] ** B1[x] ** tp[B1[x]] ** GEx[x, 0]/4 + 
   tp[c[0]] ** tp[D12[x]] ** D12[x] ** c[0] + 
   tp[GEx[x, 0]] ** B1[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/4 + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[B1[x]] ** GEx[x, 0]/4 + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/4

In[4]:= Sub[%,ruhomog]

Out[4]= tp[A[x]] ** GEx[x, 0]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, 0]] ** A[x]/2 + tp[C2[x]] ** tp[b[0]] ** GEz[x, 0]/2 + 
   tp[GEz[x, 0]] ** b[0] ** C2[x]/2 + 
   tp[GEx[x, 0]] ** B1[x] ** tp[B1[x]] ** GEx[x, 0]/4 + 
   tp[GEx[x, 0]] ** B1[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/4 + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[B1[x]] ** GEx[x, 0]/4 + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/4

In[5]:= SubSym[%,ruXXYYI]

Out[5]= tp[A[x]] ** YYI[x] + tp[C1[x]] ** C1[x] + tp[YYI[x]] ** A[x] + 
   tp[C2[x]] ** tp[b[0]] ** GEz[x, 0]/2 + tp[GEz[x, 0]] ** b[0] ** C2[x]/2 + 
   tp[YYI[x]] ** B1[x] ** tp[B1[x]] ** YYI[x] + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[B1[x]] ** YYI[x]/2 + 
   tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/2 + 
   tp[GEz[x, 0]] ** b[0] ** D21[x] ** tp[D21[x]] ** tp[b[0]] ** GEz[x, 0]/4

In[6]:= SubSym[%,tp[GEz[x,0]]**b[0]->q[x,0]]

Out[6]= q[x, 0] ** C2[x]/2 + tp[A[x]] ** YYI[x] + tp[C1[x]] ** C1[x] + 
   tp[C2[x]] ** tp[q[x, 0]]/2 + tp[YYI[x]] ** A[x] + 
   q[x, 0] ** D21[x] ** tp[B1[x]] ** YYI[x]/2 + 
   q[x, 0] ** D21[x] ** tp[D21[x]] ** tp[q[x, 0]]/4 + 
   tp[YYI[x]] ** B1[x] ** tp[B1[x]] ** YYI[x] + 
   tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** tp[q[x, 0]]/2

In[8]:= Sub[%6,rue]

Out[8]= q[x, 0] ** C2[x]/2 + tp[A[x]] ** YYI[x] + tp[C1[x]] ** C1[x] + 
   tp[C2[x]] ** tp[q[x, 0]]/2 + tp[YYI[x]] ** A[x] + 
   q[x, 0] ** e2[x] ** tp[q[x, 0]]/4 + 
   q[x, 0] ** D21[x] ** tp[B1[x]] ** YYI[x]/2 + 
   tp[YYI[x]] ** B1[x] ** tp[B1[x]] ** YYI[x] + 
   tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** tp[q[x, 0]]/2

In[9]:= Crit[%,tp[q[x,0]]]

Out[9]= {tp[q[x, 0]] -> 
    -2*inv[e2[x]] ** C2[x] - 2*inv[e2[x]] ** D21[x] ** tp[B1[x]] ** YYI[x]}

In[11]:= NCE[SubSym[%8,%9]]

Out[12]= tp[A[x]] ** YYI[x] + tp[C1[x]] ** C1[x] + tp[YYI[x]] ** A[x] - 
   tp[C2[x]] ** inv[e2[x]] ** C2[x] + 
   tp[YYI[x]] ** B1[x] ** tp[B1[x]] ** YYI[x] - 
   tp[C2[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] ** YYI[x] - 
   tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x] - 
   tp[YYI[x]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] ** 
    YYI[x]

In[13]:= IAYI = NCCSym[%,YYI[x]]

Out[13]= (-tp[C2[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] + tp[A[x]]) ** 
    YYI[x] + tp[C1[x]] ** C1[x] + 
   tp[YYI[x]] ** (A[x] - B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x]) - 
   tp[C2[x]] ** inv[e2[x]] ** C2[x] + 
   tp[YYI[x]] ** (B1[x] ** tp[B1[x]] - 
      B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]]) ** YYI[x]

In[14]:= Quit

Explicit form for Hopt

Hopt[x_,z_,a_,b_]:= 
   tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
   tp[GEz[x, z]] ** b[z] ** C2[x]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[B2[x]] ** GEx[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]/2 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** e2[x] ** tp[b[z]] ** GEz[x, z]/4

*)

(*
Derivation of critical q, k, and bterm

In[2]:= <<SYSTEMSNL

In[16]:= SubSym[sHWo,ruc]

Out[16]= tp[A[x]] ** GEx[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** a[z]/2 + 
   tp[a[z]] ** GEz[x, z]/2 + tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 + 
   tp[GEz[x, z]] ** b[z] ** C2[x]/2 - 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** tp[B2[x]] ** 
     GEx[x, z]/2 - (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** 
    inv[e1[z]] ** tp[D12[x]] ** C1[x] - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** 
    (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]) + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** 
     (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z])/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** tp[D12[x]] ** 
    D12[x] ** inv[e1[z]] ** (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]) + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4

In[17]:= NCE[SubSym[%,rua]]

Out[17]= tp[A[x]] ** GEx[x, z]/2 + tp[A[z]] ** GEz[x, z]/2 + 
   tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 + 
   tp[C2[x]] ** tp[b[z]] ** GEz[x, z]/2 - 
   tp[C2[z]] ** tp[b[z]] ** GEz[x, z]/2 + tp[GEz[x, z]] ** b[z] ** C2[x]/2 - 
   tp[GEz[x, z]] ** b[z] ** C2[z]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   tp[GEz[x, z]] ** b[z] ** D21[z] ** tp[B1[z]] ** XX[z]/2 - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** tp[b[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] + 
   tp[GEz[x, z]] ** b[z] ** D21[x] ** tp[D21[x]] ** tp[b[z]] ** GEz[x, z]/4 + 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** D12[x] ** inv[e1[z]] ** 
    tp[B2[z]] ** XX[z] + tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** 
    D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] + 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** D12[x] ** inv[e1[z]] ** 
    tp[B2[z]] ** XX[z] + tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** 
    D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]

In[18]:= SubSym[%,tp[GEz[x,z]]**b[z]->q[x,z]]

Out[18]= q[x, z] ** C2[x]/2 - q[x, z] ** C2[z]/2 + tp[A[x]] ** GEx[x, z]/2 + 
   tp[A[z]] ** GEz[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[C2[x]] ** tp[q[x, z]]/2 - tp[C2[z]] ** tp[q[x, z]]/2 + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 + 
   q[x, z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   q[x, z] ** D21[x] ** tp[D21[x]] ** tp[q[x, z]]/4 - 
   q[x, z] ** D21[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[q[x, z]]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** tp[q[x, z]]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] + 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** D12[x] ** inv[e1[z]] ** 
    tp[B2[z]] ** XX[z] + tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** 
    D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] + 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** D12[x] ** inv[e1[z]] ** 
    tp[B2[z]] ** XX[z] + tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** 
    D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]

In[19]:= SubSym[%,rue]

Out[19]= q[x, z] ** C2[x]/2 - q[x, z] ** C2[z]/2 + tp[A[x]] ** GEx[x, z]/2 + 
   tp[A[z]] ** GEz[x, z]/2 + tp[C1[x]] ** C1[x] + 
   tp[C2[x]] ** tp[q[x, z]]/2 - tp[C2[z]] ** tp[q[x, z]]/2 + 
   tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 + 
   q[x, z] ** e2[x] ** tp[q[x, z]]/4 + 
   q[x, z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   q[x, z] ** D21[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[q[x, z]]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** tp[q[x, z]]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] + 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** tp[B2[z]] ** 
    XX[z] + tp[C1[z]] ** D12[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** 
    tp[D12[z]] ** C1[z] + tp[XX[z]] ** B2[z] ** inv[e1[z]] ** e1[x] ** 
    inv[e1[z]] ** tp[B2[z]] ** XX[z] + 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** tp[D12[z]] ** 
    C1[z]

In[20]:= Crit[%,tp[q[x,z]]]

Out[20]= {tp[q[x, z]] -> 
    -2*inv[e2[x]] ** C2[x] + 2*inv[e2[x]] ** C2[z] - 
     inv[e2[x]] ** D21[x] ** tp[B1[x]] ** GEx[x, z] + 
     2*inv[e2[x]] ** D21[z] ** tp[B1[z]] ** XX[z]}

In[21]:= K=NCE[SubSym[%19,%20]]


Out[22]= tp[A[x]] ** GEx[x, z]/2 + tp[A[z]] ** GEz[x, z]/2 + 
   tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 - 
   tp[C2[x]] ** inv[e2[x]] ** C2[x] + tp[C2[x]] ** inv[e2[x]] ** C2[z] + 
   tp[C2[z]] ** inv[e2[x]] ** C2[x] - tp[C2[z]] ** inv[e2[x]] ** C2[z] + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z] - 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z] - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] - 
   tp[C2[x]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/2 + 
   tp[C2[x]] ** inv[e2[x]] ** D21[z] ** tp[B1[z]] ** XX[z] + 
   tp[C2[z]] ** inv[e2[x]] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/2 - 
   tp[C2[z]] ** inv[e2[x]] ** D21[z] ** tp[B1[z]] ** XX[z] - 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[x]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** C2[z]/2 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEx[x, z]] ** B2[x] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** XX[z]/2 - 
   tp[GEz[x, z]] ** B2[z] ** inv[e1[z]] ** tp[D12[z]] ** C1[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** inv[e2[x]] ** C2[x] - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** inv[e2[x]] ** C2[z] - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[x]] ** GEx[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[B2[z]] ** GEz[x, z]/2 - 
   tp[XX[z]] ** B2[z] ** inv[e1[z]] ** tp[D12[x]] ** C1[x] + 
   tp[C1[z]] ** D12[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** tp[B2[z]] ** 
    XX[z] + tp[C1[z]] ** D12[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** 
    tp[D12[z]] ** C1[z] - tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** 
     inv[e2[x]] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** D21[z] ** 
     tp[B1[z]] ** XX[z]/2 + tp[XX[z]] ** B1[z] ** tp[D21[z]] ** inv[e2[x]] ** 
     D21[x] ** tp[B1[x]] ** GEx[x, z]/2 - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** inv[e2[x]] ** D21[z] ** tp[B1[z]] ** 
    XX[z] + tp[XX[z]] ** B2[z] ** inv[e1[z]] ** e1[x] ** inv[e1[z]] ** 
    tp[B2[z]] ** XX[z] + tp[XX[z]] ** B2[z] ** inv[e1[z]] ** e1[x] ** 
    inv[e1[z]] ** tp[D12[z]] ** C1[z]

In[29]:= K = NCC[NCC[K,inv[e2[x]]],inv[e1[z]]]

Out[29]= tp[A[x]] ** GEx[x, z]/2 + tp[A[z]] ** GEz[x, z]/2 + 
   tp[C1[x]] ** C1[x] + tp[GEx[x, z]] ** A[x]/2 + tp[GEz[x, z]] ** A[z]/2 + 
   (tp[GEx[x, z]] ** B2[x] + tp[GEz[x, z]] ** B2[z]) ** inv[e1[z]] ** 
    (-tp[B2[z]] ** XX[z]/2 - tp[D12[z]] ** C1[z]/2) + 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** 
    (-tp[B2[x]] ** GEx[x, z]/2 - tp[B2[z]] ** GEz[x, z]/2 - 
      tp[D12[x]] ** C1[x]) + tp[C2[x]] ** inv[e2[x]] ** 
    (-C2[x] + C2[z] - D21[x] ** tp[B1[x]] ** GEx[x, z]/2 + 
      D21[z] ** tp[B1[z]] ** XX[z]) + 
   (tp[XX[z]] ** B1[z] ** tp[D21[z]] + tp[C2[z]]) ** inv[e2[x]] ** 
    (C2[x] - C2[z] + D21[x] ** tp[B1[x]] ** GEx[x, z]/2 - 
      D21[z] ** tp[B1[z]] ** XX[z]) + 
   tp[C1[x]] ** D12[x] ** inv[e1[z]] ** 
    (-tp[B2[z]] ** XX[z] - tp[D12[z]] ** C1[z]) + 
   tp[GEx[x, z]] ** B1[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
   tp[GEz[x, z]] ** B1[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[XX[z]] ** B1[z] ** tp[B1[z]] ** GEz[x, z]/2 + 
   (tp[C1[z]] ** D12[z] + tp[XX[z]] ** B2[z]) ** inv[e1[z]] ** e1[x] ** 
    inv[e1[z]] ** (tp[B2[z]] ** XX[z] + tp[D12[z]] ** C1[z]) + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** inv[e2[x]] ** 
    (-C2[x]/2 + C2[z]/2 - D21[x] ** tp[B1[x]] ** GEx[x, z]/4 + 
      D21[z] ** tp[B1[z]] ** XX[z]/2)

In[31]:= qpart = NCE[%19-(%19//.q[x,z]->0)]

Out[31]= q[x, z] ** C2[x]/2 - q[x, z] ** C2[z]/2 + 
   tp[C2[x]] ** tp[q[x, z]]/2 - tp[C2[z]] ** tp[q[x, z]]/2 + 
   q[x, z] ** e2[x] ** tp[q[x, z]]/4 + 
   q[x, z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   q[x, z] ** D21[z] ** tp[B1[z]] ** XX[z]/2 + 
   tp[GEx[x, z]] ** B1[x] ** tp[D21[x]] ** tp[q[x, z]]/4 - 
   tp[XX[z]] ** B1[z] ** tp[D21[z]] ** tp[q[x, z]]/2

In[32]:= %//.tp[q[x,z]]->0

Out[32]= q[x, z] ** C2[x]/2 - q[x, z] ** C2[z]/2 + 
   q[x, z] ** D21[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   q[x, z] ** D21[z] ** tp[B1[z]] ** XX[z]/2

In[33]:= L = %//.q[x,z]->1

Out[33]= C2[x]/2 - C2[z]/2 + D21[x] ** tp[B1[x]] ** GEx[x, z]/4 - 
   D21[z] ** tp[B1[z]] ** XX[z]/2

In[34]:= Q = e2[x]/4

Out[34]= e2[x]/4

In[35]:= bterm = q[x,z]+tp[L]**inv[Q]

Out[35]= 4*(tp[GEx[x, z]] ** B1[x] ** tp[D21[x]]/4 - 
       tp[XX[z]] ** B1[z] ** tp[D21[z]]/2 + tp[C2[x]]/2 - tp[C2[z]]/2) ** 
     inv[e2[x]] + q[x, z]

In[36]:= Sub[NCE[%19-bterm**Q**tp[bterm]-K],rue]

Out[36]= 0

In[39]:= Quit


*)

(************************************************************************)
(*

*)

Print["                            REFERENCES                 "]

(*

[AV]  B. D. O. Anderson and S. Vongpanitlerd, Network Analysis and Synthesis,
Prentice Hall, Englewood Cliffs, 1973.

[BHW] J. A. Ball, J. W. Helton, and M. L. Walker, A Variational Approach to 
Nonlinear H-infinity Control, preprint.

[BH4]  J. A. Ball and J. W. Helton, $H^\infty$ control for stable
nonlinear plants, to appear.

[DGKF]  J. C. Doyle, K. Glover, P. P. Khargonekar and B. A. Francis,
State--space solutions to standard $H_2$ and $H_\infty$ control problems, IEEE
Trans. Auto. Control 34 (1989), 831--847.

[HM] D. J. Hill and P. J. Moylan, "Dissipative Dynamical Systems:  
Basic Input-Output and 
State Properties", J. Franklin Inst. v.309, No.5, May 1980, pp.327-357

[IB]  A. Isidori and C. I. Byrnes, "Output Regulation of Nonlinear Systems", 
IEEE Trans.  Aut. Contr., V.35, No.2, Feb.1990, pp. 131-140

[PAJ]  I. R. Petersen, B. D. O. Anderson and E. A. Jonckheere, "A First 
Principles Solution to the Non-Singular $H^{\infty}$ Control Problem", 
submitted to Int. J. Robust and Nonlinear Control, 1990

[V2]  A. J. Van der Schaft, "$L_2$-gain analysis of nonlinear systems and nonlinear
$H_{\infty}$ control", submitted to IEEE Trans. Auto. Control. 

[W] J. C. Willems, Dissipative Dynamical Systems, Part I: general theory, 
Arch. Rat. Mech. Anal. 45 (1972), 321-351.
*)
(************************************************************************)
(*

*)
(*   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   *)
(*   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   *)
(*   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   GLOSSARY   *)

Print["          GLOSSARY FOR SYSTEM ENERGY CALCULATIONS         "]

(*
This glossary is split into 2 subsections.  Section G.1 contains 
expressions available for manipulation and functions
available for evaluation.  The distinction between expressions and 
functions is defined by Mathematica.  Section G.2  contains 
rules for substituting in expressions.

Executable definitions of expressions/rules are defined here only if not
previously defined.  Otherwise a short description of the rule or a
commented version of the executable is provided.  
*)

Print["              FORMULAS AVAILABLE FOR MANIPULATION        "]

(*

ricd 		= Riccati from bounded real lemma (for system (2.1))

These formulas contain mixed state and dual variables (IA systems):
	HWUY 	= Hamiltonian for the system (1.1) and (1.2)
	HWU	= HWUY/.Y->G2[x,W,U];
	HWY	= HWUY/.U->g[z,Y];
	HW	= HWY/.Y->G2[x,W,U];

These formulas contain state variables only (IA systems):
	sHWUY	= HWUY/.ruxz;
	sHWU	= HWU/.ruxz;
	sHWY	= HWY/.ruxz;
	sHW	= HW/.ruxz;

These formulas contain dual variables only (IA systems):
	dHWUY	= HWUY//.rudual;
	dHWU	= HWU//.rudual;
	dHWY	= HWY//.rudual;
	dHW	= HW//.rudual;

CritW[x_,z_,b_] = value of W which makes Grad[sHW,W]=0(both IA and WIA systems).

sHWo 		= max sHW (IA systems)
        	   W

sHWoWIA 	= max sHW (WIA systems)
           	   W

CritU[x_,z_]	= value of U which makes Grad[sHWU,U]=0 (IA systems).


IAX[x_]		= XX[x] ** (A[x] - B2[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x])+ 
	   (-tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[B2[x]] + tp[A[x]]) ** 
	   tp[XX[x]] + tp[C1[x]] ** C1[x] + 
   	XX[x] ** (B1[x] ** tp[B1[x]] - B2[x] ** inv[e1[x]] ** tp[B2[x]]) ** 
	    tp[XX[x]] - tp[C1[x]] ** D12[x] ** inv[e1[x]] ** tp[D12[x]] ** C1[x]

IAYI[x_]	= YYI[x] ** (A[x] - B1[x] ** tp[D21[x]] ** inv[e2[x]]**C2[x]) + 
	(-tp[C2[x]]**inv[e2[x]]**D21[x]**tp[B1[x]] + tp[A[x]])**tp[YYI[x]] + 
   	  tp[C1[x]] ** C1[x] + YYI[x] ** 
 	     (B1[x]** tp[B1[x]] - B1[x]**tp[D21[x]] ** inv[e2[x]] ** D21[x] ** 
 	        tp[B1[x]]) ** tp[YYI[x]] - tp[C2[x]] ** inv[e2[x]] ** C2[x]

QQ 		= 2 x 2 symmetric block matrix - can be used as matrix defining
                  quadratic energy function for linear 2-port closed loop system 
	QQ	= {{P11,P12},{P21,P22}}
	tp[P11]	= P11
	tp[P22]	= P22
	tp[P21]	= P12
	tp[P12]	= P21

seLin    	= tp[x] ** P11 ** x + tp[x] ** P12 ** z + 
                   tp[z] ** P21 ** x + tp[z] ** P22 ** z
                  ( quadratic form energy function for linear 2-port closed 
                    loop system)

k[x_,z_]  	= minimum in b of sHWo evaluated at a* and c* (see Theorem 4.4)

bterm         	= defined by equation (4.13), Theorem 4.4

Hopt[x,z,a,b] 	= min max sHWU, where you specify functions a[z],b[z]
                   U   W

Linear DGKF simplifying assumption versions of IA system
expressions are made by the function:
----------------*)

LinearDGKF[expr_]:=
Block[{temp1,temp2},
     expr1=expr;      
     temp1 =SubstituteSymmetric[ExpandNonCommutativeMultiply[expr1],ruDGKFNL];
     temp2 =SubstituteSymmetric[
         ExpandNonCommutativeMultiply[temp1],rulinearall
                               ];
     temp3 =SubstituteSymmetric[ExpandNonCommutativeMultiply[temp2],ruDGKFlin];
     Return[temp3]
];

LinDGKF::=LinearDGKF;

(*---------------
Ansatz Experimentation:

    EnergyGuess[ruleGE_] = generate sHWo with the Ansatz on the energy function
			   given by ruleGE and a, b, and c are substituted out 
			   according to the RECIPE.
    EnergyGuess2[ruleGE,rulea] = same but a is substituted out by the 
                                 user provided rulea.

    EnergyGuessDGKF[ruleGE_] = same with DGKF simplifying assumptions
    EnergyGuess2DGKF[ruleGE,ruaDGKF] = same with DGKF simplifying assumptions

*)

Print["                   RULES AVAILABLE FOR SUBSTITUTION                  "];

(*

CHANGE OF VARIABLES:
Convert energy Hamiltonians from dual or mixed state/dual to state 
variables only:
	ruxz={p->GEx[x,z], PP->GEz[x,z]};

Convert energy Hamiltonian from dual or mixed state/dual to dual variables only:
	rudual={rudualx,rudualz};
                              where rudualx = x->IGE1[p,PP];
                                    rudualy = z->IGE2[p,PP]; 

Rules applying Assumptions:
	ruGEz0=GEz[x_,x_]:>0
	ruhomog = {A[0]->0, C1[0]->0, C2[0]->0, a[0]->0, c[0]->0};

CHANGE OF NOTATION:
	rue = {tp[D12[x_]] ** D12[x_]:> e1[x], D21[x_] ** tp[D21[x_]] :> e2[x]} 
	rubtoq=tp[GEz[x_,z_]]**b[z_]:>q[x,z]

	ruXXYYI={ruGEz0,ruXX, ruYYI}
	                      where   ruXX = GEx[x_,x_]:>2*XX[x]
	                              ruYYI = GEx[x_,0]:>2*YYI[x]

	ruIAXYI={ruIAX,ruIAYI};
	                      where ruIAX = replace terms linear in A or tp[A]
                                            using IAX[x]=0 (see 4.4b).
	                            ruIAYI= replace terms linear in A or tp[A]
                                            using IAYI[x]=0 (see 4.4c).
    
Replacements of variables with critical values:

	ruCritW = {W -> tp[B1[x]] ** tp[GEx[x, z]] + 
                tp[D21[x]] ** tp[b[z]] ** tp[GEz[x, z]]};

	ruCritU = {U -> -inv[e1[x]] ** tp[B2[x]] ** tp[GEx[x, z]] - 
                             inv[e1[x]] ** tp[D12[x]] ** C1[x]}

	ruc = c[z_]:> -inv[e1[z]]**(tp[B2[z]]**XX[z] + tp[D12[z]]**C1[z]);
	rua = a[z_]:> A[z] + B2[z]**c[z] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z]//.ruc ;
	ruaWIA = a[z_]:> AB[z,c[z]] - b[z]**C2[z] +
                         (B1[z]- b[z]**D21[z])**tp[B1[z]]**XX[z];

SPECIAL SYSTEMS

Linear Systems:

	ruGEXY={ruGEXY1,ruGEXY2};
	                      where ruGEXY1=tp[GEx[x_,0]]:>tp[x]**inv[YY];
	                            ruGEXY2=tp[GEx[x_,x_]]:>tp[x]**XX;

	rulinearall=Union[rulinearsys,ruGEXY,rulinearXY];
	              where rulinearsys={A[x_]:>A**x, B1[x_]:>B1,
                                         B2[x_]:>B2,C1[x_]:>C1**x,C2[x_]:>C2**x,
	                                 D21[x_]:>D21,D12[x_]:>D12,a[x_]:>a**x,
                                         b[x_]:>b,c[x_]:>c**x,dd[x_]:>dd,
                                         e1[x_]:>e1,
                                         e2[x_]:>e2,tp[e1]->e1,tp[e2]->e2};
	                    rulinearXY={XX[x_]:>XX**x,YY[p_]:>p**YY,
                                                YYI[x_]:>inv[YY]**x};

	rulinearEB={
	GEx[x_,z_]:> 2*(tp[x] ** P11 + tp[z] ** P21),
	GEz[x_,z_]:> 2*(tp[x] ** P12 + tp[z] ** P22)};


Doyle Glover Khargonekar Francis Simplifying Assumptions:

	ruDGKFNL = Apply DGKF simplifying assumptions for IA systems

	ruDGKFlin = Apply DGKF simplifying assumptions for linear systems
 
	ruCRcDGKF=c[z_]:>-tp[B2[z]]**tp[XX[z]];
	ruCRqDGKF=q[x_,z_]:>-tp[C2[x-z]];

	ruaDGKF = a[z_]:>A[z]+B1[z]**tp[B1[z]]**tp[XX[z]] - 
               B2[z]**tp[B2[z]]**tp[XX[z]] - b[z]**C2[z]+cheat[z];

	ruaDGKF2=a[z_]:> AA1[z,z]-b[z]**C2[z];

Energy Ansatzes:

Ansatz (5.1):

	ruGE1=Flatten[{ruGEz0,SubSym[{ruGEz0,ruGEx1,ruGEz1},ruXXYYI]}];
	             where ruGEx1=GEx[x_,z_]:>GEx[x,x]+GEx[x-z,0]-GEx[x-z,x-z];
	                   ruGEz1=GEz[x_,z_]:>-GEx[x-z,0]+GEx[x-z,x-z];
*)

