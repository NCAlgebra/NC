PrependTo[$Path,"/home/oba/mstankus/smallMora/"];
AppendTo[$Path,"/home/oba/mstankus/GB/Stuff/../smallMora/"];
<<Mathematica.misc.m
Print["The path you are using is (in ColumnForm):"];
Print[""];
Print[""];
Print[""];
Print[""];
Print[""];
Print[ColumnForm[$Path]];
<<NCAlgebra.m
Print[$Context];
Run["date"];

va := Run["vi smallMoraAlg.m"];
vd := Run["vi smallMoraData.m"];
ga := Get["smallMoraAlg.m"];
gd := Get["smallMoraData.m"];

SetMonomialOrderOld[{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}];

dostan := (<<GB.atom;<<GBAux.m;<<GB2.m);

test1 := (
ans = Timing[
NCMakeGBOld[{x**y-a,x**y-b}]];
Print[ans];
);

test2 := (
Get["Resol.m"];
AddToMonomialOrder[Inv[x]];
AddToMonomialOrder[Inv[1-x]];
ans = Timing[NCMakeGBOld[RESOL[x,1-x],CleanUpBasisOld->True]];
Print[ans];
);

test3 := (
the = {
x**Inv[x]==1,
Inv[x]**x==1,
(1-x)**Inv[1-x]==1,
Inv[1-x]**(1-x)==1
};
AddToMonomialOrder[Inv[x]];
ans1 = Timing[NCMakeGBOld[the,CleanUpBasisOld->True]];
Print[ans1];
ans2 = Timing[NCMakeGBOld[the]];
Print[ans2];
Print[ans1[[1]],ans2[[1]]]; 
);

goric := Get["RIC.indeterminants"];
(*
goric  := (
           Get["Resol.m"];
           Get["RicattiData.m"];
           Get["Ric.m"];
           ListResol = SimpleConvert2[ListResol];
           temp = Map[AddToDataBase,ListResol];
           temp = CleanUpBasisOld[temp];
           ans = NCMakeGBOld[WhatIsDataBase[temp]];
          );
*)

test4 := Timing[
  GroebnerSimplifyOld[x**x**x**x,
                   {x**x-a,x**x**x-b},
                   CleanUpBasisOld->True]];

test5 := 
  Timing[GroebnerSimplifyOld[x**x**x**x,
                          {x**x-a},
                          CleanUpBasisOld->True]];

test6 := Timing[NCMakeGBOld[{x**x-a},CleanUpBasisOld->True]];

test7  := Timing[NCMakeGBOld[{x**x-a}]];

test8 := smallConvert[a a - x**b];

test9  :=
   (<<GB.indeterminants;
    debugConvert = True;
    smallConvert[RuleTuple[
        Inv[1 - x] ** (Inv[1 - y ** x]^m)** Inv[1 - x] ->
       -Inv[1 - x] ** (Inv[1 - x ** y]^m) + 
       (Inv[1 - y ** x]^m) ** Inv[1 - x] +
       Inv[1 - x] ** (Inv[1 - x ** y]^m)** Inv[1 - x], {m >= 1}, {m}]]
   );

test10 := ResolveInequalities[RuleTuple[a^m,{m < 1, m >= 0},{m}]];
tests := 
( 
test1;
Input[];
test2;
Input[];
test3;
Input[];
test4;
Input[];
test5;
Input[];
);

