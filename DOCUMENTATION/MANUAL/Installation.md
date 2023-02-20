## Manual Installation {#ManualInstallation}

Manual installation is no longer necessary nor advisable. Consider
installing NCAlgebra via our paclet distribution, as discussed in
section [Installing NCAlgebra](#InstallingNCAlgebra).

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

All that is needed for NCAlgebra to run is that its top directory, the
`NC` directory, be on Mathematica's search path.

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
