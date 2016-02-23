(*   
   This file helps with Samba. NCGBGet is the same as Get when Samba is not begin used.
     It is for use by the developers at UCSD
*)

NCGBLoad[x_String,cont_String] := If[Not[MemberQ[$Packages,cont]] , NCGBGet[x];];
NCGBLoad[x_String] :=  NCGBLoad[x,StringDrop[x,-2]<>"`"];

NCGBGet[x_String] := 
   With[{str = NCGBDecipherGet[x]}, ToExpression[str]];

NCGBGet := Get;

NCGBDecipherGet[x_String] := 
Module[{result = ""},
  If[StringMatchQ["//*",x]
    , result = StringJoin["Get[\"",x,"\"]"]
    , result = StringJoin[SaveNCGB[],PathDoNCGBPath[x],
                 "Get[\"",NameNCGB[x],"\"];",RestoreNCGBDirectory[]];
  ];
  Return[result];
];

$NC$SaveDirectory["count"] = 0;

Clear[SaveNCGB,RestoreNCGB,PathDoNCGBPath,NameNCGB];

SaveNCGB[] := 
   StringJoin["++$NC$SaveDirectory[\"count\"];",
              "$NC$SaveDirectory[$NC$SaveDirectory[\"count\"]]",
              "=Directory[];"
    ];
RestoreNCGBDirectory[] := 
   StringJoin["SetDirectory[$NC$SaveDirectory[$NC$SaveDirectory[\"count\"]]];",
              "$NC$SaveDirectory[\"count\"] -= 1;"
    ];
    
PathDoNCGBPath[x_String] := 
Module[{result = "",L = StringPosition[x,"/"]},
  If[Not[Length[L]==0]
    , result = StringJoin["SetDirectory[\"",StringTake[x,L[[-1,1]]],"\"];"];
  ];
  Return[result];
];

NameNCGB[x_String]:=
Module[{result = x,L = StringPosition[x,"/"]},
  If[Not[Length[L]==0]
    , result = StringDrop[x,L[[-1,1]]];
  ];
  Return[result];
];
