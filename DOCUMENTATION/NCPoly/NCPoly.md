# NCPoly {#PackageNCPoly}

Members are:

* [NCFromDigits](#NCFromDigits)
* [NCIntegerDigits](#NCIntegerDigits)
* [NCPadAndMatch](#NCPadAndMatch)
* [NCPoly](#NCPoly)
* [NCPolyCoefficient](#NCPolyCoefficient)
* [NCPolyConstant](#NCPolyConstant)
* [NCPolyDegLex](#NCPolyDegLex)
* [NCPolyDegLexGraded](#NCPolyDegLexGraded)
* [NCPolyDegree](#NCPolyDegree)
* [NCPolyDisplay](#NCPolyDisplay)
* [NCPolyDisplayOrder](#NCPolyDisplayOrder)
* [NCPolyDivideDigits](#NCPolyDivideDigits)
* [NCPolyDivideLeading](#NCPolyDivideLeading)
* [NCPolyFullReduce](#NCPolyFullReduce)
* [NCPolyGetCoefficients](#NCPolyGetCoefficients)
* [NCPolyGetDigits](#NCPolyGetDigits)
* [NCPolyGetIntegers](#NCPolyGetIntegers)
* [NCPolyLeadingMonomial](#NCPolyLeadingMonomial)
* [NCPolyLeadingTerm](#NCPolyLeadingTerm)
* [NCPolyLexDeg](#NCPolyLexDeg)
* [NCPolyMonomial](#NCPolyMonomial)
* [NCPolyMonomialQ](#NCPolyMonomialQ)
* [NCPolyNormalize](#NCPolyNormalize)
* [NCPolyNumberOfVariables](#NCPolyNumberOfVariables)
* [NCPolyOrderType](#NCPolyOrderType)
* [NCPolyProduct](#NCPolyProduct)
* [NCPolyQuotientExpand](#NCPolyQuotientExpand)
* [NCPolyReduce](#NCPolyReduce)
* [NCPolySum](#NCPolySum)
* [NCPolyToRule](#NCPolyToRule)

## NCFromDigits {#NCFromDigits}
NCFromDigits[list] constructs an integer from the list of its decimal digits.
NCFromDigits[list,b] takes the digits to be given in base b.

## NCIntegerDigits {#NCIntegerDigits}
NCIntegerDigits[n] gives a list of the decimal digits in the integer n.
NCIntegerDigits[n,b] gives a list of the base-b digits in the integer n.
NCIntegerDigits[n,b,len] pads the list on the left with zeros to give a list of length len.

## NCPadAndMatch {#NCPadAndMatch}
When list a is longer than list b, NCPadAndMatch[a,b] returns the minimum number of elements from list a that should be added to the left and right of list b so that a = l b r.
When list b is longer than list a, return the opposite match. NCPadAndMatch returns all possible matches with the minimum number of elements.

## NCPoly {#NCPoly}
NCPoly[c, monomials, var] constructs a noncommutative polynomial object in variables var where the monomials have coefficient c. Monomials are specified in terms of the symbols in the list var. For example, NCPoly[{-1,2}, {{x,y,x},{z}}, {x, y, z}] constructs an object associated with the noncommutative polynomial 2 z - x y x in variables x, y and z. The internal representation is so that the terms are sorted according to a degree-lexicographic order in vars. In the above example, x < y < z.

## NCPolyCoefficient {#NCPolyCoefficient}
NCPolyCoefficients[p, m] returns the coefficient of the monomial m in the NCPoly p.

## NCPolyConstant {#NCPolyConstant}
NCPolyConstant[value, var] constructs a noncommutative monomial object in variables var representing value. For example, NCPolyMonomial[3, {x, y, z}] constructs an object associated with the noncommutative monomial 3 in variables x, y and z. See NCPoly for more details.

## NCPolyDegLex {#NCPolyDegLex}
NCPolyDegLex::usage

## NCPolyDegLexGraded {#NCPolyDegLexGraded}
NCPolyDegLexGraded::usage

## NCPolyDegree {#NCPolyDegree}
NCPolyDegree[p] returns the degree of the NCPoly p.

## NCPolyDisplay {#NCPolyDisplay}
NCPolyDisplay[p] prints the noncommutative polynomial p using symbols x1,...,xn. NCPolyDisplay[p, vars] uses the symbols in the list vars.

## NCPolyDisplayOrder {#NCPolyDisplayOrder}
NCPolyDisplayOrder[vars] prints the order implied by the list vars

## NCPolyDivideDigits {#NCPolyDivideDigits}
NCPolyDivideDigits[F,G] returns the result of the division of the leading digits lf and lg.

## NCPolyDivideLeading {#NCPolyDivideLeading}
NCPolyDivideLeading[lF,lG,base] returns the result of the division of the leading Rules lf and lg as returned by NCGetLeadingTerm.

## NCPolyFullReduce {#NCPolyFullReduce}
NCPolyFullReduce[f,g] applies NCPolyReduce successively until the remainder does not change.
See also NCPolyReduce and NCPolyQuotientExpand.

## NCPolyGetCoefficients {#NCPolyGetCoefficients}
NCPolyGetCoefficients[p] returns a list with the coefficients of the terms in the NCPoly p.

## NCPolyGetDigits {#NCPolyGetDigits}
NCPolyGetIntegers[p] returns a list with the base n digits that encode the degree of the terms in the NCPoly p. See NCIntegerDigits and NCFromDigits.

## NCPolyGetIntegers {#NCPolyGetIntegers}
NCPolyGetIntegers[p] returns a list with the integers that encode the degree of the terms in the NCPoly p.

## NCPolyLeadingMonomial {#NCPolyLeadingMonomial}
NCPolyLeadingMonomial[p] returns a NCPoly representation of the leading term of the NCPoly p.

## NCPolyLeadingTerm {#NCPolyLeadingTerm}
NCPolyLeadingTerm[p] returns a rule {a, b} -> c associated with leading term of the NCPoly p. c is the coefficient of the monomial, a is the degree and b is the integer associated with the monomial. See NCIntegerDigits and NCFromDigits for details on b.

## NCPolyLexDeg {#NCPolyLexDeg}
NCPolyLexDeg::usage

## NCPolyMonomial {#NCPolyMonomial}
NCPolyMonomial[monomial, var] constructs a noncommutative monomial object in variables var. Monomials are specified in terms of the symbols in the list var. For example, NCPolyMonomial[{x,y,x}, {x, y, z}] constructs an object associated with the noncommutative monomial x y x in variables x, y and z. See NCPoly for more details.

## NCPolyMonomialQ {#NCPolyMonomialQ}
NCPolyMonomialQ[p] returns True if p is a NCPoly monomial.

## NCPolyNormalize {#NCPolyNormalize}
NCPolyNormalize[p] makes the coefficient of the leading term of p to unit. It also works when p is a list.

## NCPolyNumberOfVariables {#NCPolyNumberOfVariables}
NCPolyNumberOfVariables[p] returns the number of variables of the NCPoly p.

## NCPolyOrderType {#NCPolyOrderType}
NCPolyOrderType[p] returns the type of monomial order in which the noncommutative polynomial p is stored. Order can be NCPolyLexDeg or NCPolyDegLex.

## NCPolyProduct {#NCPolyProduct}
NCPolyProduct[f,g] returns a NCPoly that is the product of the NCPoly's f and g.

## NCPolyQuotientExpand {#NCPolyQuotientExpand}
NCPolyQuotientExpand[q,g] returns a NCPoly that is the left-right product of the quotient as returned by NCPolyReduce by the NCPoly g. It also works when g is a list.

## NCPolyReduce {#NCPolyReduce}
NCPolyToRule[f] returns a Rule associated with polynomial f. If f = lead + rest, where lead is the leading term in the current order, then NCPolyToRule[f] returns the rule 'lead -> -rest' where the coefficient of the leading term has been normalized to 1.

## NCPolySum {#NCPolySum}
NCPolySum[f,g] returns a NCPoly that is the sum of the NCPoly's f and g.

## NCPolyToRule {#NCPolyToRule}
NCPolyToRule::usage
