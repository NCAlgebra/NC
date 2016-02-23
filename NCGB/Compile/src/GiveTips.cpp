// GiveTips.c

#define USING_ROUTINE_FACTORY

#include "RecordHere.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "Polynomial.hpp"
#include "Term.hpp"

#include "load_flags.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"


// ------------------------------------------------------------------

void GiveLeadingTerms(Source & so,list<Term> & L) {
  Polynomial p;
  Source so2(so.inputNamedFunction("List"));
  while(!so2.eoi()) {
    so2 >> p;
    L.push_back(p.tip());
  };
};

void _GiveLeadingMonomials(Source & so,Sink & si) {
  list<Term> result;
  GiveLeadingTerms(so,result);
  so.shouldBeEnd();
  Sink si2(si.outputFunction("List",result.size()));
  typedef list<Term>::const_iterator LI;
  LI w = result.begin(), e = result.end();
  while(w!=e) {
    si2 << (*w).MonomialPart();
    ++w;
  };
};

AddingCommand temp1GiveTips("GiveLeadingMonomials",1,_GiveLeadingMonomials);
