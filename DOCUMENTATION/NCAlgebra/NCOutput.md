## NCOutput {#PackageNCOutput}

**NCOutput** is a package that can be used to beautify the display of
noncommutative expressions. NCOutput does not alter the internal
representation of nc expressions, just the way they are displayed on
the screen.

Members are:

* [NCSetOutput](#NCSetOutput)

### NCSetOutput {#NCSetOutput}

`NCSetOutput[options]` controls the display of expressions in a special format without affecting the internal representation of the expression.

The following `options` can be given:

* `NonCommutativeMultiply` (`False`): If `True` `x**y` is displayed as '`x` $\bullet$ `y`';
* `tp` (`True`): If `True` `tp[x]` is displayed as '`x`$^\mathtt{T}$';
* `inv` (`True`): If `True` `inv[x]` is displayed as '`x`$^{-1}$';
* `aj` (`True`): If `True` `aj[x]` is displayed as '`x`$^*$';
* `co` (`True`): If `True` `co[x]` is displayed as '$\bar{\mathtt{x}}$';
* `rt` (`True`): If `True` `rt[x]` is displayed as '`x`$^{1/2}$';
* `All`: Set all available options to `True` or `False`.

See also:
[NCTex](#NCTeX),
[NCTexForm](#NCTeXForm).
