doc:
	(cd DOCUMENTATION; make all install)

NCDocument.pdf:
	(cd DOCUMENTATION; make NCDocument.pdf)

clean:
	(cd DOCUMENTATION; make clean)

test:
	math < TESTING/NCTEST
	math < TESTING/NCPOLYTEST
	math < TESTING/NCSDPTEST
