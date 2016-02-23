// Mark Stankus 1999 (c) 
// PolynomialData.hpp

#ifndef INCLUDED_POLYNOMIALDATA_H
#define INCLUDED_POLYNOMIALDATA_H

#include "BroadCast.hpp"
class Polynomial;
class Tag;

class PolynomialData : public BroadCastData {
public:
  static const int s_ID;
  const Polynomial &d_p;
  const int d_number;
  Tag * d_poly_tag_p;
  Tag * d_rule_tag_p; 
  PolynomialData(const Polynomial & p,const int number,
      Tag * poly_tag_p,Tag * rules_tag) :
     BroadCastData(s_ID), d_p(p),d_number(number), d_poly_tag_p(poly_tag_p), 
     d_rule_tag_p(rules_tag) {};
};
#endif
