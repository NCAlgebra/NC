// p7aux.c

/* See p11c.c for documentation for functions */

#include "load_flags.hpp"
#include "Commands.hpp"
#include "RAs.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"
#include "stringGB.hpp"
#include "code_flags.hpp"
#ifndef INCLUDED_VERSION_H
#include "version.hpp"
#endif
#include "BaRoutineFactory.hpp"
 
#include "Source.hpp"
#include "Sink.hpp"
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif
#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
#endif
#ifndef INCLUDED_PDROUTINEFACTORY_H
#include "PDRoutineFactory.hpp"
#endif
#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif
#include "Command.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif


extern MngrStart * run;

GBVector<int> numbersForHistory;

// ------------------------------------------------------------------

void _registerStartingRelations(Source & so,Sink & si) {
  int m;
  so >> m;
  so.shouldBeEnd();
  int id = BaRoutineFactory::s_getCurrent().ID();
  if(false) {
  }
#ifdef WANT_MNGRSUPER
  else if(id==PDRoutineFactory::s_ID) {
    ((MngrSuper *)run)->RegisterStartingRelations(m);
  }
#endif
  si.noOutput();
} /* _registerStartingRelations */

AddingCommand temp1p7aux("registerStartingRelations",1,
                         _registerStartingRelations);

// ------------------------------------------------------------------

void _PartialBasisIntoPolynomialContainer(Source & so,Sink & si) {
  so.shouldBeEnd();
  list<Polynomial> aList(run->partialBasis());
  GBList<Polynomial> L;
  const int sz = aList.size();
  list<Polynomial>::const_iterator w = aList.begin();
  for(int i=1;i<=sz;++i,++w) {
    L.push_back(*w);
  };
  marker result;
  result.name("polynomials");
  result.num(GBGlobals::s_polynomials().push_back(L));
  result.put(si);
}; /* _PartialBasisIntoPolynomialContainer */

AddingCommand temp3p7aux("PartialBasisIntoPolynomialContainer",0,
                         _PartialBasisIntoPolynomialContainer);

// ------------------------------------------------------------------

void _CurrentManagerStartFactControl(Source & so,Sink & si) {
  so.shouldBeEnd();
  if(isPD()) {
    int n = ((MngrSuper *) run)->factControlNumber();
    si << n;
  } else DBG();
};

AddingCommand temp4p7aux("CurrentManagerStartFactControl",0,
                         _CurrentManagerStartFactControl);

// ------------------------------------------------------------------

void _GroebnerCutOffFlag(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  run->setCutOffFlag(n!=0);
  si.noOutput();
};

AddingCommand temp5p7aux("GroebnerCutOffFlag",1,_GroebnerCutOffFlag);

// ------------------------------------------------------------------

void _GroebnerCutOffMin(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  si.noOutput();
  run->setMinNumberCutOff(n);
};

AddingCommand temp6p7aux("GroebnerCutOffMin",1,_GroebnerCutOffMin);
// ------------------------------------------------------------------

void _GroebnerCutOffSum(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  si.noOutput();
  run->setSumNumberCutOff(n);
};

AddingCommand temp7p7aux("GroebnerCutOffSum",1,_GroebnerCutOffSum);

// ------------------------------------------------------------------

void transferPartialGBToHelper(GBList<GroebnerRule> & aList) {
  const pair<int *,int> & L = run->idsForPartialGBRules();
  const int num = L.second;
  if(num>0) {
    int * p = L.first;
    for(int j=1;j<=num;++j,++p) {
      aList.push_back(run->rule(*p));
    }
  }
};

// ------------------------------------------------------------------

void _transferPartialGBTo(Source & so,Sink & si) {
  so.shouldBeEnd();
  int ans = GBGlobals::s_rules().push_back(GBList<GroebnerRule>());
  GBList<GroebnerRule> & aList = GBGlobals::s_rules().reference(ans);
  transferPartialGBToHelper(aList);
  marker result;
  result.name("rules");
  result.num(ans);
  result.put(si);
}; /* _transferPartialGBTo */

AddingCommand temp8p7aux("transferPartialGBTo",0,_transferPartialGBTo);

// ------------------------------------------------------------------

void _createGBMarker(Source & so,Sink & si) {
  stringGB x;
  int ans = -1;
  so >> x;
  so.shouldBeEnd();
  if(false) {
  } else if(x.value()=="factcontrol") {
    ans = GBGlobals::s_factControls().push_back(FactControl());
  } else if(x=="integers") {
    ans = GBGlobals::s_integers().push_back(GBVector<int>());
  } else if(x=="polynomials") {
    ans = GBGlobals::s_polynomials().push_back(GBList<Polynomial>());
  } else if(x=="rules") {
    ans = GBGlobals::s_rules().push_back(GBList<GroebnerRule>());
  } else if(x=="variables") {
    ans = GBGlobals::s_variables().push_back(GBList<Variable>());
  } else {
    GBStream << "The command _createGBMarker cannot "
             << "recognize a marker of type " 
             << x.value().chars() << ".\n"
             << "By the way, the above character string has " 
             << x.value().length() << " characters.\n";
    DBG();
  };
  marker result;
  result.num(ans);
  result.name(x.value().chars());
  result.put(si);
};

AddingCommand temp9p7aux("createGBMarker",1,_createGBMarker);

// ------------------------------------------------------------------

void _setNumbersForHistory(Source & so,Sink & si) {
  numbersForHistory.clear();
  GBInput(numbersForHistory,so);
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp10p7aux("setNumbersForHistory",1,_setNumbersForHistory);
