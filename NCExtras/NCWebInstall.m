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
    Print["***    N C W e b I n s t a l l: a web autoinstaller for NCAlgebra    ***"];
    Print["************************************************************************"];

    (* Import NC_VERSION *)
    {label, version} = Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NC_VERSION"][[1, {1,2}]];
    version = StringTrim[version];
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
         version = StringTrim[version];
         
         Print["\n> There seems to be an installation of"];
         Print["  ", label, " ", version];
         Print["  already in the directory"];
         Print["  ", existing];
         
         (* Upgrade? *)
         Print[];
         Print["  Even though we recommend that you install on this same directory,"];
         Print["  beware that installation will completely erase the directory contents."];
         Print[];

         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["  Do you want to install on this " <>
                               "same directory, i.e. upgrade? (y/n) "]];
         ];
         If[ input == "Y"
            ,
             installdirectory = FileNameJoin[Drop[FileNameSplit[existing],-1]];
            ,
             
             Print[];
             Print["  Having multiple installations of NCAlgebra can create conflicts"];
             Print["  and we recommended that you remove the existing installation "];
             Print["  before proceeding."];
             Print[];
             
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
             Check[ DeleteDirectory[existing, DeleteContents->True];
                   ,
                    Print["\n> Something went wrong.\n  Aborting..."];
                    Return[];
             ];
            ,
             Print[];
             Print["  Proceeding without removing existing installation."];
             Print["  You might want to rename the directory"];
             Print["  ", existing];
             Print["  to avoid conflicts."];
         ];
    ];

    (* Default installation path *)
    If[ !ValueQ[installdirectory],
        installdirectory = FileNameJoin[{$UserBaseDirectory,"Applications"}];
        installdirectory = $HomeDirectory;
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
              InputString["  Do you want to change the installation directory? (y/n) "]];
    ];
    If[ input == "Y",
        
        Print["\n  Choose one of the options:"];
        Print["  1) '", $HomeDirectory, "' (recommended)"];
        Print["  2) '", 
              FileNameJoin[{$UserBaseDirectory,"Applications"}],
             "'"];
        Print["  3) Type in my own directory"];

        input = "Z";
        While[ !(input == "1" || input == "2" || input == "3")
              ,
               input = StringTrim[InputString["  Choice? (1/2/3) "]];
        ];
    
        installdirectory = 
          Switch[ input
                 ,
                  "1"
                 ,
                  $HomeDirectory
                 ,
                  "2"
                 ,
                  FileNameJoin[{$UserBaseDirectory,"Applications"}]
                 ,
                  "3"
                 ,
                  (* type in *) 
                 
                  StringTrim[InputString["  Type installation directory: "]]
        ];
    
        Print["\n> This program will install the latest version of NCAlgebra from:"];
        Print["  ", zipremote];
        Print["  in the directory:"];
        Print["  ", installdirectory];
    ];
    
    Print["\n> Last chance to change your mind."];
    
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
        Check[ CreateDirectory[installdirectory]
              ,
               Print["\n> Something went wrong.\n  Aborting..."];
               Return[];
        ];
    ];

    (* Download zip file *)
    ziplocal = FileNameJoin[{ installdirectory, FileNameTake @ zipremote}];
    dirlocal = FileNameJoin[{ installdirectory, "NC-master"}];
    nclocal = FileNameJoin[{ installdirectory, "NC"}];
    Print["\n> Downloading:"];
    Print["  ", zipremote];
    Print["  into:"];
    Print["  ", ziplocal];
    
    (* get rid of previous download *)
    If[ FileExistsQ[ziplocal],
        Print["\n> A local copy of the installation zip file already exists."];
        Print["  Deleting '", ziplocal, "'."];
        Check[ DeleteFile@ziplocal;
              ,
               Print["\n> Something went wrong.\n  Aborting..."];
               Return[];
        ];
    ];
    If[ DirectoryQ[dirlocal],
        Print["\n> A local copy of the expanded files already exists."];
        Print["  Deleting '", dirlocal, "'."];
        Check[ DeleteDirectory[dirlocal, DeleteContents->True];
              ,
               Print["\n> Something went wrong.\n  Aborting..."];
               Return[];
        ];
    ];
    If[ DirectoryQ[nclocal],
        Print["\n> A local copy of the package already exists."];
        Print["  Deleting '", nclocal, "'."];
        Check[ DeleteDirectory[nclocal, DeleteContents->True];
              ,
               Print["\n> Something went wrong.\n  Aborting..."];
               Return[];
        ];
    ];
       
    (* Download file *)
    fcfilesize = Unzip`URLFileByteSize[zipremote];
    Print[""];
    Print["> Transfering ", ToString[Round[fcfilesize/1024^2]], " MB from:"];
    Print["  ", zipremote];
    Print["  Please be patient..."];
    Check[ Unzip`CopyRemote[zipremote, ziplocal];
          ,
           Print["\n> Something went wrong.\n  Aborting..."];
           Return[];
    ];
    Print["  Done downloading."];

    Print["\n> Extracting NCAlgebra files to:"];
    Print["  ", installdirectory];
    Print["  Please be patient..."];
    Check[ Unzip`Unzip[ziplocal, installdirectory, Verbose -> False];
          ,
           Print["\n> Something went wrong.\n  Aborting..."];
           Return[];
    ];
    Print["  Done extracting files."];

    Print["  Removing downloaded installation file."];
    Check[ DeleteFile@ziplocal
          ,
           Print["\n> Something went wrong.\n  Aborting..."];
           Return[];
    ];
           
    Print["  Renaming installation folder."];
    Check[ RenameDirectory[ dirlocal,
                            FileNameJoin[{ installdirectory, "NC"}] ];
          ,
           Print["\n> Something went wrong.\n  Aborting..."];
           Return[];
    ];
       
    (* Go to $HomeDirectory *)
    SetDirectory[$HomeDirectory];
           
    (* Installled? *)
    If [ FindFile[ "NC`" ] === $Failed
        ,
         Print["> Post installation setup"];
         Print["\n  Directory"];
         Print["  ", installdirectory];
         Print["  does not to seem to be in the system $Path."];
         input = "Z";
         While[ !(input == "Y" || input == "N")
               ,
                input = ToUpperCase[
                   InputString["  Do you want to add this folder to the system $Path? (y/n) "]];
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
             WriteString[stream, "\n(* NCALGEBRA - BEGIN *)\n"];
             WriteString[stream, "AppendTo[$Path,\"", installdirectory, "\"];\n"];
             WriteString[stream, "(* NCALGEBRA - END *)\n\n"];
             Close[stream];
                   
             Print["\n  Trying to import init.m"];
             Get[initfile];
                   
            ,
             Print["  Proceeding without adding installation folder to system $Path."];
             Print["  You may not be able to load NCAlgebra!"];
         ];
        ,
         Print["  Looking good."];
    ];

    (* Load *)
    Print["\n> Try to load NC.\n"];
    If [ FindFile["NC`"] =!= $Failed,
         Quiet[Needs["NC`"], Needs::nocont],
         Print["Installation of NCAlgebra failed!"];
         Return[];
    ];
         
    Print["\n> Try to load NCAlgebra.\n"];
    If [ FindFile["NCAlgebra`"] =!= $Failed,
         Quiet[Needs["NCAlgebra`"], Needs::nocont],
         Print["Installation of NCAlgebra failed!"];
         Return[];
    ];
    Print["\n> Congratulations, you have succesfully intalled NCAlgebra!"];
    Print["\n> Type '<< NCTEST' to test basic NCAlgebra functionality."];

];