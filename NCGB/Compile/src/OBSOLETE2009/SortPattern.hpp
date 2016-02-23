// (c) Mark Stankus 1999
// SortPattern.hpp

#ifndef INCLUDED_SORTPATTERN_H
#define INCLUDED_SORTPATTERN_H

#include "SortPattern.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "GroebnerRule.hpp"
#include "RuleDisplayPart.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
class BuildOutput;
#include "vcpp.hpp"

void SortPattern(const list<GroebnerRule> & L,BuildOutput & build,list<RuleDisplayPart> & result);
#endif
