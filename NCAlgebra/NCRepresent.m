(*  :Title:     NCXRepresent // Mathematica 3.0 and 4.0 *)

(*  :Author:    Eric Rowell (rowell)  and Dell Kronewitter (dkronewi)  *)

(*  :Summary:   Replaces indeterminates in a list of noncommutative
                expressions with matrices of a specified size.  Also
                includes functions that create matrices with symbolic
                entries.
*)

(*  :History:
    :9/9/99:    Created.  *)

(*  :Warnings:
                Even if a variable x appears only in the 
                arguement of a function that
                is in aListOfFunctions, one must include it 
                in the list of variables to
                be symbolically represented.
*)


BeginPackage["NCRepresent`","NonCommutativeMultiply`","Grabs`",
"Global`"];

Clear[MakeMtx];

MakeMtx::usage=
    "MakeMtx[aString,n1,n2] returns an n1 by n2 matrix with
    entries x11 etc.";

Clear[FunctionMatMake];

FunctionMatMake::usage=
    "FunctionMatMake[F[amatrix]] creates a matrix with entries
     Fx11 etc.";

Clear[NCXRepresent];

NCXRepresent::usage=
    "NCXRepresent[aListOfExpressions,aListOfVariables,aListOfDims,
     aListOfFuntions,aListOfExtraRules] replaces the variables in
     aListOfExpressions with matrices of a specified size.  aListOfFunctions
     are the functions to which FunctionMatMake are applied, and 
     aListOfExtraRules are exra rules.  Includes the auxillary function
     PrimeMat.  See documentation in the manual."; 

PrimeMat::usage=
    "PrimeMat[{n1,n2},k] creates a n1 by n2 matrix of primes starting
at the kth prime.";

Begin["`Private`"];

(* Make a matrix of non-commuting elts *)

MakeMtx[ VarName_String, Rows_Integer,  Columns_Integer ]:=

Module[{newMtx= {} },

        For[ indexD = 1, indexD <= Rows , indexD++,
           AppendTo[ newMtx, {} ];    (* add a new row *)
           For[ indexA = 1, indexA <= Columns , indexA++,
              Astr = ToString[indexA];
              Dstr = ToString[indexD];
              strIndex = StringJoin[Dstr,Astr];
          Elt = StringJoin[ VarName, strIndex];
                  Elt = ToExpression[ Elt ] ;
          SNC[ Elt ];
          newMtx = Insert[ newMtx, Elt, {indexD, indexA } ] ;
          ]; (* end for *)
          ]; (* end for *)

    Return[ newMtx ];

]; (* end module  *)

(* takes f[amatrix] and creates a matrix of appropriate size
   with entries famatrix11 etc.  *)
FunctionMatMake[ f_ [ x_List ] ] := Module[{ans}, 

		Switch [ f ,
		   tp, ans =  Transpose[ x ],
		   _,  ans=Map[  ToExpression[ ToString[ f] <> 
                           ToString[ # ] ] &  , x , {2}  ]; 
                   ];
        SNC[GrabVariables[ans]]; 
        Return[ans]; 

]; (* end module *)

(* this is the auxillary function that makes a matrix with
prime entries  *)

     PrimeMat[dimensions_, k_] := Module[{Primek, Row, Mat, n1, n2, ans}, 
       n1 = dimensions[[1]]; n2 = dimensions[[2]]; Primek[n_] := 
         Prime[n + k]; Row[j_] := Table[Primek[i], {i, (j - 1)*n2, 
           j*n2 - 1}]; ans = Table[Row[j], {j, 1, n1}]; Return[ans];
       ]; (* end module *) 

(* this is the big function. *)

NCXRepresent[aListOfExpressions_,aListOfVariables_, aListOfDims_, 
    aListOfFunctions_,
aListOfOptionalRules_] := Module[{rulesRepresent, 
ans,ans1,UseFunctionMatMake,
newrules,ans2,ans3,ans4}, 

    SNC[aListOfVariables]; 

(* this creates a list of rules  *)

     rulesRepresent = If[Length[aListOfVariables]=!=0,
	Table[aListOfVariables[[i]] -> 
        MakeMtx[ToString[aListOfVariables[[i]]], aListOfDims[[i]][[1]], 
         aListOfDims[[i]][[2]]], {i, 1, Length[aListOfVariables]}],{}]; 


(* here the first lists of rules are applied *)
     ans1 = aListOfExpressions /. Union[rulesRepresent, 
           aListOfOptionalRules]; 
	newvars=GrabIndeterminants[ans1];

(* this decides which of the indeterminates will have FunctionMatMake
applied to them  *)
     UseFunctionMatMake[anIndeterminate_]:=
       Union[	If[
        Intersection[
                    {Head[anIndeterminate]},aListOfFunctions
	]=={Head[anIndeterminate]},
     {anIndeterminate->FunctionMatMake[anIndeterminate]}, {} ] ];

newrules=Union[Flatten[Map[UseFunctionMatMake,newvars],1]];		


ans2=Hold[aListOfExpressions]/.Union[rulesRepresent,
           aListOfOptionalRules];

(* this applies the rules created from FunctionMatMake *)

ans3=ans2/.newrules;

ans4=ans3/.{NonCommutativeMultiply->Dot};


ans=Release[ans4];
Return[ans]; 
     ]; (* end module *)

End[];

EndPackage[]
