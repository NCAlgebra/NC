Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Print["DO NOT LOAD IN THIS FILE"];
Clear[NumberToString];
Clear[MonomialToString];
Clear[TermToString];
Clear[PolynomialToString];
Clear[MyToString];
Clear[CoefficientQ];
Clear[other];
Clear[regular];
Clear[CoefficientTypeStart];
Clear[CoefficientTypeEnd];

CoefficientQ[x_?NumberQ] := True;
CoefficientQ[x_] := False;
CoefficientQ[x___] := (Print["Coeff:",{x}];Abort[];);

CoefficientSet[x_] := 
Module[{},
   CoefficientType = x;
   Which[x=="numbers"
       , CoefficientTypeStart = "number[rational[";
         CoefficientTypeEnd = "]]";
       , x=="quotient"
       , CoefficientTypeStart = StringJoin[x,"["];
         CoefficientTypeEnd = "]";
       , True, Print["CoeffSet:",{x}];Abort[];
   ];
];

regular := CoefficientSet["numbers"];
other := CoefficientSet["quotient"];
regular;

NumberToString[num_?CoefficientQ] :=
Module[{result,top,bot},
   top = Numerator[num];
   bot = Denominator[num];
   Which[CoefficientType=="numbers"
       , top = MyToString[top];
         bot = MyToString[bot];
       , CoefficientType=="quotient"
       , If[NumberQ[top], top = MyToString[top];
                          top = StringJoin["plus[term[number[rational[",
                                           top,",1",
                                           "]],monomial[]]]"];
                        , top = PolynomialToString[top];
         ];  
         If[NumberQ[bot], bot = MyToString[bot];
                          bot = StringJoin["plus[term[number[rational[",
                                           bot,",1",
                                           "]],monomial[]]]"];
         ];
       , True, Print["NumberToString:",{CoefficientType}];Abort[];
   ];
   result = StringJoin[CoefficientTypeStart,
                       top,",",bot, 
                       CoefficientTypeEnd];
   Return[result];
];

MonomialToString[x_NonCommutativeMultiply] := MyToString[Apply[monomial,x]];

MonomialToString[x_] := MyToString[monomial[x]];

TermToString[num_?CoefficientQ] := 
   Which[
      CoefficientType=="numbers"
    , StringJoin["term[",
                 NumberToString[num],
                ",monomial[]]"] 
    , CoefficientType=="quotient"
    , StringJoin["tterm[",
                 NumberToString[num],
                ",monomial[]]"] 
    , True, Print["TermToString:",{CoefficientType}]; Abort[]
   ];
  
TermToString[num_?CoefficientQ monomial_] := 
Module[{number,mon,result},
   number = NumberToString[num];
   mon = MonomialToString[monomial];
   Which[CoefficientType=="numbers"
       , result = "term["<>number<>","<>mon<>"]";
       , CoefficientType=="quotient"
       , result = "tterm["<>number<>","<>mon<>"]"; 
       , True, Print["TermToString:",{CoefficientType}]; Abort[];
   ];
   Return[result];
];

TermToString[monomial_] := 
Module[{number,mon},
   number = NumberToString[1];
   mon = MonomialToString[monomial];
   Return["term["<>number<>","<>mon<>"]"];
];

PolynomialToString[poly_Plus] :=
Module[{len,result,item,j,aList,temp},
    aList = Apply[List,poly];
    len = Length[aList];
    result = "plus[";
    Do[ item = aList[[j]];
        temp = StringJoin[result,TermToString[item],","];
        result = temp;
    ,{j,1,len-1}];
    temp = StringJoin[result,TermToString[aList[[-1]]],"]"];
    Return[temp];
];

PolynomialToString[term_] := StringJoin["plus[",
                                       TermToString[term],
                                       "]"
                                       ];
    
OpenIt[x_String] := ActiveFile = OpenWrite[x,FormatType->InputForm];
CloseIt[] := Close[ActiveFile];

PolynomialToFile[math_] := 
    WriteString[ActiveFile,PolynomialToString[math],"\n"]; 

MyToString[x_?NumberQ] := ToString[Format[x,TextForm]];
MyToString[x_Symbol] := ToString[Format[x,TextForm]];

MyToString[x_] :=
Module[{str,i,temp},
   temp[0] = ToString[Format[Head[x],TextForm]];
   If[Length[x]>0
      , Do[ temp[i] = MyToString[x[[i]]];
        ,{i,1,Length[x]}];
        str = Table[{temp[i],","},{i,1,Length[x]}];
        str = Flatten[str];
        str = Take[str,{1,-2}];
        str = Apply[StringJoin,str];
        str = StringJoin[temp[0],"[",str,"]"];
     ,  str = temp[0];
   ];
   str = StringReplace[str," "->""];
   Clear[temp];
   Return[str];
];

