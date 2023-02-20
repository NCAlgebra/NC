// Mark Stankus 1999 (c)
// IAlgExpr.hpp

#ifndef INCLUDED_IALGEXPR_H
#define INCLUDED_IALGEXPR_H

#include "AlgExpr.hpp"
#include "AlgebraicExpression.hpp"

class MultExpr : public AlgExpr {
public:
  virtual ~MultExpr();
  virtual void tryToFillList() const;
  virtual AlgExpr * clone() const;
  void makeproduct(list<ICopy<AlgExpr> > &,
          list<ICopy<AlgExpr> > &,list<ICopy<AlgExpr> > &) const;
  list<ICopy<AlgExpr> > d_L;
};

void MultExpr::makeproduct(list<ICopy<AlgExpr> > & L1,
        list<ICopy<AlgExpr> > & L2, list<ICopy<AlgExpr> > & L3) const {
  L3.erase(L3.begin(),L3.end());
  typedef list<ICopy<AlgExpr> >::const_iterator LI;
  LI w1 = L1.begin(), e1 = L1.end();
  while(w1!=e1) {
    const AlgExpr & temp1 = (*w1)();
    ICopy<AlgExpr> ic1(temp1);
    LI w2 = L2.begin(), e2 = L2.end();
    while(w2!=e2) {
      const AlgExpr & temp2 = (*w2)();
      MultExpr * p = new MultExpr;
      p->d_L.push_back(ic1);
      ICopy<AlgExpr> ic2(temp2);
      p->d_L.push_back(ic2);
      ICopy<AlgExpr> ic(p,Adopt::s_dummy);
      L3.push_back(ic);
      ++w2;
    };
    ++w1;
  };
};

class AddExpr : public AlgExpr {
public:
  AddExpr() : AlgExpr(s_ID), d_L(){};
  AddExpr(const AddExpr & x) : AlgExpr(s_ID), d_L(x.d_L) {};
  virtual ~AddExpr();
  virtual void tryToFillList() const;
  virtual AlgExpr * clone() const;
  static const int s_ID;
  list<AlgebraicExpression> d_L;
};

class MultNumberExpr : public AlgExpr {
  AlgebraicExpression d_x;
  Field d_f;
public:
  MultNumberExpr(const AlgebraicExpression & x,const Field & f) : 
       AlgExpr(s_ID), d_x(x), d_f(f) {};
  MultNumberExpr(const MultNumberExpr & x) : AlgExpr(s_ID), 
       d_x(x.d_x), d_f(x.d_f) {};
  virtual ~MultNumberExpr();
  virtual void tryToFillList() const;
  virtual AlgExpr * clone() const;
  static const int s_ID;
};

class NegateExpr : public AlgExpr {
  AlgebraicExpression d_x;
public:
  NegateExpr(const AlgebraicExpression & x) : AlgExpr(s_ID), d_x(x) {};
  NegateExpr(const NegateExpr & x) : AlgExpr(s_ID), d_x(x.d_x) {};
  virtual ~NegateExpr();
  virtual void tryToFillList() const;
  virtual AlgExpr * clone() const;
  static const int s_ID;
};
#endif
