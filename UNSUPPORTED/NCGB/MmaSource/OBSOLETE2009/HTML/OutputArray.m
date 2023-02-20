Clear[OutputArray];
Clear[CreatePolynomialArray];
Clear[DividerLine];
Clear[OutputANumberCategory];

<<StreamClass.m;
<<OutputSingleCategory.m;

(*
CreatePolynomialArray[gbmarker_GBMarker,function_Symbol] :=
   CreatePolynomialArray[RetrieveMarker[gbmarker],function];
*)

CreatePolynomialArray[gbmarker_GBMarker,function_Symbol] :=
Module[{},  
  Print["MXS:NOTE:CreatePolynomialArray was called on a marker"];
  Print["Why? Send e-mail to mstankus@oba.ucsd.edu with explination of the code which you are running."];
  Clear[function];
];

CreatePolynomialArray[polynomials_List,function_Symbol]:=
Module[{poly,rule,i,str},
  Clear[function];
  Do[ poly=NCE[polynomials[[i]]];
      If[Not[polynomials[[i]]===poly]
        , rule=PolyToRule[poly];
          function[rule]=polynomials[[i]];
          Print["Polynomial : ",polynomials[[i]]];
          Print["corresponds to rule : ",rule];
      ];
  ,{i,Length[polynomials]}];  
];

OutputArray[anArray_Symbol] := OutputArray[anArray,$Output];

OutputArray[anArray_Symbol,stream_,NCCPolys_List,categorycutoff_] := 
Module[{i,j,k,singleRuleList,singleVarList,nonsingleVarList,poly,
        monomials,aMono,theNumbers,num,n,w,knowns,shouldOutput,
        aList,nccpolys,texrules,str,TeXString,columnwidth,baselineskip,
        rulewidth1,rulewidth2,rulewidth3,rulewidth4,rulewidth5,headerwidth,
        userselects},
  CreatePolynomialArray[NCCPolys,nccpolys];
  n = WhatIsMultiplicityOfGrading[];
  Print["Outputting results to the stream ",
        Format[stream,InputForm]];
  InitializeStreamClass[stream];
  singleRuleList = GetCategory["singleRules",anArray];
  If[Head[singleRuleList]===GBMarker
    , singleRuleList = RetrieveMarker[singleRuleList];
  ];
  singleVarList = anArray["singleVars"];
  If[Head[singleVarList]===GBMarker
    , singleVarList = RetrieveMarker[singleVarList];
  ];
  nonsingleVarList = anArray["nonsingleVars"];
  If[Head[nonsingleVarList]===GBMarker
    , nonsingleVarList = RetrieveMarker[nonsingleVarList];
  ];
  BeginHeader[];
  WriteString[stream,"THE ORDER IS NOW THE FOLLOWING:\n"];
  Do[ aList = WhatIsSetOfIndeterminants[j];
      If[Not[aList==={}]
         , Do[WriteStringAux[stream,aList[[w]]];
              WriteStringAppend[stream," < "];
          ,{w,1,Length[aList]-1}];
           WriteStringAux[stream,aList[[-1]]];
          If[j!=n
            ,WriteStringAppend[stream," << "];
          ];
      ];
  ,{j,1,n}];
  WriteStringNewLine[stream];
  WriteString[stream,
     "===================================================================="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "==================== YOUR SESSION HAS DIGESTED ====================="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "==================== THE FOLLOWING RELATIONS ======================="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "===================================================================="];
  WriteStringNewLine[stream];
  

  If[singleRuleList != {}
     ,WriteString[stream,"THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:\n"];
      WriteStringAux[stream,singleVarList];
      WriteStringNewLine[stream];
      WriteStringNewLine[stream];
      WriteString[stream,"The corresponding rules are the following:","\n"];
      Do[ WriteStringAux[stream,singleRuleList[[i]]];
          WriteStringNewLine[stream];
      ,{i,1,Length[singleRuleList]}];
  ];
  EndHeader[];
  theNumbers = Select[anArray["numbers"],#<categorycutoff&];
  notoutput = Complement[anArray["numbers"],theNumbers];
  userselects = unmarkerAndDestroy[anArray["userSelects"]];
  OutputANumberCategory[anArray,stream,0,
                            nccpolys,userselects];
  WriteString[stream,
    "===================================================================="];
  WriteStringNewLine[stream];
  WriteString[stream,
    "=================== USER CREATIONS APPEAR BELOW ===================="];
  WriteStringNewLine[stream];
  WriteString[stream,
    "===================================================================="];
  WriteStringNewLine[stream];
  num = anArray["userSelects"];
  Do[ poly = num[[i]];
      WriteStringAux[stream,poly];
      WriteStringNewLine[stream];
      If[Not[i==Length[num]]
        ,WriteStringNewLine[stream];
      ];
  ,{i,1,Length[num]}
  ];
  WriteString[stream,
     "===================================================================="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "=================== SOME RELATIONS WHICH APPEAR BELOW =============="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "========================== MAY BE UNDIGESTED ======================="];
  WriteStringNewLine[stream];
  WriteString[stream,
     "===================================================================="];
  WriteStringNewLine[stream];
  WriteString[stream,"THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\n"];
  WriteStringAux[stream,nonsingleVarList];
  WriteStringNewLine[stream];
  Do[num = theNumbers[[i]];
   If[Not[num===0]
     ,OutputANumberCategory[anArray,stream,num,
                 nccpolys,anArray["userSelects"]];
   ];
(* MXS
       monomials = anArray[num];
       WriteString[stream,"THE EXPRESSIONS WITH ",num," UNKNOWNS ARE THE FOLLOWING.\n"];
       WriteString[stream,
             "--------------------------------------------------\n"];

       Do[ aMono = monomials[[j]];
           shouldOutput = True;
           If[Length[anArray[aMono]]===1
             , If[MemberQ[singleRuleList,anArray[aMono][[1]]]
                  , shouldOutput = False;
               ];
           ];
           If[shouldOutput
               ,OutputASingleCategory[aMono,anArray,stream];
           ];
       ,{j,1,Length[monomials]}];
*)
  ,{i,1,Length[theNumbers]}];
  Print["Done outputting results to the stream ",
        Format[stream,InputForm]];
];

DividerLine[stream_] := WriteString[stream,
     "========= DIVIDER LINE =====================\n"];

OutputANumberCategory[anArray_Symbol,stream_,n_Integer,
         nccpolys_Symbol,userselects_List] :=
Module[{aMono,shouldOutput,monomials,j,outputedHeader},
  outputedHeader = False;
  monomials = anArray[n];
  Do[
    aMono = monomials[[j]];
    shouldOutput = True;
    If[Length[anArray[aMono]]===1
        , If[MemberQ[anArray["singleRules"],anArray[aMono][[1]]]
            , shouldOutput = False;
          ];
    ];
    If[shouldOutput
      , If[Not[outputHeader], 
           WriteString[stream,
    "----------------------------------------------------------------------\n"];
           WriteString[stream,"THE EXPRESSIONS WITH "
                             ,n
                             ," UNKNOWNS ARE THE FOLLOWING.\n"];
           outputedHeader = True;
        ];
        OutputASingleCategory[aMono,anArray,stream,nccpolys];
    ];
  ,{j,1,Length[monomials]}];
];
