include ../make.inc

MD2USAGE_OPTIONS = -H "\#\#\#"

FILES = NCSDP.usage \
	SDP.usage \
	SDP.private.usage \
	SDPFlat.usage \
	SDPSylvester.usage \
	PrimalDual.usage \
	Sylvester.usage \

all: $(FILES)

clean:
	rm -f $(FILES)

install:
	mv $(FILES) ../../NCSDP/.
