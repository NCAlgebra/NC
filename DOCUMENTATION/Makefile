include make.inc

DIRS := NCSDP NCAlgebra NCPoly NCTeX TESTING
# the sets of directories to do various things in
BUILDDIRS = $(DIRS:%=build-%)
CLEANDIRS = $(DIRS:%=clean-%)
INSTALLDIRS = $(DIRS:%=install-%)

all: $(BUILDDIRS)
$(DIRS): $(BUILDDIRS)
$(BUILDDIRS):
	$(MAKE) -C $(@:build-%=%)

clean: $(CLEANDIRS)
	rm -f NCDocument.tex

wipe: clean
	rm -f NCDocument.html NCDocument.pdf

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean

install: $(INSTALLDIRS)
$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

MANUAL = MANUAL/Preamble.md \
	 MANUAL/Version50.md \
         MANUAL/Running.md \
         MANUAL/Basic.md \
         MANUAL/Things.md \
         MANUAL/NCGB.md \
         MANUAL/TeX.md \
         MANUAL/SDP.md \
         MANUAL/Reference.md \
         NCAlgebra/NonCommutativeMultiply.md \
	 NCAlgebra/NCCollect.md \
	 NCAlgebra/NCSimplifyRational.md \
	 NCAlgebra/NCDiff.md \
	 NCAlgebra/NCReplace.md \
	 NCAlgebra/NCSelfAdjoint.md \
	 NCAlgebra/NCOutput.md \
	 NCAlgebra/NCPolynomial.md \
	 NCAlgebra/NCSylvester.md \
	 NCAlgebra/NCQuadratic.md \
	 NCAlgebra/NCRational.md \
	 NCAlgebra/NCMatMult.md \
         NCAlgebra/NCMatrixDecompositions.md \
         NCAlgebra/MatrixDecompositions.md \
	 NCAlgebra/NCConvexity.md \
	 NCAlgebra/NCRealization.md \
	 NCAlgebra/NCUtil.md \
	 NCSDP/NCSDP.md \
	 NCSDP/SDP.md \
	 NCPoly/NCGBX.md \
	 NCPoly/NCPoly.md \
	 NCPoly/NCPolyGroebner.md \
	 NCTeX/NCTeX.md \
	 NCTeX/NCTeXForm.md \
	 NCTeX/NCRun.md \
	 TESTING/NCTest.md

doc: NCDocument.pdf NCDocument.html

NCDocument.md: $(MANUAL)
	pandoc $(MANUAL) -t markdown_github -N --toc --standalone -o NCDocument.md

NCDocument.html: $(MANUAL)
	pandoc $(MANUAL) -t html5 -N --toc --standalone --css base.css -o NCDocument.html --mathjax

NCDocument.pdf: $(MANUAL)
	$(PANDOC) $(MANUAL) -t latex -N --toc --standalone \
             --variable=geometry:margin=1in \
             --variable=documentclass:book \
	     -o NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	rm *.aux *.log *.toc *.out

.PHONY: subdirs $(DIRS)
.PHONY: subdirs $(BUILDDIRS)

.PHONY: all clean 
.PHONY: NCDocument.html NCDocument.pdf

