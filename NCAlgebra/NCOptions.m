(* :Title: 	NCOptions *)

(* :Author: 	mauricio *)

(* :Context: 	NCOptions` *)

(* :Summary:
*)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

BeginPackage[ "NCOptions`" ];

Clear[SelfAdjointVariables, 
      SymmetricVariables, 
      ExcludeVariables,
      SmallCapSymbolsNonCommutative,
      ShowBanner];
 
Options[NCOptions] = {
  SmallCapSymbolsNonCommutative -> True,
  ShowBanner ->	True
};

EndPackage[ ];
