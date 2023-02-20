System`path  = "/home/osiris/helton/mathdir/NCAndMora/";
AppendTo[$Path,System`path]; 

Context[ $$OperatingSystem ] = "Global`";
$$OperatingSystem = "UNIX";


Get["Errors.m"]; (* For error traps *)

Get["NC1SetCommands.m"];
Print["NC1SetCommands.m loaded"];
Get["NCInverses.m"];
Print["NCInverses.m loaded"];
Get["NCTransposes.m"];
Print["NCTransposes.m loaded"];
Get["NCAdjoints.m"];
Print["NCAdjoints.m loaded"];
Get["NCRoots.m"];
Print["NCRoots.m loaded"];

If[$VersionNumber >= 2.0, Get["NCSetRule.m"];
                          Print["NCSetRule.m loaded"];
                          Get["NCPInverses.m"];
                          Print["NCPInverses.m loaded"];
];

SetNonCommutative[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];

Get["NCCollect.m"];
Print["NCCollect.m loaded"];
(*
Get["NCComplex.m"];
Print["NCComplex.m loaded"];
*)
Get["NCCo.m"];
Print["NCCo.m loaded"];
(*
Get["NCDoTeX.m"];
Print["NCDoTeX.m loaded"];
Get["NCSchur.m"];
Print["NCSchur.m loaded"];
*)
Get["NCSubstitute.m"];
Print["NCSubstitute.m loaded"];
Get["NCMono.m"];
Print["NCMono.m loaded"];
Get["NCSolve.m"];
Print["NCSolve.m loaded"];
Get["NCMatMult.m"];
Print["NCMatMult.m loaded"];
Unprotect[ContextToFilename];

Unprotect[ContextToFilename];
ContextToFilename["BlockPartition`"]="NCBlockPartition.m";
DeclarePackage["BlockPartition`",{"ValueOf",
                                  "BlockQ",
                                  "SetBlock",
                                  "PartitionMatrix",
                                  "FormMatrix"
                                 }
              ];
Protect[ContextToFilename];
   
(*
Get["NC2SimplifyRational.m"];
Print["NC2SimplifyRational.m loaded"];
Get["NC1SimplifyRational.m"];
Print["NC1SimplifyRational.m loaded"];
Get["NC0SimplifyRational.m"];
Print["NC0SimplifyRational.m loaded"];
Get["NCSimplifyRational.m"];
Print["NCSimplifyRational.m loaded"];
Get["NCDiff.m"];
Print["NCDiff.m loaded"];
*)
Get["NCAliasFunctions.m"];
Print["NCAliasFunctions.m loaded"];
Get["NCAlias.m"];
Print["NCAlias.m loaded"];
   
DeclarePackage["NCSave`",{"NCSave"
                         }
              ];

DeclarePackage["NCOutput`",{"SetOutput"
                           }
              ];

(*
DeclarePackage["NCMessyFunction`",{"coexx",
                                   "coexz",
                                   "coezz",
                                   "DGXX",
                                   "DGYY",
                                   "inXY",
                                   "inYX",
                                   "resid",
                                   "A",
                                   "C1","C2","B1","B2",
                                   "XX","YY",
                                   "D12","D21",
                                   "d12","d21",
                                   "e1","e2" 
                                  }
              ];
*)
