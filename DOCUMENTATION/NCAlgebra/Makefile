include ../make.inc

MD2USAGE_OPTIONS = -H "\#\#\#"

FILES = NonCommutativeMultiply.usage \
	NCCollect.usage \
	NCSimplifyRational.usage \
	NCDiff.usage \
	NCReplace.usage \
	NCSelfAdjoint.usage \
	NCOutput.usage \
	NCDot.usage \
	NCSylvester.usage \
	NCQuadratic.usage \
	NCConvexity.usage \
	NCConvexity.private.usage \
	NCRealization.usage \
	NCRealization.private.usage \
        NCMatrixDecompositions.usage \
        MatrixDecompositions.usage \
	NCUtil.usage

FILES3 = NCPolynomial.usage \
         NCRational.usage

all: $(FILES) files3

files3: MD2USAGE_OPTIONS = -H "\#\#\#\#"
files3: $(FILES3)

clean:
	rm -f $(FILES) $(FILES3)

install:
	mv $(FILES) $(FILES3) ../../NCAlgebra/.
