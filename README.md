# NCAlgebra - Version 6.0.0

Thanks for your interest in NCAlgebra.

[![donate](http://math.ucsd.edu/~ncalg/DOCUMENTATION/donate_small.png)](https://giveto.ucsd.edu/make-a-gift?id=d86e6857-0c22-4102-ae7a-bfdc9487cb1d)

The latest version of NCAlgebra can be found in:

https://github.com/NCAlgebra/NC

Additional information, including old releases and historical
examples, is available at:

http://math.ucsd.edu/~ncalg

> **WARNING TO USERS OF VERSION 5 AND OLDER:** NCALGEBRA VERSION 6
> CHANGES THE CANNONICAL REPRESENTATION OF NONCOMMUTATIVE EXPRESSIONS.
> 
> THIS IS A BREAKING CHANGE THAT CAN AFFECT EXISTING PROGRAMS USING
> NCALGEBRA.
> 
> THE MOST NOTABLE LIKELY CONSTRUCTION THAT IS AFFECTED BY
> THIS CHANGE IS THE APPLICATION OF RULES BASED ON PATTERN MATCHING,
> WHICH NOW NEED TO EXPLICITLY TAKE INTO ACCOUNT THE PRESENCE OF
> EXPONENTS. SEE MANUAL FOR DETAILS ON HOW TO MITIGATE THE IMPACT OF
> THIS CHANGE. ALL NCALGEBRA COMMANDS HAVE BEEN REWRITTEN TO
> ACCOMODATE FOR THIS CHANGE IN REPRESENTATION.
	

## Installing NCAlgebra

Starting with version 6.0.0, it is recommended that NCAlgebra be
installed using our paclet distribution. Just type:

    PacletInstall["https://github.com/NCAlgebra/NC/blob/v6.0.0/NCAlgebra-6.0.0.paclet?raw=true"];

In the near future we plant to submit paclets to the Wolfram paclet
repository for easier updates.

Alternatively, you can download and install NCAlgebra as outlined in
the [user manual](./DOCUMENTATION#manual-installation).

## Running NCAlgebra

If you installed using our paclet distribution, all NCAlgebra
high-level packages are directly avaiable. For example, in Mathematica
(notebook or text interface), just type

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
supported for backward compatibility. It does nothing more than
posting the message:

	NC::Directory: You are using a paclet version of NCAlgebra.

## Now what?

Extensive documentation is found in the directory
[DOCUMENTATION](./DOCUMENTATION).

Basic documentation is provided on the project Wiki:

https://github.com/NCAlgebra/NC/wiki

You may want to try some of the several demo files in the directory
`DEMOS` after you install NCAlgebra.

You can also run some tests to see if things are working fine.

## Testing

**Testing in v6 is now done by loading a context**

There are 3 test sets which you can use to troubleshoot parts of
NCAlgebra. The most comprehensive test set is run by typing:

    << NCCORETEST`
	
**`NCCORETEST` replaces the old `NCTEST` tests**

This will test the core functionality of NCAlgebra. 

You can test functionality related to the package `NCPoly`, including
the new `NCGBX` package `NCGBX`, by typing:

    << NCPOLYTEST`

Finally our Semidefinite Programming Solver `NCSDP` can be tested with

    << NCSDPTEST`

We recommend that you restart the kernel before and after running
tests. Each test takes a few minutes to run.

You can also call

    << NCPOLYTESGB`
	
to perform extensive and long testing of `NCGBX`.

**Manual installation**

If you are not using the paclet version of `NCAlgebra` you need to load `NC` as in

    << NC`

before running the tests.

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
