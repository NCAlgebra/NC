(*  Shrink2 or ShrinkBasis.m   C++ compatible version
last changed 9/8/94
C++ directory
Notes:

There is a problem with SetGlobalPtr[] for this file.
It erases the Ordering on the Monomial.
We could have the order inputted as a list of lists
then use this each time by making another module that sets
the order from the list of lists.

or other special ways to get MorasAlgorithm to run
more than once per session.
*)

Clear[ShrinkBasis];
Clear[ShrinkSmall];
Clear[ShrinkMany];
Clear[ShrinkMain];

ShrinkBasis[polys_List,keep_List,iter_?NumberQ]:=
            ShrinkMain[polys,keep,iter];

ShrinkBasis[polys_List,keep_List]:=
            ShrinkMain[polys,keep,5];

ShrinkBasis[x___]:= Abort[];

ShrinkSmall[polys_List,keep_List,iter_?NumberQ]:=
Module[{temp,answerSmall,allanswer,rels,j},
Print["In ShrinkSmall"];
   Do[ item = polys[[j]];
       temp = Complement[polys,{item}];
       rels = Union[temp,keep];
Print["item :",item];
Print["temp :",temp];
Print["rels :",rels];
(*       SetGlobalPtr[];*)
       basis = NCMakeRules[rels,iter];
Print["basis :",basis];
       basis = Map[ToGBRule,basis]; (*new function from vic*)
       answerSmall[j] = Reduction[{item},basis];
Print["answerSmall[",ToString[j],"] :",answerSmall[j]];
       answerSmall[j] = Complement[answerSmall[j],{0}];
       If[ answerSmall[j] === {}
           ,answerSmall[j] = temp;
           ,answerSmall[j] = {};
       ];
Print["answerSmall[", ToString[j], "] :",answerSmall[j]];
   ,{j,1,Length[polys]}];
   allanswer = Table[answerSmall[j],{j,1,Length[polys]}];
   allanswer = Complement[allanswer,{{}}];
   Clear[answerSmall];
Print["Exiting ShrinkSmall"];
   Return[allanswer];
];

ShrinkMany[AListOfLists_List,keep_List,iter_?NumberQ]:=
Module[{temp,answerMany,result,j},
   Print["In ShrinkMany"];
   Do[ temp = AListOfLists[[j]];
       If[Length[temp] === 0
          , answerMany[j] = temp;
          , answerMany[j] = ShrinkSmall[temp,keep,iter];
       ];
Print["answerMany[", ToString[j], "] :",answerMany[j]];
   ,{j,1,Length[AListOfLists]}];
   result = Table[answerMany[j],{j,1,Length[AListOfLists]}];
   result = Flatten[result,1];
   Clear[answerMany];
   Print["Exiting ShrinkMany"];
   Return[result];
];

ShrinkMain[polynomials_List,keepalways_List,iter_?NumberQ]:=
Module[{firststep,shouldLoop,theSets,result,polys,keep},
   Print["Entering ShrinkBasis"];
   polys = polynomials /. Rule->Subtract;
   keep = keepalways /. Rule->Subtract;
   If[ polys === {}
       ,shouldLoop = False;
        result = {};
       ,theSets = {polys};
        firststep = ShrinkSmall[polys,keep,iter];
        shouldLoop = True;
   ];
   While[ shouldLoop,
          If[ Flatten[firststep] === {}
              ,result = theSets;
               shouldLoop = False;
               Print["ShrinkBasis has terminated"];
              ,theSets = firststep;
               firststep = ShrinkMany[firststep,keep,iter];
               firststep = Union[firststep,firststep];
          ];
   ];
   Return[result];
];

ReducePolys[polys_List,smallset_List,iter_?NumberQ]:=
Module[{basis,basisrules,answer},
   basis = NCMakeRules[smallset,iter];
   basisrules = ToGBRules[basis];
   answer = Reduction[polys,basisrules];
   answer = Complement[answer,{0}];
   Return[answer];
];
