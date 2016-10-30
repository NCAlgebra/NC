# Pretty Output with TeX {#TeX}

`NCAlgebra` comes with several utilities for facilitating formatting
of expression in notebooks or using LaTeX.

## Pretty Output {#Pretty_Output}

## Using NCTeX {#Using_NCTeX}

You can load NCTeX using the following command

    << NC` 
	<< NCTeX`

`NCTeX` does not need `NCAlgebra` to work. You may want to use it even
when not using NCAlgebra. It uses `NCRun`, which is a replacement for
Mathematica's Run command to run `pdflatex`, `latex`, `divps`, etc.

With `NCTeX` loaded you simply type `NCTeX[expr]` and your expression
will be converted to a PDF image after being processed by `LaTeX`:

	expr = 1 + Sin[x + (y - z)/Sqrt[2]]
	NCTeX[expr]

produces

$1 + \sin \left ( x + \frac{y - z}{\sqrt{2}} \right )$

If `NCAlgebra` is not loaded then `NCTeX` uses the built in
`TeXForm` to produce the LaTeX expressions. If `NCAlgebra` is loaded,
`NCTeXForm` is used. See [NCTeXForm](#NCTeXForm) for details.

Here is another example:

	expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
	NCTeX[expr]

produces 

$\left(
\begin{array}{cc}
 \sin \left(x+\frac{y-z}{\sqrt{2}}\right)+1 &
   \frac{x}{y} \\
 z & \sqrt{5} n \\
\end{array}
\right)$

In some cases Mathematica will have difficulty displaying certain PDF
files. When this happens `NCTeX` will span a PDF viewer so that you
can look at the formula. If your PDF viewer does not pop up
automatically you can force it by passing the following option to
`NCTeX`:

	expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
	NCTeX[exp, DisplayPDF -> True]

Here is another example were the current version of Mathematica fails
to import the PDF:

	expr = Table[x^i y^(-j) , {i, 0, 10}, {j, 0, 30}];
	NCTeX[expr, DisplayPDF -> True]

You can also suppress Mathematica from importing the PDF altogether as
well. This and other options are covered in detail in the next
section.

### NCTeX Options {#NCTeX_Options}

The following command:

	expr = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
	NCTeX[exp, DisplayPDF -> True, ImportPDF -> False]

uses `DisplayPDF -> True` to ensure that the PDF viewer is called and
`ImportPDF -> False` to prevent Mathematica from displaying the
formula inline. In other words, it displays the formula in the PDF
viewer without trying to import the PDF into Mathematica. The default
values for these options when using the Mathematica notebook interface
are:

1. DisplayPDF -> False
2. ImportPDF -> True 

When `NCTeX` is invoked using the command line interpreter version of
Mathematica the defaults are:

1. DisplayPDF -> False
2. ImportPDF -> True 

Other useful options and their default options are:

1. Verbose -> False, 
2. BreakEquations -> True
3. TeXProcessor -> NCTeXForm

Set `BreakEquations -> True` to use the LaTeX package `beqn` to
produce nice displays of long equations. Try the following
example:

    expr = Series[Exp[x], {x, 0, 20}]
    NCTeX[expr]

Use `TexProcessor` to select your own `TeX` converter. If `NCAlgebra`
is loaded then `NCTeXForm` is the default. Otherwise Mathematica's
`TeXForm` is used.

If `Verbose -> True` you can see a detailed display of what is going
on behing the scenes. This is very useful for debugging. For example,
try:

	expr = BesselJ[2, x]
	NCTeX[exp, Verbose -> True]

to produce an output similar to the following one:

    * NCTeX - LaTeX processor for NCAlgebra - Version 0.1
	> Creating temporary file '/tmp/mNCTeX.tex'...
	> Processing '/tmp/mNCTeX.tex'...
	> Running 'latex -output-directory=/tmp/  /tmp/mNCTeX 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
	> Running 'dvips -o /tmp/mNCTeX.ps -E /tmp/mNCTeX 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
	> Running 'epstopdf  /tmp/mNCTeX.ps 1> "/tmp/mNCRun.out" 2> "/tmp/mNCRun.err"'...
	> Importing pdf file '/tmp/mNCTeX.pdf'...

Locate the files with extension .err as indicated by the verbose run
of NCTeX to diagnose errors.

The remaining options:

1. PDFViewer -> "open", 
2. LaTeXCommand -> "latex" 
3. PDFLaTeXCommand -> "pdflatex"
4. DVIPSCommand -> "dvips" 
5. PS2PDFCommand -> "epstopdf"

let you specify the names and, when appropriate, the path, of the
corresponding programs to be used by `NCTeX`. Alternatively, you can
also directly implement custom versions of

	NCRunDVIPS
	NCRunLaTeX
	NCRunPDFLaTeX
	NCRunPDFViewer
	NCRunPS2PDF

Those commands are invoked using `NCRun`. Look at the documentation
for the package [NCRun](#NCRun) for more details.

## Using NCTeXForm {#Using_NCTeXForm}

`NCTeXForm` is a replacement for Mathematica's `TeXForm` that can
handle noncommutative expressions. It works just as
`TeXForm`. `NCTeXForm` is automatically loaded with `NCAlgebra` and
becomes the default processor for `NCTeX`.

Here is an example:

	SetNonCommutative[a, b, c, x, y];
	exp = a ** x ** tp[b] - inv[c ** inv[a + b ** c] ** tp[y] + d]
	NCTeXForm[exp]

produces
	
	a*\!\!*x*\!\!*{b}^T-{\left(d+c*\!\!*{\left(a+b*\!\!*c\right)}^{-1}*\!\!*{y}^T\right)}^{-1}

Note that the LaTeX output contains special code so that the
expression looks neat on the screen. You can see the result using
`NCTeX` to convert the expression to PDF. Try

	SetOptions[NCTeX, TeXProcessor -> NCTeXForm];
	NCTeX[exp]

to produce

$a*\!\!*x*\!\!*{b}^T-{\left(d+c*\!\!*{\left (a+b*\!\!*c\right)}^{-1}*\!\!*{y}^T\right )}^{-1}$

`NCTeX` also handles standard functions just as `TeXForm`:

	exp = {{1 + Sin[x + (y - z)/2 Sqrt[2]], x/y}, {z, n Sqrt[5]}}
	NCTeX[exp]

produces

$\begin{bmatrix} 1+\operatorname{sin}{\left (x+\frac{1}{\sqrt{2}}*\left (y-z\right )\right )} & x*{y}^{-1} \\ z & \sqrt{5}*n \end{bmatrix}$

`NCTeX` represents commutative products with a single `*` in order to
distinguish it from its noncommutative cousin `**`. We can see the
difference in an expression that has both commutative and
noncommutative products:

	exp = 2 ** a ** b - 3 c ** d
	NCTeX[exp]

produces

$-3*c*d+2*\left(a*\!\!*b\right)$

NCTeXForm handles lists and matrices as well. Here is a list:

	exp = {x, tp[x], x + y, x + tp[y], x + inv[y], x ** x}
	NCTeX[exp]

and its output:

$\{ x, {x}^T, x+y, x+{y}^T, x+{y}^{-1}, x*\!\!*x \}$

and here is a matrix example:

	exp = {{x, y}, {y, z}}
	NCTeX[exp]

and its output:

$\begin{bmatrix} x & y \\ y & z \end{bmatrix}$

Here are some more examples:

	exp = {inv[x + y], inv[x + inv[y]]}
	NCTeX[exp]

produces:

$\{ {\left (x+y\right )}^{-1}, {\left (x+{y}^{-1}\right )}^{-1} \}$

	exp = {Sin[x], x y, Sin[x] y, Sin[x + y], Cos[gamma], 
	       Sin[alpha] tp[x] ** (y - tp[y]), (x + tp[x]) (y ** z), -tp[y], 1/2, 
	       Sqrt[2] x ** y}
	NCTeX[exp]

produces:

$\{ \operatorname{sin}{x}, x*y, y*\operatorname{sin}{x}, 
\operatorname{sin}{\left (x+y\right )}, \operatorname{cos}{\gamma}, 
\left({x}^T*\!\!*\left (y-{y}^T\right )\right 
)*\operatorname{sin}{\alpha}, y*z*\left (x+{x}^T\right ), -{y}^T, 
\frac{1}{2}, \sqrt{2}*\left(x*\!\!*y\right ) \}$

	exp = inv[x + tp[inv[y]]]
	NCTeX[exp]

produces:

${\left (x+{{y}^T}^{-1}\right )}^{-1}$

### Notes on NCTeXForm Implementation

`NCTeXForm` does not know as many functions as `TeXForm`. In some
cases `TeXForm` will produce better results. Compare:

	exp = BesselJ[2, x]
	NCTeX[exp, TeXProcessor -> NCTeXForm]

output:

$\operatorname{BesselJ}\left (2, x\right )$

with

	NCTeX[exp, TeXProcessor -> TeXForm]

output:

$J_2(x)$

It should be easy to customize `NCTeXForm` though. Just overload
`NCTeXForm`. In this example:

	NCTeXForm[BesselJ[x_, y_]] := Format[BesselJ[x, y], TeXForm]

makes

	NCTeX[exp, TeXProcessor -> NCTeXForm]

produce

$J_2(x)$
