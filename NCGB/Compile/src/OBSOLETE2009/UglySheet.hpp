// Mark Stankus 1999 (c)
// UglySheet.hpp

#ifndef INCLUDED_UGLYSHEET_H
#define INCLUDED_UGLYSHEET_H

#include "Polynomial.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif


void UglySheet(const char * directoryname,const list<Polynomial> & L);
#endif
