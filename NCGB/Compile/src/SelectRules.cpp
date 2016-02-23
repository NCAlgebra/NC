// SelectRules.c

#include "SelectRules.hpp"
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
class GroebnerRule;

GBList<GroebnerRule> selectRules;
list<GroebnerRule> SelectRules;
