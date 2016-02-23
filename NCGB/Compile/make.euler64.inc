PLAT = Linux-x86-64
SYS = ${PLAT}

MLINKDIR = /usr/local/pkg/mathematica/Wolfram/Mathematica/7.0/SystemFiles/Links/MathLink/DeveloperKit
ADDONSDIR = ${MLINKDIR}/${SYS}/CompilerAdditions/

LIBS = -L${ADDONSDIR} -Wl,-Bstatic -lML64i3 -Wl,-Bdynamic -lm -lpthread -lrt -Wl,-Bstatic -lgmpxx -lgmp -Wl,-Bdynamic

INCLUDE = -I. -I$(ADDONSDIR)

CC = g++
CCFLAGS = -DHAS_INCLUDE_NO_DOTS $(INCLUDE) -Wno-non-template-friend -Wall -fno-for-scope -m64 -O0 -g

MPREP = $(ADDONSDIR)/mprep
