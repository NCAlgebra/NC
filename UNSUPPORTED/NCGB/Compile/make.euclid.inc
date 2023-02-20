PLAT = UltraSPARC

MLINKDIR = /usr/local/math/pkg/mathematica/Wolfram/Mathematica/5.2/AddOns/MathLink/DeveloperKit/UltraSPARC
ADDONSDIR = ${MLINKDIR}/CompilerAdditions

GMPHOME = /home/toal/MAURICIO/euclid

LIBS = -L${ADDONSDIR} -L$(GMPHOME)/lib -lML -lm -lsocket -lnsl -lrt -lgmpxx -lgmp

INCLUDE = -I. -I$(ADDONSDIR) -I$(GMPHOME)/include

CC = /usr/local/gnu/pkg/gcc-3.4.2/bin/c++
CCFLAGS = -DHAS_INCLUDE_NO_DOTS $(INCLUDE) -Wno-non-template-friend -Wall -fno-for-scope -m64 -O0 -g

MPREP = $(ADDONSDIR)/mprep
