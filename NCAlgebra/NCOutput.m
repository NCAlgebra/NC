(* :Title: NCOutput *)

(* :Context: NCOutput`, Notation`, and NonCommutativeMultiply` *)

BeginPackage["NCOutput`",
	     If[ $Notebooks
		,
		 {"Notation`",
         	  "NCUtil`",
                  "NonCommutativeMultiply`"}
		,
                 {"NCUtil`",
		  "NonCommutativeMultiply`"}
	     ]];

Clear[NCSetOutput];

Get["NCOutput.usage", CharacterEncoding->"UTF8"];

Options[NCSetOutput] = {
  NonCommutativeMultiply -> False,
  rt -> True,
  tp -> True,
  aj -> True,
  co -> True,
  inv -> True
};

Begin["`Private`"];

  NCSetOutput[opts___Rule:{}] :=
    Module[{options},

      (* Process options *)
      options = Flatten[{opts}];

      (* All *)
      If[ Length[options] == 1 && options[[1,1]] == All,
	  options = Map[Rule[#, options[[1,2]]]&, Options[NCSetOutput][[All, 1]]];
      ];

      (* pretty tp *)
      
      SetOptions[NCSetOutput, tp -> (tp /. options /. Options[NCSetOutput])];
      If[ tp /. Options[NCSetOutput]
         ,
          tp /: MakeBoxes[tp[a_], fmt_] :=
                  SuperscriptBox[MakeBoxes[a, fmt],
                     MakeBoxes[Global`T, fmt]];
         ,
          Quiet[tp /: MakeBoxes[tp[a_], fmt_] =., Unset::norep];
      ];

      (* pretty aj *)

      SetOptions[NCSetOutput, aj -> (aj /. options /. Options[NCSetOutput])];
      If[ aj /. Options[NCSetOutput]
         ,
          aj /: MakeBoxes[aj[a_], fmt_] := MakeBoxes[SuperStar[a], fmt];
         ,
          Quiet[aj /: MakeBoxes[aj[a_], fmt_] =., Unset::norep];
      ];

      (* pretty co *)
      
      SetOptions[NCSetOutput, co -> (co /. options /. Options[NCSetOutput])];
      If[ co /. Options[NCSetOutput]
         ,
          co /: MakeBoxes[co[a_], fmt_] := MakeBoxes[OverBar[a], fmt];
         ,
          Quiet[co /: MakeBoxes[co[a_], fmt_] =., Unset::norep];
      ];
      
      (* pretty rt *)
      
      SetOptions[NCSetOutput, rt -> (rt /. options /. Options[NCSetOutput])];
      If[ rt /. Options[NCSetOutput]
         ,
          rt /: MakeBoxes[rt[a_], fmt_] :=
              SuperscriptBox[Parenthesize[a, fmt, Superscript, Left],
                   MakeBoxes[1/2, fmt]];
         ,
          Quiet[rt /: MakeBoxes[rt[a_], fmt_] =., Unset::norep];
      ];
        
      (* pretty inv *)
      
      SetOptions[NCSetOutput, inv -> (inv /. options /. Options[NCSetOutput])];
      If[ inv /. Options[NCSetOutput]
         ,
	  Unprotect[Power];
	  If[ $Notebooks
	     ,
	      Quiet[
                Power /: Format[Power[a_?NCSymbolOrSubscriptQ, n_?Negative]] =. ;
                Power /: Format[Power[a_?NonCommutativeQ, n_?Negative]] =. ;
  	       ,
	        Unset::norep
	      ];
	      Power /: MakeBoxes[Power[a_?NonCommutativeQ, n_?Negative], fmt_] := 
                    SuperscriptBox[Parenthesize[a, fmt, Power, Left], n];
	     ,
	      Power /: Format[Power[a_?NCSymbolOrSubscriptQ, n_?Negative]] := 
                    Superscript[ToString[a], n];
              Power /: Format[Power[a_?NonCommutativeQ, n_?Negative]] := 
                    ToString[inv][a];
          ];
	  Protect[Power];
         ,
          Quiet[
            Unprotect[Power];
            If[ $Notebooks
	       ,
	        Power /: MakeBoxes[Power[a_?NonCommutativeQ, n_?Negative], fmt_] =.;
  	        Power /: Format[Power[a_?NCSymbolOrSubscriptQ, n_?Negative]] := 
                      Superscript[ToString[a], n];
                Power /: Format[Power[a_?NonCommutativeQ, n_?Negative]] := 
                      ToString[inv][a];
   	       ,
	        Power /: Format[Power[a_?NCSymbolOrSubscriptQ, n_?Negative]] =.; 
                Power /: Format[Power[a_?NonCommutativeQ, n_?Negative]] =. ;
            ];
	    Protect[Power];
	   ,
	    Unset::norep
	 ];
      ];

      (* pretty ** *)
      
      SetOptions[NCSetOutput,
                 NonCommutativeMultiply -> (NonCommutativeMultiply /. options /. Options[NCSetOutput])];
      If[ $Notebooks
         ,
          If[ NonCommutativeMultiply /. Options[NCSetOutput]
             ,
              InfixNotation[ParsedBoxWrapper["\[FilledSmallCircle]"],
                            NonCommutativeMultiply];
             ,
              RemoveInfixNotation[ParsedBoxWrapper["\[FilledSmallCircle]"],
                                  NonCommutativeMultiply];
          ];
      ];
  ];

  (* Calls NCOutput to initialize options *)
  NCSetOutput[];

End[];

EndPackage[];
