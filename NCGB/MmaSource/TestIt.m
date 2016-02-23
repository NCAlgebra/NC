Clear[TestIt];
Clear[WhatAreTests];
(* << Time.m; *)

WhatAreTests[]:=
Module[{result},
  result=ColumnForm[FileNames[
     {"NCMakeGB_Test*","SmallBasis_Test*",
      "SmallBasisByCategory_Test*","RemoveRedundent_Test*"},$Path,1]]; 
  Return[result];
];
   
WhatAreTests[arg_]:=
Module[{result,str},
  If[NumberQ[arg],
    result=ColumnForm[FileNames[{"NCMakeGB_Test"<>ToString[arg]<>"*",
                               "SmallBasis_Test"<>ToString[arg]<>"*",
                          "SmallBasisByCategory_Test"<>ToString[arg]<>"*",
                    "RemoveRedundent_Test"<>ToString[arg]<>"*"},$Path,1]]; 
    Return[result];
    ];
  str=ToString[arg];
  Switch[str,
    "N",
    result=ColumnForm[FileNames["NCMakeGB_Test*",$Path,1]], 
    "S",
    result=ColumnForm[Join[FileNames["SmallBasis_Test*",$Path,1], 
                         FileNames["SmallBasisByCategory_Test*",$Path,1]]], 
    "R",
    result=ColumnForm[FileNames["RemoveRedundent_Test*",$Path,1]],
    str,
    result=WhatAreTests[] 
     ];
  Return[result];
];

WhatsWrong[answer_List,answerglobal_List]:=
Module[{whatsthis,whereisit},
     Print["This answer =",answer];
     Print["Answer on file =",answerglobal];
     whatsthis=Complement[answer,answerglobal];
     whereisit=Complement[answerglobal,answer];
     If[Not[whatsthis==={}]
      ,Print["You produced the following relations,",
             " but the original function did not."];
       Print[whatsthis];
     ];
     If[Not[whereisit=={}]
        ,Print["You did not produce the following relations,",
               " but the original function did."];
         Print[whereisit];
     ];
];

TestIt[test_Integer,function_Symbol,iter___Integer]:=
Module[{result,answer,arguments,answerfile},
   ClearMonomialOrderAll[];
   ClearMonomialOrder[];
   Get[StringJoin["DataForTest",ToString[test]]];
   Start[];
   If[function==RR,function=RemoveRedundent];
   If[function==SB,function=SmallBasis];
   If[function==SBByCat,function=SmallBasisByCategory];
   Switch[function
    ,RemoveRedundent
       ,answerfile=StringJoin["RemoveRedundent_Test",ToString[test]];
        arguments={relationsglobal,historyglobal};
    ,SmallBasis
       ,answerfile=StringJoin["SmallBasis_Test",ToString[test],
                      "_Iter",ToString[iter]];
        arguments={relationsglobal,{},iter};
    ,SmallBasisRR
       ,answerfile=StringJoin["SmallBasis_Test",ToString[test],
                      "_Iter",ToString[iter]];
        arguments={relationsglobal,{},iter};
    ,NCMakeGB
       ,answerfile=StringJoin["NCMakeGB_Test",ToString[test],
                      "_Iter",ToString[iter]];
        arguments={relationsglobal,iter};
    ,SmallBasisByCategory
       ,answerfile=StringJoin["SmallBasisByCategory_Test",ToString[test],
                      "_Iter",ToString[iter]];
        arguments={relationsglobal,iter};
      ];
   Get[answerfile];
   answer=Apply[function,arguments];
   If[answer===answerglobal
      ,result=True;
      ,WhatsWrong[answer,answerglobal];
      result=False; 
     ];
   Print["This is the time for the original run ",runtime];
   Print["This is the time for this run ",Finish[]];

   Return[result];
];


