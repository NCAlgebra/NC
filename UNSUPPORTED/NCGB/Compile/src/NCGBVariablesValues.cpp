// NCGBVariablesValues.c

#include "GBStream.hpp"
#include "AllTimings.hpp"
#include "symbolGB.hpp"
#include "Debug1.hpp"
#include "GBIO.hpp"
#include "GBVector.hpp"
#include "AltInteger.hpp"
#include "MngrStart.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "Timing.hpp"
#include "UserOptions.hpp"
#include "VarValues.hpp"
#include "Variable.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "simpleString.hpp"
#include "Documentation.hpp"

class Timing;
extern MngrStart * run;

extern bool s_timeEachFunctionCall;
extern bool s_timeAndPrintEachFunctionCall;
extern Timing * s_TimingFunctionCalls_p;

struct VarValuesStruct {
  char *  d_s;
  VarValues * d_x;
  Documentation * d_doc_p;
};

void setIterations(int n)        { run->numberOfIterations(n);};
int  getIterations()             { return run->numberOfIterations();};
void setCleanUpBasis(int n)      { run->CleanUpBasis(n!=0);};
int  getCleanUpBasis()           { return (int) run->GetCleanUpBasis(); };
void setFoundBasis(int)          { DBG();};
int  getFoundBasis()             { return run->foundBasis();};
void setsupressMoraOutput(int n) { UserOptions::s_SupressOutput(n!=0);}
int  getsupressMoraOutput()      { DBG(); return 0;};
void setsupressAllCOutput(int n) { UserOptions::s_SupressAllCOutput(n!=0);}
int  getsupressAllCOutput()      { DBG(); return 0;};
void setGCDs(int n)              { INTEGER::gcds(n);};
int  getGCDs()                   { return INTEGER::gcds();};
void setPDTiming(int x)          { AllTimings::s_setTiming(x!=0);};
int  getPDTiming()               { return AllTimings::s_getTiming();};
void setPDGroebnerCutOffFlag(int n) { run->setCutOffFlag(n!=0);};
int  getPDGroebnerCutOffFlag()      { DBG(); return 0;};
void setPDGroebnerCutOffSum(int n)  { run->setSumNumberCutOff(n);};
int  getPDGroebnerCutOffSum()       { DBG(); return 0;};
void setTipReduction( int) { Debug1::s_not_supported("_TipReduction"); };
int  getTipReduction()             { DBG(); return 0;};
void setPDGroebnerCutOffMin(int n) { run->setMinNumberCutOff(n);};
int  getPDGroebnerCutOffMin()      { DBG();return 0;};



VarValuesStruct VarValuesArray[] = {
 { "NCGBFactorySetting",
   new AddrVarValues<int,int_ID>(UserOptions::s_FactorySetting,(int_ID *) 0),
  (Documentation *) 0 // new Documentation
 },
 {"GCDs",
   new FuncVarValues<int,int_ID>(setGCDs,getGCDs,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 { "Iterations",
   new FuncVarValues<int,int_ID>(setIterations,getIterations,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBCleanUpBasis",
   new FuncVarValues<int,int_ID>(setCleanUpBasis,getCleanUpBasis,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBFoundBasis",
   new FuncVarValues<int,int_ID>(setFoundBasis,getFoundBasis,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBMmaCplusRecord",
   new AddrVarValues<bool,bool_ID>(Debug1::s_RecordCommandNumbers,(bool_ID* )0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBTellMultiGradedLex",
   new AddrVarValues<bool,bool_ID>(UserOptions::s_TellMultiGradedLex,(bool_ID* )0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBsetSelectOutputMethod",
   new AddrVarValues<int,int_ID>(UserOptions::s_SelectionOutputMethod,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBsupressAllCOutput",
   new FuncVarValues<int,int_ID>(setsupressAllCOutput,
                                 getsupressAllCOutput,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBsupressMoraOutput",
   new FuncVarValues<int,int_ID>(setsupressMoraOutput,
                                 getsupressMoraOutput,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PDGroebnerCutOffFlag",
   new FuncVarValues<int,int_ID>(setPDGroebnerCutOffFlag, 
       getPDGroebnerCutOffFlag,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PDGroebnerCutOffMin",
   new FuncVarValues<int,int_ID>(setPDGroebnerCutOffMin, 
       getPDGroebnerCutOffMin,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PDGroebnerCutOffSum",
   new FuncVarValues<int,int_ID>(setPDGroebnerCutOffSum, 
       getPDGroebnerCutOffSum,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PDTiming",
   new FuncVarValues<int,int_ID>(setGCDs,getGCDs,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PrintAllFunctionNames",
   new AddrVarValues<bool,bool_ID>(Debug1::s_PrintAllFunctionNames,(bool_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PrintOutAllInputs",
   new AddrVarValues<bool,bool_ID>(Debug1::s_PrintOutAllInputs,(bool_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"PrintOutAllOutputs",
   new AddrVarValues<bool,bool_ID>(Debug1::s_PrintOutAllOutputs,(bool_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"RecordHistory",
   new BoolOrIntToInt(UserOptions::s_recordHistory),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBTipReduction",
   new FuncVarValues<int,int_ID>(setTipReduction,getTipReduction,(int_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"NCGBUseSubMatch",
   new AddrVarValues<bool,bool_ID>(UserOptions::s_UseSubMatch,(bool_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"timeAndPrintEachFunctionCall",
  new AddrVarValues<bool,bool_ID>(s_timeAndPrintEachFunctionCall,(bool_ID *)0),
  (Documentation *) 0 // new Documentation
 },
 {"timeEachFunctionCall",
  new AddrVarValues<bool,bool_ID>(s_timeEachFunctionCall ,(bool_ID *)0),
 (Documentation *) 0 // new Documentation
 },
 { (char * )0, (VarValues *) 0,(Documentation *) 0}
};

// ------------------------------------------------------------------

void _NCGBVariablesValuesDocumentation(Source & so,Sink & si) {
  symbolGB x;
  so >> x;
  VarValuesStruct  * p = VarValuesArray;
  while(p->d_s) {
    if(x.value()==p->d_s) {
      if(p->d_doc_p) {
         GBStream << p->d_doc_p << '\n';
      } else {
         GBStream << "No documentation for " << p->d_doc_p << '\n';
      };
      break;
    };
    ++p;
  };
  if(!p->d_s) {
   GBStream << "Could not find documentation for " << x.value().chars() << '\n';
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand  temp1NCGBVar("NCGBVariablesValuesDocumentation",1,
                            _NCGBVariablesValuesDocumentation);

// ------------------------------------------------------------------

void _NCGBPrintVariablesValuesOptions(Source & so,Sink & si) {
  VarValuesStruct  * p = VarValuesArray;
  GBStream << "NCGBVariablesValuesOptions \nBEGIN LIST\n";
  while(p->d_s) {
    GBStream << p->d_s << '\n'; 
    ++p;
  };
  GBStream << "END LIST\n";

  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand  temp2NCGBVar("NCGBPrintVariablesValuesOptions",1,
                            _NCGBPrintVariablesValuesOptions);

// ------------------------------------------------------------------

void NCGBSetVariablesValuesHelper(Source & so) {
  symbolGB u;
  Source source1(so.inputNamedFunction("List"));
  while(!source1.eoi()) {
    Source source2(source1.inputNamedFunction("Rule"));
    source2 >> u;
    VarValuesStruct  * p = VarValuesArray;
    bool done = false;
    while((!done)&&p->d_s) {
      if(u==p->d_s) {
        done = true;
        p->d_x->set(source2);
        break;
      } else {
        ++p;
      };
    };
    if(!done) {
      GBStream << "The SetNCGBVariablesValues option " << u.value().chars() 
               << " not recognized.\n";
      DBG();
    };
  };
};

// ------------------------------------------------------------------

void _NCGBSetVariablesValues(Source & so,Sink & si) {
  NCGBSetVariablesValuesHelper(so);
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand  temp3NCGBVar("NCGBSetVariablesValues",1,
                            _NCGBSetVariablesValues);

// ------------------------------------------------------------------

void _NCGBGetVariablesValues(Source & so,Sink & si) {
  symbolGB t;
  GBVector<simpleString> questions;
  Source source1(so.inputNamedFunction("List"));
  long len = 0L;
  while(!source1.eoi()) {
    source1 >> t;
    questions.push_back(t.value());
    ++len;
  };
  so.shouldBeEnd();
  Sink sink(si.outputFunction("List",len));
  const GBVector<simpleString> & L = (const GBVector<simpleString> &) questions;
  GBVector<simpleString>::const_iterator w = L.begin();
  for(long i=1L;i<=len;++i,++w) {
    const simpleString & str = *w;
    VarValuesStruct  * p = VarValuesArray;
    bool done = false;
    while((!done)&&p->d_s) {
      if(str==p->d_s) {
        done = true;
        p->d_x->get(sink);
        break;
      } else {
        ++p;
      };
    };
    if(!done) {
      GBStream << "The GetNCGBVariablesValues option " << str 
               << " not recognized.\n";
      DBG();
    };
  };
};

AddingCommand  temp4NCGBVar("NCGBGetVariablesValues",1,_NCGBGetVariablesValues);
