## NCPolyGroebner {#PackageNCPolyGroebner}

Members are:

* [NCPolyGroebner](#NCPolyGroebner)

### NCPolyGroebner {#NCPolyGroebner}

`NCPolyGroebner[G]` computes the noncommutative Groebner basis of the
list of `NCPoly` polynomials `G`.

`NCPolyGroebner[G, options]` uses `options`.

The following `options` can be given:

- `SimplifyObstructions` (`True`) whether to simplify obstructions
  before constructions S-polynomials;
- `SortObstructions` (`False`) whether to sort obstructions using
  Mora's SUGAR ranking;
- `SortBasis` (`False`) whether to sort basis before starting
  algorithm;
- `Labels` (`{}`) list of labels to use in verbose printing;
- `VerboseLevel` (`1`): function used to decide if a pivot is zero;
- `PrintBasis` (`False`): function used to divide a vector by an entry;
- `PrintObstructions` (`False`);
- `PrintSPolynomials` (`False`);

The algorithm is based on [@mora:ICN:1994].

See also:
[NCPoly](#NCPoly).

