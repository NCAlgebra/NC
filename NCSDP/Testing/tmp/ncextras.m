AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC`
<< NCAlgebra`

<< NC`NCExtras`

SNC[a,b,c,d,e,f,g,h]
SNC[x,y,z]
SNC[w,w1,w2,w3]

exp1 = a**x + tp[x]**b + c + x + tp[x]

lag1 = tr[tp[w]**exp1]
lag2 = tr[tp[exp1]**w]

Grad[lag1,w]
Grad[lag2,w]

Grad[lag1,x]
Grad[lag2,x]

exp2 = c**y**d + y + tp[y] + d**tp[x]**f
exp3 = {{a**x+x**tp[a],b**y},{tp[y]**tp[b],x}}

NCAdjoint[exp1, w, x]
NCAdjoint[exp2, w, x]
NCAdjoint[exp1, w, {x}]

NCAdjoint[{exp1,exp2}, {w,z}, x]
NCAdjoint[{exp1,exp2}, {w,z}, y]

NCAdjoint[{exp1,exp2}, {w,z}, {x, y}]

NCAdjoint[exp3, {{w1,w2},{tp[w2],w3}}, x]
NCAdjoint[exp3, {{w1,w2},{tp[w2],w3}}, y]
NCAdjoint[exp3, {{w1,w2},{tp[w2],w3}}, {x, y}]

NCAdjoint[exp3, {{w1,w2},{tp[w2],w3}}, {x, y}]

NCIsAffine[exp1, x]
NCIsAffine[exp1, {x}]
NCIsAffine[{exp1}, {x}]

NCIsLinear[exp1, x]
NCIsLinear[exp1, {x}]
NCIsLinear[{exp1}, {x}]

NCIsAffine[exp1-c, x]
NCIsAffine[exp1-c, {x}]
NCIsAffine[{exp1-c}, {x}]

NCIsLinear[exp1-c, x]
NCIsLinear[exp1-c, {x}]
NCIsLinear[{exp1-c}, {x}]

NCIsAffine[x**exp1, x]
NCIsAffine[x**exp1, {x}]
NCIsAffine[{x**exp1}, {x}]

NCIsLinear[x**exp1, x]
NCIsLinear[x**exp1, {x}]
NCIsLinear[{x**exp1}, {x}]

NCIsAffine[exp1, {x, y}]
NCIsLinear[exp1, {x, y}]

NCIsAffine[exp1 - c, {x, y}]
NCIsLinear[exp1 - c, {x, y}]

NCIsAffine[{exp1,exp2}, x]
NCIsAffine[{exp1,exp2}, {x, y}]

NCIsLinear[{exp1,exp2}, x]
NCIsLinear[{exp1,exp2}, {x, y}]

NCIsLinear[{exp1-c,exp2}, x]
NCIsLinear[{exp1-c,exp2}, {x, y}]

NCIsAffine[exp3, {x, y}]
NCIsAffine[MatMult[exp3,exp3], {x, y}]

NCIsLinear[exp3, {x, y}]
NCIsLinear[MatMult[exp3,exp3], {x, y}]

$Echo = DeleteCases[$Echo, "stdout"];
