(* 
   This is an installation file to be called once from within 
   a Mathematica Kernel or FrontEnd like this:

   Import["https://raw.githubusercontent.com/NCAlgebra/NC/devel/NCExtras/NCWebInstall.m"];

   By default the installation will be done to 

      FileNameJoin[{$UserBaseDirectory,"Applications"}]

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

$ZipFile = "https://github.com/NCAlgebra/NC/archive/devel.zip";

(* Default directory *)

If[ !ValueQ[$installdirectory],
    $installdirectory = FileNameJoin[{$UserBaseDirectory,"Applications"}]
];

Module[ 
    {existing, ziplocal, fcfilesize,
     label, version, input},

    Print["************************************"];
    Print["***   Welcome to NCWebInstall!   ***"];
    Print["************************************"];
    Print["This program install the latest version of NCAlgebra from:"];
    Print["  ", $ZipFile];
    Print["into the directory:"];
    Print["  ", $installdirectory];
    
    (* Import Unzip *)
    Import["https://raw.githubusercontent.com/NCAlgebra/NC/devel/NCExtras/Unzip.m"];
    Needs["Unzip`"];
    
    (* Check for existing installations *)
    existing = FindFile["NC`"];
    If [ existing =!= $Failed,
         existing = StringReplace[existing, a_ ~~ $PathnameSeparator <> "init.m" -> a];
         {label, version} = Import[FileNameJoin[{existing, 
                                                "NC_VERSION"}]][[1, {1,2}]];
         version = StringReplace[version, Whitespace -> ""];
         
         Print["> There seems to be an installation of NCAlgebra ",
               " already in the directory '", existing, "'."];
         Print["  Version: ", label, " ", version];
         Print["  Installing multiple copies of NCAlgebra may create conflicts."];
         
         (* Rename folder *)
         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["> Do you want NCWebInstall to rename " 
                               <> "the folder '" <> existing <> " as " 
                               <> existing <> version 
                               <> "'? (y/n) "]];
         ];
         If[ input == "Y"
            ,
             Print["> Renaming folder '", existing, "' as '", 
                   existing <> version];
             (* RenameDirectory[existing, existing <> version]; *)
            ,
             Print["> Proceeding without renaming folder."];
         ];
    ];

    If[ !DirectoryQ[$installdirectory],
        Print["> Installation directory does not exist. Creating..."];
        CreateDirectory[$installdirectory]
    ];

    ziplocal = FileNameJoin[{ $installdirectory, FileNameTake @ $ZipFile}];

    Print["> Downloading ", $ZipFile, " into directory ", ziplocal];
    
    (* get rid of previous download *)
    If[ FileExistsQ[ziplocal],
        Print["> Local file already exists. Deleting..."];
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

    Unzip`CopyRemote[$ZipFile, ziplocal];
    Print["> Done downloading."];
    Print["> Extracting NCAlgebra files to '", $installdirectory, "'"];
    Print["> Please wait..."];
          
    Unzip`Unzip[ziplocal, $installdirectory, Verbose -> False];
          
    Print["> Installation of NCAlgebra ready."];
    Print["> Loading NCAlgebra."];

    (* check if FeynCalc is installed. If not, install it *)
    If [ FindFile["NC`"] =!= $Failed,
         Needs["NC`"],
         Print["Installation of NCAlgebra failed!"]
    ];
    If [ FindFile["NCAlgebra`"] =!= $Failed,
         Needs["NCAlgebra`"],
         Print["Installation of NCAlgebra failed!"]
    ];
    Print["> Congratulations, you have succesfully intalled NCAlgebra!"];
];