PYTHON = python3
FILES = NonCommutativeMultiply.usage \
	NCSymmetric.usage NCSelfAdjoint.usage \
	NCCollect.usage NCPolynomial.usage

MANUAL = NonCommutativeMultiply.md \
	 NCSymmetric.md NCSelfAdjoint.md \
	 NCCollect.md NCPolynomial.md

all: $(FILES)

reference.html: $(MANUAL)
	pandoc $(MANUAL) -t html --standalone --css base.css -o reference.html

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
