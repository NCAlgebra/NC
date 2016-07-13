include make.inc

DIRS := NCSDP NCAlgebra
# the sets of directories to do various things in
BUILDDIRS = $(DIRS:%=build-%)
CLEANDIRS = $(DIRS:%=clean-%)
INSTALLDIRS = $(DIRS:%=install-%)

all: $(BUILDDIRS)
$(DIRS): $(BUILDDIRS)
$(BUILDDIRS):
	$(MAKE) -C $(@:build-%=%)

clean: $(CLEANDIRS)
	rm -f reference.tex reference.html reference.pdf

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean

install: $(INSTALLDIRS)
$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

MANUAL = PREAMBLE/Preamble.md \
         PREAMBLE/Version50.md \
         NCAlgebra/NonCommutativeMultiply.md \
	 NCAlgebra/NCCollect.md \
	 NCAlgebra/NCSimplifyRational.md \
	 NCAlgebra/NCDiff.md \
	 NCAlgebra/NCReplace.md \
	 NCAlgebra/NCSymmetric.md \
	 NCAlgebra/NCSelfAdjoint.md \
	 NCAlgebra/NCOutput.md \
	 NCAlgebra/NCMatMult.md \
	 NCAlgebra/NCPolynomial.md \
	 NCAlgebra/NCSylvester.md \
	 NCAlgebra/NCQuadratic.md \
	 NCAlgebra/NCRealization.md \
	 NCAlgebra/NCUtil.md \
         NCAlgebra/MatrixDecompositions.md \
	 NCSDP/NCSDP.md

reference.html: $(MANUAL)
	pandoc $(MANUAL) -t html5 -N --toc --standalone --css base.css -o reference.html --mathjax

reference.pdf: $(MANUAL)
	$(PANDOC) $(MANUAL) -t latex -N --toc --standalone -o reference.tex
	$(PDFLATEX) reference.tex
	$(PDFLATEX) reference.tex
	rm *.aux *.log *.toc *.out

.PHONY: subdirs $(DIRS)
.PHONY: subdirs $(BUILDDIRS)
.PHONE: all clean
