// Mark Stankus 1999 (c)
// AlgExpr.hpp

#ifndef INCLUDED_ALGEXPR_H
#define INCLUDED_ALGEXPR_H

#include "Term.hpp"
#include <list>

class AlgExpr {
  static void errorh(int);
  static void errorc(int);
  static const int s_ID;
  int d_ID;
protected:
  list<Term> d_terms;
  AlgExpr(int id) : d_ID(id) {};
public:
  AlgExpr() : d_ID(s_ID){};
  AlgExpr(const Term & x){
    d_terms.push_back(x);
  };
  virtual ~AlgExpr();
  int ID() const { return d_ID;};
  virtual void tryToFillList() const;
  const Term & tip() const {
    if(d_terms.empty()) {
      tryToFillList();
      if(d_terms.empty()) errorh(__LINE__);
    };
    return d_terms.front();
  };
  void makeTail() {
    if(d_terms.empty()) {
      tryToFillList();
    };
    d_terms.pop_front();
  };
  bool zero() const {
    bool result = d_terms.empty();
    if(result) {
      tryToFillList();
      result = d_terms.empty();
    };
    return result;
  };
  bool one() const {
    if(d_terms.empty()) {
      tryToFillList();
    };
    return !d_terms.empty() && d_terms.front().one();
  };
  virtual AlgExpr * clone() const;
};
#endif
