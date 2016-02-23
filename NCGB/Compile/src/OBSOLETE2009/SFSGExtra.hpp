// Mark Stankus 1999 (c)
// SFSGExtra.hpp

#ifndef INCLUDED_SFSGEXTRA_H
#define INCLUDED_SFSGEXTRA_H

#include "MyOstream.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "ByAdmissible.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#include <map>
#else
#include <pair.h>
#include <map.h>
#endif

class ReductionHint {
public:
  typedef map<Monomial,pair<Polynomial,ReductionHint>,ByAdmissible>::iterator MI;
  MI d_iter;
  bool d_marked;
public:
  ReductionHint() : d_marked(true) {};
  ~ReductionHint() {};
  void touch(bool b = true) { d_marked = b;};
  bool touched() const { return d_marked;};
  void print(MyOstream & os) const { 
    os << (d_marked ? "true" : "false");
  };
  MI & iter() { return d_iter;};
  friend MyOstream & operator<<(MyOstream & os,const ReductionHint & x) { 
    os << (x.d_marked ? "true" : "false");
    return os;
  };
};
#endif
