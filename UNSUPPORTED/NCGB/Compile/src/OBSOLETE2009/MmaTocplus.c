// MmaTocplus.c

#include "MmaTocplus.hpp" 
#include "RecordHere.hpp" 
#include "Source.hpp" 
#include "TellHead.hpp" 
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "GBStream.hpp"
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#ifndef INCLUDED_GBSTRING_H
#include "GBString.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#include "StringAccumulator.hpp"
#include "MyOstream.hpp"

inline void klugeMmaTocplus(Source & so,Variable & tree) {
  MmaTocplus(so,tree);
};

void GrabAllAsString(Source &,GBString &);

void TellHead(Source&);

void MmaTocplusMonomialmini(Source &  source,Monomial & mono) {
  Variable tree;
  while(!source.eoi()) {
    MmaTocplus(source,tree);
    mono *= tree;
  }
};

void MmaTocplusVariablemini(Source &  so,symbolGB & x) {
  StringAccumulator acc;
  acc.add(x.value().chars());
  acc.add('[');
  Variable child;
  while(!so.eoi()) {
    klugeMmaTocplus(so,child);
    acc.add(child.cstring());
    acc.add(',');
  }
  klugeMmaTocplus(so,child);
  acc.add(child.cstring());
  acc.add(']');
  x = acc.chars();
};

void MmaTocplus(Source &  source,Variable & tree) {
  GBString ss;
  int type = source.getType();
  if(isSymbol(type)) {
     symbolGB x;
     source >> x;
     ss = x.value().chars();
  } else if(isFunction(type)) {
     GrabAllAsString(source,ss);
  } else {
    GBStream << "The C++ part of the program wants a variable from "
             << "Mathematica and the Mathematica part of the"
             << " program supplied something else. This can "
             << "happen if a symbolic variable is used as a "
             << "Mathematica variable with a value.\n"; 
    TellHead(source);
    DBG(); // Why would the code be here?
  } 
  tree.assign(ss.chars());
};

void MmaTocplus(Source &  source1,Monomial & mono) {
  mono.setToOne();
  int type = source1.getType();
  if(isFunction(type)) // a noncommutative multiply
  {
    symbolGB ss;
    Source source2(source1.inputFunction(ss));
    if(ss=="NonCommutativeMultiply") {
      MmaTocplusMonomialmini(source2,mono);
    } else {
      MmaTocplusVariablemini(source2,ss);
      Variable tree(ss.value().chars());
      mono *= tree;
    }
  } else if(isInteger(type)) {
     // the monomial is 1
     int n;
     source1 >> n;
     if(n!=1) {
       GBStream << "n:" << n << '\n';
     }
     // do nothing
  } else  // just a tree
  {
    Variable tree;
    klugeMmaTocplus(source1,tree);
    mono *= tree;
  }
};

void MmaTocplus(Source &  source,INTEGER & I) {
  int j;
  source >> j;
  I = INTEGER((INTEGER::InternalType)j);
};

void MmaTocplus(Source &  source1,Field & qf) {
  int type = source1.getType();
  if(isInteger(type)) {
    int i;
    source1 >> i;
    qf = Field(INTEGER((INTEGER::InternalType)i));
  } else if(isFunction(type)) {
    int i,j;
    symbolGB x;
    Source source2(source1.inputFunction(x));
    if(x=="RATIONAL") {
      source2 >> i >> j;
      qf = Field(INTEGER((INTEGER::InternalType)i),
                         INTEGER((INTEGER::InternalType)j));
    } else {
      TellHead(source2);
      DBG(); // Why would the code be here?
    }
  } else {
    TellHead(source1);
    DBG(); // Why would the code be here?
  }
};

void MmaTocplusTermmini(Source &  so,const symbolGB & ss,Term & term) {
  if(ss=="Times") {
    MmaTocplus(so,term.Coefficient());
    MmaTocplus(so,term.MonomialPart());
  } else if(ss=="Integer") {
    INTEGER i;
    MmaTocplus(so,i);
    term.assign(Field(i));
  } else if(ss=="RATIONAL") {
    INTEGER i,j;
    MmaTocplus(so,i);
    MmaTocplus(so,j);
    term.assign(Field(i,j));
  } else if(ss=="NonCommutativeMultiply") {
    term.Coefficient() = 1;
    MmaTocplusMonomialmini(so,term.MonomialPart());
  } else {
    Monomial M;
    Variable t;
    symbolGB x(ss); 
    MmaTocplusVariablemini(so,x);
    t.assign(x.value().chars());
    M *= t;
    term.assign(M);
  }
};

void MmaTocplus(Source &  source1,Term & term) {
  int type = source1.getType();
  if(isFunction(type)) {
    symbolGB ss;
    Source source2(source1.inputFunction(ss));
    MmaTocplusTermmini(source2,ss,term);
  } else if(isInteger(type)) {
    int N;
    source1 >> N;
    INTEGER TOP((long) N);
    Field NUM(TOP);
    term.assign(NUM);
  } else  {
    Monomial M;
    MmaTocplus(source1,M);
    term.assign(M);
  }
};

void MmaTocplus(Source &  source1,Polynomial & poly) { 
  poly.setToZero(); 
  int type = source1.getType();
  Term term;
  if(isFunction(type)) {
    symbolGB ss;
    Source source2(source1.inputFunction(ss));
    if(ss=="Plus") {
      list<Term> L;
      while(!source2.eoi()) { 
        MmaTocplus(source2,term);  
        L.push_back(term);
      } 
      poly.setWithList(L);
    } else {
      MmaTocplusTermmini(source1,ss,term);
      poly = term;
    }
  } else {
     MmaTocplus(source1,term);
     poly = term;
  }
}; 

void MmaTocplus(Source &  source1,GroebnerRule & rule) {
  Source source2(source1.inputNamedFunction("Rule"));
  MmaTocplus(source2,rule.LHS());
  MmaTocplus(source2,rule.RHS());
};

void MmaTocplus(Source &  source1,GBString & ss) {
  stringGB x;
  int type = source1.getType();
  if(isString(type)) {
    source1 >> x;
    ss = x.value().chars();
  } else {
    TellHead(source1);
    DBG();
  };
};

GBString SwallowAllAsString(Source &  source) {
  GBString ss;
  int type = source.getType(); 
  if(isSymbol(type)) {
    symbolGB x;
    source >> x;
    ss = x.value().chars(); 
  } else if(isString(type)) {
    GBStream << "\nWe read a character string in your expression "
             << "which was unexpected.\nWe will treat the string "
             << "as a symbol.\n";
    stringGB x;
    source >> x;
    ss = x.value().chars(); 
  } else if(isInteger(type)) {
    int i;
    source >> i;
    DBG();
  } else if(isFunction(type)) {
    symbolGB y;
    Source source2(source.inputFunction(y));
    ss += '['; 
    ss += SwallowAllAsString(source2).chars(); 
    ss += ']'; 
  } else DBG();
  return ss;
};

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

#ifndef INCLUDED_STDIO_H
#define INCLUDED_STDIO_H
#include <stdio.h>
#endif

void GrabAllAsString(Source &  source1,GBString & result) {
  int type = source1.getType(); 
  if(isSymbol(type)) {
    symbolGB x;
    source1 >> x;
    result += x.value().chars();
  } else if(isString(type)) {
    stringGB x;
    source1 >> x;
    result += '\"';
    result += x.value().chars();
    result += '\"';
  } else if(isInteger(type)) {
    int i;
    source1 >> i;
    RECORDHERE(char * s = new char[20];)
    sprintf(s,"%i",i);
    result += s;
    RECORDHERE(delete s;)
  } else if(isFunction(type)) {
    symbolGB x;
    Source source2(source1.inputFunction(x));
    result += x.value().chars();
    result += '[';
    bool first = true;
    while(!source2.eoi()) {
      if(!first) result += ',';
      first = false;
      GBString temp;
      GrabAllAsString(source2,temp);
      result += temp.chars();
    }
    result += ']';
  } else DBG();
};
