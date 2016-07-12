# NCOutput {#PackageNCOutput}

**NCOutput** is a package that can be used to beautify the display of noncommutative expressions. NCOutput does not alter the internal representation of nc expressions, just the way they are displayed on the screen.

Members are:

* [NCSetOutput](#NCSetOutput)
* [NCOutputFunction](#NCOutputFunction)

## NCOutputFunction {#NCOutputFunction}

`NCOutputFunction[exp]` returns a formatted version of the expression `expr` which will be displayed to the screen.

See also:
[NCSetOutput](#NCSetOutput).

## NCSetOutput {#NCSetOutput}

`NCSetOutput[options]` controls the display of expressions in a special format without affecting the internal representation of the expression.

The following `options` can be given:

* `Dot`: If *True* `x**y` is displayed as `x.y`;
* `tp`: If *True* `tp[x]` is displayed as `x` with a superscript 'T';
* `inv`: If *True* `inv[x]` is displayed as `x` with a superscript '-1';
* `aj`: If *True* `aj[x]` is displayed as `x` with a superscript '\*';
* `rt`: If *True* `rt[x]` is displayed as `x` with a superscript '1/2';
* `Array`: If *True* matrices are displayed using `MatrixForm`;
* `All`: Set all available options to *True* or *False*.

See also:
[NCOutputFunciton](#NCOutputFunction).
