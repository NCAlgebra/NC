// p11aux.c

#include "GBStream.hpp"
#include "load_flags.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "GBOutputSpecial.hpp"
#include "RAs.hpp"
#include "Command.hpp"
#include "stringGB.hpp"
#include "VariableSet.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#include "MyOstream.hpp"
#define NOFACCATEGORY
#define NOMONOMIALIDEALREDUCTIONOPTIMIZER
#define NOREGULAROUTPUT   


#ifdef NOREGULAROUTPUT   
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#endif
#include "AdmWithLevels.hpp"

#ifndef INCLUDED_SELECTRULES_H
#include "SelectRules.hpp"
#endif

#ifndef INCLUDED_RALIST_H
#include "RAList.hpp"
#endif

#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif


// ------------------------------------------------------------------

void _singleRules(Source & so,Sink & si) {
  marker mark;
  mark.getNamed("categoryFactories",so);
  so.shouldBeEnd();
#ifdef NOFACCATEGORY
  Debug1::s_not_supported("singleRules via C++");
  si.noOutput(); 
#else
  int n = mark.num();
  marker result;
  result.name("rules");
  const FacCategory & fac =  _categoryFactories.const_reference(n);
  GBList<GroebnerRule> aList(fac.RulesSolvingForKnowns());
  aList.joinTo(fac.RulesSolvingForUnKnowns());
  result.num(GBGlobals::s_rules().push_back(aList));
  result.put(si);
GBStream << "The rules solving for knowns are " 
         << fac.RulesSolvingForKnowns() << '\n';
GBStream << "The rules solving for unknowns are " 
         << fac.RulesSolvingForUnKnowns() << '\n';
GBStream << "The rules solving are " << aList << '\n';
#endif
};

AddingCommand temp1p11aux("singleRules",1,_singleRules);

// ------------------------------------------------------------------

void _singleVariables(Source & so,Sink & si) {
  marker mark;
  mark.get(so);
  so.shouldBeEnd();
#ifdef NOFACCATEGORY
  Debug1::s_not_supported("singleVariables via C++");
  si.noOutput(); 
#else
  int n = mark.num();
  marker result;
  result.name("variables");
  const FacCategory & fac =  _categoryFactories.const_reference(n);
  GBList<Variable> aList(fac.KnownVariablesSolvedFor());
  aList.joinTo(fac.UnknownVariablesSolvedFor());
  result.num(GBGlobals::s_variables().push_back(aList));
  result.put(si);
#endif
};

AddingCommand temp2p11aux("singleVariables",1,_singleVariables);

// ------------------------------------------------------------------

void _returnMarkerList(Source & so,Sink & si) {
  marker mark;
  mark.get(so);
  int m = mark.num();
  stringGB x(mark.name());
  so.shouldBeEnd();
  if(false) {
#ifdef PDLOAD 
  } else if(x=="factcontrol") {
    GBVector<int> numbers;
    const FactControl & fc = GBGlobals::s_factControls().const_reference(m);
    const int sz = fc.numberOfFacts(); 
    numbers.reserve(sz);
    for(int i=1;i<=sz;++i) {
      numbers.push_back(i);
    }
    GBOutputSpecial2(fc,numbers,si);
#endif
  } else if(x=="integers") {
    GBOutputSpecial(GBGlobals::s_integers().const_reference(m),si);
  } else if(x=="polynomials") {
    GBOutputSpecial(GBGlobals::s_polynomials().const_reference(m),si);
  } else if(x=="rules") {
    GBOutputSpecial(GBGlobals::s_rules().const_reference(m),si);
  } else if(x=="variables") {
    GBOutputSpecial(GBGlobals::s_variables().const_reference(m),si);
  } else DBG();
};

AddingCommand temp3p11aux("returnMarkerList",1,_returnMarkerList);

// ------------------------------------------------------------------

void _sendMarkerList(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  int m = -1;
  if(x=="integers") {
    m = GBGlobals::s_integers().push_back(GBVector<int>());
    GBVector<int> & aVec = GBGlobals::s_integers().reference(m);
    GBInputSpecial(aVec,so);
  } else if(x=="polynomials") {
    m = GBGlobals::s_polynomials().push_back(GBList<Polynomial>());
    GBList<Polynomial> & aList = 
        GBGlobals::s_polynomials().reference(m);
    GBInputSpecial(aList,so);
  } else if(x=="rules") {
    m = GBGlobals::s_rules().push_back(GBList<GroebnerRule>());
    GBList<GroebnerRule> & aList = 
        GBGlobals::s_rules().reference(m);
    GBInputSpecial(aList,so);
  } else if(x=="variables") {
    m = GBGlobals::s_variables().push_back(GBList<Variable>());
    GBList<Variable> & aList = 
        GBGlobals::s_variables().reference(m);
    GBInputSpecial(aList,so);
  } else DBG();
  so.shouldBeEnd();
  marker result;
  result.num(m); 
  result.name(x.value().chars());
  result.put(si);
};

AddingCommand temp4p11aux("sendMarkerList",2,_sendMarkerList);

// ------------------------------------------------------------------

#ifdef WANT_CPPCreateCategories_NO
void _CPPCreateCategories(Source & so,Sink & si) {
  marker integerMarker;
  integerMarker.get(so);
  marker factControlMarker;
  factControlMarker.get(so);
  so.shouldBeEnd();
#ifdef PDLOAD
#ifdef NOFACCATEGORY
  Debug1::s_not_supported("CPPCreateCategory");
  si.noOutput(); 
#else
  marker result;
  result.name("categoryFactories");
  const FactControl & fb = GBGlobals::s_factControls().const_reference(
       factControlMarker.number);
  const GBVector<int> & nums = 
     GBGlobals::s_integers().const_reference(integerMarker.number);
  AdmWithLevels & ORD = (AdmWithLevels &)  AdmissibleOrder::s_getCurrent();
  GBList<Variable> kn(ORD.Knowns());
  GBList<Variable> un(ORD.Unknowns());
  result.num(_categoryFactories.push_back(FacCategory(fb,ORD,un,kn,nums)));
  result.put(si);
#endif
#else
  Debug1::s_not_supported("CPPCreateCategory");
  si.noOutput(); 
#endif
};  /* _CPPCreateCategories */
AddingCommand temp5p11aux("CPPCreateCategories",2,_CPPCreateCategories);
#endif


// ------------------------------------------------------------------

void _RetrieveCategoryMarkers(Source& so,Sink & si) {
  marker mark;
  mark.get(so);
  so.shouldBeEnd();
#ifdef NOFACCATEGORY
  Debug1::s_not_supported("RetrieveCategoryMarkers");
  si.noOutput();
#else
  int n = mark.num();
  GBList<GBList<Variable> > knowns;
  GBList<GBList<Variable> > unknowns;
  GBList<int> markerNumbers;
  const FacCategory & factory = _categoryFactories.const_reference(n);

  const int max = factory.maxNumberOfUnknowns();
  for(int ell=0;ell<=max;++ell) {
    const GBList<Category> & aList = 
         factory.categoriesWithNUnknowns(ell);
    const int sz = aList.size();
    GBList<Category>::const_iterator w = 
        ((const GBList<Category> &)aList).begin();
    for(int i=1;i<=sz;++i,++w) {
      const Category & cat = *w;
      knowns.push_back(cat.knowns());
      unknowns.push_back(cat.unknowns());
      int markerNumber = GBGlobals::s_rules().push_back(cat.rules());
      markerNumbers.push_back(markerNumber);
    }
  }
  const int sz = knowns.size();
  GBList<GBList<Variable> >::const_iterator w1 = 
     ((const GBList<GBList<Varible> > &)knowns).begin();
  GBList<GBList<Variable> >::const_iterator w2 = 
     ((const GBList<GBList<Variable> > &)unknowns).begin();
  GBList<int>::const_iterator w3 = 
      ((const GBList<int> &)markerNumbers).begin();
  GBOutputList((long)sz,si);
  for(int i=1;i<=sz;++i,++w1,++w2,++w3) { 
    GBOutputList(3L,si);
      GBOutputSpecial(*w1,si);
      GBOutputSpecial(*w2,si);
      GBOutput("GBMarker",2L,si);
        GBOutput(*w3,si);
        GBOutputString("rules",si);
  }
#endif
};

AddingCommand temp6p11aux("RetrieveCategoryMarkers",1,_RetrieveCategoryMarkers);

// ------------------------------------------------------------------

void _userSelects(Source & so,Sink &  si) {
  so.shouldBeEnd();
  marker result;
  result.name("rules");
  result.num(GBGlobals::s_rules().push_back(::selectRules));
  result.put(si);
}; /* _userSelects */

AddingCommand temp9p11aux("userSelects",0,_userSelects);

// ------------------------------------------------------------------

void _knownRelations(Source & so,Sink & si) {
  marker fcM,iM;
  fcM.getNamed("factcontrol",so);
  iM.getNamed("integers",so);
  so.shouldBeEnd();
  AdmWithLevels & ORD = (AdmWithLevels &) AdmissibleOrder::s_getCurrent();
  VariableSet knowns(ORD.Knowns());
  const FactControl & fc = 
    GBGlobals::s_factControls().const_reference(fcM.num());
  const GBVector<int> & ints = GBGlobals::s_integers().const_reference(iM.num());
  const int intsSize = ints.size();
  marker result;
  result.name("rules");
  result.num(GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
  GBList<GroebnerRule> & dest = GBGlobals::s_rules().reference(result.num());
  for(int i=1;i<=intsSize;++i) {
     const GroebnerRule & aRule = fc.fact(ints[i]);
     VariableSet vars;
     aRule.variablesIn(vars);
     bool ok = true;
     Variable xx;
     bool todo = vars.firstVariable(xx);
     while(todo && ok)  {
       ok = knowns.present(xx);
       todo = vars.nextVariable(xx);
     }
     if(ok) dest.push_back(aRule);
  }
  result.put(si);
};

AddingCommand temp10p11aux("knownRelations",2,_knownRelations);

// ------------------------------------------------------------------

void _UserSelectSet(Source & so,Sink & si) {
  GroebnerRule r;
  so >> r;
  so.shouldBeEnd();
  selectRules.insertIfNotMember(r);
  si.noOutput();
} /* _UserSelectSet */

AddingCommand temp11p11aux("UserSelectSet",1,_UserSelectSet);

// ------------------------------------------------------------------

void _WhatAreGBNumbersMarker(Source & so,Sink & si) {
  marker fcM;
  fcM.getNamed("factcontrol",so);
  int fcN = fcM.num();
  so.shouldBeEnd();
  marker result;
  result.name("integers");
  result.num(GBGlobals::s_integers().push_back(GBVector<int>()));
  GBVector<int> & dest = 
     GBGlobals::s_integers().reference(result.num());
  const FactControl & fb = 
       GBGlobals::s_factControls().const_reference(fcN);
  int n = fb.numberOfPermanentFacts();
  dest.reserve(n);
  FactControl::InternalPermanentType::const_iterator iter = 
         fb.permanentBegin();
  for (int i=1;i<=n; ++i,++iter) {
    dest.push_back(*iter);
  }
  result.put(si);
} /* _WhatAreGBNumbersMarker */

AddingCommand temp12p11aux("WhatAreGBNumbersMarker",1,_WhatAreGBNumbersMarker);

// ------------------------------------------------------------------

void _WhatAreNumbersMarker(Source & so,Sink & si) {
  marker fcM;
  int fcN = fcM.num();
  so.shouldBeEnd();
  marker result;
  result.name("integers");
  result.num(GBGlobals::s_integers().push_back(GBVector<int>()));
  GBVector<int> & dest = 
     GBGlobals::s_integers().reference(result.num());
  const FactControl & fb = 
       GBGlobals::s_factControls().const_reference(fcN);
  int n = fb.numberOfFacts();
  dest.reserve(n);
  for (int i=1;i<=n; ++i) {
    dest.push_back(i);
  }
  result.put(si);
} /* _WhatAreNumbersMarker */

AddingCommand temp13p11aux("WhatAreNumbersMarker",1,_WhatAreNumbersMarker);

// ------------------------------------------------------------------

void _NumbersFromRuleMarker(Source & so,Sink & si) {
#ifdef PDLOAD
  marker fcM,rM;
  fcM.getNamed("factcontrol",so);
  rM.getNamed("rules",so);
  int fcN = fcM.num(),rN = rM.num();
  so.shouldBeEnd();
  const FactControl & fc = 
    GBGlobals::s_factControls().const_reference(fcN);
  const GBList<GroebnerRule> & ru = 
    GBGlobals::s_rules().const_reference(rN);
  marker result;
  result.name("integers");
  result.num(GBGlobals::s_integers().push_back(GBVector<int>()));
  GBVector<int> & dest = 
     GBGlobals::s_integers().reference(result.num());
  const int sz = ru.size();
  GBList<GroebnerRule>::const_iterator w = ru.begin();
  int place;
  for(int i=1;i<=sz;++i,++w) {
    if(fc.findFact(*w,place)) {
      dest.push_back(place);
    };
  }
  result.put(si);
#else
  Debug1::s_not_supported("_NumbersFromRuleMarker");
  so.shouldBeEnd();
  so.noOutput();
#endif
};

AddingCommand temp14p11aux("NumbersFromRuleMarker",2,_NumbersFromRuleMarker);

// ------------------------------------------------------------------

void _PolynomialsToGBRules(Source & so,Sink & si) {
#ifdef PDLOAD
  list<Polynomial> L;
  GBInputSpecial(L,so);
  so.shouldBeEnd();
  int sz = L.size();
  list<Polynomial>::const_iterator w = L.begin();
  Sink sink(si.outputFunction("List",sz));
  GroebnerRule g;
  for(int i=1;i<=sz;++i,++w) {
    const Polynomial & p = *w;
    g.convertAssign(p);
    sink << g;
  };
#else
  Debug1::s_not_supported("_PolynomialsToGBRule");
  so.shouldBeEnd();
  si.noOutput();
#endif
};

AddingCommand temp15p11aux("PolynomialsToGBRules",1,_PolynomialsToGBRules);

// ------------------------------------------------------------------

void _PolynomialToGBRule(Source & so,Sink & si) {
  Polynomial p;
  so >> p;
  GroebnerRule g;
#ifdef PDLOAD
  so.shouldBeEnd();
  VariableSet vars;
  p.variablesIn(vars);
  Variable xx;
  bool todo = vars.firstVariable(xx);
  AdmWithLevels & ORD = (AdmWithLevels &) AdmissibleOrder::s_getCurrent();
  VariableSet knowns(ORD.Knowns());
  VariableSet unknowns(ORD.Unknowns());
  VariableSet extras;
  while(todo) {
    if(! knowns.present(xx)) {
       extras.insert(xx);
    }
    todo = vars.nextVariable(xx);
  }
  if(extras.size()==0) {
    g.convertAssign(p);
  } else {
    GBStream << "An expression containing the variables " 
             << extras
             << " which were not set was suppose "
             << "to be converted to a rule. The variables "
             << "have to be declared first.\n";
    GBStream << "The polynomial is " << p << '\n';
    GBStream << "The order is:\n";
    ORD.PrintOrder(GBStream);
    GBStream << "The knowns are recorded as ";
    GBStream << knowns;
    GBStream << "\nThe unknowns are recorded as ";
    GBStream << unknowns;
    GBStream << '\n';
  }
  si << g;
#else
  so.shouldBeEnd();
  Debug1::s_not_supported("_PolynomialToGBRule");
  si.noOutput();
#endif
} /* _PolynomialToGBRule */

AddingCommand temp16p11aux("PolynomialToGBRule",1,_PolynomialToGBRule);

// ------------------------------------------------------------------

void _setUserSelects(Source & so,Sink & si) {
  marker rules;
  rules.get(so);
  if(!rules.nameis("rules")) DBG();
  so.shouldBeEnd();
  const GBList<GroebnerRule> & source = 
    GBGlobals::s_rules().const_reference(rules.num());
  GBList<GroebnerRule>::const_iterator w = source.begin();
  const int sz = source.size();
  for(int i=1;i<=sz;++i,++w) {
   selectRules.insertIfNotMember(*w);
  }
  si.noOutput();
};  /* _setUserSelects */

AddingCommand temp17p11aux("setUserSelects",1,_setUserSelects);

// ------------------------------------------------------------------

#ifdef PDLOAD
void findAllNumbers(const FactControl & fc,int n,GBList<int> &v) {
  if(n>0 && !v.Member(n).first()) {
    const FactControl::History & hist = fc.history(n);
    v.push_back(n);
    int k = hist.first();
    if(k>0) {
      if(!v.Member(k).first()) findAllNumbers(fc,k,v);
      k = hist.second();
      if(!v.Member(k).first()) findAllNumbers(fc,k,v);
    } else if(k<0) {
      k = -k;
      if(!v.Member(k).first()) findAllNumbers(fc,k,v);
    }
    const FactControl::History::HistoryContainerType & source =  
  	hist.reductions();
    set<SPIID,less<SPIID> >::const_iterator w = source.SET().begin();
    const int sz = source.SET().size();
    for(int i=1;i<=sz;++i,++w) {
      k = (*w).d_data;
      if(!v.Member(k).first()) findAllNumbers(fc,k,v);
    }
  }
};
#endif

// ------------------------------------------------------------------

void _FindAllNumbers(Source & so,Sink & si) {
#ifdef PDLOAD 
  marker fc;
  fc.get(so);
  if(!fc.nameis("factcontrol")) DBG();
  int n;
  so >> n;
  so.shouldBeEnd();
  GBList<int> v;
  findAllNumbers(GBGlobals::s_factControls().const_reference(fc.num()),
                 n,v);
  const int sz = v.size();
  GBList<int>::const_iterator w = ((const GBList<int> &)v).begin();
  Sink sink(si.outputFunction("List",(long)sz));
  for(int i=1;i<=sz;++i,++w) {
    sink << *w;
  }
#else
  Debug1::s_not_supported("_FindAllNumbers");
  so.shouldBeEnd();
  si.noOutput();
#endif
};

AddingCommand temp18p11aux("FindAllNumbers",2,_FindAllNumbers);

// ------------------------------------------------------------------

void _internalSortRelations(Source & so,Sink & si) {
  marker rM;
  rM.getNamed("rules",so);
  so.shouldBeEnd();
#ifdef PDLOAD
  DBG();
  si.noOutput();
#if 0
  int m = rM.num();
  GBList<GroebnerRule> newList(
     ((MLex &) AdmissibleOrder.s_getCurrent()).SortRelations(
     GBGlobals::s_rules().const_reference(m)
                                    )
                                  );
  marker result;
  result.num(GBGlobals::s_rules().push_back(newList));
  result.name("rules");
  result.put(si);
#endif
#else 
  Debug1::s_not_supported("_internalSortRelations");
  si.noOutput();
#endif
};

AddingCommand temp19p11aux("internalSortRelations",1,_internalSortRelations);

// ------------------------------------------------------------------

void _UserSelectMarkerSet(Source & so,Sink & si) {
  marker mark;
  mark.get(so);
  int n = mark.num();
  so.shouldBeEnd();
  const GBList<GroebnerRule> & aList = GBGlobals::s_rules().const_reference(n);
  GBList<GroebnerRule>::const_iterator w = aList.begin();
  const int sz = aList.size();
  for(int i=1;i<=sz;++i,++w) {
    selectRules.insertIfNotMember(*w);
  }
  si.noOutput();
};

AddingCommand temp20p11aux("UserSelectMarkerSet",1,_UserSelectMarkerSet);
