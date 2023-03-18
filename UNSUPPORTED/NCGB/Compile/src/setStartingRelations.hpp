// setStartingRelations.h

#ifndef INCLUDED_SETSTARTINGRELATIONS_H
#define INCLUDED_SETSTARTINGRELATIONS_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "Polynomial.hpp"
class MngrStart;
#include "vcpp.hpp"

void setStartingRelations(const list<Polynomial> &L,MngrStart *);
#endif
