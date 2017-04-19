(* 
   This is an installation file to be called once from within a Mathematica Kernel or FrontEnd like this:

   Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/install.m"];

   By default the installation will be done to 

      FileNameJoin[{$UserBaseDirectory,"Applications"}] ,

   However,this can be changed by uncommenting the next line:
   
*)

(* $installdirectory = FileNameJoin[{$BaseDirectory,"Applications"}]; *)

(* 

   This installation script is adapted from 

   http://www.feyncalc.org/install.m 

   by Rolf Mertig, GluonVision GmbH 
   
*)
   
If[ ("AllowInternetUse" /. SystemInformation["Network"]) === False,
    Print["You have configured Mathematica not to access the internet. Too bad. 
	Please check the \"Allow Mathematica to use the Internet\" box in the
    Help \[FilledRightTriangle] Internet Connectivity dialog. Exiting now."];
    Quit[]
];

$ZipFile = "https://github.com/NCAlgebra/NC/archive/master.zip";

(* Default directory *)

If[ !ValueQ[$installdirectory],
    $installdirectory = FileNameJoin[{$UserBaseDirectory,"Applications"}]
];

(* Import Unzip *)

Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/Unzip.m"];

Module[ 
    {ziplocal, fcfilesize},
    If[ !DirectoryQ[$installdirectory],
        CreateDirectory[$installdirectory]
    ];
    Print["> Downloading ", $ZipFile, ". Please wait..."];
    
    ziplocal = FileNameJoin[{ $installdirectory, FileNameTake @ $ZipFile}];

    (* get rid of previous download *)
    If[ FileExistsQ[ziplocal],
        DeleteFile@ziplocal
    ];
    fcfilesize = Unzip`URLFileByteSize[$ZipFile];
    If[ (Head[$FrontEnd]===System`FrontEndObject) && (Global`$FCProgressDisplay =!= False),
        PrintTemporary @  (* this way it does not get saved which is good *)
        Dynamic@Row[{"Downloading ", Round[fcfilesize/1024^2]," MB from ", 
        If[ StringQ[Setting@#],
            #,
            " "
        ] &@$ZipFile, " ", 
        ProgressIndicator[
         Quiet[If[ ! NumberQ[#],
                   0,
                   #
               ] &@( Refresh[FileByteCount[ziplocal], 
                     UpdateInterval -> .01]/fcfilesize )]],
        " ", If[ ! NumberQ[Setting@#],
                 0,
                 #
             ] &@
         Refresh[FileByteCount[ziplocal]/1024.^2, UpdateInterval -> .02], 
        " MByte"
        }],
        Print["> Downloading ", Round[fcfilesize/1024^2]," MB from ", $ZipFile]
    ];
    CopyRemote[$ZipFile, ziplocal];
    Print["> Downloading done, installing NCAlgebra on ", Style[$installdirectory, FontWeight -> "Bold"]];
    (* Unzip[ziplocal, $installdirectory, Verbose -> False]; *)
    Print["> Installation of NCAlgebra ready."];
    Print["> Loading NCAlgebra."];

    (*
    (* check if FeynCalc is installed. If not, install it *)
    Which [ 
           FindFile["NC`"] =!= $Failed,
           Needs["NC`"],
           FindFile["NCAlgebra`"] =!= $Failed,
           Needs["NCAlgebra`"],
           True,
           Print["Installation of NCAlgebra failed!"]
    ];
];