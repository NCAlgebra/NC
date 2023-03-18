## NCAlgebra {#PackageNCAlgebra}

**NCAlgebra** is the main package of the *NCAlgebra suite* of
  non-commutative algebra packages for Mathematica.

The package can be loaded using `Get`, as in

    << NCAlgebra`

or `Needs`, as in

    Needs["NCAlgebra`"]

If the option `SmallCapSymbolsNonCommutative` is `True` then
`NCAlgebra` will set all global single letter small cap symbols as
noncommutative. Set [NCOptions](#PackageNCOptions). If that is not
desired, simply set `SmallCapSymbolsNonCommutative` to `False` before
loading `NCAlgebra`, as in

    << NCOptions`
    SetOptions[NCOptions, SmallCapSymbolsNonCommutative -> False]
    << NCAlgebra`

A message will be issued warning users whether any letters have been
set as noncommutative upon loading. Those messages are documented
[here](#NCAlgebraMessages). Users can use Mathematica's `Quiet` and
`Off` if they do not want these messages to display. For example,

    Off[NCAlgebra`NCAlgebra::SmallCapSymbolsNonCommutative]
    << NCAlgebra`

or

    << NCOptions`
    SetOptions[NCOptions, SmallCapSymbolsNonCommutative -> False]
    Off[NCAlgebra`NCAlgebra::NoSymbolsNonCommutative]
    << NCAlgebra`

will load `NCAlgebra` without issuing a symbol assignment message.

Upon loading `NCAlgebra` for the first time, a large banner will be
shown. If you do not want this banner to be displayed set the
option [`ShowBanner`](#PackageNCOptions) to `False` before loading, as in

    << NCOptions`
    SetOptions[NCOptions, ShowBanner -> False]
    << NCAlgebra`

For example, the following commands will perform a completly quiet
loading of `NC` *and* `NCAlgebra`:

    Quiet[<< NC`, NC`NC::Directory];
	<< NCOptions`
    SetOptions[NCOptions, ShowBanner -> False];
    Quiet[<< NCAlgebra`, NCAlgebra`NCAlgebra::SmallCapSymbolsNonCommutative];

### Messages {#NCAlgebraMessages}

One of the following messages will be displayed after loading.

* `NCAlgebra::SmallCapSymbolsNonCommutative`, if small cap single letter symbols have
  been set as noncomutative;
* `NCAlgebra::NoSymbolsNonCommutative`, if no symbols have been set as noncomutative by
  `NCAlgebra`.
