<<NCGB.m;
<<NCNb.m;
Get["NCProcess.m"];

NCStartNb["Demos/Demo4/this_time"];

$ExecuteNb = False;

SetNonCommutative[A,B,C0,m1,m2,im1,im2,a,b,c,e,f,g];
SNC[P1];
SetKnowns[A,B,C0,P1];
SetUnknowns[{m1,m2},{im1,im2},{a,b,c,e,f,g}];

<<threetuple1;
GBdigested=RuleToPol[threetuple1[[1]]];
digested=RuleToPol[threetuple1[[2]]];
undigested=RuleToPol[threetuple1[[3]]];

discovered = {m1**im1-P1,im1**A**m2,im1**m1-1,im2**m2-1,m2**im2-1+m1**im1};

GBDirectory="~/Spreadsheet2";
NCSetNb["threetuple2", Spreadsheet[Join[digested,discovered,
              Complement[undigested,discovered]],
              2,4,4,4,
              "step2.spreadsheet",
              Deselect->GBdigested,UserSelect->discovered,
              RR->True,SBByCat->True]];

Put[Definition[threetuple2],"threetuple2"];

