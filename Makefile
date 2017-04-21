usage:
	(cd DOCUMENTATION; make all install)

doc:
	(cd DOCUMENTATION; make doc)

NCDocument.pdf:
	(cd DOCUMENTATION; make NCDocument.pdf)

clean:
	(cd DOCUMENTATION; make clean)

test:
	math < TESTING/NCTEST
	math < TESTING/NCPOLYTEST
	math < TESTING/NCSDPTEST
