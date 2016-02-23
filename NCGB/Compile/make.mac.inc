PLAT = MacOSX-x86

MLINKDIR = /Applications/Mathematica.app/SystemFiles/Links/MathLink/DeveloperKit
ADDONSDIR = ${MLINKDIR}/CompilerAdditions
LIBS = -L${ADDONSDIR} -lMLi3 -lm -lgmpxx -lgmp 
LIBS = -F${ADDONSDIR} -framework mathlink -lm -lgmpxx -lgmp 

INCLUDE = -I. -I$(ADDONSDIR)

CC = g++
CCFLAGS = -DHAS_INCLUDE_NO_DOTS $(INCLUDE) -Wno-non-template-friend -Wall -fno-for-scope -m64 -O0 -g

MPREP = $(ADDONSDIR)/mprep
