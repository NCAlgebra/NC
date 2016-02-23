(* 
       The right hand sides of the following two assignments can

       be either True or False.
*)

askRunning = False;
defaultRunning = False;

expandRuleTuples = False;

If[askRunning, Print["Do you want to run the general version of
the code?"];
               runningGeneral = Input["(True or False)"];
               If[runningGeneral,(**),(**), runningGeneral = defaultRunning;];
             , runningGeneral = defaultRunning;
];
If[runningGeneral
    , generalReduction = "smallNonSymbolicReduction.m";
    , generalReduction = "smallSymbolicReduction.m";
];
