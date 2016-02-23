// paux.c

#define USING_ROUTINE_FACTORY


#include "RecordHere.hpp"
#include "Sink.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#include "string_choice.hpp"
#include "Command.hpp"
#include "RA1.hpp"

#include "load_flags.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "ReportTimings.hpp"
#include "GBStream.hpp"
#include "marker.hpp"
#include "GBGlobals.hpp"
#include "AdmWithLevels.hpp"
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "GBOutputSpecial.hpp"
#ifndef INCLUDED_PRINTLIST_H
#include "PrintList.hpp"
#endif
#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
#ifndef INCLUDED_CREATENEWFACTORY_H
#include "CreateNewFactory.hpp"
#endif
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_DEBUG2_H
#include "Debug2.hpp"
#endif
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
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
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#ifdef USING_ROUTINE_FACTORY
#include "BaRoutineFactory.hpp"
#endif


MngrStart * run = 0;

#ifndef INCLUDED_SELECTRULES_H
#include "SelectRules.hpp"
#endif


// ------------------------------------------------------------------

void _SetFactoryType(Source & so,Sink & si) {
  so >> UserOptions::s_FactorySetting;
  so.shouldBeEnd();
  si.noOutput(); 
  CreateNewFactory();
};

AddingCommand temp2paux("SetFactoryType",1,_SetFactoryType);

// ------------------------------------------------------------------

void _GetFactoryType(Source & so,Sink & si) {
  so.shouldBeEnd();
  si << UserOptions::s_FactorySetting;
};

AddingCommand temp3paux("GetFactoryType",0,_GetFactoryType);

// ------------------------------------------------------------------

void _SetIterations(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  run->numberOfIterations(n);
  si.noOutput(); 
} /* _SetIterations */

AddingCommand temp4paux("SetIterations",1,_SetIterations);

// ------------------------------------------------------------------

void _Iterations(Source & so,Sink & si) {
  so.shouldBeEnd();
  si << run->numberOfIterations();
} /* _Iterations */

AddingCommand temp5paux("Iterations",0,_Iterations);

// ------------------------------------------------------------------

void _MoraRun(Source & so,Sink &  si) {
  so.shouldBeEnd();
#if 1
  list<Polynomial> relations(run->startingRelations());
  PrintList("starting relations",relations);
#endif
  AllTimings temp;
  run->run();
#if 1
  list<Polynomial> partialB(run->partialBasis());
  PrintList("partialBasis",partialB);
#endif
// ReportTimings();
  si.noOutput(); 
} /* _MoraRun */

AddingCommand temp6paux("MoraRun",0,_MoraRun);

// ------------------------------------------------------------------

void _SetCleanUpBasis(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  run->CleanUpBasis(n!=0);
  si.noOutput(); 
} /* _SetCleanUpBasis */

AddingCommand temp7paux("SetCleanUpBasis",1,_SetCleanUpBasis);

// ------------------------------------------------------------------

void _CleanUpBasisQ(Source & so,Sink & si) {
  so.shouldBeEnd();
  si << (int) run->GetCleanUpBasis(); 
} /* _CleanUpBasisQ */

AddingCommand temp8paux("CleanUpBasisQ",0,_CleanUpBasisQ);

// ------------------------------------------------------------------

void _FoundBasis(Source & so,Sink &  si) {
  so.shouldBeEnd();
  int n = 0;
  if(run->foundBasis()) n = 1;
  si << n;
} /* _FoundBasis */

AddingCommand temp9paux("FoundBasis",0,_FoundBasis);

// ------------------------------------------------------------------

void _ClearMonOrd(Source & so,Sink &  si) {
  so.shouldBeEnd();
#ifdef PDLOAD
  AdmWithLevels & ORD  = (AdmWithLevels &) AdmissibleOrder::s_getCurrent();
  ORD.ClearOrder();
#else
  Debug1::s_not_supported("_ClearMonOrd");
#endif
  si.noOutput();
} /* _ClearMonOrd */

AddingCommand temp10paux("ClearMonomialOrder",0,_ClearMonOrd);

// ------------------------------------------------------------------

void _ClearMonOrdN(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
#ifdef PDLOAD
  AdmWithLevels & ORD  = (AdmWithLevels &) AdmissibleOrder::s_getCurrent();
  if(n<=0) DBG();
  if(n<=ORD.multiplicity()) {
    vector<Variable> empty;
    ORD.setVariables(empty,n);
  };
#else
  Debug1::s_not_supported("_ClearMonOrd");
#endif
  si.noOutput();
} /* _ClearMonOrdN */

AddingCommand temp11paux("ClearMonomialOrderN",1,_ClearMonOrdN);

// ------------------------------------------------------------------

void _PrintMonOrd(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
#ifdef PDLOAD
  AdmissibleOrder::s_getCurrent().PrintOrder(GBStream);
#else
  Debug1::s_not_supported("_ClearMonOrd");
#endif
} /* _PrintMonOrd */

AddingCommand temp12paux("PrintMonomialOrder",0,_PrintMonOrd);

// ------------------------------------------------------------------

void _WhatAreGBNumbers(Source & so,Sink & si) {
  so.shouldBeEnd();
  const pair<int *,int> & V = run->idsForPartialGBRules();
  int n = V.second;
  int * p = V.first;
  Sink sink(si.outputFunction("List",(long)n));
  for (int i=1;i<=n; ++i,++p) {
    si << *p;
  }
} /* _WhatAreGBNumbers */

AddingCommand temp13paux("WhatAreGBNumbers",0,_WhatAreGBNumbers);

// ------------------------------------------------------------------

void _WhatAreNumbers(Source & so,Sink & si) {
  so.shouldBeEnd();
  int n = run->numberOfFacts();
  Sink sink(si.outputFunction("List",(long)n));
  for(int i=1;i<=n;++i) {
    si << i;
  }
} /* _WhatAreNumbers */

AddingCommand temp14paux("WhatAreNumbers",0,_WhatAreNumbers);

// ------------------------------------------------------------------

void _supressMoraOutput(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  si.noOutput(); 
  UserOptions::s_SupressOutput(n!=0);
} /* _supressMoraOutput */

AddingCommand temp15paux("supressMoraOutput",1,_supressMoraOutput);

// ------------------------------------------------------------------

void _DeselectForSPolynomial(Source& so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  run->addDeselect(n);
  si.noOutput();
} /* _DeselectForSPolynomial */

AddingCommand temp16paux("DeselectForSPolynomial",1,_DeselectForSPolynomial);

// ------------------------------------------------------------------

void _ClearDeselect(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  run->emptyDeselects();
} /* _ClearDeselect */

AddingCommand temp17paux("ClearDeselect",0,_ClearDeselect);

// ------------------------------------------------------------------

void _ClearUserSelect(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  selectRules.clear();
} /* _ClearUserSelect */

AddingCommand temp18paux("ClearUserSelect",0,_ClearUserSelect);

// ------------------------------------------------------------------

void _UserSelectRules(Source& so,Sink & si) {
  so.shouldBeEnd();
  GBOutputSpecial(selectRules,si);
} /*  _UserSelectRules */

AddingCommand temp19paux("UserSelectRules",0,_UserSelectRules);

// ------------------------------------------------------------------

void _TurnOnMmaCplusRecord(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  Debug1::s_RecordCommandNumbers = true;
} /*  _TurnOnMmaCplusRecord */

AddingCommand temp20paux("TurnOnMmaCplusRecord",0,_TurnOnMmaCplusRecord);

// ------------------------------------------------------------------

void _TurnOffMmaCplusRecord(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  Debug1::s_RecordCommandNumbers = false;
} /*  _TurnOffMmaCplusRecord */

AddingCommand temp21paux("TurnOffMmaCplusRecord",0,_TurnOffMmaCplusRecord);

// ------------------------------------------------------------------

void _ClearMmaCplusRecord(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  Debug2::s_traceNumbers.erase(Debug2::s_traceNumbers.begin(),
                               Debug2::s_traceNumbers.end());
} /*  _ClearMmaCplusRecord */

AddingCommand temp22paux("ClearMmaCplusRecord",0,_ClearMmaCplusRecord);

// ------------------------------------------------------------------

void _supressAllCOutput(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  si.noOutput();
  UserOptions::s_SupressAllCOutput(n!=0);
} /*  _supressAllCOutput */

AddingCommand temp23paux("supressAllCOutput",1,_supressAllCOutput);

// ------------------------------------------------------------------

void _continueRun(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  run->continueRun();
}; /* _continueRun */

AddingCommand temp24paux("continueRun",0,_continueRun);

// ------------------------------------------------------------------

void _SetReorder(Source & so,Sink & si) {
  symbolGB x;
  so >> x;
  so.shouldBeEnd();
#if 1
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
GBStream << "Reorder command ignored.\n";
#else
  int n=-1;
  if(x=="True") { 
    n = 1;
  } else if(x=="False") { 
    n = 0;
  } else {
    GBStream << "_SetReorder was called with " << s 
             << " and either the symbol True or False was expected.\n";
  };
  if(n!=-1) run->reorder(n);
#endif
  si.noOutput();
}; /* _SetReorder */

AddingCommand temp25paux("SetReorder",1,_SetReorder);

// ------------------------------------------------------------------

void _IterationNumber(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  si << run->iterationNumber(n);
}; /* _IterationNumber */

AddingCommand temp26paux("IterationNumber",1,_IterationNumber);

// ------------------------------------------------------------------

void _setSelectOutputMethod(Source & so,Sink & si) {
  so >> UserOptions::s_SelectionOutputMethod;
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp27paux("setSelectOutputMethod",1,_setSelectOutputMethod);

// ------------------------------------------------------------------

#ifdef USING_ROUTINE_FACTORY
void _SetGlobalPtr(Source & so,Sink & si) {
  so.shouldBeEnd();
  RECORDHERE(delete run;)
  if(BaRoutineFactory::s_currentValid()) {
    run = BaRoutineFactory::s_getCurrent().create();
  } else { 
    GBStream << "Need to call BaRoutineFactory::s_setCurrent\n";
  };
  if(run==0) DBG();
  si.noOutput();
} /* _SetGlobalPtr */
#else
void _SetGlobalPtr(Source & so,Sink & si) {
  so.shouldBeEnd();
  // MoraControlGlobalPtr is set to 0 at compile time
  AdmissibleOrder::s_setCurrentAdopt(CreateOrder());
  RECORDHERE(delete run;)
  RECORDHERE(run = new MngrSuper();)
  if(run==0) DBG();
  si.noOutput();
} /* _SetGlobalPtr */
#endif

AddingCommand temp1paux("SetGlobalPtr",0,_SetGlobalPtr);

// ------------------------------------------------------------------

void _HistoryOfFactControlMarker(Source & so,Sink & si) {
  marker fcm;
  fcm.get(so);
  so.shouldBeEnd();
  const FactControl & fc = 
      GBGlobals::s_factControls().const_reference(fcm.num());
  const int len = fc.numberOfFacts();
  Sink sink(si.outputFunction("List",(long)len));
  for(int i=1;i<=len;++i) {
    Sink sink1(sink.outputFunction("List",4L));
    sink1 << i << fc.fact(i);
    GBOutputSpecial(fc.history(i),sink1);  // 2 entries
  }
};

AddingCommand temp28paux("HistoryOfFactControlMarker",1,_HistoryOfFactControlMarker);

// ------------------------------------------------------------------

extern vector<simpleString> * s_AllStrings_p;

#ifdef STRING2CHOICE

#include "CompareNotOnHash.hpp" 
#pragma warning(disable:4786)
#include <set> 
#include <utility> 
#include "vcpp.hpp"

extern set<pair<const char *,int>,CompareNotOnHash> * 
     s_not_on_hash_table_and_recorded_p;

extern vector<int>    * s_hash_vector_len_p;

extern vector<const char *> * s_hash_vector_str_p;

void _NCDdumpStrings(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  ofstream ofs(s.value().chars());
  if(s_hash_vector_str_p) {
    typedef vector<const char *>::const_iterator VI;
    VI w = s_hash_vector_str_p->begin();
    VI e = s_hash_vector_str_p->end();
    while(w!=e) {
      if(**w!='\0' && **w!='\n') {
        ofs << *w << '\n';
      };
      ++w;
    };
  };
  if(s_not_on_hash_table_and_recorded_p) {
    typedef set<pair<const char *,int>,CompareNotOnHash>::const_iterator SI; 
    SI w = s_not_on_hash_table_and_recorded_p->begin();
    SI e = s_not_on_hash_table_and_recorded_p->end();
    while(w!=e) {
      if((*(*w).first!='\0') && (*(*w).first)!='\n') {
        ofs << (*w).first << '\n';
      };
      ++w;
    };
  };
  so.shouldBeEnd();
  si.noOutput();
};

void _NCDdumpHash(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  {
    ofstream ofs(x.value().chars());
    if(s_hash_vector_str_p) {
      typedef vector<const char *>::const_iterator VI;
      VI w = s_hash_vector_str_p->begin();
      VI e = s_hash_vector_str_p->end();
      while(w!=e) {
        if(**w!='\0' && (**w)!='\n') {
          ofs << *w << '\n';
        };
        ++w;
      };
    };
  };
  StringAccumulator acc;
  acc.add("rm ncgb_junk.txt | sort ");
  add.add(x.value().chars());
  acc.add(" | uniq | tee > ncgb_junk.txt; rm ncgb_hash.txt;cp ncgb_junk.txt ncgb_hash.txt");
  system(acc.chars());
  si.noOutput();
};
#else 
void _NCDdumpStrings(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  ofstream ofs(x.value().chars());
  if(s_AllStrings_p) {
    vector<simpleString>::const_iterator w = s_AllStrings_p->begin();
    vector<simpleString>::const_iterator e = s_AllStrings_p->end();
    while(w!=e) {
      if((*(*w).chars()!='\0') && (*(*w).chars()!='\n')) {
        MyOstream dummy(ofs);
        dummy << *w << '\n';
      };
      ++w;
    };
  };
  so.shouldBeEnd();
  si.noOutput();
};

void _NCDdumpHash(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  GBStream << "NCDdumpHash disabled.\n"; 
  so.shouldBeEnd();
  si.noOutput();
};
#endif
AddingCommand temp29paux("NCDdumpHash",1,_NCDdumpHash);
AddingCommand temp30paux("NCDdumpStrings",1,_NCDdumpStrings);
