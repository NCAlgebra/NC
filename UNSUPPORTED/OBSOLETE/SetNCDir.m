If[ Not[TrueQ[$NCAutoDir$]], 

  (* YOU SHOULD ONLY CHANGE THIS IF "<< NC`" GAVE YOU AN ERROR MESSAGE! *)
  (* MODIFY THIS LINE TO SUIT YOUR NC INSTALLATION PATH *)
  $NCDir$ = "/home/ncalg/NC/"; 
  (* $NCDir$ = "C:/NC/"; *) (* for a windows pc *)

];

(* DO NOT CHANGE ANYTHING BELOW THIS POINT  *)
$NC$Loaded$NCLoader$ = "SetNCDir.m";
AppendTo[$Path, $NCDir$];

(* CLEANED UP BY MAURICIO JUNE 2009 *)
(* If[Head[$NC$Machine$]===Symbol, $NC$Machine$ = "" ]; *)

Get[ToFileName[$NCDir$, "NCPathCommonFile.m"]];
