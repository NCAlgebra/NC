<<NCGB.m;
<<NCBoth.m;
<<AttemptParameterize.m;

SNC[E11,E22,E12,E21,iE11,iE22,iE12,iE21,
    Tp[iE11],Tp[iE22],Tp[iE12],Tp[iE21],
    Tp[E11],Tp[E22],Tp[E12],Tp[E21],
    A,Tp[A],B1,Tp[B1],B2,Tp[B2],
    C1,Tp[C1],C2,Tp[C2],
    b,Tp[b],c,Tp[c],a,Tp[a]];

SetMonomialOrder[{A,Tp[A],B1,Tp[B1],B2,Tp[B2],C1,Tp[C1], 
                  C2,Tp[C2]},1];
SetMonomialOrder[{E12,E21,E22,Tp[E12],Tp[E21],Tp[E22],E11,
                   Tp[E11],iE11,Tp[iE11]},2];
SetMonomialOrder[{iE12,iE21,iE22,Tp[iE12],Tp[iE21],Tp[iE22]},3];
SetMonomialOrder[{b,Tp[b]},4];
SetMonomialOrder[{c,Tp[c]},5];
SetMonomialOrder[{a,Tp[a]},6];

<<demo3.result;

equ=RuleToPoly[threetuple2[[3,-1]]];
equ2=NCCOV[equ];
boths2 = NCGrabSides[equ];
Print["equ2 =",equ2];
Print["boths2 =",boths2];
Abort[];
(*
*)
ans = AttemptParameterize[equ,WhatIsSetOfIndeterminants[1],
                          2,threetuple2[[3]]];
Abort[];









Print[""];
Print["Now we notice that the following multiplication"];
Print["will give us an equation in one unknown"];
Print["E12**iE22**equ2**iE22**E21"];
Print[""];

equ3 = NCE[E12**iE22**equ2**iE22**E21];
equ4 =
Transform[equ3,{iE22**E22->1,E12**iE12->1,E22**iE22->1,iE21**E21->1}];
equ5 = NCCOV[equ4];
boths5 = NCGrabSides[equ4];
Print["equ5 =",equ5];
Print["boths5 =",boths5];
