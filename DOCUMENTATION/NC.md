## NC {#PackageNC}

**NC** is a meta package that enables the functionality of the
*NCAlgebra suite* of non-commutative algebra packages for Mathematica.

The package can be loaded using `Get`, as in

    << NC`

or `Needs`, as in

    Needs["NC`"]

Once `NC` is loaded you will see a message like

    NC::Directory: You are using the version of NCAlgebra which is found in: "/your_home_directory/NC".

You can then proceed to load any other package from the *NCAlgebra suite*.

For example you can load the package `NCAlgebra` using

    << NCAlgebra`

The `NC::Directory` message can be suppressed by using standard Mathematica message control functions. For example,

    Off[NC`NC::Directory]
    << NC`

or

    Quiet[<< NC`, NC`NC::Directory]

will load `NC` quietly. Note that you have to refer to the message by
its fully qualified name `NC``NC::Directory` because the context
`NC``` is only available after loading `NC`.

### Options {#PackageNCOptions}

The following `options` can be set using `SetOptions` before loading other packages:

* `SmallCapSymbolsNonCommutative` (`True`): If `True`, loading
  `NCAlgebra` will set all global single letter small cap symbols as
  noncommutative;
* `ShowBanner` (`True`): If `True`, a banner, when available, will be shown
  during the first loading of a package.
