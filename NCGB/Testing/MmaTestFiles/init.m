AppendTo[$Path,"/home/osiris/helton/mathdir/NCAndMora"];
(*
doit:= <<doit;
*)
<<NCAlgebra.m;
<<superloop;
yo[num_?NumberQ]:=
Module[{},
  Get[StringJoin["test.",ToString[num]]];
  Put[ans, StringJoin["test.",ToString[num],".answer"]];
];

dude[x___]:= 
Print["Go to the dugout directory!!"];
