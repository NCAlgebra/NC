(***************************************************** 
*  Filename: NCInstall.m
*  Author: Tony Shaheen, 2002
*
*  History: None
*
*******************************************************)

NCTestPath[ pathToCheck_ ] := Module[ {}, 
  If[ FileNames[ pathToCheck <> "*" ] != {}, 
     Return[ True ];
  , (* else *)
     Return[ False ];
  ];
];


(* NCInstall does all the work *)
NCInstall[] := Module[ 
   { NCPossiblePaths, NCPath, NCFoundPath = False, NCFileStream },

Print[ "Running NCInstall..." ];

(************************************************************************)
(************************************************************************)
(* Add other paths to check in here inside of the list.                 *)
(* IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT          *)
(* MAKE SURE TO END YOUR PATHS WITH A \\ OR A /                         *)
(************************************************************************)
(************************************************************************)

If[ StringPosition[ $OperatingSystem, "indows" ] != {},

   (* WINDOWS...when you put in the paths make sure to use \\ 
      instead of \ for the windows paths *)
      
   NCPossiblePaths = { "C:\\NC\\" };

,(*else*)

   (* UNIX *)
   NCPossiblePaths = { "/home/ncalg/NC/" };

]; (* end if *)

(************************************************************************)
(************************************************************************)
(************************************************************************)
(************************************************************************)

(* find any other possible spots for NCAlgebra *)
For[ i = 1, i <= Length[$Path], i++, 

   (* do for windows "\\" and for unix "/" *)
   
   (* Look for the AddOns/Applications directory.  If you find it then
      add it in as a possible path to check for NC *)
   If[ StringPosition[ $Path[[i]], "AddOns/Applications" ] != {},
      NCPossiblePaths = Insert[ NCPossiblePaths, $Path[[i]] <> "/NC/" , 1 ];
   ];
   
   If[ StringPosition[ $Path[[i]], "AddOns\\Applications" ] != {},
      NCPossiblePaths = Insert[ NCPossiblePaths, $Path[[i]] <> "\\NC\\" , 1 ];
   ];
]; (* end for *)


(* Now it is time to try to find the NC directory *)
For[ i = 1, i <= Length[ NCPossiblePaths ], i++, 
   If[ NCTestPath[ NCPossiblePaths[[i]] ] == True, 
      NCPath = NCPossiblePaths[[i]];
      NCFoundPath = True;
   ];
]; (* end for *)


(* Check to see if you found the directory.  If we did, then generate the new 
   NCSetDir.m file in that directory.  If not, then output a message telling 
   the user what to do now. *)
If[ NCFoundPath == True,
   Print[ "NCALGEBRA HAS BEEN FOUND AT: ", NCPath ];
   Print[ "A new SetNCDir.m file will be generated in the above directory." ];
   
 (* now generate the new SetNCDir.m file *)
  NCFileStream = OpenWrite[ NCPath <> "SetNCDir.m" ];

  (* When we write the value of NCPath to the file if it is windows we have to use \\ not \ so lets 
     replace it before we write it. *)
  NCPath = StringReplace[ NCPath, { "\\" -> "\\\\" } ];   
  
  WriteString[ NCFileStream, "(*\n" ];
  WriteString[ NCFileStream, "You have to CHANGE THE FOLLOWING PATH ASSIGNMENT STATEMENT\n" ];
  WriteString[ NCFileStream, "so that the value inside the quotes is the same as the\n" ];
  WriteString[ NCFileStream, "directory which this file is in.\n" ];
  WriteString[ NCFileStream, "*)\n" ]; 
  WriteString[ NCFileStream, "\n" ];
  WriteString[ NCFileStream, "\n" ];
  WriteString[ NCFileStream, "$NCDir$ = \"" <> NCPath <> "\";\n" ];;
  WriteString[ NCFileStream, "\n" ];
  WriteString[ NCFileStream, "\n" ];
  WriteString[ NCFileStream, "(* DO NOT WORRY ABOUT THIS  *)\n" ];
  WriteString[ NCFileStream, "$NC$Loaded$NCLoader$ = \"SetNCDir.m\";\n" ];
  WriteString[ NCFileStream, "AppendTo[$Path,$NCDir$];\n" ];
  WriteString[ NCFileStream, "If[Head[$NC$Machine$]===Symbol, $NC$Machine$ = \"\" ];\n" ];
  WriteString[ NCFileStream, "\n" ];
  WriteString[ NCFileStream, "Get[StringJoin[$NCDir$,\"NCPathCommonFile.m\"]];\n" ];

  (* close the stream *)
  Close[ NCFileStream ];  

, (* else *)
   Print[ "We could not find the NC directory.\n" ];
   Print[ "Please go to www.math.ucsd.edu/~ncalg/   " ];
   Print[ "and download the instructions for installation in the download section; Starting.html." ];

]; (* end if *)


]; (* end module *)



(* Run NCInstall[] *)
NCInstall[];
