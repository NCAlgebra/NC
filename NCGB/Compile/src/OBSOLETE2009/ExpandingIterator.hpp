// (c) Mark Stankus 1999
// ExpandingIterator.h

#ifndef INCLUDED_EXPANDINGITERATOR_H
#define INCLUDED_EXPANDINGITERATOR_H

#include "Term.h"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

class ExpandingIterator {
  list<Term>::const_iterator d_w;
  list<Term>::const_iterator d_e;
  const Polynomial * d_p_p;
public:
  ExpandingIterator(list<Term>::const_iterator w,
       const Polynomial & p) : d_w(w), d_e(w), d_p_p(&p) {
    if(!d_p_p->isAlone()) DBG();
    d_w = d_p_p->d_terms.end();
  };
  ExpandingIterator(const ExpandingIterator & x) :
    d_w(x.d_w), d_e(x.d_e), d_p_p(&p) {};
  void operator=(const ExpandingIterator & x) {
    d_w=x.d_w; d_e=x.d_e; d_p_p= x.d_p_p;
  };
  bool operator==(const ExpandingIterator & x) const { 
    return d_w == x.d_w; 
  };
  bool operator!=(const ExpandingIterator& x) const { 
    return !operator==(x);
  };
  const Term & operator*() const { 
    return * d_w;
  };
  ExpandingIterator & operator++() {
    ++d_w;
    if(d_w==d_e) {
      if(!p.d_terms.isAlone()) DBG();
      p.expandList();
      d_e = p.d_terms().end();
    };
    return *this;
  }
};
#endif
