(* :Title: 	SDPSylvester.m *)

(* :Author: 	Mauricio de Oliveira *)

(* :Context:    SDPSylvester` *)

(* :Summary: *)

(* :Alias:   *)

(* :Warnings: *)

(* :History: *)

BeginPackage[ "SDPSylvester`",
              "NCOptions`",
	      "SDP`",
	      "PrimalDual`",
	      "Sylvester`",
	      "Kronecker`",
	      "NCDebug`"
]

Clear[SylvesterToVectorizedSDP];
SylvesterToVectorizedSDP::usage="";

Begin[ "`Private`" ]

  (* SDPEval *)
  SDPSylvesterPrimalEval = SylvesterPrimalEval;

  (* SDPDualEval *)
  SDPSylvesterDualEval = SylvesterDualEval;

  (* SDPEval *)
  SDPEval = SylvesterPrimalEval;
  
  (* SDPFunctions *)
  Clear[SDPFunctionsAux];
  SDPFunctionsAux[AA_List,BB_List,CC_List,syms_List] := Module[ 
    { FDualEval, FPrimalEval, FSylvesterEval }, 

    FDualEval = SylvesterDualEval[AA, {##}, syms]&;
    FPrimalEval = SylvesterPrimalEval[AA, {##}]&;
    FSylvesterEval = SylvesterSylvesterVecEval[AA, #1, #2, 
                                               Map[Dimensions, BB], syms, True]&;

    (* Return *)
    Return[ {FDualEval, FPrimalEval, FSylvesterEval} ];

  ];

  SDPFunctions[{AA_List,BB_List,CC_List},opts:OptionsPattern[{}]] := Module[ 
    { options, symmetricVariables, syms }, 

    (* Process options *)
    options = Flatten[{opts}];

    symmetricVariables = SymmetricVariables 
          /. options
          /. Options[PrimalDual, SymmetricVariables];

    NCDebug[3, symmetricVariables];

    syms = Table[ False, {i, Length[BB]}];
    Part[ syms, symmetricVariables ] = True;

    NCDebug[3, syms];

    Return[ SDPFunctionsAux[AA,BB,CC,syms] ];

  ];

  SylvesterToVectorizedSDP[{AA_List,BB_List,CC_List},opts:OptionsPattern[{}]]:=
  Module[ 
    { options, symmetricVariables, syms, dims,
      AAvec, BBvec }, 

    (* Process options *)
    options = Flatten[{opts}];

    symmetricVariables = SymmetricVariables 
          /. options
          /. Options[PrimalDual, SymmetricVariables];

    syms = Table[ False, {i, Length[BB]}];
    Part[ syms, symmetricVariables ] = True;

    (* Compute dimensions *)
    dims = Map[Dimensions, BB];

    (* TODO: CHECK DIMMENSIONS *)
      
    (* Vectorize Sylvester Mapping *)
    AAvec = SylvesterPrimalVectorize[AA, dims, syms, True];
    AAvec = Transpose[ Map[ ToMatrix[#]&, Map[Transpose, AAvec], {2}]];

    (* Vectorize cost *)
    BBvec = {{Flatten[MapThread[
       If[ #2, SymmetricToVector[#1, 2], ToVector[#1] ]&,
       {BB, syms}
    ]]}};

    Return[{AAvec, BBvec, CC}];

  ];

End[]

EndPackage[]
