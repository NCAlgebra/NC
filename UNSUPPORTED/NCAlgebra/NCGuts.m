(* :Title: NCGuts // Mathematica 1.2 and 2.0 *)

(* :Author: Mauricio de Oliveira (mauricio). *)

(* :Context: NCGuts` *)

(* :Summary: NCGuts. *)

(* :Alias: *)

(* :Warnings: *)

(* :History: 
   :06/20/2001	Packaged. (mauricio)
*)

BeginPackage[
	      "NCGuts`",
              "NonCommutativeMultiply`",
	      "NCMatMult`"
	    ]

Clear[NCChangeGuts];

NCChangeGuts::usage = "NCChangeGuts[options]";

Options[ NCGuts ] := 
	{
		NCSetNC -> True,
		NCStrongProduct1 -> False,
		NCStrongProduct2 -> False
	};

Begin["`Private`"]

(* ------------------------------------------------------------------ *)
(* NCChangeGuts                                                       *)
(* ------------------------------------------------------------------ *)

NCGuts[options___] := Module[
	{},
	SetOptions[NCGuts, options];

	(* Define Hierachy for NCStrongProduct *)

	If [(NCStrongProduct2 /. {options}) == True,
		(* Set NCStrongProduct1 -> True *)
		SetOptions[ NCGuts, NCStrongProduct1 -> True ]];

	If [(NCStrongProduct1 /. {options}) == False,
		(* Set NCStrongProduct2 -> False *)
		SetOptions[ NCGuts, NCStrongProduct2 -> False ]];



	(* Process Symbols option *)
	If[ NCSetNC /. Options[NCGuts], 

		(* NCSetNC -> True *)
		CommutativeQ[_Symbol] := False,

		(* NCSetNC -> False *)
		CommutativeQ[_Symbol] := True
	];



	(* Process NCStrongProduct1 option *)
	If[ NCStrongProduct1 /. Options[NCGuts],

	(* NCStrongProduct1 -> True *)

		(* Treat lists and matrices as NonCommutative *)
		CommutativeQ[_List] = False;
		(* CommutativeAllQ[_List] = False; *)

		(* Define product and transpose rules for lists *)
		NonCommutativeMultiply[x_List,y_List]:=Inner[NonCommutativeMultiply,x,y,Plus];
		NonCommutativeMultiply[x_List,y_List,z__List]:=NonCommutativeMultiply[NonCommutativeMultiply[x,y],z];
		tp[x_?MatrixQ]:=Transpose[Map[tp,x,{2}]];

	,
	(* NCStrongProduct1 -> False *)

		(* Treat lists and matrices as NonCommutative *)
		CommutativeQ[_List] = True;
		(* CommutativeAllQ[_List] = True; *)

		(* Define dummy rules for lists to avoid warnings *)
		NonCommutativeMultiply[x_List,y_List]:=1;
		NonCommutativeMultiply[x_List,y_List,z__List]:=1;
		tp[x_?MatrixQ]:=1;

		(* Unset product and transpose rules for lists *)
		NonCommutativeMultiply[x_List,y_List]=.;
		NonCommutativeMultiply[x_List,y_List,z__List]=.;
		tp[x_?MatrixQ]=.;

	];



	(* Process NCStrongProduct2 option *)
	If[ NCStrongProduct2 /. Options[NCGuts],

	(* NCStrongProduct2 -> True *)

		(* Define expand rules for lists *)
		ExpandNonCommutativeMultiply[expr_] := 
			Expand[expr //. { 
				Literal[NonCommutativeMultiply[a___, b_Plus, c___]] :>
				  (NonCommutativeMultiply[a, #, c]& /@ b),
				Literal[NonCommutativeMultiply[a___,b_?MatrixQ,c_,d___]] :>
				  NonCommutativeMultiply[a,Map[NonCommutativeMultiply[#, c]&, b, {2}],d] /; !ListQ[c] && (Dimensions[b][[2]]==1),
				Literal[NonCommutativeMultiply[a___,b_,c_?MatrixQ,d___]] :>
				  NonCommutativeMultiply[a,Map[NonCommutativeMultiply[b, #]&, c, {2}],d] /; !ListQ[b] && (Dimensions[c][[1]]==1) }];

		(* Define inverse rule for matrices*)
		inv[x_?MatrixQ]:=NCMatMult`NCInverse[x];

	,
	(* NCStrongProduct2 -> False *)

		(* Define standard expand rule *)
		ExpandNonCommutativeMultiply[expr_] := 
			Expand[expr //.
				Literal[NonCommutativeMultiply[a___, b_Plus, c___]] :>
				  (NonCommutativeMultiply[a, #, c]& /@ b) ];

		(* Define dummy inverse rule for matrices *)
		inv[x_?MatrixQ]:=1;

		(* Unset inverse rule for matrices *)
		inv[x_?MatrixQ]:=1;
	];

]

End[ ]

EndPackage[ ]
