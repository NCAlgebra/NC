preTransformArgs = {
         "preTransform`","NonCommutativeMultiply`",
         "ArrayManager`","Errors`","Global`"
                   };

If[TrueQ[runningGeneral], AppendTo[preTransformArgs,"Tuples`"];
                           AppendTo[preTransformArgs,"ManipulatePower`"];
];

Apply[BeginPackage,preTransformArgs];

If[runningGeneral, 

Clear[MakeLiteral];

MakeLiteral::usage = 
     "MakeLiteral";

Clear[SimpleLeftPatternRuleTuple];

SimpleLeftPatternRuleTuple::usage = 
     "SimpleLeftPatternRuleTuple";

];
Clear[preTransform];

preTransform::usage = 
     "preTransform";

Clear[ClearpreTransformData];

ClearpreTransformData::usage = 
     "ClearpreTransformData";

Clear[RecordpreTransformData];

RecordpreTransformData::usage = 
     "RecordpreTransformData";

Clear[WhatIspreTransformData];

WhatIspreTransformData::usage = 
     "WhatIspreTransformData";

Clear[preTransformRecord];

preTransformRecord::usage = 
     "preTransformRecord";

Clear[preTransformTag];

preTransformTag::usage = 
     "preTransformTag";

Begin["`Private`"];


ClearpreTransformData[] := InitializeArray[preTransformRecord];

ClearpreTransformData[x___] := BadCall["ClearpreTransformData",x];

RecordpreTransformData[x_] := 
     ( AppendToArray[preTransformRecord,x];
       x[[-1]]
     );
RecordpreTransformData[x___] := BadCall["ClearpreTransformData",x];

WhatIspreTransformData[] := ArrayToList[preTransformRecord];

WhatIspreTransformData[x___] := BadCall["ClearpreTransformData",x];

preTransform[aList_List,opts___Rule] := 
      Flatten[Map[preTransform[#,opts]&,aList]];

Options[preTransform] = {preTransformRecord->False,
                         preTransformTag->aRule};

preTransform[aRule_Rule,opts___Rule] := 
Block[{record,atag,prefront,preback,result}, 
     record = preTransformRecord/.{opts}/.Options[preTransform];
     atag = preTransformTag/.{opts}/.Options[preTransform];
     atag = ToString[Format[atag,InputForm]];
     frontstr = ToString[Format[prefront,InputForm]];
     backstr = ToString[Format[preback,InputForm]];
     SetNonCommutative[prefront,preback]; 
     If[record,
         result = ToExpression[StringJoin[
                     "Literal[NonCommutativeMultiply[",
                     frontstr,
                     "___,",
                     Aux[aRule[[1]]],",",
                     backstr,
                     "___]] :> RecordpreTransformData[{",
                     "NonCommutativeMultiply[",
                     frontstr,
                     "],NonCommutativeMultiply[",
                     backstr,
                     "],",
                     atag,
                     ",",
                     frontstr,
                     "**(",
                     ToString[Format[aRule[[2]],InputForm]],
                     ")**",
                     backstr,
                     "}]"]];
       , result = ToExpression[StringJoin[
                     "Literal[NonCommutativeMultiply[",
                     frontstr,
                     "___,",
                     Aux[aRule[[1]]],",",
                     backstr,
                     "___]] :> ",
                     frontstr,
                     "**(",
                     ToString[Format[aRule[[2]],InputForm]],
                     ")**",
                     backstr]];
     ];
     Return[{result,aRule}];
];

Aux[x_NonCommutativeMultiply] :=
Module[{str},
     str = ToString[Format[Apply[List,x],InputForm]];
     Return[StringTake[str,{2,-2}]];
];

Aux[x_] := ToString[Format[x,InputForm]];

Aux[x___] := BadCall["Aux",x];

If[Global`runningGeneral, Print["Getting preTransform2"];
                          Get["preTransform2.m"];
];

preTransform[x___] := BadCall["preTransform",x];

End[];
EndPackage[]
