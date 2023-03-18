### NCOptions {#PackageNCOptions}

The following `options` can be set using `SetOptions` before loading other packages:

* `SmallCapSymbolsNonCommutative` (`True`): If `True`, loading
  `NCAlgebra` will set all global single letter small cap symbols as
  noncommutative;
* `ShowBanner` (`True`): If `True`, a banner, when available, will be shown
  during the first loading of a package.
* `UseNotation` (`False`): If `True` use Mathematica's package
  `Notation` when setting pretty output in
  [`NCSetOutput`](#NCSetOutput).

For example,

    << NC`
    << NCOptions`
	SetOptions[NCOptions, ShowBanner -> False];
	<< NCAlgebra`

suppress the NCAlgebra banner that is printed the first time NCAlgebra
is loaded.
