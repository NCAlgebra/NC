include make.inc

DIRS := NCSDP NCAlgebra NCPoly NCTeX TESTING NCExtras
# the sets of directories to do various things in
BUILDDIRS = $(DIRS:%=build-%)
CLEANDIRS = $(DIRS:%=clean-%)
INSTALLDIRS = $(DIRS:%=install-%)

all: $(BUILDDIRS)
$(DIRS): $(BUILDDIRS)
$(BUILDDIRS):
	$(MAKE) -C $(@:build-%=%)

clean: $(CLEANDIRS)
	rm -f NCDocument.tex NCDocument.tex.* \
              NCDocument.run.xml NCDocument.b*

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
         MANUAL/Advanced.md \
         MANUAL/NCGB.md \
         MANUAL/SDP.md \
         MANUAL/TeX.md \
         MANUAL/Reference.md \
         MANUAL/ExpressionPackages.md \
         NCAlgebra/NonCommutativeMultiply.md \
	 NCAlgebra/NCCollect.md \
	 NCAlgebra/NCReplace.md \
	 NCAlgebra/NCSelfAdjoint.md \
	 NCAlgebra/NCSimplifyRational.md \
	 NCAlgebra/NCDiff.md \
         MANUAL/MatrixPackages.md \
	 NCAlgebra/NCDot.md \
         NCAlgebra/NCMatrixDecompositions.md \
         NCAlgebra/MatrixDecompositions.md \
         MANUAL/Output.md \
	 NCAlgebra/NCOutput.md \
	 NCTeX/NCTeX.md \
	 NCTeX/NCTeXForm.md \
	 NCTeX/NCRun.md \
	 TESTING/NCTest.md \
	 NCExtras/NCDebug.md \
	 NCAlgebra/NCUtil.md \
         MANUAL/DataStructures.md \
	 NCPoly/NCPoly.md \
	 NCPoly/NCPolyInterface.md \
	 NCAlgebra/NCPolynomial.md \
	 NCAlgebra/NCQuadratic.md \
	 NCAlgebra/NCSylvester.md \
         MANUAL/Algorithms.md \
	 NCPoly/NCGBX.md \
	 NCPoly/NCPolyGroebner.md \
	 NCAlgebra/NCConvexity.md \
	 NCSDP/NCSDP.md \
	 NCSDP/SDP.md \
	 NCSDP/SDPFlat.md \
	 NCSDP/SDPSylvester.md \
	 NCSDP/PrimalDual.md \
         MANUAL/WorkInProgress.md \
	 NCAlgebra/NCRational.md \
	 NCAlgebra/NCRealization.md \
	 MANUAL/Bibliography.md

doc: NCDocument.pdf index.html README.md

README.md: $(MANUAL)
	pandoc $(MANUAL) -t markdown -N --toc --standalone \
             --bibliography references.bib \
	     --filter makeindex.py \
	     -o README.tmp.md
	pandoc README.tmp.md -t markdown_github \
	     --filter github-mangle.py \
	     --filter tex2img.py \
	     -o README.md
	rm -f README.tmp.md formula.*

index.html: $(MANUAL)
	pandoc $(MANUAL) -t html5 -N --toc --standalone --css base.css \
             --bibliography references.bib \
	     -o index.html --mathjax

NCDocument.pdf: $(MANUAL)
	$(PANDOC) $(MANUAL) -t latex -N --toc --toc-depth=4 --standalone \
	     --biblatex \
             --bibliography references.bib \
             --variable=geometry:margin=1in \
             --variable=documentclass:book \
	     --variable=colorlinks \
	     --variable=linkcolor:MidnightBlue \
	     -o NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	biber NCDocument
	$(PDFLATEX) NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	rm *.aux *.log *.toc *.out

.PHONY: subdirs $(DIRS)
.PHONY: subdirs $(BUILDDIRS)

.PHONY: all clean 
.PHONY: index.html NCDocument.pdf README.md

