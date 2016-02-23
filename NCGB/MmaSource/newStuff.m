
NCGBSetUp[] :=
Module[{},
  RecordEnvironment["left-invertible",c**a-1];
  RecordEnvironment["right-invertible",a**c-1];
  RecordEnvironment["self-adjoint",a-b];
  RecordEnvironment["unitary",c-b];
  RecordEnvironment["isometry",b**a-1];
  RecordEnvironment["coisometry",a**b-1];
  RecordEnvironment["isosymmetry", a - b - b**a**a + b**b**a];
  RecordEnvironment["coisosymmetry", -a + b + a**a**b - a**b**b];
  RecordEnvironment["normal",a**b-b**a];
];

NCGBSetLeftInvertible[v_] := AddToEnvironment["left-invertible",v];
NCGBSetLeftInvertible[v___] := BadCall["NCGBSetLeftInvertible",v];

NCGBSetRightInvertible[v_] := AddToEnvironment["right-invertible",v];
NCGBSetRightInvertible[v___] := BadCall["NCGBSetRightInvertible",v];

NCGBSetInvertible[v_] := 
   (NCGBSetLeftInvertible[v];
    NCGBSetRightInvertible[v];);
NCGBSetInvertible[v___] := BadCall["NCGBSetInvertible",v];

NCGBSetSelfAdjoint[v_] := AddToEnvironment["self-adjoint",v];
NCGBSetSelfAdjoint[v___] := BadCall["NCGBSetSelfAdjoint",v];

NCGBSetIsometry[v_] := AddToEnvironment["isometry",v];
NCGBSetIsometry[v___] := BadCall["NCGBSetIsometry",v];

NCGBSetCoIsometry[v_] := AddToEnvironment["coisometry",v];
NCGBSetCoIsometry[v___] := BadCall["NCGBCoIsometry",v];

NCGBSetUnitary[v_] := 
    (NCGBSetInvertible[v];
     NCGBSetCoIsometry[v];
     NCGBSetIsometry[v];);
NCGBSetUnitary[v___] := BadCall["NCGBSetUnitary",v];

NCGBSetIsosymmetry[v_] := AddToEnvironment["isosymmetry",v];
NCGBSetIsosymmetry[v___] := BadCall["NCGBSetIsosymmetry",v];

NCGBSetCoIsosymmetry[v_] := AddToEnvironment["coisosymmetry",v];
NCGBSetCoIsosymmetry[v___] := BadCall["NCGBSetCoIsosymmetry",v];

NCGBSetNormal[v_] := AddToEnvironment["normal",v];
NCGBSetNormal[v___] := BadCall["NCGBSetNormal",v];
