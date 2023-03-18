
ParenthesisOutput[aList_List] :=
Module[{noparen,dummy},
  noparen = NCE[aList];
  Clear[dummy];
  Clear[junk];
  CreateCategories[noparen,dummy];
  cats = dummy["AllCategories"];
  Do[ list = cats[[j]];
      junk[list] = junk;
  ,{j,1,Length[cats]}];
  Clear[dummy];
  Clear[junk];
]; 

ParenthesisOutput[x___] := BadCall["ParenthesisOutput",x];
