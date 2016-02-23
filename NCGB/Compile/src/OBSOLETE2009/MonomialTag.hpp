// Mark Stankus 1999 (c)
// MonomialTag.h

#ifndef INCLUDED_MONOMIALTAG_H
#define INCLUDED_MONOMIALTAG_H

#include "Monomial.hpp"
#include "Tag.hpp"

class MonomialTag : public Tag {
  static int s_ID;
  Monomial d_x;
public:
  MonomialTag(const Monomial & x) : Tag(s_ID,false), d_x(x) {};
  virtual ~MonomialTag();
  virtual void print(MyOstream &) const;
  virtual bool less(const Tag &) const;
  virtual bool equal(const Tag & x) const;
};
#endif 
