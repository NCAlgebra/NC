// Mark Stankus 1999 (c)
// AlgebraicExpression.c

#include "AlgebraicExpression.hpp"
#include "IAlgExpr.hpp"

AlgebraicExpression AlgebraicExpression::operator+(
   const AlgebraicExpression & x) {
#if 0
  MultExpr * it = new MultExpr;
  it->d_L.push_back(*this);
  it->d_L.push_back(x);
  ICopy<AlgExpr> ic(it,Adopt::s_dummy);
#else
  ICopy<AlgExpr> ic;
  if(d_expr().ID()==AddExpr::s_ID) {
    AddExpr it((const AddExpr &)(d_expr()));
    it.d_L.push_back(x);
    ic = it;
  } else if(x.d_expr().ID()==AddExpr::s_ID) {
    AddExpr it((const AddExpr &)(x.d_expr()));
    it.d_L.push_back(*this);
    ic = it;
  } else {
    AddExpr it;
    it.d_L.push_back(*this);
    it.d_L.push_back(x);
    ic = it;
  };
#endif
  AlgebraicExpression result(ic);
  return result; 
};

AlgebraicExpression AlgebraicExpression::operator-(
    const AlgebraicExpression & x) {
#if 1
  AlgebraicExpression neg(x);
  NegateExpr * negit  = new NegateExpr(neg);
  ICopy<AlgExpr> ic1(negit,Adopt::s_dummy);
  AlgebraicExpression alg(ic1);
  AddExpr * it = new AddExpr;
  it->d_L.push_back(*this);
  it->d_L.push_back(alg);
  ICopy<AlgExpr> ic(it,Adopt::s_dummy);
#else
#endif
  AlgebraicExpression result(ic);
  return result; 
};

AlgebraicExpression AlgebraicExpression::operator*(
    const AlgebraicExpression & x) { 
#if 1
  MultExpr * it = new MultExpr;
  it->d_L.push_back(d_expr);
  it->d_L.push_back(x.d_expr);
  ICopy<AlgExpr> ic(it,Adopt::s_dummy);
#else
#endif
  AlgebraicExpression result(ic);
  return result; 
};

AlgebraicExpression AlgebraicExpression::doubleProduct(
        const AlgebraicExpression & front,
        const AlgebraicExpression & back) {
#if 1
  MultExpr * it = new MultExpr;
  it->d_L.push_back(front.d_expr);
  it->d_L.push_back(d_expr);
  it->d_L.push_back(back.d_expr);
  ICopy<AlgExpr> ic(it,Adopt::s_dummy);
#else
#endif
  AlgebraicExpression result(ic);
  return result; 
};

int AlgebraicExpression::treeNumber() const {
  DBG();
  return 0;
};
