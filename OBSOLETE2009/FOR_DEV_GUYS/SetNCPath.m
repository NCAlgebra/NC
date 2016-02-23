(* 
  You have to CHANGE THE FOLLOWING PATH ASSIGNMENT STATEMENT 
  so that the value inside the quotes is the same as the 
  directory which this file is in.
*) 

(* FOR UNIX AT UCSD WE USE -- YOU MUST CHANGE TO SUIT YOUR OWN PATH*)

$NCDir$ = "/home/ncalg/NC/";



(* FOR A  WINDOWS PC

             $NCDir$ = "C:/NC/";
*)

(* DO NOT WORRY ABOUT THIS  *)

$NC$Loaded$NCLoader$ = "SetNCDir.m";
AppendTo[$Path,$NCDir$];
If[Head[$NC$Machine$]===Symbol, $NC$Machine$ = "" ];

Get[StringJoin[$NCDir$,"NCPathCommonFile.m"]];
