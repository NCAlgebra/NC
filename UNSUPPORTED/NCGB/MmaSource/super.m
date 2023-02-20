
f = Structure[ForAll[{n},RightArrow[n>1,Hole1]],p];
g = Structure[ForAll[{m},RightArrow[m>2,Hole1]],q];

super[x_Structure,y_Structure,newValue_] :=
Module[{patternx,patterny,newpat,ans},
  patternx = x[[1]];
  patterny = y[[1]];
  newpat = patternx/.Hole1->patterny;
  ans = newpat/.Hole1->newValue;
  Return[ans];
];

RightArrow[x_,y_ForAll] := ForAll[y[[1]],RightArrow[x,y[[2]]]];
ForAll[x_,y_ForAll] := ForAll[Join[x,y[[1]]],y[[2]]];
RightArrow[x_,y_RightArrow] := RightArrow[MyAnd[x,y[[1]]],y[[2]]];
ForAll[x_,y_MyAnd] :=  Apply[MyAnd,Map[ForAll[x,#]&,Apply[List,y]]];
RightArrow[x_,y_MyAnd] :=  Apply[MyAnd,Map[RightArrow[x,#]&,Apply[List,y]]];
MyAnd[y___,MyAnd[x___],z___] := MyAnd[y,x,z];
     


Print[super[f,g,spol[p,q]]];
Print[""];
Print[""];
Print[""];
Print[super[f,g,MyAnd[spol[p,q],spol1[p,q]]]];
Print[""];
Print[""];
Print[""];
Print[super[f,g,RightArrow[Equal[m,n],
                           MyAnd[spol[p,q],spol1[p,q]]]]];

