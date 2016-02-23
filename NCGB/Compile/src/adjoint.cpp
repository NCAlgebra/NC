// adjoint.c

#include "adjoint.hpp"
#ifndef INCLUDED_GBSTRING_H
#include "GBString.hpp"
#endif
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#include "GroebnerRule.hpp"

Variable adjoint(const Variable & v,const char *) {
  bool strip = false;
  const int len = strlen(v.cstring());
  if(len>5) {
    GBString temp(v.cstring());
    GBString::const_iterator place = temp.begin();
    char firstChar = *place;
    ++place;
    char secondChar = *place;
    ++place;
    char thirdChar = *place;
    if(thirdChar=='[') {
      if(secondChar=='p') {
        if(firstChar=='T'||firstChar=='T') {
          strip = true;
        }
      }
      if(secondChar=='j') {
        if(firstChar=='A'||firstChar=='a') {
          strip = true; 
        } 
      } 
    }
  };
  GBString newString;
  if(strip) {
    newString = GBString(v.cstring()).at(3,len-4);
  } else {
    newString = "Aj[";
    newString += v.cstring();
    newString += ']';
  }
  Variable newVar;
  newVar.assign(newString.chars());
  return newVar;
};

Monomial adjoint(const Monomial & v,const char * s) {
  GBList<Variable> list;
  MonomialIterator w = v.begin();
  const int sz = v.numberOfFactors();
  int i=1;
  for(;i<=sz;++i,++w) {
    list.addElement(adjoint(*w,s),1);
  }
  Monomial result;
  GBList<Variable>::const_iterator ww = 
       ((const GBList<Variable> &)list).begin();
  for(i=1;i<=sz;++i,++ww) {
     result *= (*ww);
  }
  return result;
};

Polynomial adjoint(const Polynomial & p,const char * s) {
  const int sz = p.numberOfTerms(); 
  PolynomialIterator w = p.begin();
  list<Term> L;
  for(int i=1;i<=sz;++i,++w) {
    L.push_back(adjoint(*w,s));
  }
  Polynomial result;
  result.setWithList(L);
  return result;
};

Polynomial adjoint(const GroebnerRule & r,const char * s) {
  Polynomial result;
  result = Term(adjoint(r.LHS(),s));
  result -= adjoint(r.RHS(),s);
  return result;
};
