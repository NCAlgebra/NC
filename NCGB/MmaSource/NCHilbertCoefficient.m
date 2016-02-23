
(* :Title:      NCHilbertCoefficient //  Mathematica 3.0 and 4.0  *)

(* :Author:     Eric Rowell (rowell)   *)

(* :Context:    NCHilbertCoefficient`   *)

(* :Summary:    NCHilbertCoefficient compute coefficients of the
                Hilbert series for an algebra.  There is a default 
		for arbitrary algebras, and options to make the code
                execute faster for homogeneous polynomials

*)

(* :Alias:      None. *)

(* :Warnings:   NCX1VectorDimension Clears out the order, so if one uses the 
                default Filtration version of this code, one will 
                have to reset the monomial order.
*)

(* :History:   
   :9/9/99:    Created for use in computing Gelfand-Kirillov
               dimension.  Also includes the auxillary function
               NCX1VectorDimension that computes the dimension of
               the span of some polynomials.
*)

BeginPackage[ "NCHilbertCoefficient`","MoraAlg`","Grabs`","Reduce`","Global`"];
     

Clear[NCX1VectorDimension];

NCX1VectorDimension::usage=
     "NCX1VectorDimension[aList] computes the dimension of the span
     of aList as a vector space.";

Clear[NCHilbertCoefficient];

NCHilbertCoefficient::usage=
     "NCHilbertCoefficient[n1,aListOfExpressions,n2] computes the 
      coefficients of the Hilbert series for the algebra with relations
	aListOfExpressions.";

Clear[Homogeneous];
Clear[ExpressionForm];
ExpressionForm::usage=
	"This is how one sets the options for NCHilbertCoefficient.";
Homomgeneous::usage=
      "This is an option for NCHilbertCoefficient.";

Clear[HomogeneousBinomial];

HomogeneousBinomial::usage=
      "This is an option for NCHilbertCoefficient.";

Clear[partialGBHomogeneous];

partialGBHomogeneous::usage=
      "This is an option for NCHilbertCoefficient.";

Begin["`Private`"];

(* this is the function that computes the vector space dimension
of the span of a set of polynomials. *)

NCX1VectorDimension[aList_] := 
  Module[{newlist, F, q, currentlist, var, poly, ans}, 
   F[var_, poly_] := NCExpand[var**poly**var]; SNC[q]; 
    ClearMonomialOrderAll[]; 

   Print["The order will need to be reset after this function executes."];

newlist = (F[q, #1] & ) /@ aList; 
    currentlist = newlist; SetMonomialOrder[Union[GrabVariables[newlist]]]; 
    For[index = 1, index <= Length[currentlist], index++, 
     rule = PolyToRule[currentlist[[index]]]; 
      If[rule =!= 0, currentlist = Reduction[currentlist, {rule}]; ]; 
      currentlist[[index]] = RuleToPoly[rule]; ]; 
    currentlist = Complement[currentlist, {0}]; Print[Length[currentlist]]; 
    Return[Length[currentlist]]; ClearMonomialOrderAll[];

     ]; (* end module *)

(* this computes the first int1 Hilbert series coefficients for an
arbitrary algebra using the filtration version.  *)
NCHilbertCoefficient[int1_, rels1_, iters1_ ] := 
   NCHilbertCoefficient[int1, rels1, iters1, ExpressionForm->default1];


Options[NCHilbertCoefficient] = {ExpressionForm ->dummyword};

(* this is the big function *)
 
NCHilbertCoefficient[int1_, rels1_, iters1_, opt___Rule] := 
   Module[{NCX1BigHilbCoef, NCX1BinHilbCoef, NCX1HilbCoef, NCX1FiltHilbCoef, 
     theanswer},

(* Here the options are set *)

specialFun=ExpressionForm/.{opt}/.Options[NCHilbertCoefficient];

(* this is the default code *)

NCX1FiltHilbCoef[n1_, rels_, iter_ 
       ] := Module[{varlist1, Graded, Filtration, bases, gb}, 
       F[var_, list_] := Union[(var**#1 & ) /@ list, (#1**var & ) /@ list]; 
        varlist1 = Union[GrabVariables[rels]]; 
        gb = NCMakeGB[rels, iter]; Graded[1] := varlist1; 
        Graded[k_] := Graded[k] = Union[Reduction[NCExpand[
             Union[Flatten[(F[#1, Graded[k - 1]] & ) /@ varlist1]]], 
            PolyToRule[gb]]]; 
       Filtration[1] := Union[varlist1, {1}]; 
        Filtration[n_] := Filtration[n] = Reduction[Union[Filtration[n - 1], 
            Graded[n]], PolyToRule[gb]]; Return[NCX1VectorDimension /@ 
          Table[Filtration[j], {j, 1, n1}]]; ]; 

(* end module *)

(* this is the code for HomogeneousBinomial
 note only one call to NCMakeGB *)

NCX1BinHilbCoef[n1_, rels_, iter_ ] := 
      Module[{varlist1, Graded, bases}, 
       F[var_, list_] := Union[(var**#1 & ) /@ list, (#1**var & ) /@ list]; 
        varlist1 = Union[GrabVariables[rels]]; 
        gb = NCMakeGB[rels, iter]; Graded[1] := varlist1; 
        Graded[k_] := Graded[k] = Union[Reduction[
            Union[Flatten[(F[#1, Graded[k - 1]] & ) /@ varlist1]], 
            PolyToRule[gb]]]; bases = Graded /@ Table[i, {i, 1, n1}]; 
Length /@ bases];

(* end module *) 

(* this is the code for the Homogeneous option *)

NCX1BigHilbCoef[n1_, relations_, iter_ ] := 
      Module[{varlist1, Graded, bases, fbres, gb},
       F[var_, list_] := Union[(var**#1 & ) /@ list, (#1**var & ) /@ list]; 
varlist1 = Union[GrabVariables[relations]]; 
gb = NCMakeGB[relations, iter]; 
        Graded[1] := varlist1; 
Graded[k_] := Graded[k] = 
          NCMakeGB[Reduction[Union[Flatten[(F[#1, Graded[k - 1]] & ) /@ 
               varlist1]], PolyToRule[gb]], k]; 
        bases = Graded /@ Table[i, {i, 1, n1}]; 
        Length /@ bases]; 

(* end module *)

(* this is the code for the partialGBHomogeneous option *)

NCX1HilbCoef[n_, aGB_ ] := 
      Module[{varlist1, Graded, bases}, 
F[var_, list_] := 
         Union[(var**#1 & ) /@ list, (#1**var & ) /@ list]; 
        varlist1 = Union[GrabVariables[aGB]]; SNC[varlist1]; 
        Graded[1] := varlist1; Graded[k_] := Graded[k] = 
          NCMakeGB[Union[Reduction[Union[Flatten[(F[#1, Graded[k - 1]] & ) /@ 
                varlist1]], PolyToRule[aGB]]], 2]; 
        bases = Graded /@ Table[i, {i, 1, n}]; 
        Length /@ bases]; 

(* end module *)

(* here is where the function actually executes *)

theanswer=Switch[specialFun, 
	Homogeneous, NCX1BigHilbCoef[int1, rels1, 
       iters1 ], 
	HomogeneousBinomial, NCX1BinHilbCoef[int1, rels1, iters1 
       ], 
	partialGBHomogeneous, NCX1HilbCoef[int1, rels1 ], 
	_,NCX1FiltHilbCoef[int1, rels1, iters1 ] 
	];

Return[theanswer];

	]; (* end module *)

End[];

EndPackage[]
