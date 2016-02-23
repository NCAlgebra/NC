// GBInputNumbers.c

#include "GBInputNumbers.hpp"
#ifndef INCLUDED_MATHLINK_H
#include "mathlink.h"
#endif
#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

#ifdef DUMMY_MATHLINK
int GBInputNumbers::s_IOSYMBOL   = idValue("GBInputNumbers::s_IOSYMBOL");;
int GBInputNumbers::s_IOSTRING   = idValue("GBInputNumbers::s_IOSTRING");;
int GBInputNumbers::s_IOFUNCTION = idValue("GBInputNumbers::s_IOFUNCTION");
int GBInputNumbers::s_IOREAL     = idValue("GBInputNumbers::s_IOREAL");;
int GBInputNumbers::s_IOINTEGER  = idValue("GBInputNumbers::s_IOINTEGER");;
#else
int GBInputNumbers::s_IOSYMBOL   = MLTKSYM;
int GBInputNumbers::s_IOSTRING   = MLTKSTR;
int GBInputNumbers::s_IOFUNCTION = MLTKFUNC;
int GBInputNumbers::s_IOREAL     = MLTKREAL;
int GBInputNumbers::s_IOINTEGER  = MLTKINT;
#endif
int GBInputNumbers::s_IOINTARRAY = idValue("GBInputNumbers::s_IOINTARRAY");
int GBInputNumbers::s_IOCOMMAND = idValue("GBInputNumbers::s_IOCOMMAND");
int GBInputNumbers::s_IOEOI = idValue("GBInputNumbers::s_IOEOI");
int GBInputNumbers::s_IOEOF = idValue("GBInputNumbers::s_IOEOF");
