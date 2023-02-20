(* :Title: 	Errors // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	Errors` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)
BeginPackage["Errors`"];

Clear[BadCall];

BadCall::usage = 
    "BadCall[string,rest] reports an error message \
     indicating that the routine with name \
     given by string was called incorrectly and rest \
     is the nonheaded list of parameters sent to that routine. \
     BadCall records the erroneous arguments. See \
     WhatAreBadArgs. BadCall then makes the aggresive move \
     of calling Abort[]!";

Options[BadCall] = {
  Verbose -> False;
};

Clear[WhatAreBadArgs];

WhatAreBadArgs::usage = 
     "WhatAreBadArgs[] returns the error list of the \
      most recent call to BadCall. See BadCall.";

BadStack::usage =
     "BadStack is the bad stack.";

Begin["`Private`"];

Clear[$ErrorArgs];

BadCall[name_String, param___] := Block[
    {},

    (* save parameters *)
    $ErrorArgs = List[param];

    (* save stack *)
    Clear[BadStack];
    BadStack[] = Stack[];
    Map[(BadStack[#] = Stack[#])&,Union[BadStack[]]];

    (* print message *)
    If [ Verbose /. Options[BadCall],
      Print["Severe error from :-( ", name];
      Print["The parameters are (as a list): ", Short[ErrorArgs,3] ];
      Print["Bad argument can be retrieved by a call to WhatAreBadArgs"];
      Print["The call occured while in the context '",$Context, "'."];
    ];

    (* Use Throw? *)
    If[Global`$NC$isCatching$===True
      , Print[Throw[BadCallOf[name, param]]];
    ];

    Abort[];
];

BadCall[___] := 
Block[{},
      Print["If you see this message, send a message to ncalg@osiris.ucsd.edu and"];
      Print["tell us that we have a bad call error from the context ",$Context,"."];
      Abort[];
];
      
WhatAreBadArgs[] := ErrorArgs;

End[];
EndPackage[]
