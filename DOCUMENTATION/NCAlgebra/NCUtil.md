# NCUtil {#PackageNCUtil}

**NCUtil** is a package with a collection of utilities used throughout NCAlgebra.

Members are:

* [NCConsistentQ](#NCConsistentQ)
* [NCGrabFunctions](#NCGrabFunctions)
* [NCGrabSymbols](#NCGrabSymbols)
* [NCGrabIndeterminants](#NCGrabIndeterminants)
* [NCConsolidateList](#NCConsolidateList)
* [NCLeafCount](#NCLeafCount)
* [NCReplaceData](#NCReplaceData)
* [NCToExpression](#NCToExpression)

## NCConsistentQ {#NCConsistentQ}

`NCConsistentQ[expr]` returns *True* is `expr` contains no commutative products or inverses involving noncommutative variables.

## NCGrabFunctions {#NCGrabFunctions}

`NCGragFunctions[expr]` returns a list with all fragments of `expr` containing functions.

`NCGragFunctions[expr,f]` returns a list with all fragments of `expr` containing the function `f`.

For example:

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]], inv]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x]}

and

    NCGrabFunctions[inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {inv[1+inv[1+tp[x]**y]], inv[1+tp[x]**y], inv[x], tp[x], tp[y]}

See also:
[NCGrabSymbols](#NCGragSymbols).

## NCGrabSymbols {#NCGrabSymbols}

`NCGragSymbols[expr]` returns a list with all *Symbols* appearing in `expr`.

`NCGragSymbols[expr,f]` returns a list with all *Symbols* appearing in `expr` as the single argument of function `f`.

For example:

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]]]

returns `{x,y}` and

    NCGrabSymbols[inv[x] + y**inv[1+inv[1+x**y]], inv]

returns `{inv[x]}`.

See also:
[NCGrabFunctions](#NCGragFunctions).

## NCGrabIndeterminants {#NCGrabIndeterminants}

`NCGragIndeterminants[expr]` returns a list with first level symbols and nc expressions involved in sums and nc products in `expr`.

For example:

    NCGrabIndeterminants[y - inv[x] + tp[y]**inv[1+inv[1+tp[x]**y]]]

returns

    {y, inv[x], inv[1 + inv[1 + tp[x] ** y]], tp[y]}

See also:
[NCGrabFunctions](#NCGragFunctions), [NCGrabSymbols](#NCGragSymbols).

## NCConsolidateList {#NCConsolidateList}

`NCConsolidateList[list]` produces two lists:

- The first list contains a version of `list` where repeated entries have been suppressed;
- The second list contains the indices of the elements in the first list that recover the original `list`.

For example:

    {list,index} = NCConsolidateList[{z,t,s,f,d,f,z}];
  
results in:

    list = {z,t,s,f,d};
    index = {1,2,3,4,5,4,1};

See also:
`Union`

## NCLeafCount {#NCLeafCount}

`NCLeafCount[expr]` returns an number associated with the complexity of an expression:

- If `PossibleZeroQ[expr] == True` then `NCLeafCount[expr]` is `-Infinity`;
- If `NumberQ[expr]] == True` then `NCLeafCount[expr]` is `Abs[expr]`;
- Otherwise `NCLeafCount[expr]` is `-LeafCount[expr]`;

`NCLeafCount` is `Listable`.

See also:
`LeafCount`.

## NCReplaceData {#NCReplaceData}

`NCReplaceData[expr, rules]` applies `rules` to `expr` and convert resulting expression to standard Mathematica, for example replacing `**` by `.`. 

`NCReplaceData` does not attempt to resize entries in expressions involving matrices. Use `NCToExpression` for that.

See also:
[NCToExpression](#NCToExpression).

## NCToExpression {#NCToExpression}

`NCToExpression[expr, rules]` applies `rules` to `expr` and convert resulting expression to standard Mathematica. 

`NCToExpression` attempts to resize entries in expressions involving matrices.

See also:
[NCReplaceData](#NCReplaceData).
