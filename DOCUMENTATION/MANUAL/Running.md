# Introduction {#UserGuideIntroduction}

This *User Guide* attempts to document the many improvements
introduced in `NCAlgebra` Version 5.0. Please be patient, as we move
to incorporate the many recent changes into this document.

See [Reference Manual](#ReferenceIntroduction) for a detailed
description of the available commands.

There are also notebooks in the `NC/DEMOS` directory that accompany
each of the chapters of this user guide.

## Running NCAlgebra {#RunningNCAlgebra}

In *Mathematica* (notebook or text interface), type

    << NC`

If this step fails, your installation has problems (check out installation instructions on the main page). If your installation is succesful you will see a message like:

    You are using the version of NCAlgebra which is found in:
       /your_home_directory/NC.
    You can now use "<< NCAlgebra`" to load NCAlgebra.

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

You can also run some tests to see if things are working fine.

## Testing

You do not need to load `NCAlgebra` before running any of the tests
below, but you need to load `NC` as in

    << NC`

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCTEST

This will test the core functionality of NCAlgebra.

You can test functionality related to the package
[`NCPoly`](#PackageNCPoly), including the new `NCGBX` package
[`NCGBX`](#PackageNCGBX), by typing:

    << NCPOLYTEST

Finally our Semidefinite Programming Solver [`NCSDP`](#PackageNCSDP)
can be tested with 

    << NCSDPTEST

We recommend that you restart the kernel before and after running
tests. Each test takes a few minutes to run.

You can also call

    << NCPOLYTESGB
	
to perform extensive and long testing of `NCGBX`.

## Pre-2017 NCGB C++ version

The old `C++` version of our Groebner Basis Algorithm still ships with
this version and can be loaded using:

    << NCGB`

This will at once load `NCAlgebra` *and* `NCGB`. It can be tested
using

	<< NCGBTEST


