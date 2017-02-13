PYTHON = python3
MD2USAGE = ../md2usage.py
PANDOC = pandoc
PDFLATEX = pdflatex
MD2USAGE_OPTIONS = -H '##'

%.usage : %.md
	$(PYTHON) $(MD2USAGE) $(MD2USAGE_OPTIONS) -o $@ $<
