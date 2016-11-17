SetNonCommutative[a,b,inva,invb,inv1a,inv1b,inv1ab,inv1ba];

ebrels={
	a**inva - 1,
	inva**a - 1,
	b**invb - 1,
	invb**b - 1,
	inv1b - b**inv1b - 1,
	inv1b - inv1b**b - 1,
	inv1a - a**inv1a - 1,
	inv1a - inv1a**a - 1,
	inv1ab - a**b**inv1ab - 1,
	inv1ab - inv1ab**a**b - 1,
	inv1ba - b**a**inv1ba - 1, 
	inv1ba - inv1ba**b**a - 1
       };

SNC[a,b,c,Aja,InvAja,Inva,LossLessM,InvLossLessM,Ajb,Ajc];

     Rel[0] =  + InvLossLessM ** LossLessM - 1  ;
     Rel[1] =  + LossLessM ** InvLossLessM - 1;
     Rel[2] =  + Inva** a - 1;
     Rel[3] =  + a ** Inva - 1;
     Rel[4] =  + InvAja ** Aja - 1;
     Rel[5] =  + Aja ** InvAja - 1;
     Rel[6] = 0  ;
     Rel[7] =  + Ajb ** InvLossLessM - c ;
     Rel[8] =  + LossLessM ** Ajc - b ;
     Rel[9] = 0  ;
     Rel[10] = 0  ;
     Rel[11] =  + InvLossLessM ** b - Ajc ;
     Rel[12] =  + c ** LossLessM - Ajb ;
     Rel[13] =  + LossLessM ** Aja ** InvLossLessM - b ** c + a ;
     Rel[14] =  + c ** b - Ajb ** Ajc ;
     Rel[15] = 0  ;
     Rel[16] = 0  ;
     Rel[17] =  + Ajc ** c - Aja ** InvLossLessM - InvLossLessM ** a ;
     Rel[18] =  + InvLossLessM ** a ** LossLessM - Ajc ** Ajb + Aja ;
     Rel[19] =  + b ** Ajb - a ** LossLessM - LossLessM ** Aja ;
     Rel[20] =  + Ajc ** Ajb ** Ajc - InvLossLessM ** a ** b -
             Aja ** Ajc ;
     Rel[21] =  + c ** a ** LossLessM - Ajb ** Ajc ** Ajb + Ajb **
             Aja ;
     Rel[22] =  + Ajc ** Ajb ** Aja ** InvLossLessM - InvLossLessM **
             a ** b ** c - Aja ** Aja ** InvLossLessM + InvLossLessM **
             a ** a ;

LossLessList = Table[Rel[j],{j,0,22}];
LossLessRelations = Complement[Union[LossLessList],{0}];
ClearMonomialOrder[];
SetMonomialOrder[{a,c,LossLessM,InvLossLessM,Ajc,Aja,Inva,InvAja,b,Ajb,
                 inva,invb,inv1a,inv1b,inv1ab,inv1ba},1];

rels=Join[LossLessRelations,ebrels];

Iterations=5;
Interrupted = True;
