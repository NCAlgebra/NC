# NCAlgebra - Version 5.0

Thanks for your interest in NCAlgebra. 

The latest version of NCAlgebra can be downloaded from:

https://github.com/NCAlgebra/NC

Additional information, including old releases and historical
examples, is available at:

http://math.ucsd.edu/~ncalg

## Downloading

You can download NCAlgebra in one of the following ways.

### Clone

You can clone the repository using git:

    git clone https://github.com/NCAlgebra/NC

This will create a directory `NC` which contains all files neeeded to
run NCAlgebra in any platform.

Cloning allows you to easily upgrade and switch between the various
available releases. If you want to try the latest *experimental*
version switch to branch *devel* using:

    git checkout devel

If you're happy with the latest stable release you do not need to
do anything.

### Download

After you downloaded a zip file from github use your favorite zip
utility to unpack the file `NC-master.zip` or `NC-devel.zip` on your
favorite location.

**IMPORTANT:** Rename the top directory `NC`!

### Releases

Releases are stable snapshots that you can find at

https://github.com/NCAlgebra/NC/releases

Earlier releases can be downloaded from:

www.math.ucsd.edu/~ncalg

## Installation

All that is needed for NCAlgebra to run is that its top directory, the
`NC` directory, be on Mathematica's search path. If you are on a unix
flavored machine (Solaris, Linux, Mac OSX) then unpacking or cloning
in your home directory (`~`) is all you need to do. You may want to try
to run NCAlgebra as explained in the next section to see if that
works.

If you want to put the files someplace else, all you need to do is to
modify Mathematica's search path. You can do this in one of two ways:

* Use our installation notebook: 

  You can use our `InstallNCAlgebra.nb` notebook to automagically set up the Mathematica's `$Path` variable. Navigate to the directory `DEMOS` inside the `NC` directory, open this notebook and follow the directions which are found there.

* or, if you are experienced with Mathematica: 

  Edit the main *Mathematica* init.m file (not the one inside the `NC` directory) to add the name of the directory which contains the `NC` folder to the Mathematica variable `$Path`, as in:

        AppendTo[$Path,"/Users/YourName/"];

## Running NCAlgebra

In Mathematica (notebook or text interface), type

    << NC`

If this fails, your installation has problems (check out previous
section). If your installation is succesful you will see a message
like:

    You are using the version of NCAlgebra which is found in:
      /your_home_directory/NC.
    You can now use "<< NCAlgebra`" to load NCAlgebra.

Just type 

    << NCAlgebra`

to load NCAlgebra

## Now what?

Extensive documentation is found in the directory `DOCUMENTATION`.

Basic documentation is provided on the project Wiki:

https://github.com/NCAlgebra/NC/wiki

You may want to try some of the several demo files in the directory
`DEMOS` after you install NCAlgebra.

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

## NCGB

The old `C++` version of our Groebner Basis Algorithm still ships with
this version and can be loaded using:

    << NCGB`

This will at once load `NCAlgebra` *and* `NCGB`. It can be tested
using

	<< NCGBTEST

## Reporting Bugs

Please report any bug or your extraordinarily pleasant experience with
NCAlgebra by email

ncalg@math.ucsd.edu

Thanks,

Bill Helton and Mauricio de Oliveira
