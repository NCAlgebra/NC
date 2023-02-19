# NCAlgebra - Version 6.0.0

Thanks for your interest in NCAlgebra.

[![donate](http://math.ucsd.edu/~ncalg/DOCUMENTATION/donate_small.png)](https://giveto.ucsd.edu/make-a-gift?id=d86e6857-0c22-4102-ae7a-bfdc9487cb1d)

The latest version of NCAlgebra can be downloaded from:

https://github.com/NCAlgebra/NC

Additional information, including old releases and historical
examples, is available at:

http://math.ucsd.edu/~ncalg

## Automatic Installation and Updates

Starting with version 6.0.0, the easiest to install NCAlgebra is using
our paclet distribution. Just type:

    PacletInstall["https://github.com/NCAlgebra/NC/blob/v6.0.0/NCAlgebra-6.0.0.paclet?raw=true"];

In the near future we might submit paclets to the Wolfram paclet repository.

Alternatively you can download and install NCAlgebra as outlined below.

## Manual installation

Skip this section if you installed our paclet.

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

Releases in github are also tagged so you can easily switch from
version to version using git.

### Post-download installation

If you are using our paclet distribution you are done. Proceed to the
section [Running NCAlgebra](#running-ncalgebra).

If not, all that is needed for NCAlgebra to run is that its top
directory, the `NC` directory, be on Mathematica's search path.

If you are on a unix
flavored machine (Solaris, Linux, Mac OSX) then unpacking or cloning
in your home directory (`~`) is all you need to do.

Otherwise, you may need to add the installation directory to
Mathematica's search path.

**If you are experienced with Mathematica:**

Edit the main *Mathematica* `init.m` file (not the one inside the `NC` directory) to add the name of the directory which contains the `NC` folder to the Mathematica variable `$Path`, as in:

    AppendTo[$Path,"**YOUR_INSTALLATION_DIRECTORY**"];

You can locate your user `init.m` file by typing:

    FileNameJoin[{$UserBaseDirectory, "Kernel", "init.m"}]

in Mathematica.

## Running NCAlgebra

If you installed our paclet, all NCAlgebra high-level packages are
directly avaiable. For example, in Mathematica (notebook or text
interface), just type

    << NCAlgebra`

to load NCAlgebra.

If you installed manually, then you will need to to type

    << NC`

first before loading any NCAlgebra packages. If this fails, your
installation has problems (check out previous section). If your
installation is succesful you will see a message like:

    NC::Directory: You are using the version of NCAlgebra which is found in: "/your_home_directory/NC".

**In the paclet version, it is no longer necessary to load the context `NC`.**

Loading the context `NC` in the paclet version is however still
supported for backward compatibility. It does nothing other than post
the message:

	NC::Directory: You are using a paclet version of NCAlgebra.

## Now what?

Extensive documentation is found in the directory [DOCUMENTATION](./DOCUMENTATION).

Basic documentation is provided on the project Wiki:

https://github.com/NCAlgebra/NC/wiki

You may want to try some of the several demo files in the directory
`DEMOS` after you install NCAlgebra.

You can also run some tests to see if things are working fine.

## Testing

**Testing in v6 is now done by loading a context**

You do not need to load `NCAlgebra` before running any of the tests
below, but you need to load `NC` as in

    << NC`

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCCORETEST`
	
**`NCCORETEST` replaces the old `NCTEST` tests**

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

    << NCPOLYTESGB`
	
to perform extensive and long testing of `NCGBX`.

## NCGB

Starting with version 6, the old `C++` version of our Groebner Basis
Algorithm is no longer compatible with `NCAlgebra`. Use the `NCGBX`
implementation instead. 

## Reporting Bugs

Please report any bug or your extraordinarily pleasant experience with
NCAlgebra by email

ncalg@math.ucsd.edu

Thanks,

Bill Helton and Mauricio de Oliveira
