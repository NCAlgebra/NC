// SelectRules.h

#ifndef INCLUDED_SELECTRULES_H
#define INCLUDED_SELECTRULES_H

template<class T> class GBList;
#include "GroebnerRule.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

extern GBList<GroebnerRule> selectRules;
extern list<GroebnerRule> SelectRules;
#endif
