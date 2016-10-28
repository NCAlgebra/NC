SNC[a,b,c,Aja,InvAja,Inva,LossLessM,InvLossLessM,Ajb,Ajc];

     Rel[0] =  + InvLossLessM ** LossLessM - 1;
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

rels=Complement[Union[LossLessList],{0}];

ClearMonomialOrder[];
SetMonomialOrder[{a,c,LossLessM,InvLossLessM,Ajc},1];
SetMonomialOrder[{Aja,Inva,InvAja,b,Ajb},2];
Iterations=5;
