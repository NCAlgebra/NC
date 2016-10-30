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
also directly implement custom version of

	NCRunDVIPS
	NCRunLaTeX
	NCRunPDFLaTeX
	NCRunPDFViewer
	NCRunPS2PDF

Those commands are invoked using `NCRun`. Look at the documentation
for the package [NCRun](#NCRun) for more details.
