## NCPolyGroebner {#PackageNCPolyGroebner}

This packages implements a Gröebner Bases algorithm that runs purely
under Mathematica. This algorithm is the one called by the
user-friendly functions in the package [NCGBX](#PackageNCGBX).

Members are:

* [NCPolyGroebner](#NCPolyGroebner)

### NCPolyGroebner {#NCPolyGroebner}

`NCPolyGroebner[G, iter]` computes the noncommutative Groebner basis
of the list of `NCPoly` polynomials `G`. The algorithm either
converges before or is interrupted when the number of iterations reach
`iter`.

`NCPolyGroebner[G, iter, options]` uses `options`.

The following `options` can be given:

- `SimplifyObstructions` (`True`) whether to remove obstructions
  before constructing more S-polynomials;
- `SortObstructions` (`False`) whether to sort obstructions using
  Mora's SUGAR ranking;
- `SortBasis` (`False`) whether to sort basis before starting
  algorithm;
- `Labels` (`{}`) list of labels to use in verbose printing;
- `VerboseLevel` (`1`): function used to decide if a pivot is zero;
- `PrintBasis` (`False`): function used to divide a vector by an entry;
- `PrintObstructions` (`False`);
- `PrintSPolynomials` (`False`);

The algorithm is based on [@mora:ICN:1994] and uses the terminology there.

See also:
[NCPoly](#NCPoly).

