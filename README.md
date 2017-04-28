# NCAlgebra - Version 5.0.3

Thanks for your interest in NCAlgebra. 

[![donate](http://math.ucsd.edu/~ncalg/DOCUMENTATION/donate_small.png)](https://giveto.ucsd.edu/make-a-gift?id=d86e6857-0c22-4102-ae7a-bfdc9487cb1d)

The latest version of NCAlgebra can be downloaded from:

https://github.com/NCAlgebra/NC

Additional information, including old releases and historical
examples, is available at:

http://math.ucsd.edu/~ncalg

## Automatic Installation and Updates

Starting with version 5.0.1, the easiest way to download and install
NCAlgebra is using the `NCWebInstall` script. Just type:

    Import["https://raw.githubusercontent.com/NCAlgebra/NC/master/NCExtras/NCWebInstall.m"];

on the Mathematica Kernel or FrontEnd and follow the instructions to download and install NCAlgebra.

This method will always install the latest available stable release
available in the branch `master`. It may be ahead of the latest
release.

Alternatively you can download and install NCAlgebra as outlined below.

Automatic updates are also available using:

    << NCWebUpdate`
    NCUpdate

checks the main repository for the latest version and run
`NCWebInstall`.

## Manual installation

Skip this section if you installed with `NCWebInstall`.

### Downloading

You can download NCAlgebra in one of the following ways.

#### Via `git clone`

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

#### From the github download button

After you downloaded a zip file from github use your favorite zip
utility to unpack the file `NC-master.zip` or `NC-devel.zip` on your
favorite location.

**IMPORTANT:** Rename the top directory `NC`!

#### From one of our releases

Releases are stable snapshots that you can find at

https://github.com/NCAlgebra/NC/releases

**IMPORTANT:** Rename the top directory `NC`!

Earlier releases can be downloaded from:

www.math.ucsd.edu/~ncalg

Releases in github are also branches so you can easily switch from
version to version using git.

### Post-download installation

All that is needed for NCAlgebra to run is that its top directory, the
`NC` directory, be on Mathematica's search path.

If you are on a unix
flavored machine (Solaris, Linux, Mac OSX) then unpacking or cloning
in your home directory (`~`) is all you need to do.

Otherwise, you may need to add the installation directory to
Mathematica's search path. This is done automatically for you if you
used `NCWebInstall`.

**If you are experienced with Mathematica:**

Edit the main *Mathematica* `init.m` file (not the one inside the `NC` directory) to add the name of the directory which contains the `NC` folder to the Mathematica variable `$Path`, as in:

    AppendTo[$Path,"/Users/YourName/"];

You can locate your user `init.m` file by typing:

    FileNameJoin[{$UserBaseDirectory, "Kernel", "init.m"}]

in Mathematica.

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

Extensive documentation is found in the directory [DOCUMENTATION](https://github.com/NCAlgebra/NC/tree/master/DOCUMENTATION).

An [online version of the manual](http://math.ucsd.edu/~ncalg/DOCUMENTATION) is also available.

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
