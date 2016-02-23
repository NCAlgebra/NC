// GBOutput.c
 
#ifndef INCLUDED_GBOUTPUT_H
#include "GBOutput.hpp"
#endif
#include "Field.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "load_flags.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "GBHistory.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#ifdef PDLOAD
#include "FactControl.hpp"
#endif
#include "simpleString.hpp"
#define GBOUTPUT_CHECK_OUTPUT
#include "GBVector.hpp"
#include "GBList.hpp"
#include "UniqueList.hpp"
#include "Composite.hpp"
#include "GBOutputSpecial.hpp"
#include "templates.hpp"
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif

#include "vcpp.hpp"

const char * gboutput_marker = "@@@";

void GBOutput(int x,Sink& sink) {  
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of int:" << x 
           << gboutput_marker<< '\n';
};
#endif
  sink << x;
};

void GBOutput(long x,Sink & sink) {  
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of long int:" << x 
           << gboutput_marker<< '\n';
};
#endif
  sink << x;
};

void GBOutputSymbol(const symbolGB & x,Sink & sink) {
  if(x.value()=="$Failed") DBG();
  if(x.value()=="$Aborted") DBG();
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER 
           << "GBOutput of symbol:" << x.value().chars()
           << gboutput_marker<< '\n';
};
#endif
  sink << x;
};

void GBOutputSymbol(const char * x,Sink & sink) {
  symbolGB y(x);
  sink << y;
};

void GBOutputString(const stringGB & x,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER 
           << "GBOutput of string:" << x.value().chars()
           << gboutput_marker<< '\n';
};
#endif
  sink << x;
};

void GBOutputString(const char * x,Sink & sink) {
  symbolGB y(x);
  sink << y;
};

#if 0
void GBOutputFunction(const char * const x,long sz,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of function:" << x 
           << ' ' << sz
           << gboutput_marker<< '\n';
};
#endif
  sink.putFunction((char *)x,sz);
};
#endif

#if 0
void GBOutputList(long sz,Sink & sink) { 
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of list:" << sz 
           << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("List",sz,4L);
};
#endif

void GBOutputNull(Sink & sink) { 
  sink.noOutput();
};

#if 0
void GBOutputPower(Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :Power:" 
           << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("Power",2L,5L);
};

void GBOutputRule(Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :Rule:" 
           << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("Rule",2L,4L);
};

void GBOutputPlus(long size,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :Plus:" 
           << size << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("Plus",size,4L);
};

void GBOutputNCM(long size,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :NCM:" 
           << size << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("NonCommutativeMultiply",size,22L);
};

void GBOutputTimes(long size,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :Times:" 
           << size << gboutput_marker<< '\n';
};
#endif
  sink.putFunction("Times",size,5L);
};

void GBOutputAborted(Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :$Aborted:" 
           << gboutput_marker<< '\n';
};
#endif
  sink.putSymbol("$Aborted",8L);
};
#endif

#define NEW_STYLE_VARIABLE_OUTPUT

#ifdef  TEMPLATE_OK
#if 0
void GBOutputSpecial(const Variable & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :Variable:"  << L
           << gboutput_marker<< '\n';
};
#endif
#ifdef NEW_STYLE_VARIABLE_OUTPUT
  const Composite * const ptr = L.composite();
  if(ptr) {
    ptr->put(sink);
  } else {
#endif
  Sink sink(sink.outputFunction("ToExpression",1L));
  symbolGB temp(L.cstring());
  sink  << temp;
#ifdef NEW_STYLE_VARIABLE_OUTPUT
  };
#endif
};

void GBOutputSpecial(const Monomial & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :monomial:"  << L
           << gboutput_marker<< '\n';
};
#endif
  long size = (long) L.numberOfFactors(); 
  if(size==0L) {
    sink << 1;
  } else {
    Sink sink1(sink.outputFunction("NonCommutativeMultiply",size));
    MonomialIterator w = L.begin();
    for(long i=1L;i<=size;++i,++w) {
      sink << *w;
    };
  };
};
#endif

void GBOutputSpecial(const Field & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER 
           << "GBOutput of :rational:";
  L.print(GBStream);
  GBStream << gboutput_marker<< '\n';
};
#endif
  L.put(sink);
};

#if 0 
void GBOutputSpecial(const Term & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :term:"  << L
           << gboutput_marker<< '\n';
};
#endif
  Sink sink1(sink.outputFunction("Times",2L));
  sink1 << L.CoefficientPart() << L.MonomialPart();
};

void GBOutputSpecial(const Polynomial & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :polynomial:"  << L
           << gboutput_marker<< '\n';
};
#endif
  long size = L.numberOfTerms(); 
  Sink sink1(sink.outputFunction("Plus",size));
  PolynomialIterator w = L.begin();
  for(long i=1L;i<=size;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const GroebnerRule & L,Sink & sink) {
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of :rule:"  << L
           << gboutput_marker<< '\n';
};
#endif
  Sink sink1(sink.outputFunction("Rule",2L));
  sink1 << L.LHS() << L.RHS();
};
#endif

void GBOutputSpecial(const list<int> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  list<int>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const list<Polynomial> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  list<Polynomial>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const list<GroebnerRule> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  list<GroebnerRule>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const list<Variable> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  list<Variable>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const vector<int> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  vector<int>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const GBVector<int> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  GBVector<int>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const GBList<GroebnerRule> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  GBList<GroebnerRule>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const GBList<Variable> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  GBList<Variable>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

void GBOutputSpecial(const GBList<Polynomial> & L,Sink & sink) {
  long sz = L.size();
  Sink sink1(sink.outputFunction("List",sz));
  GBList<Polynomial>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink1 << *w;
  };
};

symbolGB s_True("True");
symbolGB s_False("False");

void GBOutputTrueFalse(bool x,Sink & sink) {  
#ifdef GBOUTPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllOutputs) {
  GBStream << gboutput_marker << Debug1::s_OUTPUT_CHECKER_NUMBER << "GBOutput of TrueFalse" 
           << (x ? "True" : "False")
           << gboutput_marker<< '\n';
};
#endif
  
  if(x) {
   sink << s_True;
  } else {
   sink << s_False;
  };
};

#endif

#ifdef PDLOAD
void GBOutputSpecial(const GBHistory & x,Sink & sink) {
  // 2 entries!!!!!!!!!!!!
  Sink sink1(sink.outputFunction("List",2L));
  sink1 << x.first() << x.second();
  const int count = x.reductions().SET().size();
  Sink sink2(sink1.outputFunction("List",(long)count));
  if(count>0) {
    set<SPIID,less<SPIID> >::const_iterator w = x.reductions().SET().begin();
    for(int i=1;i<=count;++i,++w) {
      sink2 << (*w).d_data;
    }
  }
};

void GBOutputSpecial2(const FactControl & fc,
                const GBVector<int> & aList,Sink & sink) {
  const int len = aList.size();
  Sink sink1(sink.outputFunction("List",(long)len));
  for(int i=1;i<=len;++i) {
    Sink sink1(sink.outputFunction("List",4L));
      int num = aList[i];
      sink1 << num << fc.fact(num); 
      GBOutputSpecial(fc.history(num),sink1);  // 2 entries
  }
};
#endif

symbolGB s_Aborted("$Aborted");

void GBOutputAborted(Sink & sink) {
  sink << s_Aborted;
};

void GBOutputSpecial(const RuleID&,Sink &) {
  DBG();
};
