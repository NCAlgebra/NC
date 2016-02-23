(* This is a simplified copy of NCAlgebra which 
   elimenates some of the Get's which are not
   necessary for the Groebner basis stuff.
 
   It is not maintained in any sense.
*)

System`path  = "/home/osiris/osiris/helton/mathdir/NCAndMora/";
AppendTo[$Path,System`path]; 

Context[ $$OperatingSystem ] = "Global`";
$$OperatingSystem = "UNIX";
Get["NCMultiplication.m"]
Get["NC1SetCommands.m"];
Get["NC2SetCommands.m"];
If[$VersionNumber >= 2.0, Get["NCSetRule.m"];
                          Get["NCPInverses.m"];
];


SetNonCommutative[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

Get["NCDoTeX.m"];
Get["NCMatMult.m"];

Get["NCSubstitute.m"];
Unprotect[ContextToFilename];

If[$VersionNumber >= 2.0, 
     Unprotect[ContextToFileName];
     DeclarePackage["Errors`",{"BadCall",
                               "WhatAreBadArgs"
                              } 
                   ];
     DeclarePackage["ArrayManager`",{"AppendToArray",
                                     "InitializeArray",
                                     "UnionArray",
                                     "UnionListToArray",
                                     "List2Array",
                                     "Array2List",
                                     "JoinListToArray",
                                     "LengthArray",
                                     "PartArray"
                                    }
                   ];
     DeclarePackage["SimpleConvert2`",{"SimpleConvert2",
                                 "SimpleConvert2NormalizeSupress"
                                }
                   ];
     Protect[ContextToFileName];
];

Unprotect[ContextToFilename];
Get["NC2SimplifyRational.m"];
Get["NC1SimplifyRational.m"];
Get["NCSimplifyRational.m"];
Get["NCSubstitute.m"];
Get["NCAlias.m"];

DeclarePackage["NCOutput`",{"SetOutput"
                           }
              ];


If[$VersionNumber>=2.0,
    Print["\nSetting stubs for Groebner basis files."];
     Get["SimpleMoraMatch.m"];
     Get["SimpleMoraAlg.m"];
     Get["Extra.more"];
     DeclarePackage["HereditaryCalculus`",{"Hereditary",
                                           "PowerMM",
                                           "Zero",
                                           "Var1",
                                           "Var2"
                                          }
                   ];
     DeclarePackage["NCSetRelations`",{"NCSetRelations"
                                      }
                   ];

     Get["Extra.TeXForm"];

     Protect[ContextToFilename];
     Print["Done setting stubs for Groebner basis files."];
     Print[""];

]; (*end If*)

Print[" (subset of) NCALGEBRA"];
