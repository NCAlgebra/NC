Get["NCGB.m"];

SNC[v1,e1,x1,v2,e2,x2];

T1 = {{ v1, e1},{0,Aj[x1]}};
T2 = {{ v2, e2},{0,Aj[x2]}};

MyAj[x_List] := Map[MyAj,x];
MyAj[x_Aj] := x;
MyAj[x_?NumberQ] = Conjugate[x];
MyAj[x_ + y_] := MyAj[x] + MyAj[y];
MyAj[x_NonCommutativeMultiply] := 
   Apply[NonCommutativeMultiply,MyAj[Reverse[Apply[List,x]]]];
MyAj[x_Times] := Apply[Times,MyAj[Apply[List,x]]];
MyAj[x_] := Aj[x];

AjT1 = MyAj[Transpose[T1]];
AjT2 = MyAj[Transpose[T2]];

Print["MyT1"];
Print[MatrixForm[MyT1]];
Print[];
Print["MyT2"];
Print[MatrixForm[MyT2]];

SetKnowns[v1,v2,Aj[v1],Aj[v2]];
SetUnknowns[{e1,e2,x1,x2,Aj[e1],Aj[e2],Aj[x1],Aj[x2]}];


rels = {
MatMult[T1,T2] - MatMult[T2,T1], (* unitary extensions commute *)
MatMult[AjT1,T1] - IdentityMatrix[2], (* T1 unitary *)
MatMult[T1,AjT1] - IdentityMatrix[2], (* T1 unitary *)
MatMult[AjT2,T2] - IdentityMatrix[2], (* T2 unitary *)
MatMult[T2,AjT2] - IdentityMatrix[2] (* T2 unitary *)
};

rels = Union[Flatten[{MyAj[rels],rels}]];
Print["rels:"];
Print[ColumnForm[rels]];

RegularOutput[rels,"junk1"];

ans = NCProcess[rels,3,"junk2"];
