<<DigestedRelations.m
(*
Takes a list of subsets and a list of variables and returns a list of 
subsets which are subordinate to the list of variables.
*)
GetLabelsSubordinateTo[aListOfLabels_List,aListOfVars_List] :=
Module[{result,j},
   result ={}; 
   Do[
     If[Complement[aListOfLabels[[j]],
                   aListOfVars]==={}
            ,result=Union[result,{aListOfLabels[[j]]}]];
   ,{j,1,Length[aListOfLabels]}];
   Return[Complement[result,{aListOfVars}]];
];
   
(*
Takes a list of polynomials and returns a list of 
variables 
*)
GetLabelSubset[aListOfPolynomials_List] :=
Module[{result},
  result = Map[Grabs`GrabVariables,aListOfPolynomials];
  result = Union[result];
  result = Map[Union,result];
  Return[result];
];

(*
  Takes a list of labels and a list of polynomials.
  Creates a list of polynomials for each label.
  The list includes the polynomials which include EXACTLY
  the indeterminates in the label.
*)
AssignSubsets[aListOfLabels_,aListOfPolynomials_] :=
Module[{i,j},
   Clear[Subset];
   Subset[_]={};
   Do[Subset[aListOfLabels[[i]]]=Select[aListOfPolynomials,
            (aListOfLabels[[i]]===GetLabelSubset[{#}][[1]])&];
     ,{i,1,Length[aListOfLabels]}
     ];
   Return[];
];
       


(*
  Do Small Basis on each subset and replace the
  subset with the smaller one on each one.
*)
SmallBasisBySubset[aListOfLabels_,aListOfPolynomials_,iter_]:=
Module[{i,j,otherlabels,polys,newpolys},
  newpolys={};
  Do[otherlabels= GetLabelsSubordinateTo[aListOfLabels,
                                          aListOfLabels[[i]]];
Print["labels:",otherlabels];
    polys=Flatten[Map[Subset,otherlabels]];
Print["First argument:",Subset[aListOfLabels[[i]]]];
Print["Second argument:",polys];
    Subset[aListOfLabels[[i]]]=
              SmallBasis[Subset[aListOfLabels[[i]]],polys,iter];
Print["Subset[{}]:",Subset[aListOfLabels[[i]]]];
  ,{i,Length[aListOfLabels]}];
  newpolys = Flatten[Map[Subset,aListOfLabels]];
  Return[newpolys];
];
 
SmallBasisOnDigestedBySubset[aListOfPolynomials_,iter_]:=
Module[{cats,i,result,labelsubset,digested},
Print["huh:",aListOfPolynomials];
   digested=RuleToPol[DigestedRelations[aListOfPolynomials]];
   labelsubset=GetLabelSubset[digested];
   AssignSubsets[labelsubset,digested];
   result = SmallBasisBySubset[labelsubset,digested,iter];
Print["result:",result];
   Return[result];
];

