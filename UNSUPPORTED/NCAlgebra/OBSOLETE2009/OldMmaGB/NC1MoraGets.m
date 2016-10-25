If[$VersionNumber >= 2.0, 
         Unprotect[ContextToFilename];
         Get["NCMtools.m"];
         DeclarePackage["Inequalities`",{"SetInequalityFactBase",
	                                 "InequalityFactQ",
                                         "InequalitySearch",
                                         "InequalityToStandardForm",
                                         "NumericalLeafs",
                                         "BoundedQ",
                                         "LowerBound",
                                         "UpperBound",
                                         "SimplifyInequality"
                                        }
                       ]; 
           DeclarePackage["Grabs`",{"GrabInsides",
                                    "GrabSubExpr",
                                    "GrabVariable",
                                    "GrabVariables",
                                    "GrabIndeterminants"
                                    }
                          ];
           Get["smallTuples.m"];
(*
           ContextToFilename["Tuples`"] = "smallTuples.m";
           DeclarePackage["Tuples`",{"ToRuleTuple",
                                     "CleanUpTuple",
                                     "SmartTupleUnion",
                                     "CleanUpPolynomialTuple"
                                    }
                          ];
*)
           DeclarePackage["ArrayManager`",{"AppendToArray",
                                           "InitializeArray",
                                           "UnionArray",
                                           "UnionListToArray",
                                           "ListToArray",
                                           "List2Array",
                                           "ArrayToList",
                                           "Array2List",
                                           "JoinListToArray",
                                           "LengthArray",
                                           "PartArray",
                                           "MapToArray",
                                           "MakeIndexArray"
                                          }
                         ];
     DeclarePackage["SimplePower`",{"TheBase",
                                    "ThePower"
                                   }
                   ];
     DeclarePackage["ManipulatePower`",{"CollapsePower",
                                        "PowerRuleTuple",
                                        "FixPowerRuleTuple",
                                        "GrabPowers",
                                        "PowerDebug",
                                        "PowerNoDebug"
                                       }
                   ];
     Get["linearConvert.m"];

     Get["NCMakeGreater.m"];
     Get["NCGBMax.m"];
     Get["NCGBConvert.m"];

     DeclarePackage["Lazy`",{"PowerToLazyPower",
                             "LazyPowerToPower",
                             "LazyPower",
                             "CollapseLazyPower",
                             "LazyPowerRuleTuple",
                             "FixLazyPowerRuleTuple"
                            }
                   ];
     DeclarePackage["Ajize`",{"Rank1",
                              "Aj",
                              "Ajize",
                              "ToAj"
                              }
                   ];
     DeclarePackage["NCSort`",{"NCSort",
                               "NCGreater",
                               "NCLength",
                               "LeadingCoefficientOne",
                               "SetHeadOrder",
                               "WhatIsHeadOrder"
                              }
                   ];
If[ readInNF,
     Print["\nSetting stubs for NCNagyFoias files."]; 
     DeclarePackage["NCNagyFoias`",{"NCNagyFoias"
                               }
                   ];
     DeclarePackage["NCNagyFoiasRt`",{"NCNagyFoiasRt"
                                 }
                   ];
     DeclarePackage["NCNagyFoiasRtJ`",{"NCNagyFoiasRtJ"
                                  }
                   ];
];
     Protect[ContextToFilename];
     Print["Done setting stubs for NCNagyFoias files.\n"];


    ,Print["\nYou are using Mathematica version ",$VersionNumber];
     Print["The version of Mathematica required for installation"];
     Print["of NCFoias, NCFoiasRt and NCFoiasRtJ is at least 2.0."];
     Print["\n"];
     Print["This message may be ignored if you do not need to use"];
     Print["these functions."];
     Print["\n"];
];
