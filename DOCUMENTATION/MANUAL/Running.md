# Introduction {#UserGuideIntroduction}

This *User Guide* attempts to document the many improvements
introduced in `NCAlgebra` **Version 6**. Please be patient, as we move
to incorporate the many recent changes into this document.

See [Reference Manual](#ReferenceIntroduction) for a detailed
description of the available commands.

There are also notebooks in the `NC/DEMOS` directory that accompany
each of the chapters of this user guide.

## Installing NCAlgebra {#InstallingNCAlgebra}

Starting with **Version 6**, it is recommended that NCAlgebra be
installed using our paclet distribution. Just type:

    PacletInstall["https://github.com/NCAlgebra/NC/blob/master/NCAlgebra-6.0.2.paclet?raw=true"];

or

    PacletInstall["https://github.com/NCAlgebra/NC/raw/NCAlgebra-6.0.2.paclet"];

for the latest version.

In the near future we plan to submit paclets to the Wolfram paclet
repository for easier updates.

Alternatively, you can download and install NCAlgebra as outlined in
the section [Manual Installation](#ManualInstallation).


## Running NCAlgebra {#RunningNCAlgebra}

In *Mathematica* (notebook or text interface), type 

    << NCAlgebra`

to load `NCAlgebra`.

Advanced options for controlling the loading of `NC` and `NCAlgebra` can be found in [here](#NCOptions) and [here](#PackageNCAlgebra).

> If you performed a manual installation of NCAlgebra you will need to type
> 
>     << NC`
>
> before loading NCAlgebra.
>
> If this step fails, your installation has problems (check out
> installation instructions in 
> [Manual Installation](#ManualInstallation)). If your installation is
> succesful, you will see a message like:
>
>     NC::Directory: You are using the version of NCAlgebra which is
>     found in: "/your_home_directory/NC".
>
> In the paclet version, it is no longer necessary to load the context
> `NC` before running NCAlgebra.
>
> Loading the context `NC` in the paclet version is however still
> supported for backward compatibility. It does nothing more than
> posting the message:
>
>     NC::Directory: You are using a paclet version of NCAlgebra.


## Now what?

Extensive documentation is found at

[https://NCAlgebra.github.io](https://NCAlgebra.github.io)

and in the distribution directory 

[https://github.com/NCAlgebra/NC/DOCUMENTATION](https://github.com/NCAlgebra/NC/DOCUMENTATION)

which includes this document.

You may want to try some of the several demo files in the directory
`DEMOS` after installing `NCAlgebra`.

You can also run some tests to see if things are working fine.

## Testing

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCCORETEST`

This will test the core functionality of NCAlgebra.

You can test functionality related to the package
[`NCPoly`](#PackageNCPoly), including the new `NCGBX` package
[`NCGBX`](#PackageNCGBX), by typing:

    << NCPOLYTEST`

Finally our Semidefinite Programming Solver [`NCSDP`](#PackageNCSDP)
can be tested with 

    << NCSDPTEST`

We recommend that you restart the kernel before and after running
tests. Each test takes a few minutes to run.

You can also call

    << NCPOLYTESTGB`
	
to perform extensive and long testing of `NCGBX`.

> If you performed a manual installation of NCAlgebra you will need to type
>
>     << NC`
>
> before before running any of the tests above.


## Pre-2017 NCGB C++ version

Starting with **Version 6**, the old `C++` version of our Groebner Basis
Algorithm is no longer included. Consider using [`NCGBX`](#PackageNCGBX).

