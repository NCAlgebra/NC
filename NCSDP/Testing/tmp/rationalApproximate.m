AppendTo[$Echo, "stdout"]

<< RationalApproximate`

M = 10^12
q = RandomInteger[M]/RandomInteger[M]
qr = RationalApproximate[q, 10^ (-12)]
N[q - qr]

q = RandomInteger[M]
qr = RationalApproximate[q, 10^ (-12)]
N[q - qr]

RationalApproximate[1, 10^ (-12)]

RationalApproximate[0, 10^ (-12)]

qList = Table[RandomInteger[M]/RandomInteger[M], {3}, {2}]
qrList = RationalApproximate[qList, 10^(-12)]
N[qList - qrList]

qrList = RationalApproximate[{qList}, 10^(-12)]
N[{qList} - qrList]

M = 10^200;
q = RandomInteger[M] / RandomInteger[M]
qr = RationalApproximate[q, 10^(-12)]
N[q - qr]

q = 168230589 / 209968810519279354235
qr = RationalApproximate[q, 10^(-12)]
N[q - qr]

q = N[Sqrt[2]]
qr = RationalApproximate[q, 10^(-12)]
N[q - qr]

Rationalize[Sqrt[2],10^(-12)]

q = 1.2323453453453
qr = RationalApproximate[q, 10^(-12)]
N[q - qr]

q = 1.
qr = RationalApproximate[q, 10^(-12)]
N[q - qr]

$Echo = DeleteCases[$Echo, "stdout"];

