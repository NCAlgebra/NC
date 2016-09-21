PYTHON = python3
MD2USAGE = ../md2usage.py
PANDOC = pandoc
PDFLATEX = pdflatex

%.usage : %.md
	$(PYTHON) $(MD2USAGE) -o $@ $<
