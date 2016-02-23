(*
  This loads in a purely-mathematica implementation of
  noncommutative Groebner Basis. 

  THIS IS NOT SUPPORTED, but sometimes you can use it.

  Never load this with the C++ GB coding. They probably
  conflict in some way.
*)

If[Not[Head[NC$OldMmaGB$Path$]===String]
  , $NC$OldMmaGB$Path$ = StringJoin[$NCDir$,"NCAlgebra/OldMmaGB/"];
];
AppendTo[$Path,$NC$OldMmaGB$Path$];






Get["MoraSettings.m"];
Get["NC1MoraGets.m"];
Get["NC2MoraGets.m"];
Get["NCSROneRule.m"];
