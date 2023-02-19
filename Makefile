usage:
	(cd DOCUMENTATION; make all install)

doc:
	(cd DOCUMENTATION; make doc)

NCDocument.pdf:
	(cd DOCUMENTATION; make NCDocument.pdf)

clean:
	(cd DOCUMENTATION; make clean)

paclet:
	rm -rf NCAlgebraPaclet
	mkdir NCAlgebraPaclet
	cp PacletInfo.wl NCAlgebraPaclet
	cp -r NCAlgebra NCAlgebraPaclet/.
	cp -r NCExtras NCAlgebraPaclet/.
	find NCAlgebraPaclet -name "*~" | xargs rm

test:
	math < TESTING/NCTEST
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCPOLYTEST
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCSDPTEST
