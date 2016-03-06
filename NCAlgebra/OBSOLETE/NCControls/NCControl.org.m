(* :Title: 	NCControl.m // Mathematica 1.2, 2.0,3.0,4.0 *)

(* :Author: 	Dell - 8-1-99 *)

(* :Summary:    NCControl file - Allows one to use Bakshee's 
                Control System Professional package with noncommutative
		systems.  *)

(* :History: 
   :8/1/99:     Created.  -- Dell
   :6/15/02:    Fixed scoping and context problems  -- Dell
   :9/4/02:     Hardwired the TransferFunction option
                ReductionMethod->NCInverse for the time being;
                added warning message.  -- Brett
*)


BeginPackage[ "NCControl`", "ControlSystems`Common`", 
                              "ControlSystems`Connections`" ];


(************ BEGIN USER WARNING **************************************)

Print[" ******************************************************** "];
Print[" * NOTE: In order to ensure that TransferFunction[]     * "];
Print[" *       works for systems with potentially non-        * "];
Print[" *       commutative arguments, the option              * "];
Print[" *             ReductionMethod->NCInverse               * "];
Print[" *       is now the TransferFunction default.           * "];
Print[" *       As TransferFunction[] may generate non-        * "];
Print[" *       standard (though correct) output for systems   * "];
Print[" *       with commutative arguments, you may wish, in   * "];
Print[" *       such cases, to replace the call                * "];
Print[" *              TransferFunction[X]                     * "];
Print[" *       with                                           * "];
Print[" *       TransferFunction[X,                            * "];
Print[" *              ReductionMethod->DeterminantExpansion], * "];
Print[" *       which is the CSP II default.                   * "];
Print[" ******************************************************** "]; 

(************ END USER WARNING ****************************************)


NCConjugateSystem::usage = 
"NCConjugateSystem[] returns the noncommutative conjugate system
of the given noncommutative system.";

NCInverseSystem::usage = 
"NCInverseSystem[] returns the noncommutative inverse system 
of the given noncommutative system.";


(*************   BEGIN BAKSHEE's PROGRAMMING  ************************)
(************   These functions are needed to run  *******************)
(*************   Bakshee's CSP with NC Algebra   *********************)


(***** The functions ****)
DownValues[ControlSystems`Connections`Private`feedback] =
  DownValues[ControlSystems`Connections`Private`feedback] /.
    {Inverse -> NCConnectInverse,
      Dot[NCControl`Private`f_, NCControl`Private`s_, 
	  NCControl`th_] -> NCMatMult`MatMult[NCMatMult`MatMult[NCControl`Private`f, NCControl`Private`s], NCControl`th]};


DownValues[TransferFunction] =
  DownValues[TransferFunction] /.
    {Inverse -> NCConnectInverse,
     (*BRETT CHANGE*) ReductionMethod-> NCMatMult`NCInverse (*END CHANGE*),
      Dot[NCControl`Private`f_, NCControl`Private`s_, NCControl`Private`th_] -> NCMatMult`MatMult[NCMatMult`MatMult[NCControl`Private`f, NCControl`Private`s], NCControl`Private`th]};

DownValues[ControlSystems`Common`TransferFunction] =
  DownValues[ControlSystems`Common`TransferFunction] /.
    {ControlSystems`Common`Private`inverse -> NCConnectInverse,
      ControlSystems`Common`Private`dot -> NCMatMult`MatMult };

NCConnectInverse := NCMatMult`NCInverse ;

(********************************************************************)
(**************  END BAKSHEE'S PROGRAMMING **************************)
(********************************************************************)

(*  Dell's add ons **) 
(*  Bakshee calls it dual **)
NCConjugateSystem[ ncs_StateSpace] := Module[ {newSys},

    newSys =  StateSpace[  - NCMatMult`tpMat[ncs[[1]] ] , 
		           - NCMatMult`tpMat[ncs[[3]] ] ,
		             NCMatMult`tpMat[ncs[[2]] ], 
		             NCMatMult`tpMat[ncs[[4]]] ];

    Return[newSys ];
]; 

(* end module - ConjugateSystem[] *)

NCInverseSystem[ncs_StateSpace ] := Module[ {MyA,newSys },
    MyA =  ncs[[1]] - Global`MM[ ncs[[2]],
	   NCConnectInverse[ ncs[[4]] ],  ncs[[3]] ] ;

    newSys =  StateSpace[  MyA,  - Global`MM[ncs[[2]],  
	      NCConnectInverse[ ncs[[4]] ]  ],
              Global`MM[ NCConnectInverse[ ncs[[4]] ] , ncs[[3]]],  
              NCConnectInverse[ ncs[[4]] ] ];

    Return[ newSys ];
];


EndPackage[];

