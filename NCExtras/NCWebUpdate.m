(* :Title: 	NCWebUpdate *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context: 	None *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History:
*)

If[ ("AllowInternetUse" /. SystemInformation["Network"]) === False,
    Print["You have configured Mathematica not to access the internet. Too bad. 
	Please check the \"Allow Mathematica to use the Internet\" box in the
    Help \[FilledRightTriangle] Internet Connectivity dialog. Exiting now."];
    Quit[]
];

BeginPackage[ "NCWebUpdate`" ];

Clear[NCUpdate];

Get["NCWebUpdate.usage"];

Begin[ "`Private`" ]

  NCUpdate := Module[
    {existing, existingLabel, existingVersion,
     latestLabel, latestVersion,
     input},

    Print["************************************************************************"];
    Print["***      N C W e b U p d a t e: a web autoupdater for NCAlgebra      ***"];
    Print["************************************************************************"];
    
    (* Check for existing installations *)
    existing = FindFile["NC`"];
    If [ existing =!= $Failed,
         existing = DirectoryName[existing];
         {existingLabel, existingVersion} = 
           Import[FileNameJoin[{existing, 
                               "NC_VERSION"}]][[1, {1,2}]];
         existingVersion = StringTrim[existingVersion];
         
         Print["\n> Found an installation of"];
         Print["  ", existingLabel, " ", existingVersion];
         Print["  already in the directory"];
         Print["  ", existing];
         
        ,
         Print["\n > Could not find NCAlgebra installation."];
         Print["  Aborting..."];
         Return[];
    ];

    (* Retrieve latest NC_VERSION *)
    {latestLabel, latestVersion} = 
       Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NC_VERSION"][[1, {1,2}]];
    latestVersion = StringTrim[latestVersion];

    If[ latestVersion != existingVersion
       ,

         Print["\n> Latest version available is:"];
         Print["  ", latestLabel, " ", latestVersion];
               
       ,
         Print["\n> You are already running the latest version of NCAlgebra"];
         Print["  Exiting..."];
         Return[];
    ];
        
    input = "Z";
    While[ !(input == "Y" || input == "N")
          ,
           input = ToUpperCase[
             InputString["  Do you want to upgrade? (y/n) "]];
    ];
    If[ input == "Y"
       ,
        Print["> Upgrading..."];
        Print[];
        Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/NCWebInstall.m"];
       ,
        Print["  Exiting..."];
    ];
    
    Return[];
  ];
        
End[]

EndPackage[]
