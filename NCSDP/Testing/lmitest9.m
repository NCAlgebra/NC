AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

SetDirectory[$HomeDirectory <> "/work/projects/ipsolver"]

<< SDP`
<< SDPFlat`
<< SDPSeDuMi`

A = {y0 - 2, {{y1, y0}, {y0, 1}}, {{y2, y1}, {y1, 1}}};
b = y2;
y = {y0, y1, y2};

sdp = 1.* SDPMatrices[b, A, y];

sdp = SDPImport["data/arch0"];
sdp = SDPImport["data/control07"];
sdp = SDPImport["data/trto3"];

{Y, X, S, iters} = SDPSolve[sdp];

$Echo = DeleteCases[$Echo, "stdout"];
