(* :Title: 	smallMatchImplementation // Mathematica 1.2 and 2.0 *)

(* :Author: 	Unknown. *)

(* :Context:    MatchImplementation` *)

(* :Summary:    
*)

(* :Alias's:    None*)

(* :Warnings:   None.  *)

(* :History: 
*)

If[runningGeneral===False, Print["Reset runningGeneral and reGet"];
                           Abort[]
];

BeginPackage["MatchImplementation`",
      "MoraData`","SimplePower`","NonCommutativeMultiply`","Errors`"];

Clear[Match1Implementation];

Match1Implementation::usage = 
     "This routine is called by FindMatches.";

Clear[Match3Implementation];

Match3Implementation::usage = 
     "This routine is called by FindMatches.";

Clear[MoraMatchDebug];

MoraMatchDebug::usage =
     "MoraMatchDebug";

Clear[MoraMatchNoDebug];

MoraMatchNoDebug::usage =
     "MoraMatchNoDebug";

Begin["`Private`"];

MoraMatchDebug[] := debugMoraMatch = True;

MoraMatchDebug[x___] := BadCall["MoraMatchDebug",x];

MoraMatchNoDebug[] := debugMoraMatch = False;
 
MoraMatchNoDebug[x___] := BadCall["MoraMatchNoDebug",x];

MoraMatchNoDebug[];

Match1Implementation[{subterm1_},{subterm2_}] := 
Module[{var,newvar1,newvar2,power1,power2},
If[debugMoraMatch,Print["Starting match1 part 1"];];
    var = TheBase[subterm1];
    If[var===TheBase[subterm2],
If[debugMoraMatch,Print["Yes"];
                  Print["subterm1:",Format[subterm1,InputForm]];
                  Print["subterm2:",Format[subterm2,InputForm]];
];
         {extracond,extravar,left,right} = ExtraMatch[subterm1,subterm2,1];
         power1 = ThePower[subterm1];
         power2 = ThePower[subterm2];
         AddaMatch[1,1,left,right,extracond,extravar];
    ];
    Return[]
];

Match1Implementation[{subterm1_},term2_List] :=  Null /; Length[term2] > 1

Match1Implementation[term1_List,term2_List] := 
Module[{len1,len2,j},
    len1 = Length[term1];
    len2 = Length[term2];
    Do[Match1ImplementationAux[term1,term2,j],{j,1,len1-len2+1}];
    Return[]
];

Match1Implementation[x___] := BadCall["Match1Implementation",x];

Match1ImplementationAux[term1_List,term2_List,j_] := 
Module[{factor1,factor2,factor3,factor4,middle,alpha,gamma,
        extracond,extravar,left,right},
If[debugMoraMatch,Print["Starting match1 part 2"];];
If[debugMoraMatch, 
      Print["Checking"];
      Print["alpha = ",Format[Take[term1,{1,j-1}],InputForm]];
      Print["beta1 = ",Format[Take[term1,{j,j+Length[term2]-1}],InputForm]];
      Print["gamma = ",Format[Take[term1,{j+Length[term2],Length[term1]}],
                              InputForm]];
      Print["beta2 = ",Format[term2,InputForm]];
];
     factor1 = term1[[j]];
     factor2 = term1[[j+Length[term2]-1]];
     factor3 = term2[[1]];
     factor4 = term2[[-1]];
     If[TheBase[factor1]===TheBase[factor3],
          If[TheBase[factor2]===TheBase[factor4], 
                   If[Length[term2]<3
                           , middle = {{True},{}};
                           , middle = ExactEqual[
                                   Take[term1,{j+1,j+Length[term2]-2}],
                                   Take[term2,{2,-2}]
                                                ];
                   ];
                   If[middle[[1]]==={True},
If[debugMoraMatch,Print["Yes"];
                  Print["middle:",middle];
];
                        alpha  = Apply[NonCommutativeMultiply,
                                       Take[term1,{1,j-1}]];
                        gamma = Apply[NonCommutativeMultiply,
                                     Take[term1,
                                          {j+Length[term2],Length[term1]}
                                         ] 
                                    ];
                        {extracond,extravar,left,right} = 
                                        ExtraMatch[factor1,factor2,
                                                   factor3,factor4,1];
                        extracond = Join[middle[[2]],extracond];
                        If[Not[MemberQ[extracond,False]],
                                 AddaMatch[1,1,alpha**left,right**gamma,
                                           Join[extracond,middle[[2]]],
                                           extravar]
                        ];
                   ];
          ];
     ];
     Return[]
] /;   And[Length[term1] > 1,Length[term2] > 1]; 

Match1ImplementationAux[term1_List,{subterm2_},j_] := 
Module[{factor1,factor3,alpha,gamma,
        extracond,extravar,left,right},
If[debugMoraMatch,Print["Starting match1 part 3"];];
If[debugMoraMatch, 
      Print["Checking"];
      Print["alpha = ",Format[Take[term1,{1,j-1}],InputForm]];
      Print["beta1 = ",Format[Take[term1,{j,j}],InputForm]];
      Print["gamma = ",Format[Take[term1,{j+1,Length[term1]}],InputForm]];
      Print["beta2 = ",Format[{subterm2},InputForm]];
];
     factor1 = term1[[j]];
     factor3 = subterm2;
   
     If[TheBase[factor1]===TheBase[factor3] ,
If[debugMoraMatch,Print["Yes"];];
            alpha  = Apply[NonCommutativeMultiply,Take[term1,{1,j-1}]];
            gamma = Apply[NonCommutativeMultiply,
                       Take[term1,{j+1,Length[term1]}] 
                        ];
            {extracond,extravar,left,right} = ExtraMatch[factor1,factor3,1];
            If[Not[MemberQ[extracond,False]],
                   AddaMatch[1,1,alpha**left,right**gamma,
                             extracond,extravar]
            ];
     ];
     Return[]
] /;  Length[term1] > 1; 

Match3Implementation[{subterm1_},{subterm2_}] := 
Module[{var,newvar1,newvar2,power1,power2},
If[debugMoraMatch, Print["starting match3 part 1"];];
    var = TheBase[subterm1];
    If[var===TheBase[subterm2],
If[debugMoraMatch,Print["Yes"];
                  Print["subterm1:",Format[subterm1,InputForm]];
                  Print["subterm2:",Format[subterm2,InputForm]];
];
         newvar1 = Global`UniqueMonomial["Match3"];
         newvar2 = Global`UniqueMonomial["Match3"];
         power1 = ThePower[subterm1];
         power2 = ThePower[subterm2];
If[debugMoraMatch, Print[Format[
                         {var,newvar1,newvar2,
                          power1+ newvar1 == power2 + newvar2,
                          newvar1 >= 0,
                          newvar2 >= 0,
                          power1  <= power2 + newvar2,
                          power2  <= power1 + newvar1,
                          newvar1 <= power1 + power2,
                          newvar2 <= power1 + power2
                         },InputForm]];
                   Print[Format[
                     CommuteEverything[subterm1**(var^newvar1) - 
                                       (var^newvar2)**subterm2],
                                InputForm]
                   ];
                   Print[Format[
                     RuleElement[MoraData`Private`TheNumbers[[1]]][[1]]**
                     (var^newvar1) ==
                     (var^newvar2)**
                     RuleElement[MoraData`Private`TheNumbers[[2]]][[1]],
                       InputForm]
                   ];
];
         AddaMatch[1,var^newvar1,var^newvar2,1,
                   {power1 + newvar1 == power2 + newvar2,
                    newvar1 >= 0,
                    newvar2 >= 0,
                    power1  <= power2 + newvar2,
                    power2  <= power1 + newvar1,
                    newvar1 <= power1 + power2,
                    newvar2 <= power1 + power2
                   },
                   {newvar1,newvar2}
                  ];
    ];
    Return[]
];

Match3Implementation[{subterm1_},term2_List] :=
Module[{var,tau,power1,power2,newvar1,newvar2},
If[debugMoraMatch, Print["starting match3 part 2"];];
     var = TheBase[subterm1];
     If[var===TheBase[term2[[1]]], 
If[debugMoraMatch,Print["Yes"];
                  Print["subterm1:",Format[subterm1,InputForm]];
                  Print["term2:",Format[term2,InputForm]];
]; 
         tau = Apply[NonCommutativeMultiply,Take[term2,{2,-1}]];
         power1 = ThePower[subterm1];
         power2 = ThePower[term2[[1]]];
         newvar1 = Global`UniqueMonomial["Match3"];
         newvar2 = Global`UniqueMonomial["Match3"];
         AddaMatch[1,(var^newvar1)**tau,var^newvar2,1,
                   {power1 + newvar1 == power2 + newvar2,
                    newvar1 >= 0,
                    newvar2 >= 0,
                    power1  <= power2 + newvar2,
                    power2  <= power1 + newvar1,
                    newvar1 <= power1 + power2,
                    newvar2 <= power1 + power2
                   },
                   {newvar1,newvar2}
                  ];
        
     ];
     Return[];                      
] /; Length[term2] > 1

Match3Implementation[term1_List,{subterm2_}] :=
Module[{},
If[debugMoraMatch, Print["starting match3 part 3"];];
     var = TheBase[subterm2];
     If[var===TheBase[term1[[-1]]], 
If[debugMoraMatch,Print["Yes"];
                  Print["term1:",Format[term1,InputForm]];
                  Print["subterm2:",Format[subterm2,InputForm]];
]; 
         alpha = Apply[NonCommutativeMultiply,Take[term1,{1,-2}]];
         power1 = ThePower[term1[[-1]]];
         power2 = ThePower[subterm2];
         newvar1 = Global`UniqueMonomial["Match3"];
         newvar2 = Global`UniqueMonomial["Match3"];
         AddaMatch[1,(var^newvar1),alpha**(var^newvar2),1,
                   {power1 + newvar1 == power2 + newvar2,
                    newvar1 >= 0,
                    newvar2 >= 0,
                    power1  <= power2 + newvar2,
                    power2  <= power1 + newvar1,
                    newvar1 <= power1 + power2,
                    newvar2 <= power1 + power2
                   },
                   {newvar1,newvar2}
                  ];
        
     ];
     Return[];                      
] /;  Length[term1] > 1;

Match3Implementation[term1_List,term2_List] := 
Module[{The},
    The= Max[0,Length[term1]-Length[term2]]+1;
    Do[Match3ImplementationAux[term1,term2,j]
    ,{j,The,Length[term1]}];
    Return[]
] /; And[Length[term1] > 1,Length[term2]>1];

Match3Implementation[x___] := BadCall["Match3Implementation",x];

Match3ImplementationAux[term1_List,term2_List,j_Integer] :=
Module[{factor1,factor2,factor3,factor4,middle,alpha,gamma,
        extracond,extravar,left,right},
If[debugMoraMatch,
     Print["Starting match3 part 4"];
     Print["Checking"];
     Print["alpha = ",Format[Take[term1,{1,j-1}],InputForm]];
     Print["beta1 = ",Format[Take[term1,{j,Length[term1]}],InputForm]];
     Print["beta2 = ",Format[Take[term2,{1,Length[term1]-j+1}],InputForm]];
     Print["gamma = ",Format[Take[term2,{Length[term1]-j+2,Length[term2]}],
                             InputForm]];
];
     factor1 = term1[[j]];
     factor2 = term1[[-1]];
     factor3 = term2[[1]];
     factor4 = term2[[Length[term1] - j + 1]];
     If[TheBase[factor1]===TheBase[factor3] ,
          If[TheBase[factor2]===TheBase[factor4], 
                   If[2<=(Length[term1]-j)
                           , middle = ExactEqual[
                                   Take[term1,{j+1,-2}],
                                   Take[term2,{2,Length[term1]-j}]
                                                ];
                           , middle = {{True},{}};
                   ];
                   If[middle[[1]]==={True},
If[debugMoraMatch,Print["Yes"];];
                        alpha = Apply[NonCommutativeMultiply,
                                       Take[term1,{1,j-1}]];
                        gamma =  Apply[NonCommutativeMultiply,
                                       Take[term2,{Length[term1] - j + 2,-1}]];
                        {extracond,extravar,left,right} = 
                                    ExtraMatch[factor1,factor2,
                                               factor3,factor4,3];
                        extracond = Join[middle[[2]],extracond];
                        If[Not[MemberQ[extracond,False]],
                                 AddaMatch[1,right**gamma,alpha**left,1,
                                           Join[extracond,middle[[2]]],
                                           extravar]
                        ];
                   ];
          ];
     ];
     Return[];
];

Match3ImplementationAux[x___] := BadCall["Match3ImplementationAux",x];

ExtraMatch[factor1_,factor2_,factor3_,factor4_,j_] := 
Module[{left,right,power1,power2,power3,power4,
        newvar1,newvar2,newtemp,extraineq,newvars},
     If[factor1 =!= factor3
       ,  power1 = ThePower[factor1];
          power3 = ThePower[factor3];
          newvar1 = Global`UniqueMonomial["MoraVar"];
          newvars = {newvar1};
          left = TheBase[factor1]^newvar1;
          extraineq = {power1>=power3,
                       newvar1 >= 0,
                       newvar1 <= power1,
                       power1==power3 + newvar1};
       ,  left = 1;
          extraineq = {}; 
          newvars = {}; 
     ];
     If[factor2 =!= factor4,
          power2 = ThePower[factor2];
          power4 = ThePower[factor4];
          newvar2 = Global`UniqueMonomial["MoraVar"];
          AppendTo[newvars,newvar2];
          right = TheBase[factor2]^newvar2;
          Which[ 
             j===1, extraineq = Join[extraineq,{power2>=power4,
                                                newvar2 >= 0,
                                                newvar2 <= power2,
                                                power2==power4 + newvar2}
                                     ];
           , j===3, extraineq = Join[extraineq,{power4 == power2 + newvar2,
                                                power4 >= power2,
                                                newvar2 >= 0,
                                                newvar2 <= power4
                                               }
                                     ];
           , True ,  Print["Aborting from ExtraMatch"];
                     Abort[];
          ];
        , right = 1;
     ];
     extraineq = extraineq/.Equal[x_,y_]->Equal[x-y,0];
     If[MemberQ[extraineq,False], extraineq = {False}];
     Return[{extraineq,newvars,left,right}];
];

ExtraMatch[factor1_,factor3_,n_] :=
Module[{power1,power3,newvar1,newvar3,var,left,right,
        extraineq,newvars},
    power1 = ThePower[factor1];
    power3 = ThePower[factor3];
    If[power1=!=power3,  newvar1 = Global`UniqueMonomial["Match"];
                         newvar3 = Global`UniqueMonomial["Match"];
                         newvars = {newvar1,newvar3};
                         var =TheBase[factor1];
                         left = var^newvar1;
                         right = var^newvar3;
                         Which[
                              n===1, extraineq = {
                                   power1 == power3 + newvar1 + newvar3,
                                   newvar1 >= 0,
                                   newvar3 >= 0,
                                   newvar1 <= power1,
                                   newvar3 <= power1,
                                   power1 >= power3};
                            , n===3, extraineq = {
                               power1 - newvar1 == power3 - newvar3,
                               newvar1 >= 0,
                               newvar3 >= 0,
                               newvar1 <= power1,
                               newvar3 <= power3
                                        };
                         ];
                      ,  newvars = {};
                         extraineq = {};
                         left = 1;
                         right = 1;
    ];
    If[MemberQ[extraineq,False], extraineq = {False}];
    Return[{extraineq,newvars,left,right}];
];

ExtraMatch[x___] := BadCall["ExtraMatch",x];

ExactEqual[aList_List,anotherList_List] := 
Module[{len,result1,result2},
     If[Not[Length[aList]===Length[anotherList]], 
         Print["Severe error from ExactEqual"];
         Print[aList];
         Print[anotherList];
         Abort[];
     ];
     len = Length[aList];
     result1 = Table[ExactEqualAux1[aList[[j]],anotherList[[j]]],{j,1,len}];
     result1 = Union[result1,{True}];
     If[MemberQ[result1,False], result1 = {False};
                                result2 = {};
                              , result2 = Table[ExactEqualAux2[
                                                      aList[[j]],
                                                      anotherList[[j]]
                                                              ]
                                               ,{j,1,len}];
                                result2 = Union[result2];
     ];
     Return[{result1,result2}];
];

ExactEqual[x___] := BadCall["ExactEqual",x];

ExactEqualAux1[x_,y_] := TheBase[x]===TheBase[y];
ExactEqualAux1[x___] := BadCall["ExactEqualAux1",x];

ExactEqualAux2[x_,y_] := ThePower[x]==ThePower[y];
ExactEqualAux2[x___] := BadCall["ExactEqualAux2",x];

End[];
EndPackage[]
