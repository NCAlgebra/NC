# Things you can do with NCAlgebra and NCGB {#ThingsYouCanDo}

In this page you will find some things that you can do with
`NCAlgebra` and `NCGB`.

## Noncommutative Inequalities

Is a given noncommutative function *convex*? You type in a function of noncommutative variables; the command `NCConvexityRegion[Function, ListOfVariables]` tells you where the (symbolic) `Function` is *convex* in the Variables. This corresponds to papers of *Camino, Helton and Skelton*.

## Linear Systems and Control

`NCAlgebra` integrates with *Mathematica*'s control toolbox (version 8.0 and above) to work on noncommutative block systems, just as a human would do...

Look for NCControl.nb in the `NC/DEMOS` subdirectory.

## Semidefinite Programming

`NCAlgebra` now comes with a numerical solver that can compute the solution to semidefinite programs, aka linear matrix inequalities.

Look for demos in the `NC/NCSDP/DEMOS` subdirectory.

You can also find examples of systems and control linear matrix inequalities problems being manipulated and numerically solved by NCAlgebra on the UCSD course webpage.

Look for the .nb files, starting with the file sat5.nb at Lecture 8.

## NonCommutative Groebner Bases

`NCGB` Computes NonCommutative Groebner Bases and has extensive
sorting and display features and algorithms for automatically
discarding *redundant* polynomials, as well as *kludgy* methods for
suggesting changes of variables (which work better than one would
expect).

`NCGB` runs in conjunction with `NCAlgebra`.

## NCGBX

`NCGBX` is a 100% Mathematica version of our NC Groebner Basis
Algorithm and does not require C/C++ code compilation.

Look for demos in the `NC/NCPoly/DEMOS` subdirectory of the most
current distributions.

**IMPORTANT:** Do not load NCGB and NCGBX simultaneously.

