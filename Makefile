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
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCPOLYTEST
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCSDPTEST
