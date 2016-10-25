(* :Title:      RandomMatrix  *)

(* :Author: 	Tony Shaheen  *)

(* :Summary: Makes Random Matrices with various properties *)

(* :Alias:
*)

(* :Warnings: 
*)

(* :History: 
*)

Get["LinearAlgebra`Orthogonalization`"];
Get["LinearAlgebra`MatrixManipulation`"];
Get["ControlSystems`"];


Options[RandomMatrix] = {MatrixType -> Any, EntryType -> Real };


(* Here is the main function that people call.  The others below are just
   helper functions. *)
RandomMatrix[ m_, n_, min_, max_, opts___Rule ] :=
  Module[ {a, mType, eType, entype },


     mType = MatrixType /. {opts} /. Options[RandomMatrix];
     eType  = EntryType /. {opts} /. Options[RandomMatrix];

     SeedRandom[];

     a = ZeroMatrix[ m, n ]; 

     If[ mType == Any, 
	 a = RMHelper[ m, n, min, max, eType ];  
     ];

     If[ mType == Diagonal, 
	 a = RMDiagonal[ m, min, max, eType ];  
     ];

     If[ mType == Symmetric, 
	 a = RMSymmetric[ m, min, max, eType ];  
     ];

     Return[a];
  ];


RMHelper[ m_, n_, min_, max_, type_ ] := 
  Module[ {a},

    a = Table[Random[type,{ min, max } ],{m},{n}];

    Return[a];
  ];



RMDiagonal[ n_, min_, max_, type_ ] := 
  Module[ {a,m},

    a = RMHelper[ n, n, min, max, type ];
    m = ZeroMatrix[ n ];

    (* take the values from matrix a and put them on the diagonal of m *)

    For[ r = 1, r <= n, r++,

       m[[r]] = Delete[ m[[r]], r ];
       m[[r]] = Insert[ m[[r]], a[[r]][[r]] , r ];

    ];

    Return[m];
  ];


RMSymmetric[ n_, min_, max_, type_ ] := 
  Module[ {a,x},

    a = Table[Random[type,{ min, max } ],{n},{n}];

    (* now make it symmetric *)

    For[ r = 1, r <= n, r++,
       For[ c = 1, c <= r, c++,

          (* there must be an easier way to do this! *)
          x = a[[c]][[r]];
          a[[r]] = Delete[ a[[r]], c ];
          a[[r]] = Insert[ a[[r]], x, c ];
	  ReplacePart[ a[[r]], a[[c]][[r]], c ];

       ];
    ];

    Return[a];
  ];



(************************************************)
(************************************************)
(************************************************)
(* below are some ones that really not done yet,
   well almost done...need to done something
   about the loops.                             *)
(************************************************)
(************************************************)
(************************************************)



(*

RandomUnitaryMatrix[ n_, min_, max_ ] :=
  Module[ {m, inc = 0 },

     While[ 1 === 1, 
        m = NCRandomMatrix[ n, min, max ];

	(* If its nonsingular then GramSchmitz it and return it! *)
	If[ Det[ m ] != 0,
	   Return[ GramSchmidt[m] ];
	];   

	inc++;

	(* If we just can't get a nonsingular random matrix
           then return the identity *)
	If[ inc >= 10,
	    Return[ IdentityMatrix[ n ] ];

	];
     ];
  ];


RandomUnitaryMatrix2[ n_, min_, max_ ] :=
  Module[ {m, inc = 0 },

     While[ 1 === 1, 
        m = NCRandomMatrixInteger[ n, min, max ];

	(* If its nonsingular then GramSchmitz it and return it! *)
	If[ Det[ m ] != 0,
	   Return[ GramSchmidt[m] ];
	];   

	inc++;

	(* If we just can't get a nonsingular random matrix
           then return the identity *)
	If[ inc >= 10,
	    Return[ IdentityMatrix[ n ] ];

	];
     ];
  ];



RandomMatrixEigen[ n_, min_, max_, eigenmin_, eigenmax_ ] :=
  Module[ {u,d,ans},

     u = NCRandomUnitaryMatrix[ n, min, max ];
     d = NCRandomDiagonalMatrix[ n, eigenmin, eigenmax ];

     Return[ Transpose[u].d.u ];     

  ];

RandomMatrixEigen2[ n_, min_, max_, eigenmin_, eigenmax_ ] :=
  Module[ {u,d,ans},

     u = NCRandomUnitaryMatrix2[ n, min, max ];
     d = NCRandomDiagonalMatrixInteger[ n, eigenmin, eigenmax ];

     Return[ Transpose[u].d.u ];     

  ];


RandomMatrixIsometry[ n_, m_, min_, max_ ] :=
  Module[ {a, singular, inc = 0 },

     While[ 1 === 1, 

        a = NCRandomMatrix[ n, m, min, max ];

        (* If its nonsingular then GramSchmitz it and return it! *)
	If[ Rank[ a ] === Min[ n,m ], 
	   If[ n >= m,

	   (* more rows than columns - so lets gram-schmidt the columns*)
	   Return[ Transpose[ GramSchmidt[ Transpose[ a ] ] ] ];
	   ,

	   (* more columns than rows - gram-schmidt the rows *)
	   Return[ GramSchmidt[ a ] ];

	   ];

        ];   

        inc++;

        (* If we just can't get a nonsingular random isometry 
           then return the ???? *)
        (* NEED TO FIX THIS PART TO RETURN A NICE ISOMETRY *)
        If[ inc >= 10,
           Return[ ZeroMatrix[ n, m ] ];
        ];

     ];
  ];
*)
