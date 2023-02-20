
NCXWholeProcess[ polys_List, orderList_List,fileName_String,
 	findIters_Integer, grobIters_Integer ] := Module[{ stuckIters = 0,
	index,currIters = 0, commonOrders=orderList, currName,
	NCPout, singVars, determVars, lastUnknowns  },

For[ currIters = 0, currIters < findIters, currIters++,

	currName = StringJoin[fileName, ToString[currIters]];

	realMonomialOrder = commonOrders;
	realMonomialOrder = { commonOrders[[1]],
      Partition[ commonOrders[[2]], 1 ], commonOrders[[3]] };
	
	If[ realMonomialOrder[[3]] == {},
		realMonomialOrder = { realMonomialOrder[[1]] ,
              Pull[realMonomialOrder[[2]]] };
		, (* Else *)
		realMonomialOrder = { realMonomialOrder[[1]] , 
			Pull[realMonomialOrder[[2]]], realMonomialOrder[[3]] }
		];

	(* We're done ! *)
	If[ realMonomialOrder[[2]] == {},
		realMonomialOrder = { realMonomialOrder[[1]] , realMonomialOrder[[3]]};
		];

	MoraAlg`ClearMonomialOrderAll[];
	MoraAlg`SetMonomialOrder[ Pull[realMonomialOrder]]; 
	PrintMonomialOrder[];

    Print[ "NCPROCESS Iter !!!!!!!!!!!!!!!!!!!!!!!!!!***********" ];
    Print[ "NCPROCESS Iter !!!!!!!!!!!!!!!!!!!!!!!!!!***********" ];
    Print[ "NCPROCESS Iter !!!!!!!!!!!!!!!!!!!!!!!!!!***********" ];

	NCPout = NCX1Process[ polys, grobIters,0,0,0, currName, SBByCat->False ]; 

	lastUnknowns = commonOrders[[2]];

  	singVars = FindSingletons[ NCPout[[3]], commonOrders[[2]] ];
  	determVars = FindDetermined[ NCPout[[3]], commonOrders[[2]] ];

  	(* We like singletons better than "determineds" *)
  	determVars = Complement[ determVars, singVars ]; 

  	commonOrders[[2]] = Complement[ commonOrders[[2]], 
        Union[singVars, determVars] ];

  	commonOrders[[1]] = Flatten[Append[ commonOrders[[1]], determVars ]];
  	commonOrders[[3]] = Flatten[Prepend[ commonOrders[[3]], singVars ]];

	If[ Length[ commonOrders[[2]] ] ==  0,
		Print["Probelm is SOLVED \n \n " ];
		Break[];
		];

	If[ lastUnknowns === commonOrders[[2]] ,
		stuckIters ++;
		Print[" No Progress is being made !" ];
		commonOrders[[2]] = RotateLeft[ commonOrders[[2]], 1 ];
(*
		If[ stuckIters == Length[ commonOrders[[2]],
			Print["Problem is not solvable"];
			Break[];
			]; ,
		stuckIters = 0;
		];
*)
 	];
  ]; (* end For[] currIters *)

If[ currIters == findIters  , 
	Print[ " Maximum finding iterations iterated."];
	];

];   (* End module *)




