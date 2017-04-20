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
    {existing, ziplocal, dirlocal, nclocal, fcfilesize,
     label, version, input,
     initfile, info, stream},

    Print["************************************************************************"];
    Print["***                     Welcome to NCWebInstall!                     ***"];
    Print["************************************************************************"];
    Print["\n> This program install the latest version of NCAlgebra from:"];
    Print["  ", $ZipFile];
    Print["  into the directory:"];
    Print["  ", $installdirectory];

    (* Import Unzip *)
    Import["https://raw.githubusercontent.com/NCAlgebra/NC/devel/NCExtras/Unzip.m"];
    Needs["Unzip`"];
    
    (* Check for existing installations *)
    existing = FindFile["NC`"];
    If [ existing =!= $Failed,
         existing = DirectoryName[existing];
         {label, version} = Import[FileNameJoin[{existing, 
                                                "NC_VERSION"}]][[1, {1,2}]];
         version = StringReplace[version, Whitespace -> ""];
         
         Print["\n> There seems to be an installation of"];
         Print["  ", label, " ", version];
         Print["  already in the directory"];
         Print["  ", existing];
         Print["  Installing multiple copies of NCAlgebra may create conflicts."];
         
         (* Rename folder *)
         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["  Do you want NCWebInstall to rename " 
                               <> "this folder as '" 
                               <> existing <> version 
                               <> "'? (y/n) "]];
         ];
         If[ input == "Y"
            ,
             Print["  Renaming folder '", existing, "' as '", 
                   existing <> version];
             Print["  You may have to manually remove the old directory from $Path."];
             (* RenameDirectory[existing, existing <> version]; *)
            ,
             Print["  Proceeding without renaming folder."];
         ];
    ];

    (* Create directory if needed *)
    If[ !DirectoryQ[$installdirectory],
        Print["\n> Installation directory does not exist. Creating..."];
        CreateDirectory[$installdirectory]
    ];

    (* Download zip file *)
    ziplocal = FileNameJoin[{ $installdirectory, FileNameTake @ $ZipFile}];
    dirlocal = FileNameJoin[{ $installdirectory, "NC-devel"}];
    nclocal = FileNameJoin[{ $installdirectory, "NC"}];
    Print["\n> Downloading:"];
    Print["  ", $ZipFile];
    Print["  into directory:"];
    Print["  ", ziplocal];
    
    (* get rid of previous download *)
    If[ FileExistsQ[ziplocal],
        Print["\n> A local copy of the zip file already exists."];
        Print["  Deleting '", ziplocal, "'."];
        DeleteFile@ziplocal
    ];
    If[ DirectoryQ[dirlocal],
        Print["\n> A local copy of the expanded files already exists."];
        Print["  Deleting '", dirlocal, "'."];
        DeleteDirectory[dirlocal, DeleteContents->True];
    ];
    If[ DirectoryQ[nclocal],
        Print["\n> A local copy of the package already exists."];
        Print["  Deleting '", nclocal, "'."];
        DeleteDirectory[nclocal, DeleteContents->True];
    ];
       
    (* Download file *)
    fcfilesize = Unzip`URLFileByteSize[$ZipFile];
    Print[""];
    Print["> Downloading ", ToString[Round[fcfilesize/1024^2]], " MB from:"];
    Print["  ", $ZipFile];
    Print["  Please be patient..."];
    Unzip`CopyRemote[$ZipFile, ziplocal];
    Print["  Done downloading."];

    Print["\n> Extracting NCAlgebra files to:"];
    Print["  ", $installdirectory];
    Print["  Please be patient..."];
    Unzip`Unzip[ziplocal, $installdirectory, Verbose -> False];
    Print["  Done extracting files."];

    Print["  Renaming downloaded folder."];
    RenameDirectory[ dirlocal,
                     FileNameJoin[{ $installdirectory, "NC"}] ];
          
    (* Installled? *)
    Print["\n> Installation successful?"];
    If [ FindFile[ "NC`" ] === $Failed
        ,
         Print["  Directory"];
         Print["  ", $installdirectory];
         Print["  does not to seem in the system $Path."];
         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["  Do you want NCWebInstall to add " 
                               <> "this folder to the system $Path? (y/n) "]];
         ];
         If[ input == "Y"
            ,
             Print["  Adding '", $installdirectory, "' to the system $Path"];
             initfile = FileNameJoin[{$UserBaseDirectory, "Kernel", "init.m"}];
             Print["  Looking for user's init.m file..."];
             info = FileInformation[initfile];
             stream = If[ info === {}
                         ,
                          Print["  User does not have an init.m file."];
                          Print["  Creating '", initfile, "'"];
                          OpenWrite[initfile]
                        ,
                          Print["  User already has an init file"];
                          Print["  Appending to '", initfile, "'"];
                          OpenAppend[initfile]
             ];
             Print["  Adding '", $installdirectory, "' to $Path"];
             WriteString[stream, "\n(* NCINSTALL - BEGIN *)\n"];
             WriteString[stream, "AppendTo[$Path,\"", $installdirectory, "\"];\n"];
             WriteString[stream, "(* NCINSTALL - END *)\n\n"];
             Close[stream];
            ,
             Print["  Proceeding without adding folder to $Path."];
             Print["  You may not be able to load NCAlgebra!"];
         ];
        ,
         Print["  Looking good."];
    ];

    (* Load *)
    Print["\n> Try to load NC.\n"];
    If [ FindFile["NC`"] =!= $Failed,
         Quiet[Needs["NC`"], Needs::nocont],
         Print["Installation of NCAlgebra failed!"]
         Return[];
    ];
         
    Print["\n> Try to load NCAlgebra.\n"];
    If [ FindFile["NCAlgebra`"] =!= $Failed,
         Quiet[Needs["NCAlgebra`"], Needs::nocont],
         Print["Installation of NCAlgebra failed!"]
         Return[];
    ];
    Print["\n> Congratulations, you have succesfully intalled NCAlgebra!"];
    Print["\n> Type '<< NCTEST' to test basic NCAlgebra functionality."];

];