# Introduction {#UserGuideIntroduction}

This *User Guide* attempts to document the many improvements
introduced in `NCAlgebra` Version 5.0. Please be patient, as we move
to incorporate the many recent changes into this document.

See [Reference Manual](#ReferenceIntroduction) for a detailed
description of the available commands.

## Running NCAlgebra {#RunningNCAlgebra}

In *Mathematica* (notebook or text interface), type

    << NC`

If this step fails, your installation has problems (check out installation instructions on the main page). If your installation is succesful you will see a message like:

    You are using the version of NCAlgebra which is found in:
       /your_home_directory/NC.
    You can now use "<< NCAlgebra`" to load NCAlgebra or "<< NCGB`" to load NCGB.

Then just type 

    << NCAlgebra`

to load `NCAlgebra`.

## Now what?

Extensive documentation is found in the directory `DOCUMENTATION`,
including this document.

Basic documentation is found in the project wiki:

[`https://github.com/NCAlgebra/NC/wiki`](https://github.com/NCAlgebra/NC/wiki)

You may want to try some of the several demo files in the directory
`DEMOS` after installing `NCAlgebra`.

You can also run some tests to see if things are working fine. See
Section [Testing](#Testing).

## Testing

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCTEST

This will test the core functionality of NCAlgebra. You can test
functionality related to the package [`NCPoly`](#NCPolyPackage),
including the new `NCGBX` package [`NCGBX`](#NCGBXPackage), by typing:

    << NCPOLYTEST

Finally our Semidefinite Programming Solver [`NCSDP`](#NCSDPPackage)
can be tested with 

    << NCSDPTEST

We recommend that you restart the kernel before and after running
tests. Each test takes a few minutes to run.

## NCGB

The old `C++` version of our Groebner Basis Algorithm still ships with
this version and can be loaded using:

    << NCGB`

This will at once load `NCAlgebra` *and* `NCGB`. It can be tested
using

	<< NCGBTEST


