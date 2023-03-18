// (c) Mark Stankus 1999
// ByAdmissible.hpp

#ifndef INCLUDED_BYADMISSIBLE_H
#define INCLUDED_BYADMISSIBLE_H

#include "AdmissibleOrder.hpp"
#include "Choice.hpp"
class GroebnerRule;
class Polynomial;
#include "Debug1.hpp"
#include "MyOstream.hpp"

class ByAdmissible {
  const AdmissibleOrder * d_order;
  static void errorh(int);
  static void errorc(int);
public:
  ByAdmissible() : d_order(0) {};
  ByAdmissible(const AdmissibleOrder & order) : 
       d_order(&order) {};
  bool operator()(const Variable & m,const Variable & n) const {
    return d_order ? d_order->variableLess(m,n)
                   : AdmissibleOrder::s_getCurrent().variableLess(m,n);
  };
  bool operator()(const Monomial & m,const Monomial & n) const {
    return d_order ? d_order->monomialLess(m,n)
                   : AdmissibleOrder::s_getCurrent().monomialLess(m,n);
  };
  bool operator()(const GroebnerRule & m,const GroebnerRule & n) const;
  bool operator()(const Polynomial & m,const Polynomial & n) const;
  bool operator()(const VariableSet & m,const VariableSet & n) const {
    bool result = false;
    int msz = m.size();
    int nsz = n.size();
    if(msz!=nsz) {
      result = msz< nsz;
    } else if(msz>0) {
      result = false; // perhaps they are equal
      Variable v1,v2;
      bool b1 = m.firstVariable(v1);
      bool b2 = n.firstVariable(v2);
      if(v1==v2) {
        while(b1&&b2) {
          b1 = m.nextVariable(v1);
          b2 = n.nextVariable(v2);
          if(b1) {
            if(v1!=v2) {
             result = operator()(v1,v2);
            }; 
          } else break; 
       };
      } else {
        result = operator()(v1,v2);
      };
      if(b1!=b2) errorh(__LINE__);
    };
    return result;
  };
#ifdef OLD_GCC
  void operator=(const ByAdmissible &) const { errorh(__LINE__);};
  bool operator==(const ByAdmissible & x) const { return this==&x;};
  bool operator!=(const ByAdmissible & x) const { return this!=&x;};
#endif
};
#endif
