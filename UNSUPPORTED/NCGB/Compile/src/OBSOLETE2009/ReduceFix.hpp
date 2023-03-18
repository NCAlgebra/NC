// (c) Mark Stankus 1999
// ReduceFix.h

#ifndef INCLUDED_REDUCEFIX_H
#define INCLUDED_REDUCEFIX_H

// Reduce a fixed set of polynomials

#include "Reduce.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "Polynomial.hpp"
#include "vcpp.hpp"

class ReduceFix : public Reduce {
  ReduceFix(const ReduceFix&);
    // not implemented
  void operator=(const ReduceFix &);
    // not implemented
  Reduce & d_x;
  int d_num_zero;
  list<Polynomial> d_original; 
  list<Polynomial> d_current; 
public:
  ReduceFix(Reduce & x,const list<Polynomial> & L);
  virtual ~ReduceFix();
  virtual bool reduce(Polynomial &) const;
  void reducefix();
  int numberZero() const { return d_num_zero;}
  const list<Polynomial> & original() const { return d_original; };
  const list<Polynomial> & current() const { return d_current; }; 
};
#endif 
