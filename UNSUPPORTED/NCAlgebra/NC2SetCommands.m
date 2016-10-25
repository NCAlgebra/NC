(* :Title: 	NCSetCommands2 // Mathematica 1.2 and 2.0 *)

(* :Author: 	Mark Stankus (mstankus). *)

(* :Context: 	NonCommutativeMultiply` *)

(* :Summary:    Code to set symbols to have operator
                theory attributes such as self-adjointness,
                the property of being an isometry,etc. 
*)

(* :Alias: *)

(* :Warnings: *)

(* :History: 
   :8/27/92    Rewrote UnitaryQ and SetUnitary and 
               changed the comments.            
   :9/18/92    Fixed CoIsometry code.
*)

BeginPackage[ "NonCommutativeMultiply`" ]

Clear[SetInv];

SetInv::usage =
     "SetInv[a,b,...] will set a, b, ... to be (2-sided) invertible \
      elements. If set, then the rules invL[a] := inv[a] and \
      invR[a] := inv[a] will be automatically applied. \
      See InvQ and OverrideInverse.";

Clear[invQ];

invQ::usage =
     "InvQ[x] = True if x is invertible. See SetInv.";

Clear[SetSelfAdjoint];

SetSelfAdjoint::usage =
     "SetSelfAdjoint[a,b,...] will set a, b, ... to be self-adjoint.  \
      If set the rules tp[a] := a;tp[b] :=b,... and \
      aj[a] := a ;aj[b] := b;... will be automatically applied. See \
      SelfAdjointQ.";

Clear[SelfAdjointQ];

SelfAdjointQ::usage =
     "SelfAdjointQ[x] will return true if SetSelfAdjoint[x] was  \
      executed previously. See SetSelfAdjoint.";

Clear[SetIsometry];

SetIsometry::usage =
     "SetIsometry[a,b,...] will set a, b, ... to be isometries. \
      If set the rules tp[a]**a := Id;tp[b]**b :=Id,...  and \
      aj[a]**a := Id ;aj[b]**b := Id;... will be automatically \
      applied. See IsometryQ.";

Clear[IsometryQ];

IsometryQ::usage =
     "IsometryQ[x] will return true if SetIsometry[x] was executed \
      previously. See SetIsometry.";

Clear[SetCoIsometry];

SetCoIsometry::usage =
     "SetCoIsometry[a,b,...] will set a, b, ... to be co-isometries. \
      If set the rules a**tp[a] := Id;b**tp[b] :=Id,... and \
      a**aj[a] := Id ;b**aj[b] := Id;... will be automatically \
      applied. See CoIsometryQ.";

Clear[CoIsometryQ];

CoIsometryQ::usage =
     "CoIsometryQ[x] will return true if SetCoIsometry[x] was \
      executed previously. See SetCoIsometry.";

Clear[SetUnitary];

SetUnitary::usage =
     "SetUnitary[a,b,...] will set a, b, ... to be isometries and 
      co-isometries. See SetIsometry and SetCoIsometry.  Also \
     effects UnitaryQ.";

Clear[UnitaryQ];

UnitaryQ::usage =
     "UnitaryQ[x] will return true if either SetUnitary[x] was executed \
      previously or both SetIsometry[x] and SetCoIsometry[x] were \
      executed previously.";

Clear[SetProjection];

SetProjection::usage =
     "SetProjection[a,b,...] will set a, b, ... to be projections.  \
      If set the rules a**a := a;b**b :=b,...  will be automatically \
      applied. See ProjectionQ. \n \n \
      Caution: If one wants x to be a self-adjoint projection, then \
      one must execute SetSelfAdjoint[x];SetProjection[x].";

Clear[ProjectionQ];

ProjectionQ::usage =
     "ProjectionQ[x] will return true if SetProjection[x] was executed \
      previously. See SetProjection.";

Clear[SetSignature];

SetSignature::usage = 
     "If set as well as SelfAdjoint, the rule a**a := -Id will be \
      automatically applied. See SetSelfAdjoint and SignatureQ.";

Clear[SignatureQ];

SignatureQ::usage =
     "SignatureQ[x] will return true if SetSignature[x] was executed \
      previously. See SetSignature.";

Begin[ "`Private`" ]

(*
    Self-adjoint
*)
SelfAdjointQ[___] := False;
SetSelfAdjoint[a__]:=(Function[x,SelfAdjointQ[x]=True;
                                 SelfAdjointQ[x[___]]=True] /@{a});
tp[a_] := a /; SelfAdjointQ[a] == True;
aj[a_] := a /; SelfAdjointQ[a] == True;

(*
    Isometry
*)
IsometryQ[___] := False;
SetIsometry[a__]:=(Function[x,IsometryQ[x]=True;
                              IsometryQ[x[___]]=True] /@{a});

SNC[a,b,c];

Literal[NonCommutativeMultiply[a___,tp[b_],b_,c___]] :=
	NonCommutativeMultiply[a,Id,c] /; IsometryQ[b] == True;

Literal[NonCommutativeMultiply[a___,aj[b_],b_,c___]] :=
	NonCommutativeMultiply[a,Id,c] /; IsometryQ[b] == True;

(*
    CoIsometry
*)
CoIsometryQ[___] := False;
SetCoIsometry[a__]:=(Function[x,CoIsometryQ[x]=True;
                                CoIsometryQ[x[___]]=True] /@{a});

Literal[NonCommutativeMultiply[a___,b_,tp[b_],c___]] :=
	NonCommutativeMultiply[a,Id,c] /; CoIsometryQ[b] == True;

Literal[NonCommutativeMultiply[a___,b_,aj[b_],c___]] :=
	NonCommutativeMultiply[a,Id,c] /; CoIsometryQ[b] == True;

(*
    UnitaryQ 
*)
UnitaryQ[x_] := IsometryQ[x] && CoIsometryQ[x];
SetUnitary[a__]:=(Function[x,SetIsometry[x];
                             SetCoIsometry[x]] /@{a});

(*
    Non-orthogonal projection                                       
*)
ProjectionQ[___] := False;
SetProjection[a__]:=(Function[x,ProjectionQ[x]=True;
                                ProjectionQ[x[___]]=True] /@{a});

Literal[NonCommutativeMultiply[a___,b_,b_,c___]] :=
	NonCommutativeMultiply[a,b,c] /; ProjectionQ[b] == True;

(*
    Signature
*)
SignatureQ[___] := False;
SetSignature[a__]:=(Function[x,SignatureQ[x]=True;
                               SignatureQ[x[___]]=True] /@{a});

Literal[NonCommutativeMultiply[a___,b_,b_,c___]] :=
  NonCommutativeMultiply[a,Times[-1,b],c]/; SignatureQ[b] && SelfAdjointQ[b];

(*
    Set invertible
*)
SetInv[a__]:=(Function[x,invQ[x]=True;invQ[x[___]]=True]
       /@{a});

End[]

EndPackage[]
