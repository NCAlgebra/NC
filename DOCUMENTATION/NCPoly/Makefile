include ../make.inc

MD2USAGE_OPTIONS = -H "\#\#\#"

FILES = NCGBX.usage NCPolyGroebner.usage NCPolyInterface.usage NCPolySOS.usage

FILES3 = NCPoly.usage

all: $(FILES) files3

files3: MD2USAGE_OPTIONS = -H "\#\#\#\#"
files3: $(FILES3)

clean:
	rm -f $(FILES) $(FILES3)

install:
	mv $(FILES) $(FILES3) ../../NCPoly/.
