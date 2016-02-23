(* :Title: 	NCChangeOfVariables  // Mathematica 3.0 and 4.0  *)

(* :Author:	David Glickenstein     *)

(* :Context:	NCChangeOfVariables`  *)

(* :Summary:	*)

(* :Alias:	None.    *)

(* :History:	
   :9/8/99:	Made the package.

*)


BeginPackage["NCChangeOfVariables`", "NonCommutativeMultiply`","MoraAlg`", "Grabs`", "NCCollectOnVariables`", "Global`"];

Clear[NCXPossibleChangeOfVariables];

NCXPossibleChangeOfVariables::usage = 
	"NCXPossibleChangeOfVariables[aListOfPolynomials, Options] 
	takes a list of relations and looks for a good
	motivated unknown.  It returns a list of pairs {E, M} where E is
	the expression which motivated the candidate M and M is the
	candidate for a motivated unknown.";


Clear[NCXFindChangeOfVariables];

NCXFindChangeOfVariables::usage = 
	"NCXFindChangeOfVariables[aListofPolynomials, anInteger, 
	aString, Options] takes a list of relations
	aListOfPolynomials, finds
	the candidates for  motivated unknowns and then tries each one in 
	NCProcess until it finds that all unknowns except the candidate have
	been eliminated (and hence would make a good motivated unknown).  
	If it finds a motivated unknown (which absorbs all other unknowns) 
	then it returns a list {E, M} where M is the
	motivated unknown and E is the
	expression which motivated it.  Otherwise it returns False.  
	It can also be made to return a list
	of outputs from the calls to NCProcess.";

Clear[NCXAllPossibleChangeOfVariables];

NCXAllPossibleChangeOfVariables::usage = 
	"NCXAllPossibleChangeOfVariables[aListOfPolynomials] 
	takes a list of polynomials and returns a list of pairs {P, C}
	where P is a polynomial from aListOfPolynomials and C is
	on the left or right side of a product of knowns inside P after
	P has been collected (with NCCollectOnVariables).";

SortByTermLength::usage =
	"The SortByTermLength option decides whether or not
	to sort the results by the length (number of terms) of the 
	candidate (with the shortest first).  The default (True) does the
	sorting, while setting the option to False does not sort at all.";

CountVariables::usage = "This option determines
  	whether or not NCXPossibleChangeOfVariables eliminates the
	candidates which do not contail all of the unknowns present in the
	polynomial that motivated it (and
	thus the candidate cannot reduce that polynomial to a
	polynomial in one variable).  The default (True) does eliminate these
	possibilities while setting it to False does not do this elimination.";

IncludeTranspose::usage = "This option for NCXFindChangeOfVariables 
	adds the transpose 
	of the candidate to the set of relations.  The default (False)
	is not to add the transpose relation, while setting it to True
	will not add the transpose relation.";

AllRelations::usage = "This option for NCXFindChangeOfVariables determines
	whether the Grobner Basis is computed using only the relation
  	that motivated the candidate together with the candidate
  	or if it uses all of the given relations plus
  	the candidate.  The default (False) only uses the polynomial
  	that motivated the unknown plus all relations of length 2 
	(these we will consider ``important'' relations and include 
	relations defining inverses and symmetry) while setting it to 
	True uses all of the relations.";

MultiplyByMonomials::usage ="This option for NCXFindChangeOfVaraibles 
	determineswhether or not NCXMultiplyByMonomials is called, 
	so that if no candidate works, 
	it tries to multiply though by monomials on
	the left and/or right.  The default (True) tries multiplying through
	by monomials, while setting it to False does not do this step.";

NCProcessOptions::usage  = "This option decides whether or not to
	sort the results of NCXPossibleChangeOfVariables 
	by the length (number of terms)
	in the candidate (shortest to longest).  The default (True)
	does sort it so that it tries the shortest candidates first
	(since in practice the longer ones don't tend to work).  Setting it to
	False does not do the sorting step.";

StopIfFound::usage = "This option for NCXFindChangeOfVariables 
	determines whether the program stops if a motivated unknown 
	is found.  The default (True) 
	stops if a motivated unknown is found and returns only this pair.  
	Setting this option to False runs all possibilities in 
	NCProcess and returns all of the results 
	(whether a motivated unknown is found or not).";


Begin["`Private`"];



(************* Leading Term *****************)
Lt[poly_] := PolynomialToGBRule[poly][[1]]

(************* TermsLength ******************)

TermsLength[poly_] := If[Head[poly] =!= Plus, 1, Length[poly]];


(******************EliminateAllButQ******************)

	(* Decides if all but vars have been eliminated from exp *)
EliminateAllButQ[exp_, vars_]:= 
	Module[{unknownsList = Flatten[Map[WhatIsSetOfIndeterminants[#]&, 
			Range[2, WhatIsMultiplicityOfGrading[]]]]},
	  Apply[And, Map[FreeQ[exp, #]&,  Complement[unknownsList, vars]]]]

ElimAllButQ = EliminateAllButQ



(******************NCXAllPossibleChangeOfVariables*****************)

	(*Get polynomials from NCCollectOnVariables *)
	(*Return a list of pairs {expression, possible motivated unknown} *)
NCXAllPossibleChangeOfVariables[list_] := Module[{},Select[
    Flatten[Array[Function[i,
	Map[({list[[i]], #})&, Union[Flatten[NCCoefficientList[list[[i]], 
		WhatIsSetOfIndeterminants[1]]]]]],
    Length[list]],1], Not[IntegerQ[#[[2]]]]&]]


(******************NCXCountVariables******************************)

(* Count Variables in candidate for motivated unknown to see if it has as 
   many variables as in the motivating expression                        *)
NCXCountVariables[list_] := Select[list,
     ((Length[v = Complement[Union[GrabVariables[#[[1]]]], 
	Union[GrabVariables[#[[2]]]], WhatIsSetOfIndeterminants[1]]] ==0) 
       && (Length[GrabIndeterminants[#[[2]]]]>1))& ]




(*****************NCXKillConstantTerms***************************)

(* Kill constant terms in motivated unknown *)
NCXKillConstantTerms[list_]:= 
	Module[{indets = Flatten[Map[WhatIsSetOfIndeterminants, 
		Range[WhatIsMultiplicityOfGrading[]]]]},
	Map[({#[[1]], #[[2]]-Global`NCTermsOfDegree[#[[2]],  indets,
	Table[0,{i,1,Length[indets]}]]})&, list]]


(*****************NCXPossibleChangeOfVariables*******************)

Options[NCXPossibleChangeOfVariables] = {CountVariables->True, SortByTermLength ->True};

(* This is the best list of candidates for motivated unknown *)
NCXPossibleChangeOfVariables[list_, opts___]:=
	Module[{},
	    Apply[(If[SortByTermLength/.{opts}/.Options[NCXPossibleChangeOfVariables],
	      Sort[#, (TermsLength[(NCE[#1])[[2]]]< TermsLength[(NCE[#2])[[2]]])&], #])&, 
	      {NCXKillConstantTerms[
	        Apply[(If[CountVariables/.{opts}/.Options[NCXPossibleChangeOfVariables], NCXCountVariables[#], #])&, 
		  {NCXAllPossibleChangeOfVariables[list]}]]}]]


(***********************NCXMultiplyByMonomials*******************)

(* Multiply through by monomials *)
NCXMultiplyByMonomials[list_]:= Module[{oldlist = list,
			newlist, lt},
	newlist = oldlist;
	For[i=1, i<=Length[oldlist], i++,
	  lt = Lt[oldlist[[i]][[2]]];
	  For[j=1, j<Length[lt], j++,
	    newlist = Append[newlist, 
		{NCE[lt[[Range[1,j]]]**oldlist[[i]][[1]]], 
		 oldlist[[i]][[2]]}];
	    For[k = Length[lt], k>1,k--,
	      If[j==1, newlist = Append[newlist,
		{NCE[oldlist[[i]][[1]]**lt[[Range[k,Length[lt]]]]], 
		 oldlist[[i]][[2]]}]];
 		newlist = Append[newlist, 
	{NCE[lt[[Range[1,j]]]**oldlist[[i]][[1]]**lt[[Range[k, Length[lt]]]]], 
	 oldlist[[i]][[2]]}];

]]];
	Return[newlist]]


(**********************NCXFindChangeOfVariables***********************)

	(* Find Change of Variables.  *)

Options[NCXFindChangeOfVariables] = 
	{IncludeTranspose->False,
	AllRelations->False,
	CountVariables->True,
	MultiplyByMonomials->False,
	SortByTermLength->True,
	NCProcessOptions->{SBByCat->False, RR->False},
	StopIfFound->True};	

NCXFindChangeOfVariables[list_, num_, name_String, opts___] := 
  Module[{newOrder, 

	(* We will use all relations of length 2 (which includes 
	   relations defining inverses and which say something is 
	   symmetric) *)

	importantRelations = Union[Select[list, 
		((Head[#] == Plus) && (Length[#] == 2))&]]},

  (********* Put motUnknown in the monomial order *********)
motUnknown = Global`motUnknown;
    newOrder = If[MemberQ[
		    Flatten[Map[WhatIsSetOfIndeterminants[#]&, 
			Range[2, WhatIsMultiplicityOfGrading[]]]],
		    motUnknown],
	      Map[WhatIsSetOfIndeterminants[#]&, 
		Range[1, WhatIsMultiplicityOfGrading[]]],
	      Join[{WhatIsSetOfIndeterminants[1]},
		{{motUnknown, Tp[motUnknown]}}, 
		Map[WhatIsSetOfIndeterminants[#]&, 
		  Range[2, WhatIsMultiplicityOfGrading[]]]]];
    ClearMonomialOrderAll[];
    SetNonCommutative[motUnknown, Tp[motUnknown]];
    Apply[SetMonomialOrder,newOrder];

  (*********** Set default options if options are not set. **********)
(*    If[(Global`IncludeTranspose/.options) =!= True, 
	options = Join[options, {Global`IncludeTranspose->False}]];
    If[(Global`AllRelations/.options) =!= False, 
	options = Join[options, {Global`AllRelations->True}]];
    If[(Global`CountVariables/.options) =!= False, 
	options = Join[options, {Global`CountVariables->True}]];
    If[(Global`MultiplyByMonomials/.options) =!= False, 
	options = Join[options, {Global`MultiplyByMonomials->True}]];
    If[(Global`SortByTermLength/.options) =!= False, 
	options = Join[options, {Global`SortByTermLength->True}]];
    If[(Global`NCProcessOptions/.options) === Global`NCProcessOptions, 
	options = Join[options, {Global`NCProcessOptions->{}}]];
    If[(Global`StopIfFound/.options) =!= False, 
	options = Join[options, {Global`StopIfFound->True}]];
*)
  (*********** Do the real work. ***********)
    Module[{reallist, NCPargs, NCPout={}},
	reallist = Apply[If[MultiplyByMonomials/.{opts}/.Options[NCXFindChangeOfVariables], 
	  NCXMultiplyByMonomials[#], #]&, 
	  {Apply[NCXPossibleChangeOfVariables[list, #]&, 
		{CountVariables->(CountVariables/.{opts}/.Options[NCXFindChangeOfVariables]),
		SortByTermLength->(SortByTermLength/.{opts}/.Options[NCXFindChangeOfVariables])}]}];
      For[i=1 , i<=Length[reallist], i++,
	Module[{ans = Apply[(*Print*)NCProcess, 
	  Join[{Join[If[AllRelations/.{opts}/.Options[NCXFindChangeOfVariables], 
		list,
		Join[importantRelations, {reallist[[i]][[1]]}]], 
	      Join[{reallist[[i]][[2]]->motUnknown}, 
		If[IncludeTranspose/.{opts}/.Options[NCXFindChangeOfVariables], 
		  {(tp[reallist[[i]][[2]]/.Tp->tp]/.tp->Tp)->Tp[motUnknown]},
		  {}]]], 
	  num, 
	  name<>"no"<>ToString[i]} , 
	  NCProcessOptions/.{opts}/.Options[NCXFindChangeOfVariables]]]},
	If[StopIfFound /. {opts}/.Options[NCXFindChangeOfVariables],
	  If[Apply[Or,Map[
And[((#/. motUnknown->QK) =!= #),EliminateAllButQ[#, {motUnknown, Tp[motUnknown]}]]&, 
		ans[[3]]]], 
	     Print["Found motivated unknown"];
	    Return[{reallist[[i]][[1]], 
		   reallist[[i]][[2]]->motUnknown, 
		   ans[[3]]}]]];	
	   NCPout = Join[NCPout, {ans}]]]; 
  Return[NCPout]]];


End[];
EndPackage[]

