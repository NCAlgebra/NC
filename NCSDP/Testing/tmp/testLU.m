AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< MatrixDecompositions`

(* All answers should be zero or small *)

A1 = {{3, 17, 10}, {2, 4, -2}, {6, 18, -12}}
A2 = A1;
A2[[3]] = A2[[1]] - A2[[2]];
A3 = Join[A1, {{1}, {3}, {4}}, 2];
A4 = A1[[All,{1,2}]];
A5 =SparseArray[A1];

{lu, p, q, rank} = LUDecompositionWithCompletePivoting[A1];
{l1, u1} = LUMatrices[lu];
l1.u1 - A1[[p, q]]
rank - 3

{lu, p, q, rank} = LUDecompositionWithCompletePivoting[A2];
{l, u} = LUMatrices[lu];
l.u - A2[[p, q]]
rank - 2

{lu, p, q, rank} = LUDecompositionWithCompletePivoting[A3];
{l, u} = LUMatrices[lu];
l.u - A3[[p, q]]
rank - 3

{lu, p, q, rank} = LUDecompositionWithCompletePivoting[A4];
{l, u} = LUMatrices[lu];
l.u - A4[[p, q]]
rank - 2

{lu, p, q, rank} = LUDecompositionWithCompletePivoting[A5];
{l, u} = LUMatrices[lu];
l.u - A5[[p, q]] // Normal
l - l1
u - u1
rank - 3

(* Full rank test *)
mMIN = nMIN = 3;
mMAX = nMAX = 30;
mINC = nINC = 10;

For[ m = mMIN, m <= mMAX, m += mINC,

  For[ n = nMIN, n <= mMAX, n += nINC,

    range = 10;
    A = RandomInteger[{-range,range}, {m,n}];

    {lu, p, q, rank} = LUDecompositionWithCompletePivoting[A];
    {l, u} = LUMatrices[lu];
    Print["A(", m, ",", n, \
          "),\trank = ", rank, \
          "\tres = ", Norm[l.u - A[[p, q]]]
    ];
  ];
];

(* Full rank test (sparse) *)
mMIN = nMIN = 3;
mMAX = nMAX = 30;
mINC = nINC = 10;

For[ m = mMIN, m <= mMAX, m += mINC,

  For[ n = nMIN, n <= mMAX, n += nINC,

    range = 10;
    A = SparseArray[RandomInteger[{-range,range}, {m,n}]];

    {lu, p, q, rank} = LUDecompositionWithCompletePivoting[A];
    {l, u} = LUMatrices[lu];
    Print["A(", m, ",", n, \
          "),\trank = ", rank, \
          "\tres = ", Norm[l.u - A[[p, q]]]
    ];
  ];
];

(* Low rank test *)
mMIN = nMIN = 4;
mMAX = nMAX = 30;
mINC = nINC = 10;

For[ m = mMIN, m <= mMAX, m += mINC,

  For[ n = nMIN, n <= mMAX, n += nINC,

    range = 10;
    A = RandomInteger[{-range,range}, {m,n}];

    A[[m]] = A[[m-2]] - A[[m-3]];
    A[[m-1]] = A[[m-2]] + A[[m-3]];

    {lu, p, q, rank} = LUDecompositionWithCompletePivoting[A];
    {l, u} = LUMatrices[lu];
    Print["A(", m, ",", n, \
          "), \trank = ", rank, \
          "\tres = ", Norm[l.u - A[[p, q]]]
    ];

  ]
]

$Echo = DeleteCases[$Echo, "stdout"];
