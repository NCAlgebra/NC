// Mark Stankus 1999 (c)
// AlgebraicExpression.hpp

#ifndef INCLUDED_ALGEBRAICEXPRESSION_H
#define INCLUDED_ALGEBRAICEXPRESSION_H

#include "AlgExpr.hpp"
class AlgebraicExpression {
  ICopy<AlgExpr> d_expr;
  void operator+=(const AlgebraicExpression & x);
    // not implemented
  void operator-=(const AlgebraicExpression & x);
    // not implemented
  void operator*=(const AlgebraicExpression & x);
    // not implemented
public:
  AlgebraicExpression(const ICopy<AlgExpr> & x) : d_expr(x) {};
  ~AlgebraicExpression(){};
  AlgebraicExpression operator+(const AlgebraicExpression &);
  AlgebraicExpression operator-(const AlgebraicExpression &);
  AlgebraicExpression operator*(const AlgebraicExpression &);
  AlgebraicExpression doubleProduct(
        const AlgebraicExpression & front,
        const AlgebraicExpression & back);
  bool hasTip() const {
    return !d_expr().zero();
  };
  const Term & getTip() const {
    return d_expr().tip();
  };
  void removeTip() {
    d_expr.access().makeTail(); 
  };
  int treeNumber() const;
};
#endif
