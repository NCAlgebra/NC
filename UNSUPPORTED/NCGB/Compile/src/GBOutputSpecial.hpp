// GBOutputSpecial.h

#ifndef INCLUDED_GBOUTPUTSPECIAL_H
#define INCLUDED_GBOUTPUTSPECIAL_H

#include "Variable.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "GBList.hpp"
#include "GBVector.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "load_flags.hpp"
#include "vcpp.hpp"
class FactControl;
class Field;
class Sink;
class Monomial;
class Term;
class GBHistory;
class RuleID;

using namespace std;

#if 0
void GBOutputSpecial(const Variable & L,Sink & ioh);
void GBOutputSpecial(const Monomial & L,Sink & ioh);
void GBOutputSpecial(const Term & L,Sink & ioh);
void GBOutputSpecial(const Polynomial & L,Sink & ioh);
void GBOutputSpecial(const GroebnerRule & L,Sink & ioh);
#endif
void GBOutputSpecial(const Field & L,Sink & ioh);
void GBOutputSpecial(const list<Polynomial> & L,Sink & ioh);
void GBOutputSpecial(const list<GroebnerRule> & L,Sink & ioh);
void GBOutputSpecial(const list<Variable> & L,Sink & ioh);
void GBOutputSpecial(const list<int> & L,Sink & ioh);
void GBOutputSpecial(const vector<int> & L,Sink & ioh);
void GBOutputSpecial(const GBVector<int> & L,Sink & ioh);
void GBOutputSpecial(const GBList<GroebnerRule> & L,Sink & ioh);
void GBOutputSpecial(const GBList<Variable> & L,Sink & ioh);
void GBOutputSpecial(const GBList<Polynomial> & L,Sink & ioh);
void GBOutputSpecial(const GBHistory & x,Sink &);
void GBOutputSpecial(const RuleID & x,Sink & ioh);

#endif
#ifdef PDLOAD
void GBOutputSpecial2(const FactControl &,const GBVector<int> &,Sink &);
#endif
