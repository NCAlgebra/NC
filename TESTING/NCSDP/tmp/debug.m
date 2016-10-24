AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NCDebug`

logFile = OpenWrite["debug.log"];
SetOptions[NCDebug, DebugLevel -> 1];
SetOptions[NCDebug, DebugLogfile -> logFile];
SetOptions[NCDebug, DebugLogfile -> Append[$Output, logFile]];

a = 1;
b = {{1, 2},{3,4}};
c = {1. 10^(-12),1. 10^12};
d = N[Sqrt[2]];

NCDebug[1, a, b]

NCDebug[2, a, b, c, d]

NCDebug[2, a, b]

NCDebug[1, c]

NCDebug[0, a + b, c + 1]

NCDebug[2, a + b, c + 1]

NCDebug[2.3, a + b, c + 1]

x=1/2
NCDebug[1, x, Sqrt[x]/2, Sqrt[x/2+4/5]/4]

Close[logFile];

$Echo = DeleteCases[$Echo, "stdout"];

