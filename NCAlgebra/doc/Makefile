PYTHON = python3
FILES = NonCommutativeMultiply.usage \
	NCCollect.usage \
	NCSimplifyRational.usage \
	NCDiff.usage \
	NCReplace.usage \
	NCSymmetric.usage \
	NCSelfAdjoint.usage \
	NCOutput.usage \
	NCMatMult.usage \
	NCPolynomial.usage \
	NCSylvester.usage \
	NCQuadratic.usage \
	NCRealization.usage \
	NCUtil.usage \
        MatrixDecompositions.usage

MANUAL = NonCommutativeMultiply.md \
	NCCollect.md \
	NCSimplifyRational.md \
	NCDiff.md \
	NCReplace.md \
	NCSymmetric.md \
	NCSelfAdjoint.md \
	NCOutput.md \
	NCMatMult.md \
	NCPolynomial.md \
	NCSylvester.md \
	NCQuadratic.md \
	NCRealization.md \
	NCUtil.md \
        MatrixDecompositions.md

all: $(FILES)

reference.html: $(MANUAL)
	pandoc $(MANUAL) -t html -N --toc --standalone --css base.css -o reference.html

reference.pdf: $(MANUAL)
	pandoc $(MANUAL) -t latex -N --toc --standalone -o reference.tex
	pdflatex reference.tex
	pdflatex reference.tex
	rm *.aux *.log *.toc *.out

clean:
	rm -f $(FILES)

install:
	mv $(FILES) ..

%.usage : %.md
	$(PYTHON) md2usage.py -o $@ $<
