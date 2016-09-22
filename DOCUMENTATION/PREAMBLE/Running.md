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

Just type 

    << NCAlgebra`

to load `NCAlgebra`, or

    << NCGB`

to load `NCAlgebra` *and* `NCGB`.

## Now what?

Basic documentation is found in the project wiki:

https://github.com/NCAlgebra/NC/wiki

Extensive documentation is found in the directory `DOCUMENTATION`.

You may want to try some of the several demo files in the directory `DEMOS` after installing `NCAlgebra`.

You can also run some tests to see if things are working fine.

## Testing

Type 

    << NCTEST

to test NCAlgebra. Type 

    << NCGBTEST

to test NCGB. We recommend that you restart the kernel before and after running tests. Each test takes a few minutes to run.
