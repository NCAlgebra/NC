// GBInput.c

#include "simpleString.hpp"
#include "TellHead.hpp"
#include "RecordHere.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "Source.hpp"
#include "Sink.hpp"

#if 0
#include "Categories.hpp"
#endif
//#include "GBString.hpp"
#include "GroebnerRule.hpp"
#include "MmaTocplus.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "Field.hpp"
#include "StringAccumulator.hpp"
#include "Variable.hpp"
#include "Term.hpp"
#include "GBList.hpp"
#include "GBVector.hpp"

#include "GBInput.hpp"
#include "AppendItoString.hpp"
#include "Debug1.hpp"
#include "idValue.hpp"
#include "Debug2.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
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

extern void MmaTocplusVariablemini(Source & ,symbolGB &);
extern void MmaTocplusTermmini(Source &,const symbolGB &,Term &);
extern void MmaTocplusMonomialmini(Source & ,Monomial &);


void GrabAllAsString(StringAccumulator &,Source &);
void GrabAllAsString(StringAccumulator &,long,Source&);

const char * gbinput_marker = "@@@";

void GBInput(int & x,Source & ic) {
  ic >> x;
};

void GBInput(long & x,Source & ic) {
  ic >> x;
};

void GBInput(bool & x,Source & ic) {
  ic >> x;
};

void GBInputSpecial(RuleID &,Source &) {
  DBG();
};

simpleString typeAsAString(int type) {
  simpleString result;
  if(isSymbol(type)) {
    result = "symbol";
  } else if(isString(type)) {
    result = "string";
  } else if(isInteger(type)) {
    result = "integer";
  } else if(isFunction(type)) {
    result = "function";
  } else if (isReal(type)) {
    result = "real";
  } else {
    RECORDHERE(char * s = new char[strlen("unknown x")+1];)
    strcpy(s,"unknown x");
    s[strlen("unknown x")-1] = (char) type; // turn x into character
    result = s;
    RECORDHERE(delete s;)
  }
  return result;
};

#if 0
void GBInputSpecial(
    Categories &,Source & 
    ) {
  DBG();
};
#endif

void GBInputSpecial(GBVector<int> & vec,Source &  so) {
  int n;
  Source counted(so.inputNamedFunction("List"));
  while(!counted.eoi()) {
    counted >> n;
    vec.push_back(n);
  };
};

void GBInputSpecial(vector<int> & vec,Source &  so) {
  int n;
  Source counted(so.inputNamedFunction("List"));
  list<int> temp;
  while(!counted.eoi()) {
    counted >> n;
    temp.push_back(n);
  };
  vec.erase(vec.begin(),vec.end());
  vec.reserve(temp.size());
  copy(temp.begin(),temp.end(),back_inserter(vec));
};

void GBInputSpecial(list<Monomial> & L,Source & so) {
  Source source(so.inputNamedFunction("List"));
  Monomial x;
  while(!source.eoi()) {
    source >> x;
    L.push_back(x);
  } 
};

void GBInputSpecial(list<Polynomial> & L,Source & so) {
  Source source(so.inputNamedFunction("List"));
  Polynomial x;
  while(!source.eoi()) {
    source >> x;
    L.push_back(x);
  } 
};

void GBInputSpecial(list<GroebnerRule> & L,Source & so) {
  Source source(so.inputNamedFunction("List"));
  GroebnerRule x;
  while(!source.eoi()) {
    source >> x;
    L.push_back(x);
  }
}

void GBInputSpecial(list<Variable> & L,Source & so) {
  Source source(so.inputNamedFunction("List"));
  Variable x;
  while(!source.eoi()) {
    source >> x;
    L.push_back(x);
  }
}

#if 0
void GrabAllAsString(StringAccumulator & acc,Source & so) {
  int type = so.getType(); 
  if(isSymbol(type)) {
    symbolGB x;
    so >> x;
    acc.add(x.value().chars());
  } else if(isString(type)) {
    stringGB x;
    so >> x;
    acc.add('\"');
    acc.add(x.value().chars());
    acc.add('\"');
  } else if(isInteger(type)) {
    int i;
    so >> i;
    char * s = 0;
    ItoString(i,s);
    acc.add(s);
    RECORDHERE(delete s;)
  } else if(isFunction(type)) {
    symbolGB y;
    Source source1(so.inputFunction(y));
    acc.add(y.value().chars());
    acc.add('[');
    bool first = true;
    while(!source1.eoi()) {
      if(!first) acc.add(',');
      first = false;
      GrabAllAsString(acc,source1);
    }
    acc.add(']');
  } else {
    TellHead(so);
    DBG();
  };
};

void GrabAllAsString(StringAccumulator & acc,long count,Source & so) {
  acc.add('[');
  for(int i=1;i<count;++i) {
    GrabAllAsString(acc,so);
    acc.add(',');
  }
  GrabAllAsString(acc,so);
  acc.add(']');
};

void GrabAllAsString(Source&,GBString & result);
#endif

#if 0
void GBInputSpecial(Variable & x,Source & so) {
  int type = so.getType();
  if(isSymbol(type)) {
     symbolGB y;
     so >> y;
     x.assign(y.value().chars());
  } else if(isFunction(type)) {
     StringAccumulator acc;
     GrabAllAsString(acc,so);
     x.assign(acc.chars());
  } else {
    GBStream << "The C++ part of the program wants a variable from "
             << "Mathematica and the Mathematica part of the"
             << " program supplied something else. This can "
             << "happen if a symbolic variable is used as a "
             << "Mathematica variable with a value.\n"; 
    TellHead(so);
    DBG(); // Why would the code be here?
  } 
};

void GBInputSpecial(Monomial & mono,Source &  so) {
  mono.setToOne();
  int type = so.getType();
  if(isFunction(type)) // a noncommutative multiply
  {
    symbolGB ss;
    Source source(so.inputFunction(ss));
    if(ss=="NonCommutativeMultiply") {
      MmaTocplusMonomialmini(source,mono);
    } else {
      MmaTocplusVariablemini(source,ss);
      Variable tree;
      tree.assign(ss.value().chars());
      mono *= tree;
    }
  } else if(isInteger(type)) {
     // the monomial is 1
     int n;
     so >> n;
     if(n!=1) {
       GBStream << "n:" << n << '\n';
     }
     // do nothing
  } else  // just a tree
  {
    Variable tree;
    so >> tree;
    mono *= tree;
  }
#ifdef GBINPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllInputs) {
  GBStream << gbinput_marker << Debug1::s_INPUT_CHECKER_NUMBER << "GBInputSpecial: monomial: " << mono 
           << gbinput_marker << '\n';
};
#endif
};
#endif

void GBInputSpecial(INTEGER & I,Source &  so) {
  int j;
  GBInput(j,so);
  I = INTEGER((INTEGER::InternalType)j);
#ifdef GBINPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllInputs) {
  GBStream << gbinput_marker << Debug1::s_INPUT_CHECKER_NUMBER << "GBInputSpecial: INTEGER: " << I 
           << gbinput_marker << '\n';
};
#endif
};

void GBInputSpecial(Field & qf,Source &  so) {
  int type = so.getType();
  if(isInteger(type)) {
    int i;
    so >> i;
    qf = Field(i);
  } else if(isFunction(type)) {
    int i,j;
    symbolGB x;
    Source source(so.inputFunction(x));
    if(x=="RATIONAL") {
      source >> i >> j;
      qf = Field(i,j);
    } else {
      TellHead(so);
      DBG(); // Why would the code be here?
    }
  } else {
    TellHead(so);
    DBG(); // Why would the code be here?
  }
#ifdef GBINPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllInputs) {
  GBStream << gbinput_marker << Debug1::s_INPUT_CHECKER_NUMBER 
           << "GBInputSpecial: rational: ";
  qf.print(GBStream);
  GBStream  << gbinput_marker << '\n';
};
#endif
};

#if 0
void GBInputSpecial(Term & term,Source &  so) {
  int type = so.getType();
  if(isFunction(type)) {
    symbolGB x;
    Source source(so.inputFunction(x));
    MmaTocplusTermmini(source,x,term);
  } else if(isInteger(type)) {
    int N;
    so >> N;
    INTEGER TOP((long) N);
    Field NUM(TOP);
    term.assign(NUM);
  } else  {
    Monomial M;
    GBInputSpecial(M,so);
    term.assign(M);
  }
#ifdef GBINPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllInputs) {
  GBStream << gbinput_marker << Debug1::s_INPUT_CHECKER_NUMBER << "GBInputSpecial: term: " << term
           << gbinput_marker << '\n';
};
#endif
};

void GBInputSpecial(Polynomial & poly,Source &  so) { 
  poly.setToZero(); 
  Term term;
  int type = so.getType();
  if(isFunction(type)) {
    symbolGB x;
    Source source(so.inputFunction(x)); 
    if(x=="Plus") {
      list<Term> L;
      while(!source.eoi()) { 
        source >> term;  
        L.push_back(term);
      } 
      poly.setWithList(L);
    } else {
      MmaTocplusTermmini(source,x,term);
      poly = term;
    }
  } else {
     GBInputSpecial(term,so);
     poly = term;
  }
#ifdef GBINPUT_CHECK_OUTPUT
if(Debug1::s_PrintOutAllInputs) {
  GBStream << gbinput_marker 
           << Debug1::s_INPUT_CHECKER_NUMBER 
           <<  "GBInputSpecial: polynomial: " << poly 
           << gbinput_marker << '\n';
};
#endif
}; 

void GBInputSpecial(GroebnerRule & rule,Source &  so) {
  Source source(so.inputNamedFunction("Rule"));
  Monomial   & m = rule.LHS();
  Polynomial & p = rule.RHS();
  source >> m >> p;
};
#endif

#if 0 
void GBInputSpecial(GBString & ss,Source &  so) {
  int type = so.getType();
  if(isString(type)) {
    stringGB x;
    so >> x;
    ss = x.value().chars();
  } else {
    TellHead(so);
    DBG();
  };
};
#endif

void GBInputSpecial(GBList<Polynomial> & x,Source &  so) {
  Polynomial temp;
  Source source(so.inputNamedFunction("List"));
  while(!source.eoi()) {
    source >> temp;
    x.push_back(temp);
  } 
};

void GBInputSpecial(GBList<GroebnerRule> & aList,Source &  so) {
  GroebnerRule temp;
  Source source(so.inputNamedFunction("List"));
  while(!source.eoi()) {
    source >> temp;
    aList.push_back(temp);
  }
}

void GBInputSpecial(GBList<Variable> & aList,Source &  so) {
  Variable temp;
  Source source(so.inputNamedFunction("List"));
  while(!source.eoi()) {
    source >> temp;
    aList.push_back(temp);
  }
}

#if 0
MOVED TO SetMLex.c

void GBInput(vector<vector<Variable> > & x,Source & so) {
  x.erase(x.begin(),x.end());
  Variable v;
  Source counted1(so.inputNamedFunction("List"));
  while(!counted1.eoi()) {
    Source counted2(counted1.inputNamedFunction("List"));
    vector<Variable> V1;
    while(!counted2.eoi()) {
      counted2 >> v;
      V1.push_back(v);
    };
    x.push_back(V1);
  };
};
#endif
