// Mark Stankus 1999 (c) 
// MonomialTag.c

#include "MonomialTag.hpp"

#include "AdmissibleOrder.hpp"

MonomialTag::~MonomialTag() {};

void MonomialTag::print(MyOstream & os) const {
  os << d_x;
};

bool MonomialTag::less(const Tag & x) const {
  const MonomialTag & y = (const MonomialTag &) x;
  return AdmissibleOrder::s_getCurrent().monomialLess(d_x,y.d_x);
};

bool MonomialTag::equal(const Tag & x) const {
  const MonomialTag & y = (const MonomialTag &) x;
  return d_x==y.d_x;
};
