(* :Title: 	NCDebug.m *)

(* :Author: 	Mauricio C. de Oliveira *)

(* :Context: 	NCDebug` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "NCDebug`" ];

Clear[NCDebug];

Get["NCDebug.usage"];

NCDebug::level = "NCDebug must be called with an integer level";

Clear[DebugLevel]

Options[NCDebug] = {
  DebugLevel -> 0,
  DebugLogfile -> $Output
};

Begin[ "`Private`" ]

PPrint[form_:InputForm, x_Rational] := form[InputForm[x]];
PPrint[form_:InputForm, x_] := form[x];

FormatSequence[form_:InputForm, x_Symbol] := 
  StringForm[ "`` = ``;\n\n", 
              SymbolName[Unevaluated[x]], 
              PPrint[form,x] ];

FormatSequence[form_:InputForm, x_String] := form[x <> "\n" ];

FormatSequence[form_:InputForm, x_] := 
  StringForm[ "(* `` = *) ``;\n\n", 
              form[
                StringCases[
                  ToString[InputForm[Unevaluated[x]]],
                  RegularExpression["^Unevaluated\[(.*)\]"] -> "$1"
                ]],
              PPrint[form,x] ];

(* NCDebug *)

NCDebug[level_Integer, message_, rest__] := 
  ( NCDebug[level, message];
    NCDebug[level, rest]; )

NCDebug[level_, message___] := Message[NCDebug::level];

NCDebug[level_Integer, message_] := Module[
  {tmp, debugFile},

  If[ (DebugLevel /. Options[NCDebug, DebugLevel]) >= level,
    debugFile = Flatten[{DebugLogfile /. Options[NCDebug, DebugLogfile]}];
    debugFile = Intersection[Streams[], debugFile];

    Map[WriteString[#, 
          FormatSequence[FormatType /. Options[#, FormatType], 
	  message]]&, 
      debugFile];
  ];
];

SetAttributes[NCDebug, HoldRest];
SetAttributes[FormatSequence, HoldRest];

End[]

EndPackage[]
