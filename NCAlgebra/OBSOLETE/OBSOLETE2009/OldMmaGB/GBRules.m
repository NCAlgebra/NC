(* :Title: 	GBRules // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	??` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
   :3/13/93: Added jrules to the end of the file. (mstankus)
*)

Print["Loading GBRules.m\n\n"];

SetNonCommutative[Inv];

Print["Setting General rules"];

rule[1] = 
x ** (Inv[1-y**x]^m) ** Inv[1-x] -> -(
- (Inv[1-x**y]^m) ** (Inv[1-x] - 1)
);

rule[2] =
x ** (Inv[1-y**x]^n) ** Inv[1-y] -> -(
- (Inv[1-x**y]^n) ** Inv[1-y] - 
x ** (Inv[1-y**x]^n) + (Inv[1-x**y]^(n-1)) ** Inv[1-y]
);

rule[3] = 
x ** (Inv[1-y**x]^m) ** Rt[1-y**x] ** Inv[1-x] -> -(
- (Inv[1-x**y]^m) ** Rt[1-x**y] ** (Inv[1-x]-1)
);

rule[4] = 
x ** (Inv[1-y**x]^n) ** Rt[1-y**x] ** Inv[1-y] -> -(
-
((Inv[1-x**y]^n) - (Inv[1-x**y]^(n-1))) ** Rt[1-x**y] ** Inv[1-y] -
x ** (Inv[1-y**x]^n) ** Rt[1-y**x]
);

rule[5] = 
y ** (Inv[1-x**y]^n) ** Inv[1-x] -> -(
-
((Inv[1-y**x]^n) - (Inv[1-y**x]^(n-1))) ** Inv[1-x] -
y ** (Inv[1-x**y]^n)
);

rule[6] = 
y ** (Inv[1-x**y]^m) ** Inv[1-y] -> -(
- (Inv[1-y**x]^m) ** (Inv[1-y] - 1)
);

rule[7] = 
y ** (Inv[1-x**y]^n) ** Rt[1-x**y] ** Inv[1-x] -> -(
- ((Inv[1-y**x]^n) - (Inv[1-y**x]^(n-1))) ** Rt[1-y**x] ** Inv[1-x] -
y ** (Inv[1-x**y]^n) ** Rt[1-x**y] 
);

rule[8] = 
y ** (Inv[1-x**y]^m) ** Rt[1-x**y] ** Inv[1-y] -> -(
- (Inv[1-y**x]^m) ** Rt[1-y**x] ** (Inv[1-y]-1)
);

rule[9] = 
Inv[1-x] ** (Inv[1-y**x]^m) ** Inv[1-x] -> -(
- Inv[1-x] ** (Inv[1-x**y]^m) ** Inv[1-x] -
(Inv[1-y**x]^m) ** Inv[1-x] + Inv[1-x] ** (Inv[1-x**y]^m) 
);

rule[10] = 
Inv[1-x] ** (Inv[1-y**x]^n) ** Inv[1-y] -> -(
- Inv[1-x] ** ((Inv[1-x**y]^n) - (Inv[1-x**y]^(n-1))) ** Inv[1-y] -
(Inv[1-y**x]^n) ** (Inv[1-y]-1) - Inv[1-x] ** (Inv[1-y**x]^n)
);

rule[11] = 
Inv[1-x] ** (Inv[1-y**x]^m) ** Rt[1-y**x] ** Inv[1-x] -> -(
- Inv[1-x] ** (Inv[1-x**y]^m) ** Rt[1-x**y] ** (Inv[1-x]-1) -
(Inv[1-y**x]^m) ** Rt[1-y**x] ** Inv[1-x]
);

rule[12] =
Inv[1-x] ** (Inv[1-y**x]^n) ** Rt[1-y**x] ** Inv[1-y] -> -(
- Inv[1-x] ** ((Inv[1-x**y]^n) - (Inv[1-x**y]^(n-1))) **
Rt[1-x**y] ** Inv[1-y]  -
(Inv[1-y**x]^n) ** Rt[1-y**x] ** (Inv[1-y] - 1)  -
Inv[1-x] ** (Inv[1-y**x]^n) ** Rt[1-y**x]
);

(*  
rule[13] = 
Inv[1-y] ** (Inv[1-y**x]^n) ** Inv[1-x] -> -(
- Inv[1-y] ** (Sum[(Inv[1-x**y]^jj),{jj,0,n-1}]+Inv[1-x**y]^n) ** Inv[1-x] +
Sum[(Inv[1-x**y]^jj),{jj,1,n}] ** Inv[1-x] +
Inv[1-y] ** Sum[(Inv[1-x**y]^jj),{jj,1,n}] - Sum[(Inv[1-x**y]^jj),{jj,1,n}]
);
*)

rule[13] = 
Inv[1-y] ** (Inv[1-y**x]^n) ** Inv[1-x] -> 
Inv[1-y] ** (Inv[1-y**x]^(n-1)) ** Inv[1-x]  + 
(Inv[1-x**y]^n) - Inv[1-y]**(Inv[1-x**y]^n) -
(Inv[1-x**y]^n)**Inv[1-x] + Inv[1-y]**(Inv[1-x**y]^n)**Inv[1-x];


rule[14] = 
Inv[1-y] ** (Inv[1-y**x]^m) ** Inv[1-y] -> -(
- Inv[1-y] ** (Inv[1-x**y]^m) ** Inv[1-y] +
(Inv[1-x**y]^m) ** Inv[1-y] - Inv[1-y] ** (Inv[1-y**x]^m)
);

(*
rule[15] = 
Inv[1-y] ** (Inv[1-y**x]^n) ** Rt[1-y**x] ** Inv[1-x] -> -(
- Inv[1-y] ** (Sum[(Inv[1-x**y]^jj),{jj,1,n-1}] +
Inv[1-x**y]^n) ** Rt[1-x**y] ** Inv[1-x] +
Sum[(Inv[1-x**y]^jj),{jj,1,n}] ** Rt[1-x**y] ** Inv[1-x] +
Inv[1-y] ** Sum[(Inv[1-x**y]^jj),{jj,1,n}] ** Rt[1-x**y] -
Sum[(Inv[1-x**y]^jj),{jj,1,n}] ** Rt[1-x**y] -
Inv[1-y] ** Rt[1-y**x] ** Inv[1-x]
);
*)

rule[15] = 
Inv[1-y] ** (Inv[1-y**x]^n) ** Rt[1-y**x]**Inv[1-x] -> 
Inv[1-y] ** (Inv[1-y**x]^(n-1))**Rt[1-y**x] ** Inv[1-x]  + 
(Inv[1-x**y]^n)**Rt[1-x**y] - 
Inv[1-y]**(Inv[1-x**y]^n)**Rt[1-x**y] -
(Inv[1-x**y]^n)**Rt[1-x**y]**Inv[1-x] + 
Inv[1-y]**(Inv[1-x**y]^n)**Rt[1-x**y]**Inv[1-x];
 
rule[16] = 
Inv[1-y] ** (Inv[1-y**x]^m) ** Rt[1-y**x] ** Inv[1-y] -> -(
- Inv[1-y] ** (Inv[1-x**y]^m) ** Rt[1-x**y] ** Inv[1-y] +
(Inv[1-x**y]^m) ** Rt[1-x**y] ** Inv[1-y] -
Inv[1-y] ** (Inv[1-y**x]^m) ** Rt[1-y**x]
);

Print["Done Setting General rules\n\n"];
Print["Setting Particular rules"];

rule[17] = 
Inv[1-x] ** y ** Inv[1-x**y] -> -(
- Inv[1-x] ** Inv[1-x**y] - y ** 
Inv[1-x**y] + Inv[1-x]
);

rule[18] = 
Inv[1-y] ** x ** Inv[1-y**x] -> -(
- Inv[1-y] ** Inv[1-y**x] - x ** 
Inv[1-y**x] + Inv[1-y]
);

rule[19] = Inv[1-x**y] ** x -> x ** Inv[1-y**x];
rule[20] = Inv[1-y**x] ** y -> y ** Inv[1-x**y];

rule[21] = Rt[1-x**y] ** x -> x ** Rt[1-y**x];
rule[22] = Rt[1-y**x] ** y -> y ** Rt[1-x**y];

rule[23] = Rt[1 - x**y] ** Inv[y] -> Inv[y] ** Rt[1 - y**x];

rule[24] = Rt[1 - x**y] ** Inv[1-x**y] -> Inv[1-x**y] ** Rt[1 - x**y];

rule[25] = Rt[1 - y**x] ** Inv[x] -> Inv[x] ** Rt[1 - x**y];

rule[26] = Rt[1 - y**x] ** Inv[1-y**x] -> Inv[1-y**x] ** Rt[1 - y**x];

rule[27] = Inv[x] ** Rt[1 - x**y] ** Inv[1-x] -> -(
 - Rt[1 - y**x] **
Inv[1-x] - Inv[x] ** Rt[1 - x**y]
);

rule[28] = Inv[y] ** Rt[1 - y**x] ** Inv[1-y] -> -(
- Rt[1 - x**y] **
Inv[1-y] - Inv[y] ** Rt[1 - y**x]
);
   
Print["Done Setting Particular rules\n\n"];
Print["Setting EB rules"];
rule[29] =  Inv[x] ** x -> Id;
rule[30] =  x ** Inv[x] -> Id;
rule[31] =  Inv[y] ** y -> Id;
rule[32] =  y ** Inv[y] -> Id;
rule[33] =  x ** y ** Inv[1-x**y] -> -(- Inv[1-x**y] + Id);
rule[34] =  y ** x ** Inv[1-y**x] -> -(- Inv[1-y**x] + Id);
rule[35] =  Inv[1-x**y] ** x ** y -> -(- Inv[1-x**y] + Id);
rule[36] =  Inv[1-y**x] ** y ** x -> -(- Inv[1-y**x] + Id);

rule[37] =  Inv[1-y**x] ** Inv[x] ->-(- y ** Inv[1-x**y] - Inv[x]);
rule[38] =  Inv[1-x**y] ** Inv[y] -> -(- x ** Inv[1-y**x] - Inv[y]);
rule[39] =  Inv[x] ** Inv[1-x**y] -> -(- y ** Inv[1-x**y] - Inv[x]);
rule[40] =  Inv[y] ** Inv[1-y**x] -> -(- x ** Inv[1-y**x] - Inv[y]);
rule[41] =  Inv[1-y**x] ** y -> -(- y ** Inv[1-x**y]);
rule[42] =  Inv[1-x**y] ** x -> -(- x ** Inv[1-y**x]);
Print["Done Setting EB rules\n\n"];
Print["Setting RESOL in both x and y"];
rule[43] = Inv[x] ** x -> Id;
rule[44] = x ** Inv[x] -> Id;
rule[45] = Inv[1-x] ** x -> -(- Inv[1-x] + Id);
rule[46] = x ** Inv[1-x] -> -(- Inv[1-x] + Id);
rule[47] = Inv[1-x] ** Inv[x] -> -(- Inv[1-x] - Inv[x]);
rule[48] = Inv[x] ** Inv[1-x] -> -(- Inv[1-x] - Inv[x]);
rule[49] = Inv[y] ** y -> Id;
rule[50] = y ** Inv[y] -> Id;
rule[51] = Inv[1-y] ** y -> -(- Inv[1-y] + Id);
rule[52] = y ** Inv[1-y] -> -(- Inv[1-y] + Id);
rule[53] = Inv[1-y] ** Inv[y] -> -(- Inv[1-y] - Inv[y]);
rule[54] = Inv[y] ** Inv[1-y] -> -(- Inv[1-y] - Inv[y]);
Print["Done Setting RESOL rules\n\n"];
Print["Start Setting Rt definition rules"];
rule[55] = Rt[1-x**y]^2 -> 1 - x**y;
rule[56] = Rt[1-y**x]^2 -> 1 - y**x;
Print["Done Setting Rt definition rules\n\n"];
(*
Print["Starting rules with m == 0"];
rule[57] = rule[3]/.m->0;
rule[58] = rule[8]/.m->0;
rule[59] = rule[11]/.m->0;
rule[60] = rule[16]/.m->0;
*)


numberofrules = 56;

Print["Done Setting ", numberofrules," rules.\n\n"];
Print["Starting NCEing rules."];
Do[ rule[j] = ExpandNonCommutativeMultiply[rule[j]];
, {j,numberofrules}];
Print["Done NCEing rules.\n\n"];

RESOL = Table[rule[j],{j,43,54}];
EB = Table[rule[j],{j,29,42}];

NFtotalaux[x_] := 
Module[{aListOfFacts,aListOfVariables},
     aListOfFacts = {};
     aListOfVariables = {};
     If[Not[FreeQ[x,m]], AppendTo[aListOfFacts,m>=1];
                         AppendTo[aListOfVariables,m];
     ];
     If[Not[FreeQ[x,n]], AppendTo[aListOfFacts,n>=1];
                         AppendTo[aListOfVariables,n];
     ];
     Return[RuleTuple[x,aListOfFacts,aListOfVariables]]
];
    
Do[rule[j] = NFtotalaux[rule[j]];
,{j,1,numberofrules}]; 

NFtotal = Union[Table[rule[j],{j,1,numberofrules}]];

preNFnet[x_RuleTuple] := 
Module[{aRule,test,result},
    aRule = x[[1]];
    test = FreeQ[aRule,Rt];
    If[test, result = {x}
           , result = {}
           , Print["Error in GBRules.m"];
             Abort[];
    ];
    Return[result]
];

preNFnet[x___] := BadCall["preNFnet",x];
 
Print["Starting finding preNF"];

preNFtotal = Map[preNFnet,NFtotal];

preNFtotal = Union[Flatten[preNFtotal]];

Print["Done finding preNF"];

j1 = OperatorSignature[1-x**y];
j2 = OperatorSignature[1-y**x];

SetNonCommutativeMultiply[OperatorSignature];
jrule[1] := j1**j1->1;
jrule[2] := j2**j2->1;

jrule[3] := x**j1 == j2**x;
jrule[4] := j1**y == y**j2;

jrule[5] := (1 - x**y)**j1 == j1**(1 - x**y);
jrule[6] := (1 - y**x)**j2 == j2**(1 - y**x);

numberofjrules = 6;

Do[jrule[k] = ExpandNonCommutativeMultiply[jrule[k]];
   jrule[k] = RuleTuple[jrule[k],{},{}];
,{k,1,numberofjrules}];

jrules = Table[jrule[k],{k,1,numberofjrules}];
Print["Done finding jrule."];

GBExplode[aList_List,aListOfVars_List] := 
        Map[GBExplode[#,aListOfVars]&,aList];

Literal[GBExplode[PolynomialTuple[a_,b_,c_],vars_List]] := 
             PolynomialTuple[a,b,Union[c,vars]];

Literal[GBExplode[RuleTuple[a_,b_,c_],vars_List]] := 
             RuleTuple[a,b,Union[c,vars]];

GBExplode[x___] := BadCall["GBExplode",x];

KlugeQ = True; (* A setting for ReductionOld.m *)
