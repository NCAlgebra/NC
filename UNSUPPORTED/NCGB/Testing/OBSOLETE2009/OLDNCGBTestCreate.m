If[$NC$Loaded$CreateReferences$ =!= True,
$NC$Loaded$CreateReferences$ = True;

Get["Time.m"];

DefaultFunction[input_,file_String,iterations_Integer,type_String] :=
  NCProcess[input,
            iterations,0,0,0,
            file,AdditionalRegularOutputOptions->{Latex->False},
	    RR->False,SB->False,RRByCat->False,SBByCat->False,NCCV->False];

NCMakeGBFunction[input_,file_String,iterations_Integer,type_String]:=
Module[{answer,outfile},
  answer=NCMakeGB[input,iterations];
  outfile=StringJoin[file,".",type];
  QuietDeleteFile[ outfile];
  Write[outfile,answer];
  Return[];
];

NCGBTestCreate[First_Integer,Last_Integer,InputFunction_,Type_]:=
Module[{Counter,InputSequence,InputFile,OutputFile,Answer},
  QuietDeleteFile[ "Status.Of.Test"];
  Do[ InputSequence="c";
      If[Counter<10,InputSequence=StringJoin[InputSequence,"0"]];
      InputSequence=StringJoin[InputSequence,ToString[Counter]];
      InputFile=StringJoin[$NC$TestInputs$,InputSequence,".data.m"];
      OutputFile=StringJoin[$NC$CurrentTest$,InputSequence,".out"];
      Iterations=6; (* Default number of iterations if not specified *)
      MoraAlg`ClearMonomialOrderAll[]; 
      Get[InputFile];

Pause[1];   
 
      StringJoin["Now working on:",
                 InputFile,"->",OutputFile,
                 " #",ToString[Iterations]] >>> Status.Of.Test;
      Start[];
      Answer=InputFunction[rels,OutputFile,Iterations,Type];
      If[And[Head[Answer]===Symbol,ToString[Answer]==="$Failed"]
        , Print["Have a $Failed.... "];
          Print["Terminating mathematica to get your attention"];
      ];
      NCGBTestCreateTimes[Counter] = Finish[];
  ,{Counter,First,Last}];
  Print[""];
  Print[""];
  Print[""];
  Print["Summary of times to create output:"];
  Print[""];
  Do[ Print["Test #:",Counter," took ",NCGBTestCreateTimes[Counter]];
  ,{Counter,First,Last}];
];

NCGBTestCreate[First_Integer,Last_Integer] := 
      NCGBTestCreate[First,Last,DefaultFunction,"tex"];

NCGBTestCreate[First_Integer,Last_Integer,InputFunction_] :=
      NCGBTestCreate[First,Last,InputFunction,"GB"];
];
