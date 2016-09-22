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
	rm -f NCAlgebra.tex

wipe: clean
	rm -f NCAlgebra.html NCAlgebra.pdf

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean

install: $(INSTALLDIRS)
$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

MANUAL = PREAMBLE/Preamble.md \
	 PREAMBLE/Version50.md \
         PREAMBLE/Running.md \
         PREAMBLE/Basic.md \
         PREAMBLE/Things.md \
         PREAMBLE/Reference.md \
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
	 NCAlgebra/NCConvexity.md \
	 NCAlgebra/NCRealization.md \
         NCAlgebra/NCMatrixDecompositions.md \
         NCAlgebra/MatrixDecompositions.md \
         NCAlgebra/NCSolve.md \
	 NCAlgebra/NCUtil.md \
	 NCAlgebra/NCTest.md \
	 NCSDP/NCSDP.md \
	 NCSDP/SDP.md

NCAlgebra.html: $(MANUAL)
	pandoc $(MANUAL) -t html5 -N --toc --standalone --css base.css -o NCAlgebra.html --mathjax

NCAlgebra.pdf: $(MANUAL)
	$(PANDOC) $(MANUAL) -t latex -N --toc --standalone \
             --variable=geometry:margin=1in \
             --variable=documentclass:book \
	     -o NCAlgebra.tex
	$(PDFLATEX) NCAlgebra.tex
	$(PDFLATEX) NCAlgebra.tex
	$(PDFLATEX) NCAlgebra.tex
	rm *.aux *.log *.toc *.out

.PHONY: subdirs $(DIRS)
.PHONY: subdirs $(BUILDDIRS)
.PHONE: all clean
