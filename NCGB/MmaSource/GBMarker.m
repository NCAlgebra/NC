Get["Errors.m"];
Clear[RetrieveMarker];

(*
 * The following function transfers a marker from
 * C++ to Mathematica. 
 * See also unmarker and unmarkerAndDestroy.
 *)

RetrieveMarker[x_GBMarker] := returnMarkerList[x];

RetrieveMarker[x___] := BadCall["RetrieveMarker",x];

(*
 * The following is suppose to keep track of the
 * markers which exist. We have not implemented
 * it yet. 
 *)

currentMarkers = {};

(*
 * Record the fact that the marker exists.
 * Not used fully yet.
 *)

RecordMarker[x_GBMarker] := AppendTo[currentMarkers,x];

RecordMarker[x___] := BadCall["RecordMarker",x];

(*
 * The following function returns an empty "history" marker.
 * The caller must destroy the marker.
 * It will probably be deleted.
 *)

CreateMarker["history",aList_List] := 
Module[{},
  setNumbersForHistory[aList];
  Return[CreateMarker["history"]];
];

(*
 * The following function returns an empty marker.
 * The caller must destroy the marker.
 *)

CreateMarker[str_String] := 
Module[{ans},
  ans = createGBMarker[str];
  AppendTo[currentMarkers,ans];
  Return[ans];
];

CreateMarker[x___] := BadCall["CreateMarker",x];

(*
 * The following is used for debugging.
 *)

disabledMarkers = False;

(*
 * The following function destroys a marker
 *)

DestroyMarker[x_GBMarker] := Apply[destroyGBMarker,x];
DestroyMarker[x:{___GBMarker}] := destroyGBMarkers[x];
(*
  pos = Flatten[Position[currentMarkers,x],1];
  currentMarkers = Delete[currentMarkers,pos];
];
*)

DestroyMarker[x___] := BadCall["DestroyMarker",x];

(*
 * The following function prints a marker without retrieving it
 *)

PrintMarker[x:GBMarker[_Integer,_String]] := printGBMarker[x];

PrintMarker[x___] := BadCall["PrintMarker",x];

(*
 * The following function creates a marker of the type
 * "factcontrol". 
 * The caller of the function is responsible for destroying
 * the marker.
 *)

SaveFactControl[] :=
  Global`copyGBMarker["factcontrol",
                      Global`CurrentManagerStartFactControl[],
                      "factcontrol"];

SaveFactControl[x__] := BadCall["SaveFactControl",x];

(*
 * The following function copies a marker.
 * The caller of the function is responsible for destroying
 * the marker.
 *)

CopyMarker[x_GBMarker,to_String] :=
     Global`copyGBMarker[x[[2]],x[[1]],to];

CopyMarker[x___] := BadCall["CopyMarker",x];

(*
 * I have not written this function correctly yet.
 * The point is to deal with memory leaks.
 *)

ClearCategoryFactory[x_Symbol] := 
Module[{},
  DeleteRecordedMarkers[x];
];

ClearCategoryFactory[x___] := BadCall["ClearCategoryFactory",x];

(*
 * The following function returns a list of mathematica
 * expressions corresponding to the data passed to it.
 * This function does destroy a marker if possible.
 * See also unmarker.
 *)

unmarkerAndDestroy[x_GBMarker] :=
Module[{TEMP},
  TEMP = RetrieveMarker[x];
  DestroyMarker[x];
  Return[TEMP];
];

unmarkerAndDestroy[x_List] := x;

unmarkerAndDestroy[x___] := BadCall["unmarkerAndDestroy",x];

(* 
 * The following function returns a list of mathematica
 * expressions corresponding to the data passed to it.
 * This function does not destroy any markers.
 * See also unmarkerAndDestroy.
 *)

unmarker[x_GBMarker] := RetrieveMarker[x];
unmarker[x_List] := x;
unmarker[x___] := BadCall["unmarker",x];

(*
 * The following function creates a marker which holds
 * the data. The caller of the routine is responsible
 * for deleting the marker. See also RecordMarkerForDelete
 * and DeleteRecordedMarkers.
 *)

ListToMarker[aList_List,"polynomials"] := 
     sendMarkerList["polynomials",RuleToPol[aList]];

ListToMarker[aList_List,"rules"] := 
     sendMarkerList["rules",PolyToRule[aList]];

ListToMarker[x_GBMarker,s_String] := CopyMarker[x,s];

ListToMarker[x___] := BadCall["ListToMarker",x];

(*
 * The following function records that a specific marker
 * should be deleted sometime in the future. The deletion
 * should be done by the function DeleteRecordedMarkers.
 *)

RecordMarkerForDelete[x_GBMarker,symbol_Symbol] :=
Module[{},
  If[Head[symbol["trash"]]===List
   , symbol["trash"] = {symbol["trash"],x};
   , symbol["trash"] = {};
  ];
  Return[x];
];

RecordMarkerForDelete[x___] := BadCall["RecordMarkerForDelete",x];

(*
 * The following function destroys specific markers
 * which were recorded for deletion by the function RecordMarkerForDelete.
 *)

DeleteRecordedMarkers[symbol_Symbol] :=
Module[{aList},
  If[Head[symbol["trash"]]===List
   , aList = Flatten[symbol["trash"]];
     Do[ DestroyMarker[aList[[i]]];
     ,{i,1,Length[aList]}];
     Clear[symbol];
   , Print["Error in DeleteRecordedMarkers"]; Abort[];
  ];
];

DeleteRecordedMarkers[x___] := BadCall["DeleteRecordedMarkers",x];
