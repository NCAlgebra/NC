// Mark Stankus 1999 (c)
// IAlgExpr.hpp

#include "IAlgExpr.hpp"

AddExpr::~AddExpr() {};

MultExpr::~MultExpr() {};

MultNumberExpr::~MultNumberExpr(){};

NegateExpr::~NegateExpr(){};

AlgExpr * MultExpr::clone() const {
  MultExpr * p = new MultExpr;
  p->d_L = d_L;
  return p;
};

void addExtractTerm(list<ICopy<AlgExpr> > &) { DBG();};

void MultExpr::tryToFillList() const {
  bool done = d_L.empty();
  while(!done) {
    list<ICopy<AlgExpr> > L1,L2,L3;
    typedef list<ICopy<AlgExpr> >::const_iterator LI;
    LI w = d_L.begin(), e = d_L.end();
    ICopy<AlgExpr> temp = (*w);
    ICopy<AlgExpr> ic(new AlgExpr(temp().tip()),Adopt::s_dummy);
    L1.push_back(ic);
    temp.access().makeTail();
    L1.push_back(temp);
    ++w;
    while(w!=e) {
      ICopy<AlgExpr> temp = (*w);
      ICopy<AlgExpr> ic(new AlgExpr(temp().tip()),Adopt::s_dummy);
      L2.push_back(ic);
      temp.access().makeTail();
      L2.push_back(temp);
      makeproduct(L1,L2,L3);
      L1 = L3;
      ++w;
    };
    addExtractTerm(L1);
    done = !L1.empty();
    if(done) {
    };
  };
};

AlgExpr * AddExpr::clone() const {
  AddExpr * p = new AddExpr;
  p->d_L = d_L;
  return p;
};

void AddExpr::tryToFillList() const {
  DBG();
};

AlgExpr * MultNumberExpr::clone() const {
  return new MultNumberExpr(d_x,d_f);
};

void MultNumberExpr::tryToFillList() const {
  if(d_x.hasTip() && !d_f.zero()) {
     Term t(d_x.getTip());
     t.Coefficient() *= d_f;
     MultNumberExpr * alias = const_cast<MultNumberExpr *>(this);
     alias->d_terms.push_back(t);
     alias->d_x.removeTip();
  };
};


AlgExpr * NegateExpr::clone() const {
  return new NegateExpr(d_x);
};

void NegateExpr::tryToFillList() const {
  if(d_x.hasTip()) {
     Term t(d_x.getTip());
     t.Coefficient() *= -1;
     NegateExpr * alias = const_cast<NegateExpr *>(this);
     alias->d_terms.push_back(t);
     alias->d_x.removeTip();
  };
};
