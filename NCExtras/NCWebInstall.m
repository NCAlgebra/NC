(* 
   
   Call:

     Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/NCWebInstall.m"];

   from the Mathematica Kernel or FrontEnd to install NCAlgebra.
   
   This installation script is inspired by:

   http://www.feyncalc.org/install.m 

   by Rolf Mertig, GluonVision GmbH 
   
*)
   
If[ ("AllowInternetUse" /. SystemInformation["Network"]) === False,
    Print["You have configured Mathematica not to access the internet. Too bad. 
	Please check the \"Allow Mathematica to use the Internet\" box in the
    Help \[FilledRightTriangle] Internet Connectivity dialog. Exiting now."];
    Quit[]
];

Module[ 
    {existing, ziplocal, zipremote, 
     dirlocal, nclocal, fcfilesize,
     installdirectory,
     label, version, input,
     initfile, info, stream},

    Print["************************************************************************"];
    Print["***                     Welcome to NCWebInstall!                     ***"];
    Print["************************************************************************"];

    (* Import NC_VERSION *)
    {label, version} = Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NC_VERSION"][[1, {1,2}]];
    version = StringReplace[version, Whitespace -> ""];
    Print[];
    Print["> This program will install ", label, " ", version];
    
    (* Import Unzip *)
    Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/Unzip.m"];
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
         
         (* Rename folder *)
         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["  Do you want to install on this same directory? (y/n) "]];
         ];
         If[ input == "Y"
            ,
             installdirectory = FileNameJoin[Drop[FileNameSplit[existing],-1]];
            ,
             input = "Z";
             While[ !(input == "Y" || input == "N")
                   ,
                    input = ToUpperCase[
                       InputString["  Do you want to remove the existing installation? (y/n) "]];
             ];
         ];
         If[ input == "Y"
            ,
             Print["  Deleting '", existing, "'."];
             DeleteDirectory[existing, DeleteContents->True];
            ,
             Print["  Proceeding without removing existing installation."];
             Print["  You might want to rename the directory 'NC' to avoid conflicts."];
         ];
    ];

    (* Default installation path *)
    If[ !ValueQ[installdirectory],
        installdirectory = FileNameJoin[{$UserBaseDirectory,"Applications"}]
    ];
    
    zipremote = "https://github.com/NCAlgebra/NC/archive/master.zip";
    Print["\n> This program will install the latest version of NCAlgebra from:"];
    Print["  ", zipremote];
    Print["  in the directory:"];
    Print["  ", installdirectory];
    input = "Z";
    While[ !(input == "Y" || input == "N")
          ,
           input = ToUpperCase[
              InputString["  Do you want to proceed? (y/n) "]];
    ];
    If[ input == "N",
        Print["\n> Aborting..."];
        Return[];
    ];
                
    (* Create directory if needed *)
    If[ !DirectoryQ[installdirectory],
        Print["\n> Installation directory does not exist. Creating..."];
        CreateDirectory[installdirectory]
    ];

    (* Download zip file *)
    ziplocal = FileNameJoin[{ installdirectory, FileNameTake @ zipremote}];
    dirlocal = FileNameJoin[{ installdirectory, "NC-master"}];
    nclocal = FileNameJoin[{ installdirectory, "NC"}];
    Print["\n> Downloading:"];
    Print["  ", zipremote];
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
    fcfilesize = Unzip`URLFileByteSize[zipremote];
    Print[""];
    Print["> Downloading ", ToString[Round[fcfilesize/1024^2]], " MB from:"];
    Print["  ", zipremote];
    Print["  Please be patient..."];
    Unzip`CopyRemote[zipremote, ziplocal];
    Print["  Done downloading."];

    Print["\n> Extracting NCAlgebra files to:"];
    Print["  ", installdirectory];
    Print["  Please be patient..."];
    Unzip`Unzip[ziplocal, installdirectory, Verbose -> False];
    Print["  Done extracting files."];

    Print["  Renaming downloaded folder."];
    RenameDirectory[ dirlocal,
                     FileNameJoin[{ installdirectory, "NC"}] ];
          
    (* Installled? *)
    Print["\n> Installation successful?"];
    If [ FindFile[ "NC`" ] === $Failed
        ,
         Print["  Directory"];
         Print["  ", installdirectory];
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
             Print["  Adding '", installdirectory, "' to the system $Path"];
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
             Print["  Adding '", installdirectory, "' to $Path"];
             WriteString[stream, "\n(* NCINSTALL - BEGIN *)\n"];
             WriteString[stream, "AppendTo[$Path,\"", installdirectory, "\"];\n"];
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