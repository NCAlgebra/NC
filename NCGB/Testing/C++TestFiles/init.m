AppendTo[$Path,"/home/osiris/yoshinob/dugout"];
AppendTo[$Path,"/home/osiris/yoshinob/dynamo"];
AppendTo[$Path,"/home/osiris/yoshinob/nm"];

go := <<NCAlgebra.m;

dude[n_]:= compare[n];
compare[num_?NumberQ,m_?NumberQ]:=
Module[{check},
   Do[
     Print["Checking the ", i,"th test files"]; 
     hi1 =  Get[StringJoin["test.",ToString[i],".ans"]];
     hi2 =  Get[StringJoin["test.",ToString[i],".answer"]];
     hi2 = hi2 /.Rule->Subtract; 
     comp1 = Complement[hi1,hi2];
     comp2 = Complement[hi2,hi1];
     answer = (comp1===comp2);
     Print[answer];
     ,{i,num,m}];
];

SNC[ia,ib,ic,id,ie,if,ig,ih,invx,invy,inv1x,inv1y];
SNC[inv1xy,inv1yx,inv1a,inv1b,inv1ab,inv1ba,LossLess,InvLossLess];

Print["init.m loaded for dugout directory"];
