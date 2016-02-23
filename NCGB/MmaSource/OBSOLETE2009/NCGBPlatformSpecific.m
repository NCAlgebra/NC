(*   NCGBPlatformSpecific.m

  Platform specfic information is included in this file.

THE LINES YOU MAY HAVE TO EDIT ARE ABOUT 100 LINES DOWN !!!!!!

*)


BeginPackage["NCGBPlatformSpecific`"];


Clear[NCGBUseLaTeXStyle,NCGBUseLaTeXClass,LaTeXStyleOrClass];

NCGBUseLaTeXStyle::usage = 
  "NCGBUseLaTeXStyle[] forces \\documentstyle to be used with LaTeX";

NCGBUseLaTeXClass::usage = 
  "NCGBUseLaTeXClass[] forces \\documentclass to be used with LaTeX";

LaTeXStyleOrClass::usage = 
  "LaTeXStyleOrClass[] returns either \\documentclass or \\documentarticle";

Clear[NCGBSetLatexCommand,NCGBSetDviCommand,NCGBGetLatexCommand,
NCGBGetDviCommand];

NCGBSetLatexCommand::usage = 
    "NCGBSetLatexCommand[\"latex\"] indicates that the latex program should \
     be used for latex. Another choice might be \n\
     NCGBSetLatexCommand[\"\\\"c:Program Files\\WinEdt\\\"\];";

NCGBSetDviCommand::usage = 
    "NCGBSetDviCommand[\"xdvi\"] indicates that the xdvi program should \
     be used for prieviewing. Another choice might be \n\
     NCGBSetDviCommand[\"\\\"c:Program Files\\WinEdt\\\"\];";

NCGBGetLatexCommand::usage = 
    "NCGBGetLatexCommand[] returns either the default value or the \
value of the last argument to the function NCGBSetLatexCommand";

NCGBGetDviCommand::usage = 
    "NCGBGetDviCommand[] returns either the default value or the \
value of the last argument to the function NCGBSetDviCommand";

Clear[NCGBSetLatexFilePath,NCGBGetLatexFilePath];

NCGBSetLatexFilePath::usage =
    "NCGBSetLatexFilePath[aPath] indicates that the latex \
     files should be put in the directory described by the path\
     indicated by the string aPath.";

NCGBGetLatexFilePath::usage =
    "NCGBGetLatexFilePath[] returns either the default value or the \
value of the last argument to the function NCGBSetLatexFilePath. \
The default value is the empty string (which is interpreted as the current \
directory. If the path name is not the empty string, its last term must be \
a forward slash.";


Begin["`Private`"];

(******************************************************

  YOU MAY HAVE TO CHANGE THE FOLLOWING SETTINGS EXPLICITLY HERE!!!


  A few people may change them via the above function calls.

*******************************************************)

latexHeader = "class";
(*
PC in the 2nd floor lab:
latexCommand = "c:\\\\texmf\\\\miktex\\\\bin\\\\latex.exe";
dviCommand = "c:\\texmf\\miktex\\bin\\yap.Exe";
*)

(* Some PC's have latex and yap in the following places *)
(* 
latexCommand = "c:\\latex\\miktex\\bin\\latex.exe";
dviCommand = "c:\\latex\\miktex\\bin\\yap.Exe";
*)


(*
For unix:
*)
latexCommand = "latex";
dviCommand = "xdvi";

(******************************************************

  Do not change any code after this point.

*******************************************************)

NCGBSetLatexFilePath[x_String] := (
  If[And[Not[x===""],Not[StringTake[x,-1]==="/"]]
    , Print["Erroneous input to NCGBSetLatexFilePath"];
      Print["Appending a '/' to the end of the path"];
      latexPath = StringJoin[x,"/"];
    , latexPath = x;
  ];
);

latexPath = "";

NCGBGetLatexFilePath[] := latexPath;

NCGBUseLaTeXStyle[] := latexHeader = "style";

NCGBUseLaTeXClass[] := latexHeader = "class";

LaTeXStyleOrClass[] := latexHeader;

NCGBSetLatexCommand[x_String] := latexCommand  =  x;
NCGBSetDviCommand[x_String] := dviCommand  =  x;
NCGBGetLatexCommand[] := latexCommand;
NCGBGetDviCommand[] := dviCommand;

End[];
EndPackage[]
