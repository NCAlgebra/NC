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
	 MANUAL/Version60.md \
	 MANUAL/Version50.md \
         MANUAL/Running.md \
         MANUAL/Basic.md \
         MANUAL/Advanced.md \
         MANUAL/NCGB.md \
         MANUAL/SDP.md \
         MANUAL/TeX.md \
         MANUAL/Reference.md \
         MANUAL/Installation.md \
         NC.md \
         NCAlgebra/NCAlgebra.md \
         NCAlgebra/NCOptions.md \
         MANUAL/ExpressionPackages.md \
         NCAlgebra/NonCommutativeMultiply.md \
         NCAlgebra/NCTr.md \
	 NCAlgebra/NCCollect.md \
	 NCAlgebra/NCReplace.md \
	 NCAlgebra/NCSelfAdjoint.md \
	 NCAlgebra/NCSimplifyRational.md \
	 NCAlgebra/NCDiff.md \
	 NCAlgebra/NCConvexity.md \
         MANUAL/MatrixPackages.md \
	 NCAlgebra/NCDot.md \
         NCAlgebra/NCMatrixDecompositions.md \
         NCExtras/MatrixDecompositions.md \
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
         MANUAL/NCGBChapter.md \
	 NCPoly/NCGBX.md \
	 NCPoly/NCPolyGroebner.md \
	 NCPoly/NCGB.md \
         MANUAL/SDPChapter.md \
	 NCSDP/NCSDP.md \
	 NCSDP/SDP.md \
	 NCSDP/SDPFlat.md \
	 NCSDP/SDPSylvester.md \
	 NCSDP/PrimalDual.md \
	 NCPoly/NCPolySOS.md \
         MANUAL/WorkInProgress.md \
	 NCAlgebra/NCRational.md \
	 NCAlgebra/NCRealization.md \
	 MANUAL/Bibliography.md

doc: NCDocument.pdf index.html README.md

README.md: $(MANUAL) MANUAL/Cover.md
	pandoc $(MANUAL) -t markdown -N --toc --standalone \
             --bibliography references.bib \
             --citeproc \
	     --filter makeindex.py \
	     --wrap=preserve \
	     -o README.tmp.md
	pandoc MANUAL/Cover.md README.tmp.md -t gfm \
             --bibliography references.bib \
             --citeproc \
	     --filter github-mangle.py \
	     --filter github-math.py \
	     --wrap=preserve \
	     -o README.md
	rm -f README.tmp.md

index.html: $(MANUAL)
	pandoc $(MANUAL) \
             -t html5 -N --toc --standalone \
	     --css markdown.css \
	     --css github-markdown-light.css \
             --bibliography references.bib \
             --citeproc \
	     -o index.html --mathjax
	sed -i 's/<body>/<body class="markdown-body">/' index.html

github.io: index.html
	cp index.html markdown.css github-markdown-light.css NCAlgebra.github.io/.

NCDocument.pdf: $(MANUAL)
	$(PANDOC) $(MANUAL) -t latex -N --toc --toc-depth=4 --standalone \
	     --biblatex \
             --bibliography references.bib \
             --variable=biblio-style:alphabetic \
             --variable=geometry:margin=1in \
             --variable=documentclass:book \
	     --variable=colorlinks \
	     --variable=linkcolor:MidnightBlue \
	     --variable=classoption:dvipsnames \
	     -o NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	biber NCDocument
	$(PDFLATEX) NCDocument.tex
	$(PDFLATEX) NCDocument.tex
	rm -f *.aux *.log *.toc *.out

PANDOC = pandoc -t md2nb/md2nb.lua
../DEMOS/1_MostBasicCommands.nb: MANUAL/Basic.md
	$(PANDOC) $< -o $@

../DEMOS/2_MoreAdvancedCommands.nb: MANUAL/Advanced.md
	$(PANDOC) $< -o $@

../DEMOS/3_NCGroebnerBasis.nb: MANUAL/NCGB.md
	$(PANDOC) $< -o $@

DEMOS = ../DEMOS/1_MostBasicCommands.nb ../DEMOS/2_MoreAdvancedCommands.nb ../DEMOS/3_NCGroebnerBasis.nb 
demos: $(DEMOS)

.PHONY: subdirs $(DIRS)
.PHONY: subdirs $(BUILDDIRS)

.PHONY: all clean $(DEMOS)
.PHONY: index.html NCDocument.pdf README.md github.io

