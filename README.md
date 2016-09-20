# NCAlgebra

Thanks for your insterest in NCAlgebra.

The latest release of NCAlgebra can be downloaded from:

https://github.com/ncalgebra/NC/releases

Earlier versions can be downloaded from:

www.math.ucsd.edu/~ncalg

The latest stable experimental version is on github on the branch devel.

## Downloading

* You can clone the repository using git:

  ```
  git clone https://github.com/ncalgebra/NC
  ```

  This will create a directory NC which contains all files neeeded to
  run NCAlgebra in any platform.

* Or if you downloaded a zip file from github:

  Use your favorite zip utility to unpack the file `NC-master.zip` or
  `NC-devel.zip` on your favorite location. Rename the top directory
  `NC`.

## Installation

All that is needed for NCAlgebra to run is that its top directory, the
'NC' directory, be on Mathematica's search path. If you are on a unix
flavored machine (Solaris, Linux, Mac OSX) then unpacking or cloning
in your home directory (`~`) is all you need to do. You may want to try
to run NCAlgebra as explained in the next section to see if that
works.

If you want to put the files someplace else, all you need to do is to
modify Mathematica's search path. You can do this in one of two ways:

* If you are experienced with Mathematica: 

  Edit your `init.m` file to add the name of the directory which
  contains the `NC` folder to the Mathematica variable `$Path`.

* Or 

  You can use our `InstallNCAlgebra.nb` notebook to automagically set
  up the Mathematica's `$Path` variable. Open this notebook and follow
  the directions which are found there.

## Running NCAlgebra

In Mathematica (notebook or text interface), type

    << NC`

If this fails, your installation has problems (check out previous
section). If your installation is succesful you will see a message
like:

    You are using the version of NCAlgebra which is found in:
      /your_home_directory/NC.
    You can now use "<< NCAlgebra`" to load NCAlgebra or "<< NCGB`" to load NCGB.

Just type 

    << NCAlgebra`

to load NCAlgebra, or

    << NCGB`

to load NCAlgebra and NCGB.

## Now what?

Extensive documentation is found in the directory `DOCUMENTATION`.

You may want to try some of the several demo files in the directory
DEMOS after you install NCAlgebra.

You can also run some tests to see if things are working fine.

## Testing

Type 

    << NCTEST

to test NCAlgebra. Type 

    << NCGBTEST

to test NCGB. We recommend that you restart the kernel before and
after running each test set.

## Reporting Bugs

Please report any bug or your extraordinarily pleasant experience with
NCAlgebra by email

ncalg@math.ucsd.edu

Thanks,

Bill Helton, Mauricio de Oliveira & Mark Stankus
