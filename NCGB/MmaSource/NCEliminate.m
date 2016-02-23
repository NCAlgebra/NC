(* :Title: NCEliminate.m *)

(* :Author: Mauricio C. de Oliveira *)

(* :Context: NCEliminate` *)

(* :Sumary: *)

(* :Alias: *)

(* :Warnings: *)

(* :History:
   :06/01/2004: First Version. Bill told me that there was one similar thing at 
                some point but I could not find it. So I wrote this. Might need 
                some adjusting in the contexts to get MoraAlg working with all 
                versions of NCGB.
*)

BeginPackage[ 
	        "NCEliminate`",
                "MoraAlg`",
                "NonCommutativeMultiply`"
];

Clear[NCEliminate]

NCEliminate::usage = "NCEliminate provides a simpler interface to NCGB.";

Clear[NCProcessHypothesis]

NCProcessHypothesis::usage = "NCProcessHypothesis.";

Clear[NCInvertible]

Begin["`Private`"]; 

Clear[AllSymbols];
AllSymbols[exp_]:=Union[Flatten[
      {
        Cases[exp,_Symbol,Infinity],
        Cases[exp,f_[_],Infinity]
        }
      ]]
AllSymbols[exp_Symbol]:={exp}
AllSymbols[exp_List]:=Union[Flatten[Map[AllSymbols,exp]]];

Clear[GetKnowns];
GetKnowns[list_List,unknowns_List]:=Complement[list,unknowns];

NCEliminate[eqns_List,unknowns_List,k_Integer]:=Module[
  {leqns=NCProcessHypothesis[eqns], knowns},
  ClearMonomialOrder[];
  knowns = GetKnowns[AllSymbols[leqns],Flatten[unknowns]];
  SetKnowns[knowns];
  SetUnknowns[unknowns];
  Print["leqns = ", leqns];
  Print["knowns = ", knowns];
  Print["unknowns = ", unknowns];
  NCProcessEliminateSolution[NCMakeGB[leqns, k]]
]

NCProcessHypothesis[hyp_List] := Module[
    {proc,rest},
    proc=Cases[hyp, NCInvertible[x_]];
    rest=Complement[hyp,proc];
    (* Process proc *)
    proc = proc /. NCInvertible[x_] :> { x ** Global`Inv[x] - 1, Global`Inv[x] ** x - 1 };
    Union[rest,Flatten[proc]]
    ]

Clear[NCProcessEliminateSolution]

NCProcessEliminateSolution[sol_List] := Module[
    (* poly -> rule *)
    {IRule,lsol = Global`PolyToRule[sol]},
    lsol = lsol //. Global`Inv -> inv /. Rule -> IRule;
    lsol=DeleteCases[lsol,IRule[x_,x_]] /. IRule -> Rule
    ]

End[];

EndPackage[];
