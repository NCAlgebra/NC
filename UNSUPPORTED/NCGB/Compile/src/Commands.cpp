// (c) Mark Stankus 1999
// Commands.c

#include "Commands.hpp"
#include "RA2.hpp"
#include "GBGlobals.hpp" 
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "MLex.hpp"
#include "Polynomial.hpp"
#include "RecordHere.hpp"
#include "setStartingRelations.hpp"
#include "stringGB.hpp"
#include "BaRoutineFactory.hpp"
#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
#endif
#ifndef INCLUDED_PDROUTINEFACTORY_H
#include "PDRoutineFactory.hpp"
#endif

//#pragma warning(disable:4786)
#include "Choice.hpp"
    
extern MngrStart * run;
  
void registerStartingRelationsHelper(const GBList<Polynomial> & L) {
  int id = BaRoutineFactory::s_getCurrent().ID();
  if(false) {
  }
#ifdef WANT_MNGRSUPER
  else if(id==PDRoutineFactory::s_ID) {
    int m = GBGlobals::s_polynomials().push_back(GBList<Polynomial>());
    GBList<Polynomial> & LL = GBGlobals::s_polynomials().reference(m);
    LL = L;
    ((MngrSuper *)run)->RegisterStartingRelations(m);
  }
#endif
};
