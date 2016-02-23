
unExp[x_NCProduct] := Map[NCPower[#[[1]],1]&,x];


unExp[x_OrderedMonomial] := Table[x[[j,1]],{j,1,Length[x]}];

Clear[LookForPowerRule];

LookForPowerRule[aList_List,n_Integer] :=
Module[{done,len,i,p,conditions,result,temp},
  done = False;
  len = Length[aList];
  For[i=1,i<=n && Not[done], i = i + 1,
      p[x_] := Sum[a[j] x^j,{j,0,i}];
      vars = Table[a[j],{j,0,i}];
      conditions = Table[p[k]==aList[[k]],{k,1,len}];
      result = Solve[conditions,vars];
      If[Not[result==={}]
          , done = True;
            result = Flatten[result];
            temp = p[x]/.result;
      ];
      
  ];
  If[Not[done]
     , temp = "noplynomial";
  ];
  Return[temp];
];

FindPattern[aList:{___OrderedPolynomial}] :=
Module[{len,terms,term,coeff,lens,ru,powers,bases,
        failed,i,j,monomials,monomial,result},
   failed = False;
   lens = Union[Map[Length,aList]];
   If[Not[Length[lens]===1]
       , Print["Number of terms does not work."];
         Print[Map[Length,aList]]; 
         BadCall["FindPattern",aList];
   ];
   len = lens[[1]];
   For[i=1,i<=len && Not[failed], i++,
     terms = Map[#[[i]]&,aList];
     coefficients = Map[#[[1]]&,terms];
     If[Not[Length[Union[coefficients]]===1]
       , Print["Coefficients of individual monomials does not work."];
         Print[coefficients]; 
         BadCall["FindPattern",aList];
     ];
     monomials = Map[#[[2]]&,terms];
     powerlessMonomials = Map[unExp,monomials];
     coeff[i] = coefficients[[1]];
     lens = Union[Map[Length,powerlessMonomials]];
     If[Not[Length[lens]===1]
         , Print["Degrees of individual monomials does not work."];
           Print[powerlessMonomials]; 
           Print[Map[Length,powerlessMonomials]]; 
           BadCall["FindPattern",aList];
     ];
     lenar[i] = lens[[1]];
     For[j=1,j<=lenar[i] && Not[failed],j++,
       bases = Union[Map[#[[j,1]]&,monomials]];
       If[Not[Length[bases]===1]
           , failed = True;
           , var[i,j] = bases[[1]];
             powers = Map[#[[j,2]]&,monomials];
             ru[i,j] = LookForPowerRule[powers,1]/.x->n;
             If[ru[i,j]==="nopolynomial", failed = True;];
       ];
     ];
   ];
   If[Not[failed]
       , result = 0;
         Do[ term = coeff[i];
             Do[ term=term ** (var[i,j]^ru[i,j]);
             ,{j,1,lenar[i]}];
             result = result + term;
         ,{i,1,len}];
       , result = "failed";
   ];
   Return[result];
];

ToOrderedPolynomial[x_Plus] :=
Module[{aList},
   aList = SortMonomials[Apply[List,x]];
   aList = Map[ToOrderedTerm,aList];
   Return[Apply[OrderedPolynomial,aList]];
];

ToOrderedPolynomial[x_] := OrderedPolynomial[ToOrderedTerm[x]];

ToOrderedTerm[c_?NumberQ x_] := OrderedTerm[c,ToOrderedMonomial[x]];
ToOrderedTerm[x_] := OrderedTerm[1,ToOrderedMonomial[x]];
ToOrderedTerm[c_?NumberQ] := OrderedTerm[c,OrderedMonomial[]];

ToOrderedMonomial[x_NonCommutativeMultiply] :=
Module[{tempb,tempp,result,i,j},
  tempb[1] = x[[1]];
  tempp[1] = 1;
  j = 1;
  Do[ If[x[[i]]===tempb[j]
         , tempp[j] = tempp[j]+1;
         , j = j+1;
           tempb[j] = x[[i]];
           tempp[j] = 1;
      ];
  ,{i,2,Length[x]}];
  result = Table[FakePower[tempb[i],tempp[i]],{i,1,j}];
  result = Apply[OrderedMonomial,result];
  Return[result];
];

ToOrderedMonomial[x_] := OrderedMonomial[FakePower[x,1]];
ToOrderedMonomial[c_?NumberQ] := OrderedMonomial[FakePower[x,1]];

ToOrderedMonomial[x___] := BadCall["ToOrderedMonomial",x];
