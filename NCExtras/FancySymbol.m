(* :Title: FancySymbol.m *)

(* :Author: Mauricio C. de Oliveira *)

(* :Context: FancySymbol` *)

(* :Sumary: *)

(* :Alias: *)

(* :Warnings: *)

(* :History:
   :06/01/2004: First Version
*)

BeginPackage[ 
	        "FancySymbol`"
];

Clear[FancySymbol]

FancySymbol::usage = "Provides an interface for setting visual atributes of symbols.";

Clear[UnknownDefaultStyle]

Clear[KnownDefaultStyle]

Begin["`Private`"]; 

FancySymbol[x_Symbol,options___]:=
    x/:MakeBoxes[x,StandardForm]:=StyleBox[x,options];
FancySymbol[x_List,options_List]:=Apply[FancySymbol[x,##]&,options];
FancySymbol[x_List,options___]:=Map[FancySymbol[#,options]&,x];

UnknownDefaultStyle={FontColor->RGBColor[1,0,0]};
KnownDefaultStyle={FontColor->RGBColor[0,1,0.2]};

End[];

EndPackage[];
