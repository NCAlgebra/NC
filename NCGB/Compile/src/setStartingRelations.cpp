// setStartingRelations.c

#include "setStartingRelations.hpp"

#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "Polynomial.hpp"
#include "BaRoutineFactory.hpp"
#include "EditChoices.hpp"
#include "GBList.hpp"
#include "GBGlobals.hpp"
#ifdef WANT_MNGRSUPER
#include "MngrSuper.hpp"
#include "PDRoutineFactory.hpp"
#endif
#include "RA2.hpp"

void setStartingRelations(const list<Polynomial> & L,MngrStart * p) {
  int id = BaRoutineFactory::s_getCurrent().ID();
  if(false) {
#ifdef WANT_MNGRSUPER
  } else if(id==PDRoutineFactory::s_ID) {
    GBList<Polynomial> M;
    typedef list<Polynomial>::const_iterator LI;
    LI w = L.begin();
    LI e = L.end();
    while(w!=e) { M.push_back(*w);++w;};
    int m = GBGlobals::s_polynomials().push_back(GBList<Polynomial>());
    GBList<Polynomial> & LL = GBGlobals::s_polynomials().reference(m);
    LL = M;
    ((MngrSuper *)p)->RegisterStartingRelations(m);
#endif
  };
};
