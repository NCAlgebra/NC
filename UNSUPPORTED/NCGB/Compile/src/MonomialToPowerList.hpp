// (c) Mark Stankus 1999
// MonomialToPowerList.hpp  

#ifndef INCLUDED_MONOMIALTOPOWERLIST_H  
#define INCLUDED_MONOMIALTOPOWERLIST_H  

#include "Monomial.hpp"
#include "Variable.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

void MonomialToPowerList(const Monomial &,list<pair<Variable,int> > &);
void MonomialMakePowerLess(const Monomial &,Monomial & result);
#endif
