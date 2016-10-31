(*  NCTeX.m                                                                *)
(*  Author: Mauricio de Oliveira                                           *)
(*    Date: June 2009                                                      *)
(* Version: 0.1 ( initial implementation )                                 *)

BeginPackage[ "NCTeX`",
	      "NCRun`" ];

Clear[NCRunLaTeX,
      NCRunPDFLaTeX,
      NCRunDVIPS,
      NCRunPS2PDF,
      NCRunPDFViewer,
      NCTeX];

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
  PDFLaTeXCommand -> Null,
  DVIPSCommand -> "dvips",
  PS2PDFCommand -> "epstopdf"
};
NCTeX::FailedImport = "Failed to import pdf.";

Get["NCTeX.usage"];

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
    verbose, displayPDF, importPDF, breakEquations, pdfLaTeXCommand,
    texProcessor, pdfViewer },

  (* Process options *)
  {verbose, displayPDF, importPDF, breakEquations, pdfLaTeXCommand,
   texProcessor, pdfViewer} 
    = { Verbose, DisplayPDF, ImportPDF, BreakEquations, PDFLaTeXCommand,
        TeXProcessor, PDFViewer }
    /. Flatten[{opts}]
    /. Options[NCTeX];

  (* set packages and environment *)  
  packages = "amsmath,amsfonts";
  If[ breakEquations,
      packages = packages <> ",breqn";
  ];
  environment = If[ breakEquations, "dmath", "gather" ];

  If[ verbose, Print["* NCTeX - LaTeX processor for NCAlgebra - Version 0.1"]];

  (* Create LaTeX File - BEGIN *)
  If[ verbose, Print["> Creating temporary file '", fileName <> ".tex'..."]];
  file = OpenWrite[fileName <> ".tex", 
         FormatType -> StandardForm, 
         PageWidth -> Infinity];
  Write[file, "% Document created automatically be NCTeX" ];
  Write[file, "\\documentclass{article}" ];
  (* Write[file, "\\documentclass[preview]{standalone}" ]; *)
  (* Write[file, "\\usepackage[margin=1in]{geometry}" ]; *)
  Write[file, "\\usepackage{", packages, "}" ];
  Write[file, "\\begin{document}" ];
  Write[file, "\\pagestyle{empty}" ];
  Write[file, "\\begin{", environment, "*}" ];
  Write[file, texProcessor[exp]];
  Write[file, "\\end{", environment, "*}" ];
  Write[file, "\\end{document}" ];
  Close[file];
  (* Create LaTeX File - END *)

  If[ verbose, Print["> Processing '", fileName <> ".tex'..."]];

  If[ pdfLaTeXCommand =!= Null
      ,
      (* Run PDFLaTeX *)
      Print["PDFLaTeX"];
      NCRunPDFLaTeX[fileName, Verbose -> verbose];
     ,
      (* Run LaTeX/DVIPS/EPSTOPDF *)
      NCRunLaTeX[fileName, Verbose -> verbose];
      NCRunDVIPS[fileName, "-E", Verbose -> verbose];
      NCRunPS2PDF[fileName <> ".ps", Verbose -> verbose];
  ];

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
        Message[NCTeX::FailedImport];
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
