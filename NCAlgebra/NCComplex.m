(* :Title: ComplexRules *)

(* :Author: O. Merino, Nov. 92 *)

(* :Context: ComplexRules` *)

(* :History: 
	Developed originally at the Lab. for Math
	and Stats. UCSD, La Jolla, California, (1990)
	by Orlando Merino, Julia Myers and Trent Walker.
	Nov.1992 version by Orlando Merino (not compatible
	with 1990 version).
*)

(* :Warning:
	Needs Mma. version 2.0 or higher.
*)
    
(* :Discussion:

This Mma. package contains documentation and the definition
of three Mma. objects: ComplexRules, ComplexCoordinates[], and ComplexD[].

If expr is an expression containing numbers and variables,
as well as operators/functions such as + - * / , Re[] , Im[], 
Conjugate[], Exp[], Power[],Sin[],Cos[], and others, then with the input

	expr //. ComplexRules
	
Mma. attempts to rewrite expr in terms of variables x and their complex
conjugates Conjugate[x].

Try the following examples:
	
	Re[(1 + z w)^2]^2 //.ComplexRules
	
	Conjugate[ Exp[z + 1/Conjugate[z]]^2] //.ComplexRules

The only case when the conjugate of the variable may not 
appear explicitly after applying ComplexRules occurs with the 
function Abs[].  For example,

	Abs[z]^2 /. ComplexRules
	
returns the same expression instead of z Conjugate[z].
If you want the latter you can use the function ComplexCoordinates[]:

	ComplexCoordinates[ expr ]

This function applies the ComplexRules and replaces Abs[x]
by Sqrt[ x Conjugate[x] ] 
	

The following Mma. input makes "a" a real symbol once and for all:

	Unprotect["Conjugate"];
	Conjugate[a]=a;
	Protect["Conjugate"];
	
A way to set Conjugate[a]=a in an expression without 
making this identity a global definition is to use a replacement rule:

	expr /. Conjugate[a]->a;

Other variables in your calculations may be special, for example,
you can use "e" to denote elements of the unit circle in the complex
plane.  In this case you may want to replace 1/e for Conjugate[e]
(to do it proceed as you did with real variables).


Differentiation of the *complex* expression expr with respect
to the *complex* variable z is produced with

	ComplexD[expr,z]

Try the following examples:

	ComplexD[ Conjugate[ Exp[z + 1/Conjugate[z]]^2] , z]
	
	ComplexD[ Re[(1 + z w)^2]^2 , w ]
	
	ComplexD[ Abs[1/(e^2 - 1) - z ]^2 ,z]
		
You can also differentiate with respect to Conjugate[z]; try this:

	ComplexD[Conjugate[ Exp[z + 1/Conjugate[z]]^2] , Conjugate[z] ]

Derivatives of order greater than 1 are easy to produce;
the following is a mixed derivative:

	ComplexD[Conjugate[ Exp[z + 1/Conjugate[z]]^2] , Conjugate[z] , z ]

Here is an order 2 derivative with respect to z:

	ComplexD[Conjugate[ Exp[z + 1/Conjugate[z]]^2] , {z,2} ]

END COMMENTS  *)


BeginPackage[ "ComplexRules`"];

ComplexRules::usage="ComplexRules, a set of replacement rules \
for writing expressions in terms of the variables and their \
complex conjugates."

ComplexCoordinates::usage="ComplexCoordinates[expr] expands expr in terms \
of the variables and their complex conjugates. "

ComplexD::usage="ComplexD[ expr, var ] calculates the derivative \
of the *complex* expression expr with respect to the *complex* \
variable var.  You can also calculate derivative with respect \
to Conjugate[var]."

Begin[ "`Private`" ];

 
ComplexRules = {
	Conjugate[x_ + y_] -> Conjugate[x] + Conjugate[y],
	Conjugate[x_ * y_] -> Conjugate[x] * Conjugate[y],
	Conjugate[x_ / y_] -> Conjugate[x]/Conjugate[y],
	Conjugate[- x_ ] -> - Conjugate[x],
	Conjugate[x_^n_Integer ] -> Conjugate[x]^n,
	Conjugate[Conjugate[x_]] -> x,
	Conjugate[Exp[x_]]-> Exp[Conjugate[x]],
	Conjugate[Sin[x_]] -> Sin[Conjugate[x]],
	Conjugate[Cos[x_]] -> Cos[Conjugate[x]],
	Conjugate[Tan[x_]] -> Tan[Conjugate[x]],
	Conjugate[Abs[x_]] -> Abs[x],
	Conjugate[x_?(TrueQ[Positive[#]]&) ^y_]->Conjugate[x]^Conjugate[y],
	Re[z_] -> (z + Conjugate[z])/2 ,
	Im[z_] -> (z - Conjugate[z])/(2 I)  };

 
ComplexD[f__,g__] := 
       D[ ComplexCoordinates[f] , g ] //. {Derivative[n_][Conjugate][x_] -> 0};


ComplexCoordinates[f__]:=
	(f //. Abs[x_]->Sqrt[x Conjugate[x]]) //. ComplexRules ;

End[]; (* end Private *)

EndPackage[];

