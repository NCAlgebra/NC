## NC {#PackageNC}

**NC** is a meta package that enables the functionality of the
*NCAlgebra suite* of non-commutative algebra packages for Mathematica.

The package can be loaded using `Get`, as in

    << NC`

or `Needs`, as in

    Needs["NC`"]

Once NC is loaded, you can then proceed to load any other package from the
*NCAlgebra suite*.

For example you can load the package NCAlgebra using

    << NCAlgebra`

### Options {#PackageNCOptions}

The following `options` can be set using `SetOptions` before loading other packages:

* `SmallCapSymbolsNonCommutative` (`True`): If `True`, loading
  NCAlgebra will set all global single letter small cap symbols as
  noncommutative; {#SmallCapSymbolsNonCommutative}
* `ShowBanner` (`True`): If `True`, a banner, when available, will be shown
  during the first loading of a package.
