PYTHON = python3
FILES = NonCommutativeMultiply.usage NCCollect.usage NCPolynomial.usage 

all: $(FILES)

clean:
	rm -f $(FILES)

install:
	mv $(FILES) ..

%.usage : %.md
	$(PYTHON) md2usage.py -o $@ $<
