## NC {#PackageNC}

**NC** is a meta package that enables the functionality of the
*NCAlgebra suite* of non-commutative algebra packages for Mathematica.

> If you installed the paclet version of NCAlgebra it is not necessary
> to load the context `NC` before loading other `NCAlgebra`
> packages. 
>
> Loading the context `NC` in the paclet version is however still
> supported for backward compatibility. It does nothing more than
> posting the message:
>
>     NC::Directory: You are using a paclet version of NCAlgebra.

The package can be loaded using `Get`, as in

    << NC`

or `Needs`, as in

    Needs["NC`"]

Once `NC` is loaded you will see a message like

    NC::Directory: You are using the version of NCAlgebra which is found in: "/your_home_directory/NC".

or 

    NC::Directory: You are using a paclet version of NCAlgebra.

if you installed from our paclet distribution.

You can then proceed to load any other package from the *NCAlgebra suite*.

For example you can load the package `NCAlgebra` using

    << NCAlgebra`

See section [NCAlgebra](#PackageNCAlgebra) and
[NCOptions](#PackageNCOptions) for more options and details available
while loading `NCAlgebra`.

The `NC::Directory` message can be suppressed by using standard Mathematica message control functions. For example,

    Off[NC`NC::Directory]
    << NC`

or

    Quiet[<< NC`, NC`NC::Directory]

will load `NC` quietly. Note that you have to refer to the message by
its fully qualified name ``NC`NC::Directory`` because the context
`NC` is only available after loading the package.
