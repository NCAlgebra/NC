// SetNCGBCommutative.c 

#include "GBStream.hpp"
#include "GBIO.hpp"
#include "Variable.hpp"
#include "simpleString.hpp"
#include "GBVector.hpp"
#pragma warning(disable:4786)
#include "Timing.hpp"
#include "MyOstream.hpp"
#include "symbolGB.hpp"
#include "Command.hpp"
#include "VarValues.hpp"
#include "Source.hpp"
#include "Sink.hpp"
bool s_timeEachFunctionCall = false;
bool s_timeAndPrintEachFunctionCall = false;
Timing * s_TimingFunctionCalls_p = 0;

// ------------------------------------------------------------------

void _SetNCGBCommutative(Source & so,Sink & si) {
  list<Variable> L;
  GBInputSpecial(L,so);
  const int sz = L.size();
  list<Variable>::iterator w = L.begin();
  for(int i=1;i<=sz;++i,++w) {
    (*w).setCommutative(true);
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp1Commutative("SetNCGBCommutative",1,_SetNCGBCommutative);

// ------------------------------------------------------------------

void _SetNCGBNonCommutative(Source & so,Sink & si) {
  list<Variable> L;
  GBInputSpecial(L,so);
  const int sz = L.size();
  list<Variable>::iterator w = L.begin();
  for(int i=1;i<=sz;++i,++w) {
    (*w).setCommutative(false);
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp2Commutative("SetNCGBNonCommutative",1,
                               _SetNCGBNonCommutative);

// ------------------------------------------------------------------


bool DecipherTrueFalse(const char * t) {
  bool result = false;
  if(strcmp(t,"True")==0) {
    result = true;
  } else if(strcmp(t,"False")==0) {
    // do nothing
  } else DBG();
  return result;
};

// ------------------------------------------------------------------

struct BoolNCGBVariablesValues {
  bool * d_flag;
  char * d_s;
};

BoolNCGBVariablesValues BoolNCGBVariablesValuesArray[] = {
  {&Debug1::s_PrintOutAllInputs,"PrintOutAllInputs"},
  {&Debug1::s_PrintOutAllOutputs,"PrintOutAllOutputs"},
  {&Debug1::s_PrintAllFunctionNames,"PrintAllFunctionNames"},
  {&s_timeEachFunctionCall,"timeEachFunctionCall"},
  {&s_timeAndPrintEachFunctionCall,"timeAndPrintEachFunctionCall"},
  {(bool *)0,(char *)0}
};

// ------------------------------------------------------------------

struct IntNCGBVariablesValues {
  int  * d_flag;
  char * d_s;
};

IntNCGBVariablesValues IntNCGBVariablesValuesArray[] = {
  {&UserOptions::s_SelectionOutputMethod,"SelectionOutputMethod"},
  {(int *)0,(char *)0}
};

// ------------------------------------------------------------------

void _PrintNCGBVariablesValuesOptions(Source & so,Sink & si) {
  // Booleans
  BoolNCGBVariablesValues * pB = BoolNCGBVariablesValuesArray;
  GBStream << "NCGBVariablesValuesOptions regarding True/False\nBEGIN LIST\n";
  while(pB->d_s) {
    GBStream << pB->d_s << '\n'; 
    ++pB;
  };
  GBStream << "END LIST\n";

  // Ints
  IntNCGBVariablesValues *pI = IntNCGBVariablesValuesArray;
  GBStream << "NCGBVariablesValuesOptions regarding integers\nBEGIN LIST\n";
  while(pI->d_s) {
    GBStream << pI->d_s << '\n'; 
    ++pI;
  };
  GBStream << "END LIST\n";

  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp3Commutative("PrintNCGBVariablesValuesOptions",0,
                               _PrintNCGBVariablesValuesOptions);

// ------------------------------------------------------------------

#if 0
void _SetNCGBVariablesValues(Source & so,Sink & si) {
  symbolGB t,u;
  long len;
  GBInputNamedFunction("List",len,so);
  for(long i=1L;i<=len;++i) {
    GBInputNamedFunctionWithCount("Rule",2L,so);
    so >> u;
    BoolNCGBVariablesValues *p =  BoolNCGBVariablesValuesArray;
    bool done = false;
    while((!done)&&p->d_s) {
      if(u==p->d_s) {
        done = true;
        so >> t;
        *(p->d_flag) = DecipherTrueFalse(t.value().chars());
        break;
      } else {
        ++p;
      };
    };
    if(!done) {
      GBStream << "The SetNCGBVariablesValues option " 
               << u.value().chars() << " not recognized.\n";
      DBG();
    };
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp4Commutative("SetNCGBVariablesValues",1,
                               _SetNCGBVariablesValues);
#endif

// ------------------------------------------------------------------

#if 0
void _GetNCGBVariablesValues(Source & so,Sink & si) {
  symbolGB x;
  long len;
  GBInputNamedFunction("List",len,so);
  GBVector<simpleString> questions;
  questions.reserve(len);
  for(long j=1L;j<=len;++j) {
    so >> x;
    questions.push_back(x.value());
  };
  so.shouldBeEnd(so);
  GBOutputList(len,si);
  const GBVector<simpleString> & L = (const GBVector<simpleString> &) questions;
  GBVector<simpleString>::const_iterator w = L.begin();
  for(long i=1L;i<=len;++i,++w) {
    const simpleString & str = *w;
    BoolNCGBVariablesValues *p =  BoolNCGBVariablesValuesArray;
    bool done = false;
    while((!done)&&p->d_s) {
      if(str==p->d_s) {
        done = true;
        GBOutput(*(p->d_flag),si);
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
AddingCommand temp5Commutative("GetNCGBVariablesValues",1,
                               _GetNCGBVariablesValues);
#endif
