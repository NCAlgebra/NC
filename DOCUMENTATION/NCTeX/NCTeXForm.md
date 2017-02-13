## NCTeXForm {#PackageNCTeXForm}

Members are:

* [NCTeXForm](#NCTeXForm)
* [NCTeXFormSetStarStar](#NCTeXFormSetStarStar)

### NCTeXForm {#NCTeXForm}

`NCTeXForm[expr]` prints a LaTeX version of `expr`.

The format is compatible with AMS-LaTeX.

Should work better than the Mathematica `TeXForm` :)

### NCTeXFormSetStarStar {#NCTeXFormSetStarStar}

`NCTeXFormSetStarStar[string]` replaces the standard '**' for `string`
in noncommutative multiplications.

For example:

	NCTeXFormSetStarStar["."]
	
uses a dot (`.`) to replace `NonCommutativeMultiply`(`**`).

See also:
[NCTeXFormSetStar](#NCTeXFormSetStar).

### NCTeXFormSetStar {#NCTeXFormSetStar}

`NCTeXFormSetStar[string]` replaces the standard '*' for `string`
in noncommutative multiplications.

For example:

	NCTeXFormSetStar[" "]
	
uses a space (` `) to replace `Times`(`*`).

[NCTeXFormSetStarStar](#NCTeXFormSetStarStar).
