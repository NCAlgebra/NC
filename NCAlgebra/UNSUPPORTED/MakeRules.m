<<GBRules.m
<<check.m
Print["Hi"];
thepreNF = check[preNFtotal];
theNF = check[NFtotal];
theNFJ = check[Union[NFtotal,jrules]];
MakeRuleDelayedBasedPackage["NCNagyFoias",GBExplode[thepreNF,{x,y}]];
MakeRuleDelayedBasedPackage["NCNagyFoiasRt",GBExplode[theNF,{x,y}]];
MakeRuleDelayedBasedPackage["NCNagyFoiasRtJ",GBExplode[theNFJ,{x,y}]];
