(* NCXPUtil.m                             *)
(* Author: unknown (packaged by Mauricio) *)
(*   Date: June 2009                      *)

BeginPackage[ "NCXPUtil`",
              "MoraAlg`",
	      "NonCommutativeMultiply`",
	      "Grabs`" ];

Clear[FindSingletons];
FindSingletons::usage = "";
Options[FindSingletons] = { 
  Polys -> False 
};

Clear[FindDetermined];
FindDetermined::usage = "";
Options[FindDetermined] = {
  Polys->False 
};

Clear[FindKnownPolys];
FindKnownPolys::usage = "";

Clear[NCFlatSmallBasis];
NCFlatSmallBasis::usage = "";

Begin["`Private`"];

Clear[Pull];
Pull[ f_[x__ ]] := x;

FindSingletons[ aList_List,currentUnknowns_List ,opts___Rule] :=
Module[{i,len,item,vars,kn,unk,n,alllengths,rules, singletonList,
        allvars,allind,j,totalvars,outputToFile,fileName},

  opt["polys"] =  Polys /. {opts} /. Options[FindSingletons];

  Clear[relations];
  singletonList = {};

  rules = Union[ExpandNonCommutativeMultiply[aList]];
  rules = PolyToRule[rules];
  rules = Union[rules];
  len   = Length[rules];

  Do[item = rules[[i]];
    If[Not[item===0]
       , vars = GrabIndeterminants[item];
         vars = SortMonomials[Intersection[vars,currentUnknowns ]];

        (* If the head is not NCM it's a singleton !! *)
         If[(Head[item[[1]]]=!=NonCommutativeMultiply) &&
            (MemberQ[  currentUnknowns, item[[1]] ] ),
            If[ opt["polys"] ,
                AppendTo[singletonList, RuleToPoly[item] ];, (*else*)
                AppendTo[singletonList, item[[1]] ];
                ];
            ];
        ];
  ,{i,1,len}];

  Return[singletonList];

];

FindDetermined[ aList_List,currentUnknowns_List ,opts___Rule] :=
Module[{i,len,item,vars,n,rules, determList },

  Clear[relations];
  determList = {};

  opt["polys"] = Polys /. {opts} /. Options[FindDetermined];

  rules = Union[ExpandNonCommutativeMultiply[aList]];
  rules = PolyToRule[rules];
  rules = Union[rules];
  len   = Length[rules];

  Do[item = rules[[i]];

    If[Not[item===0]
       , vars = GrabIndeterminants[item];
         vars = SortMonomials[Intersection[vars,currentUnknowns ]];

         If[ Length[ Union[vars] ] == 1,
              If[ opt["polys"],
                 AppendTo[determList, RuleToPoly[item] ]; ,
                 AppendTo[determList , vars[[1]] ];
                 ];
              ];
         ];
    ,{i,1,len}];

  Return[ determList ];

];

FindKnownPolys[ aList_List,currentUnknowns_List ,opts___Rule] :=
Module[{i,len,item,vars,kn,unk,n,alllengths,rules, determList,
        allvars,allind,j,totalvars,outputToFile,fileName},

  Clear[relations]; knownList = {};

  rules = Union[ExpandNonCommutativeMultiply[aList]];
  rules = PolyToRule[rules]; rules = Union[rules]; len   = Length[rules];

Do[item = rules[[i]];
    If[Not[item===0]
       , vars = GrabIndeterminants[item];
         vars = SortMonomials[Intersection[vars,currentUnknowns ]];

         If[ Length[ Union[vars] ] == 0,
              AppendTo[knownList , item ];
         ];
     ];
  ,{i,1,len}];
  Return[ knownList ];
];

NCFlatSmallBasis[ polyInList_List , iters_Integer ] :=
    Module[ {multOfGrade, origOrder={},theUnknowns,
        singlePolys, knownPolys, polyList = polyInList },

    multOfGrade  = WhatIsMultiplicityOfGrading[];
    Do[
      AppendTo[ origOrder, WhatIsSetOfIndeterminants[j]];
      Print[ " adding to orig order " ];

     ,{j,1,multOfGrade }];

    theUnknowns = Complement[ Flatten[origOrder],
        WhatIsSetOfIndeterminants[1]];

    ClearMonomialOrderAll[];
    SetMonomialOrder[ Flatten[ origOrder ] ];

   singlePolys =  FindSingletons[ polyList, theUnknowns,Polys->True ];
    polyList = Complement [ polyList,   singlePolys ];
    knownPolys = FindKnownPolys[ polyList,  theUnknowns ] ;

    (* Here we order the polys since order matters for the SBA *)
    polyList = Flatten[ { knownPolys,
        FindDetermined[polyList, theUnknowns, Polys->True],
        Complement[polyList, Union[knownPolys,
        FindDetermined[ polyList,theUnknowns, Polys->True ] ] ] } ];

    Print["Input to SBA", polyList ];

    polyList = Global`SmallBasis[polyList,{},iters];

    (* Put the singletons back in *)
    polyList = Union[ polyList,singlePolys];

    ClearMonomialOrderAll[];
    SetMonomialOrder[ Pull[origOrder ] ];

    Return[ polyList ];
];

End[];
EndPackage[];
