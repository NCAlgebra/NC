If[$VersionNumber>=2.0,
     Print["\nSetting stubs for Groebner basis files."];
     Unprotect[ContextToFilename];
(*
     ContextToFilename["MoraData`"] = "smallMoraData.m";
     DeclarePackage["MoraData`",{"SetMoraNumbers",
                                 "ClearDataBase",
                                 "AddToDataBase",
                                 "WhatIsDataBase",
                                 "DataElement",
                                 "RuleElement",
                                 "ConditionElement",
                                 "ParameterElement",
                                 "AddaMatch",
                                 "ClearSPolynomial",
                                 "WhatAreSPolynomial",
                                 "NonTrivialMoraData",
                                 "MoraDataDebug",
                                 "MoraDataNoDebug",
                                 "ClearToReduceBy",
                                 "ReductionRule",
                                 "ReductionOld",
                                 "SetToReduceBy",
                                 "AppendToReduceBy",
                                 "ResolveInequalities",
                                 "ExtendCases",
                                 "WhatIsPropogateReduction",
                                 "MoraPropogate",
                                 "UsePackageReduction",
                                 "SetPackageReductionName"
                                }
                   ];
*)
     Get["smallMoraData.m"];
(*
     DeclarePackage["Propogate`",{"Propogate",
                                  "PropogatePlus"
                                 }
                   ];
*)
     Get["Propogate.m"];
     If[runningGeneral, Get["smallMatchImplementation.m"];
                      , Get["smallSimpleMatchImplementation.m"];
     ];
     Get["smallMoraAlg.m"];
(*
     ContextToFilename["MoraAlg`"] = "smallMoraAlg.m";
     DeclarePackage["MoraAlg`",{"NCMakeGBOld",
                                "MoraMany",
                                "WhatIsPartialBasis",
                                "WhatIsLeftToMatchAgainst",
                                "MoraOneStep",
                                "CleanUpBasisOld",
                                "NCSCleanUpRulesOld",
                                "ReadOnlyData",
                                "Batch",
                                "NumberOfIterations",
                                "MoraAlgOutputPartialResult",
                                "GroebnerSimplifyOld",
                                "GroebnerPolynomials",
                                "MoraAlgDebug",
                                "MoraAlgNoDebug",
                                "FindMatches",
                                "AMatchSPoly",
                                "MoraMatchDone",
                                "MoraPermuteOrdering",
                                "PropogateFlag",
                                "PropogateReductionFlag",
                                "IsAGroebnerBasis",
                                "LotsOfOutput",
                                "SortRelationsOld",
                                "OrderBetween"
                               }
                  ];
*)

     DeclarePackage["HereditaryCalculus`",{"Hereditary",
                                           "PowerMM",
                                           "Zero",
                                           "Var1",
                                           "Var2"
                                          }
                   ];
     Get["Extra.more"];
     DeclarePackage["NCSetRelations`",{"NCSetRelations"
                                      }
                   ];
     DeclarePackage["NCNotation`",{"NCNotation"
                                  }
                   ];
     Get["Extra.TeXForm"];

     DeclarePackage["Resol`",{"RESOL"
                              }
                   ];
     Protect[ContextToFilename];
     Print["Done setting stubs for Groebner basis files."];
     Print[""];

]; (*end If*)
