$Path=Join[{"../regout"},$Path];
<<NCGB.m
UseGCDs[1];

SNC[E11,E22,E12,E21,Inv[E11],Inv[E22],Inv[E12],Inv[E21],
    Tp[Inv[E11]],Tp[Inv[E22]],Tp[Inv[E12]],Tp[Inv[E21]],
    Tp[E11],Tp[E22],Tp[E12],Tp[E21],
    A,Tp[A],B1,Tp[B1],B2,Tp[B2],
    C1,Tp[C1],C2,Tp[C2],
    b,Tp[b],c,Tp[c],a,Tp[a]];

transE = {
Tp[E21]-E12,
Tp[E11]-E11,
Tp[E22]-E22,
Tp[E12]-E21,
Tp[Inv[E21]]-Inv[E12],
Tp[Inv[E11]]-Inv[E11],
Tp[Inv[E22]]-Inv[E22],
Tp[Inv[E12]]-Inv[E21]};

inverseE = {
E11**Inv[E11] -1,
Inv[E11]**E11 -1,
E12**Inv[E12] -1,
Inv[E12]**E12 -1,
E21**Inv[E21] -1,
Inv[E21]**E21 -1,
E22**Inv[E22] -1,
Inv[E22]**E22 -1,
Tp[E11]**Tp[Inv[E11]] -1,
Tp[Inv[E11]]**Tp[E11] -1,
Tp[E12]**Tp[Inv[E12]] -1,
Tp[Inv[E12]]**Tp[E12] -1,
Tp[E21]**Tp[Inv[E21]] -1,
Tp[Inv[E21]]**Tp[E21] -1,
Tp[E22]**Tp[Inv[E22]] -1,
Tp[Inv[E22]]**Tp[E22] -1};

SetKnowns[A,Tp[A],B1,Tp[B1],B2,Tp[B2],C1,Tp[C1],C2,Tp[C2]];
SetUnknowns[{E12},{Tp[E12]},{E21},{Tp[E21]},{E22},{Tp[E22]},
            {E11},{Tp[E11]},{Inv[E11]},{Tp[Inv[E11]]},
            {Inv[E12]},{Tp[Inv[E12]]},{Inv[E21]},{Tp[Inv[E21]]},
            {Inv[E22]},{Tp[Inv[E22]]},{b},{Tp[b]},{c},{Tp[c]},{a},{Tp[a]}];

Hxx=E11 ** A + Tp[A] ** Tp[E11] + Tp[C1] ** C1 + 
  Tp[C2] ** Tp[b] ** (E21 + Tp[E12])/2 + (E12 + Tp[E21]) ** b ** C2/2 + 
  E11 ** B1 ** Tp[b] ** (E21 + Tp[E12])/2 + E11 ** B1 ** Tp[B1] ** Tp[E11] + 
  (E12 + Tp[E21]) ** b ** Tp[b] ** (E21 + Tp[E12])/4 + 
  (E12 + Tp[E21]) ** b ** Tp[B1] ** Tp[E11]/2;

Hxz=E21 ** A + Tp[a] ** (E21 + Tp[E12])/2 + Tp[c] ** C1 + E22 ** b ** C2 + 
  Tp[c] ** Tp[B2] ** Tp[E11] + E21 ** B1 ** Tp[b]** (E21 + Tp[E12])/2 + 
  E21 ** B1 ** Tp[B1] ** Tp[E11] + E22 ** b ** Tp[b] ** (E21 + Tp[E12])/2 + 
  E22 ** b ** Tp[B1] ** Tp[E11];
 

Hzx=Tp[A] ** Tp[E21] + Tp[C1] ** c + (E12 + Tp[E21]) ** a/2 + E11 ** B2 ** c + 
  Tp[C2] ** Tp[b] ** Tp[E22] + E11 ** B1 ** Tp[b] ** Tp[E22] + 
  E11 ** B1 ** Tp[B1] ** Tp[E21] + 
  (E12 + Tp[E21]) ** b ** Tp[b] ** Tp[E22]/2 + 
  (E12 + Tp[E21]) ** b ** Tp[B1] ** Tp[E21]/2;
 

Hzz=E22 ** a + Tp[a] ** Tp[E22] + Tp[c] ** c + E21 ** B2 ** c + 
  Tp[c] ** Tp[B2] ** Tp[E21] + E21 ** B1 ** Tp[b] ** Tp[E22] + 
  E21 ** B1 ** Tp[B1] ** Tp[E21] + E22 ** b ** Tp[b] ** Tp[E22] + 
  E22 ** b ** Tp[B1] ** Tp[E21];

Hrels=Map[ExpandNonCommutativeMultiply,{Hxx,Hxz,Hzx,Hzz}];
startingrels = Union[Hrels,inverseE,transE];
threetuple1=NCProcess[startingrels,2,"doyle1",
          AdditionalRegularOutputOptions->{FontSize->"small"}];
Put[Definition[threetuple1],"doyle1.result"];
