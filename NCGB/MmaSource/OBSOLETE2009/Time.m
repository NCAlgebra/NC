Start[]:=Start[-1];
Start[x_]:=
Module[{},
   startingtime[x]=Date[];
   Return[];
];

Finish[]:=Finish[-1];
Finish[x_]:=
Module[{time,string},
   time=Date[]-startingtime[x];
   If[time[[6]]<0,
      time[[6]]=time[[6]]+60;
      time[[5]]=time[[5]]-1;
     ];
   If[time[[5]]<0,
      time[[5]]=time[[5]]+60;
      time[[4]]=time[[4]]-1;
     ];
   If[time[[4]]<0,
      time[[4]]=time[[4]]+24;
     ];
   string=ToString[time[[4]]];
   If[time[[5]]<10,
     string=string<>":0"<>ToString[time[[5]]],
     string=string<>":"<>ToString[time[[5]]]
     ];
   If[time[[6]]<10,
     string=string<>":0"<>ToString[time[[6]]],
     string=string<>":"<>ToString[time[[6]]]
     ];
   Return[string];
];

ClearTime[]:=Clear[startingtime];
ClearTime[];

