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
	mkdir NCAlgebraPaclet/NCAlgebra
	cp -r NCAlgebra/*.m NCAlgebraPaclet/NCAlgebra/.
	cp -r NCAlgebra/*.usage NCAlgebraPaclet/NCAlgebra/.
	./addPacletPrefix.sh NCAlgebraPaclet NCAlgebra
	mkdir NCAlgebraPaclet/NCExtras
	cp -r NCExtras/*.m NCAlgebraPaclet/NCExtras/.
	cp -r NCExtras/*.usage NCAlgebraPaclet/NCExtras/.
	./addPacletPrefix.sh NCAlgebraPaclet NCExtras
	mkdir NCAlgebraPaclet/NCPoly
	cp -r NCPoly/*.m NCAlgebraPaclet/NCPoly/.
	cp -r NCPoly/*.usage NCAlgebraPaclet/NCPoly/.
	./addPacletPrefix.sh NCAlgebraPaclet NCPoly
	mkdir NCAlgebraPaclet/NCSDP
	cp -r NCSDP/*.m NCAlgebraPaclet/NCSDP/.
	cp -r NCSDP/*.usage NCAlgebraPaclet/NCSDP/.
	./addPacletPrefix.sh NCAlgebraPaclet NCSDP
	mkdir NCAlgebraPaclet/NCTeX
	cp -r NCTeX/*.m NCAlgebraPaclet/NCTeX/.
	cp -r NCTeX/*.usage NCAlgebraPaclet/NCTeX/.
	./addPacletPrefix.sh NCAlgebraPaclet NCTeX
	mkdir NCAlgebraPaclet/TESTING
	cp -r TESTING/*.m NCAlgebraPaclet/TESTING/.
	cp -r TESTING/*.usage NCAlgebraPaclet/TESTING/.
	cp TESTING/NC*TEST* NCAlgebraPaclet/TESTING
	mkdir NCAlgebraPaclet/TESTING/NCAlgebra
	cp -r TESTING/NCAlgebra/*.NCTest NCAlgebraPaclet/TESTING/NCAlgebra/.
	mkdir NCAlgebraPaclet/TESTING/NCPoly
	cp -r TESTING/NCPoly/*.NCTest NCAlgebraPaclet/TESTING/NCPoly/.
	cp -r TESTING/NCPoly/TestProblems NCAlgebraPaclet/TESTING/NCPoly/.
	cp -r TESTING/NCPoly/TestResults NCAlgebraPaclet/TESTING/NCPoly/.
	mkdir NCAlgebraPaclet/TESTING/NCSDP
	cp -r TESTING/NCSDP/*.NCTest NCAlgebraPaclet/TESTING/NCSDP/.
	cp -r TESTING/NCSDP/COMPleib NCAlgebraPaclet/TESTING/NCSDP/.
	cp -r TESTING/NCSDP/data NCAlgebraPaclet/TESTING/NCSDP/.
	./addPacletPrefix.sh NCAlgebraPaclet TESTING
	cp NCAlgebra/banner.txt NCAlgebraPaclet/.

test:
	math < TESTING/NCTEST
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCPOLYTEST
	@echo "> Press [Enter] to continue"; read nothing
	math < TESTING/NCSDPTEST
