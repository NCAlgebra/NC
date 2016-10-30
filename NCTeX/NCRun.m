(* ::Package:: *)

(*  NCRun.m                                                                *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage["NCRun`"];

Clear[NCRun];
NCRun::error="Process exited with error code '`1`'.";

Clear[CommandPrefix]
Options[NCRun] = {
  Verbose -> True,
  CommandPrefix -> ""
};

Get["NCRun.usage"];

Begin["`Private`"];

  (* NCRun*)

  NCRun[Command_String, opts___Rule:{}] := Module[
    { command, exit, options, 
      verbose, commandPrefix },

    (* Process options *)
    options = Flatten[{opts}];

    { verbose, commandPrefix } = {Verbose, CommandPrefix}
                               /. options
                               /. Options[NCRun];

    command = commandPrefix <> Command 
            <> " 1> \"" <> $TemporaryPrefix <> "NCRun.out\""
            <> " 2> \"" <> $TemporaryPrefix <> "NCRun.err\"";
    If[ verbose, Print["> Running '", command, "'..."]];
    exit = Run[ command ];

    If[ exit =!= 0,
       Message[NCRun::error, exit];
       If[ verbose, 
         Print["Contents of file '" <> $TemporaryPrefix <> "NCRun.err':"];
         FilePrint[$TemporaryPrefix <> "NCRun.err"];
       ];
    ];

    Return[exit];

  ];


  (* Initialize NCRun *)

  If[ StringMatchQ[$SystemID, RegularExpression["^Mac.*"]],
    (* We are on a mac. Run path_helper *)
    SetOptions[NCRun, CommandPrefix -> "eval `/usr/libexec/path_helper`; "];
    (* We are on a mac. Look for fink *)
    Quiet[
      If [ NCRun["fink", Verbose -> False] =!= 0,
         (* try with prefix *)
         If [ NCRun["source /sw/bin/init.sh; fink", Verbose -> False] === 0, 
           (* fink is installed, setting prefix *)
           SetOptions[NCRun, CommandPrefix -> "source /sw/bin/init.sh; "];
         ];
      ];
      ,
      NCRun::error
    ];
  ];

End[];
EndPackage[];
