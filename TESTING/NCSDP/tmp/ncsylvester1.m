AppendTo[$Echo, "stdout"]
SetOptions[$Output,PageWidth->120];

<< NC` 
<< NCAlgebra`

<< NCSDP`

(* All you should see are zeros *)

(* Test NCSDP with scalar polys *)

SNC[a, b, c, d, e, x, y];

F1 = {a ** x + x ** tp[a] + 1, -x};
F2 = {a ** x + x ** tp[a] + b ** y ** c + tp[c] ** tp[y] ** tp[b] + 1, -x};
F3 = F2 /. y -> x /. tp[x] -> x /. b -> a ** c;
F4 = {a ** x ** tp[c] + c ** x ** tp[a] + b ** y ** c + 
      tp[c] ** tp[y] ** tp[b] + 1, -x};
F5 = F4 /. y -> x /. tp[x] -> x /. b -> a;

(* Test NCSDPSymplifySymmetric *)

Map[Norm, NCSDPSimplifySymmetric[F1, {x}] - {{1 + 2 a ** x, -2 x}, {x}, {x}}]

Map[Norm, NCSDPSimplifySymmetric[F2, {x, y}] - {{1 + 2 a ** x + 2 b ** y ** c, -2 x}, {x, y}, {x}}]

Map[Norm, NCSDPSimplifySymmetric[F3, {x}] - {{1 + 2 a ** x + 2 a ** c ** x ** c, -2 x}, {x}, {x}}]

Map[Norm, NCSDPSimplifySymmetric[F4, {x, y}] - {{1 + 2 a ** x ** tp[c] + 2 b ** y ** c, -2 x}, {x, y}, {x}}]

Map[Norm, NCSDPSimplifySymmetric[F5, {x}] - {{1 + 2 a ** x ** c + 2 a ** x ** tp[c], -2 x}, {x}, {x}}]

n = 2;
m = 1;
data = {
   a -> RandomReal[{-10, 10}, {n, n}],
   b -> RandomReal[{-10, 10}, {n, m}],
   c -> RandomReal[{-10, 10}, {n, n}],
   Id[n_] :> IdentityMatrix[n],
   Ze[n_,m_] :> ConstantArray[0, {n, m}]
   };

AA = {{{a, 2 Id[n]}}, {{Id[n], -2 Id[n]}}} /. data;
BB = {};
CC = {-Id[n], Ze[n,n]} /. data;

{abc,rules} = NCSDP[F1, {x}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1}

AA = {{{a, 2 Id[n]},{b, 2c}}, {{Id[n], -2 Id[n]},{Ze[n,m],Ze[n,n]}}} /. data;
CC = {-Id[n], Ze[n,n]} /. data;

{abc,rules} = NCSDP[F2, {x,y}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1}

AA = {{{ArrayFlatten[{{a.c, a}}/.data], ArrayFlatten[{{2 c, 2 Id[n]}}/.data]}}, {{Id[n], -2 Id[n]}}} /. data;
CC = {-Id[n], Ze[n,n]} /. data;

{abc,rules} = NCSDP[F3, {x}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1}

AA = {{{a, 2 Transpose[c]},{b, 2 c}}, {{Id[n], -2 Id[n]},{Ze[n,m],Ze[n,n]}}} /. data;
CC = {-Id[n], Ze[n,n]} /. data;

{abc,rules} = NCSDP[F4, {x,y}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1}

AA = {{{a, 2 (c + Transpose[c])}}, {{Id[n], -2 Id[n]}}} /. data;
CC = {-Id[n], Ze[n,n]} /. data;

{abc,rules} = NCSDP[F5, {x}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1}

(* Test NCSDP with matrix polys *)

SNC[a, b, b1, c1, d12, x, l, w];

F6 = {a ** x + tp[a ** x] + b ** y + tp[b ** y] + 1, -x};
F7 = {{{tp[a] ** x + x ** a, a ** x ** e + x ** b, 
     tp[c]}, {tp[b] ** x + tp[a ** x ** e], -1, tp[d]}, {c, 
     d, -1}}, -x};
F8 = {{{tp[a] ** x + x ** a + b ** y + tp[y] ** tp[b], 
      a ** x ** e + x ** b, tp[c]}, {tp[b] ** x + tp[a ** x ** e], 
      -1, tp[d]}, {c, d, -1}}, -x};
F9 = {a ** x + b ** l + x ** tp[a] + tp[b ** l] + b1 ** tp[b1], 
      -{{w, c1 ** x + d12 ** l}, {tp[c1 ** x + d12 ** l], x}}};

Map[Norm, NCSDPSimplifySymmetric[F6, {x, y}] - {{1 + 2 a ** x + 2 b ** y, -2 x}, {x, y}, {x}}]

Map[Total[Abs[#],Infinity]&, NCSDPSimplifySymmetric[F7, {x}] - {{{{2 x ** a, 2 x ** b + 2 a ** x ** e, tp[c]}, {0, -1, tp[d]}, {c, d, -1}}, -2 x}, {x}, {x}}]

Map[Total[Abs[#],Infinity]&, NCSDPSimplifySymmetric[F8, {x, y}] - {{{{2 b ** y + 2 x ** a, 2 x ** b + 2 a ** x ** e, tp[c]}, {0, -1, tp[d]}, {c, d, -1}}, -2 x}, {x, y}, {x}}]

Map[Total[Abs[#],Infinity]&, NCSDPSimplifySymmetric[F9, {x, l, w}] - {{2 a ** x + 2 b ** l + tp[b1] ** b1, {{-2 w, -2 c1 ** x - 2 d12 ** l}, {0, -2 x}}}, {x, l, w}, {x, w}}]

n = 5;
m = 3;
r = 2;

data = {
   a -> RandomReal[{-10, 10}, {n, n}],
   e -> RandomReal[{-10, 10}, {n, m}],
   b -> RandomReal[{-10, 10}, {n, m}],
   c -> RandomReal[{-10, 10}, {r, n}],
   d -> RandomReal[{-10, 10}, {r, m}]
   };

data = {
  a -> RandomReal[{-10, 10}, {n, n}],
  b -> RandomReal[{-10, 10}, {n, m}],
  b1 -> IdentityMatrix[n],
  c1 -> ConstantArray[0, {m, n}],
  d12 -> IdentityMatrix[m],

  Idn -> IdentityMatrix[n],
  Idm -> IdentityMatrix[m],

  Ze -> ConstantArray[0, {n, n}],
  Zemm -> ConstantArray[0, {m, m}],
  Zenm -> ConstantArray[0, {n, m}],
  Zenpm -> ConstantArray[0, {n + m, n + m}],

  IdX -> ArrayFlatten[{{ConstantArray[0, {m, n}]}, {IdentityMatrix[n]}}],
  IdW -> ArrayFlatten[{{IdentityMatrix[m]}, {ConstantArray[0, {n, m}]}}]

};

AA = {
  {{a, 2 Idn}, {b, 2 Idn}, {Zenm, Transpose[Zenm]}},
  {{IdX, -2 Transpose[IdX]}, {IdW, -2 Transpose[IdX]}, {IdW, -2 Transpose[IdW]}}
} /. data;
CC = {-Idn, Zenpm} /. data;

{abc,rules} = NCSDP[F9, {x,l,w}, data];
Map[Total[Abs[#],Infinity]&, abc - {AA, BB, CC}]
(SymmetricVariables /. rules) - {1, 3}

$Echo = DeleteCases[$Echo, "stdout"];
