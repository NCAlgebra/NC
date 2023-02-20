<<NCGB.m

SNC[E11,E22,E12,E21,iE11,iE22,iE12,iE21,
    Tp[iE11],Tp[iE22],Tp[iE12],Tp[iE21],
    Tp[E11],Tp[E22],Tp[E12],Tp[E21],
    A,Tp[A],B1,Tp[B1],B2,Tp[B2],
    C1,Tp[C1],C2,Tp[C2],
    b,Tp[b],c,Tp[c],a,Tp[a],X,Inv[X],Y,Inv[Y]];

SetMonomialOrder[{A,Tp[A],B1,Tp[B1],B2,Tp[B2],C1,Tp[C1], 
                  C2,Tp[C2],X,Inv[X],Y,Inv[Y]},1];
SetMonomialOrder[{E12,E21,E22,Tp[E12],Tp[E21],Tp[E22],E11,
                   Tp[E11],iE11,Tp[iE11]},2];
SetMonomialOrder[{iE12,iE21,iE22,Tp[iE12],Tp[iE21],Tp[iE22]},3];
SetMonomialOrder[{b,Tp[b]},4];
SetMonomialOrder[{c,Tp[c]},5];
SetMonomialOrder[{a,Tp[a]},6];

<<demo3.result;

GBdigested=RuleToPol[threetuple2[[1]]];
digested=RuleToPol[threetuple2[[2]]];
undigested=RuleToPol[threetuple2[[3]]];
 
newrels={Inv[Y]**Y-1,Y**Inv[Y]-1,Inv[X]**X-1,X**Inv[X]-1,Y-iE11,
         Inv[Y]-E11,X-E11+E12**iE22**E21,Inv[X]-iE21**E22**iE12,
         -X**A-Tp[A]**X+X**B2**C1+Tp[C1]**Tp[B2]**X-X**B1**Tp[B1]**X+
          X**B2**Tp[B2]**X};

selected={Y-iE11,X-E11+E12**iE22**E21};

relations=Join[digested,undigested,newrels];

threetuple5=NCProcess[relations,2,"demo5.sorted",UserSelect->selected,
                   SBByCat->True,DegreeCap->6,DegreeSumCap->9];
Put[Definition[threetuple5],"demo5.result"];

