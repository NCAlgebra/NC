
SplitProblem[aPolynomial_,aListOfPolynomials_List] :=
Module[{vars,basevars,extra,arr,ts,newPoly,newPolys,i,T},
  vars = Grabs`GrabIndeterminants[aPolynomial];
  basevars = Grabs`GrabIndeterminants[aListOfPolynomials];
  extra = Complement[vars,basevars];
  arr = Table[extra[[i]]->extra[[i]] T[i],{i,1,Length[extra]}];
  ts = Table[T[i],{i,1,Length[extra]}];
  newPoly = aPolynomial/.arr;
  newPolys =  Union[Flatten[CoefficientList[newPoly,ts]]];
  Return[newPolys];
];

(* Use

  subprob = SplitProblem[relations[[1]],biglist];
  subSets = Map[VariableClosure[#,biglist]&,subprob];
  notdecided = True;
  Len = Length[subprob];
  For[j = 1,And[j<=Len,notdecided],j = j + 1,
      NCMakeGB[subSets[[j]],...];
      ans = FastReduction[{subprob[[j]]}];
      notdecided = ans==={0};
  ];
  If[notdecided, (* throw out *)
               , (* keep *)];
*)
  
