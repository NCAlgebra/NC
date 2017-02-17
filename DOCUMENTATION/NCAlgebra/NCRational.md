## NCRational {#PackageNCRational}

This package contains functionality to convert an nc rational expression into a descriptor representation.

For example the rational

    exp = 1 + inv[1 + x]

in variables `x` and `y` can be converted into an NCPolynomial using

    p = NCToNCPolynomial[exp, {x,y}]

which returns

    p = NCPolynomial[a**c, <|{x}->{{1,a,b}},{x**y,x}->{{2,1,c,1}}|>, {x,y}]

Members are:

* [NCRational](#NCRational)
* [NCToNCRational](#NCToNCRational)
* [NCRationalToNC](#NCRationalToNC)
* [NCRationalToCanonical](#NCRationalToCanonical)
* [CanonicalToNCRational](#CanonicalToNCRational)

* [NCROrder](#NCROrder)
* [NCRLinearQ](#NCRLinearQ)
* [NCRStrictlyProperQ](#NCRStrictlyProperQ)

* [NCRPlus](#NCRPlus)
* [NCRTimes](#NCRTimes)
* [NCRTranspose](#NCRTranspose)
* [NCRInverse](#NCRInverse)

* [NCRControllableSubspace](#NCRControllableSubspace)
* [NCRControllableRealization](#NCRControllableRealization)
* [NCRObservableRealization](#NCRObservableRealization)
* [NCRMinimalRealization](#NCRMinimalRealization)

### State-space realizations for NC rationals

#### NCRational {#NCRational}
NCRational::usage

#### NCToNCRational {#NCToNCRational}
NCToNCRational::usage

#### NCRationalToNC {#NCRationalToNC}
NCRationalToNC::usage

#### NCRationalToCanonical {#NCRationalToCanonical}
NCRationalToCanonical::usage

#### CanonicalToNCRational {#CanonicalToNCRational}
CanonicalToNCRational::usage

### Utilities

#### NCROrder {#NCROrder}
NCROrder::usage

#### NCRLinearQ {#NCRLinearQ}
NCRLinearQ::usage

#### NCRStrictlyProperQ {#NCRStrictlyProperQ}
NCRStrictlyProperQ::usage

### Operations on NC rationals

#### NCRPlus {#NCRPlus}
NCRPlus::usage

#### NCRTimes {#NCRTimes}
NCRTimes::usage

#### NCRTranspose {#NCRTranspose}
NCRTranspose::usage

#### NCRInverse {#NCRInverse}
NCRInverse::usage

### Minimal realizations

#### NCRControllableRealization {#NCRControllableRealization}
NCRControllableRealization::usage

#### NCRControllableSubspace {#NCRControllableSubspace}
NCRControllableSubspace::usage

#### NCRObservableRealization {#NCRObservableRealization}
NCRObservableRealization::usage

#### NCRMinimalRealization {#NCRMinimalRealization}
NCRMinimalRealization::usage
