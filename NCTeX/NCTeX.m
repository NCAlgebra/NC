(*  NCTeX.m                                                                *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCTeX`",
	      "NCRun`" ];

Clear[NCRunLaTeX];
NCRunLaTeX::usage="NCRunLaTeX[file] typesets the LaTeX file with latex. \
Produces a dvi output."

Clear[NCRunPDFLaTeX];
NCRunPDFLaTeX::usage="NCRunLaTeX[file] typesets the LaTeX file with pdflatex. \
Produces a pdf output."

Clear[NCRunDVIPS];
NCRunDVIPS::usage="NCRunDVIPS[file] run dvips on file. \
Produces a ps output."

Clear[NCRunPS2PDF];
NCRunPS2PDF::usage="NCRunPS2PDF[file] run pd2pdf on file. \
Produces a pdf output."

Clear[NCRunPDFViewer];
NCRunPDFViewer::usage="NCRunPDFViewer[file] display pdf file."

Clear[NCTeX];
NCTeX::usage="NCTeX[exp] typesets the LaTeX version of expr produced \
with TeXForm or NCTeXForm using LaTeX."
NCTeX::failedImport="Failed importing pdf file. Viewer application will be started.";

Clear[DisplayPDF, ImportPDF, PDFViewer,
      LaTeXCommand, PDFLaTeXCommand, DVIPSCommand, PS2PDFCommand,
      BreakEquations];
Options[NCTeX] = {
  Verbose -> False,
  DisplayPDF -> False,
  ImportPDF -> True,
  BreakEquations -> True,
  TeXProcessor -> TeXForm,
  PDFViewer -> "",
  LaTeXCommand -> "latex",
  PDFLaTeXCommand -> "pdflatex",
  DVIPSCommand -> "dvips",
  PS2PDFCommand -> "epstopdf"
};

Begin["`Private`"];

(* Initialize TeXProcess *)
$PDFViewer = Switch[ $SystemID,
  "MacOSX-x86", 
  "open",
  "MacOSX-x86-64",
  "open",
  "Windows-x86-64",
  "start",
  "Windows", 
  "start",
  _, 
  "acroread"
];
SetOptions[NCTeX, PDFViewer -> $PDFViewer];
Print["NCTeX::Using '", $PDFViewer, "' as PDFViewer."];

(* TYPESETTING *)

NCRunLaTeX[fileName_String, runopts_String:"", opts___Rule:{}] := 
  NCRun[ 
    (LaTeXCommand /. Flatten[{opts}] /. Options[NCTeX, LaTeXCommand])
    <> " -output-directory="  
    <> If[ DirectoryName[fileName] === "", ".", DirectoryName[fileName] ]
    <> " " <> runopts <> " " <> fileName, opts ];

NCRunPDFLaTeX[fileName_String, runopts_String:"", opts___Rule:{}] := 
  NCRun[ 
    (PDFLaTeXCommand /. Flatten[{opts}] /. Options[NCTeX, PDFLaTeXCommand])
    <> " -output-directory=" 
    <> If[ DirectoryName[fileName] === "", ".", DirectoryName[fileName] ]
    <> " " <> runopts <> " " <> fileName, opts ];

NCRunDVIPS[fileName_String, runopts_String:"", opts___Rule:{}] := 
  NCRun[ 
    (DVIPSCommand /. Flatten[{opts}] /. Options[NCTeX, DVIPSCommand]) 
    <> " -o " <> fileName <> ".ps" 
    <> " " <> runopts <> " " <> fileName, opts ];

NCRunPS2PDF[fileName_String, runopts_String:"", opts___Rule:{}] := 
  NCRun[ 
    (PS2PDFCommand /. Flatten[{opts}] /. Options[NCTeX, PS2PDFCommand]) 
    <> " " <> runopts <> " " <> fileName, opts ];

NCRunPDFViewer[fileName_String, runopts_String:"", opts___Rule:{}] := 
  NCRun[ 
    (PDFViewer /. Flatten[{opts}] /. Options[NCTeX, PDFViewer]) 
    <> " " <> runopts <> " " <> fileName, opts ];

NCTeX[exp_, opts___Rule:{}] := 
  NCTeX[exp, $TemporaryPrefix <> "NCTeX", opts];

NCTeX[exp_, fileName_String, opts___Rule:{}] := Module[
  { file, command, packages, environment, pdfImage, importFailed, options, 
    verbose, displayPDF, importPDF, breakEquations, texProcessor, pdfViewer },

  (* Process options *)
  {verbose, displayPDF, importPDF, breakEquations, texProcessor, pdfViewer} 
    = { Verbose, DisplayPDF, ImportPDF, BreakEquations, TeXProcessor, PDFViewer }
    /. Flatten[{opts}]
    /. Options[NCTeX];

  (* set packages and environment *)  
  packages = If[ breakEquations, "amsmath,amsfonts,breqn", "amsmath,amsfonts" ];
  environment = If[ breakEquations, "dmath", "gather" ];

  If[ verbose, Print["* NCTeX - LaTeX processor for NCAlgebra - Version 0.1"]];

  (* Create LaTeX File - BEGIN *)
  If[ verbose, Print["> Creating temporary file '", fileName <> ".tex'..."]];
  file = OpenWrite[fileName <> ".tex", 
         FormatType -> StandardForm, 
         PageWidth -> Infinity];
  Write[file, "% Document created automatically be NCTeX" ];
  Write[file, "\\documentclass{article}" ];
  Write[file, "\\usepackage{", packages, "}" ];
  Write[file, "\\usepackage[margin=1in]{geometry}" ];
  Write[file, "\\begin{document}" ];
  Write[file, "\\pagestyle{empty}" ];
  Write[file, "\\begin{", environment, "*}" ];
  Write[file, texProcessor[exp]];
  Write[file, "\\end{", environment, "*}" ];
  Write[file, "\\end{document}" ];
  Close[file];
  (* Create LaTeX File - END *)

  (* Run LaTeX/DVIPS/EPSTOPDF *)
  If[ verbose, Print["> Processing '", fileName <> ".tex'..."]];
  NCRunLaTeX[fileName, Verbose -> verbose];
  NCRunDVIPS[fileName, "-E", Verbose -> verbose];
  NCRunPS2PDF[fileName <> ".ps", Verbose -> verbose];

  pdfImage = Null;
  If[ And[importPDF, $Notebooks], 
    If[ verbose, Print["> Importing pdf file '", fileName <> ".pdf'..."]];
    importFailed = False;
    Quiet[
      Check[
        pdfImage = Part[Import[fileName <> ".pdf"], 1];
        ,
        importFailed = displayPDF = True;
        pdfImage = $Failed;
      ];
    ];
    If[ importFailed, 
        Message[NCTeX::failedImport];
    ];
  ];

  If[ Or[Not[$Notebooks], displayPDF], 
  
    (* Open pdf file for viewing *)
    If[ verbose, Print["> Displaying '", fileName <> ".pdf'..."]];
    command = pdfViewer <> " " <> fileName <> ".pdf 2> " <> $TemporaryPrefix <> "NCTeX.tex.log.2 &";
    If[ verbose, Print["> Running '", command, "'..."]];
    Run[command];

  ];

  Return[pdfImage];

];

End[];
EndPackage[]
