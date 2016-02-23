// GBInput.h

#ifndef INCLUDED_GBINPUT_H
#define INCLUDED_GBINPUT_H

#define GBInputSpecial GBInput

#include "Source.hpp"
class simpleString;
class symbolGB;
class stringGB;

#ifndef INCLUDED_GBIOSTRUCTS_H
#include "GBIOStructs.hpp"
#endif

void GBInput(int &,Source &);
void GBInput(long &,Source &);
void GBInput(bool &,Source &);

#include "GBList.hpp"
#include "GBVector.hpp"
//#pragma warning(disable:4786)
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
#include "vcpp.hpp"
class GroebnerRule;
class Polynomial;
class Monomial;
class INTEGER;
class Term;
class Variable;
class Categories;
class RuleID;

#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"

#if 0
void GBInputSpecial(GroebnerRule &,Source &);
void GBInputSpecial(Polynomial &,Source &);
void GBInputSpecial(Monomial &,Source &);
void GBInputSpecial(Variable &,Source &);
void GBInputSpecial(Term &,Source &);
void GBInputSpecial(Categories&,Source &);
#endif
void GBInputSpecial(RuleID&,Source &);
void GBInputSpecial(INTEGER &,Source &);
void GBInputSpecial(Field &,Source &);
void GBInputSpecial(GBList<Variable> &,Source &);
void GBInputSpecial(GBList<Polynomial> &,Source &);
void GBInputSpecial(GBList<GroebnerRule> &,Source &);
void GBInputSpecial(GBVector<int> &,Source &);
void GBInputSpecial(list<Polynomial> &,Source &);
void GBInputSpecial(list<GroebnerRule> &,Source &);
void GBInputSpecial(list<Variable> &,Source &);
void GBInputSpecial(list<Monomial> &,Source &);
void GBInputSpecial(vector<int> &,Source &);
void GBInputSpecial(vector<vector<Variable> > &,Source &);

#ifndef INCLUDED_GBINPUTNUMBERS_H
#include "GBInputNumbers.hpp"
#endif

#endif
