// Mark Stankus 1999 (c)
// TrieNodeOrder.h

#ifndef INCLUDED_TRIENODEORDER_H
#define INCLUDED_TRIENODEORDER_H

#include "TrieNode.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"

struct TrieNodeOrder {
public:
  bool operator()(const TrieNode & x,const TrieNode & y) const {
    bool done = false;
    bool result = false;
    const Monomial & mx = x.d_m;
    const Monomial & my = y.d_m;
    int szx = mx.numberOfFactors();
    int szy = my.numberOfFactors();
    MonomialIterator wx = mx.begin();
    MonomialIterator wy = my.begin();
    int i = 0;
    while(i<szx && i<szy) {
      if(*wx!=*wy) {
        // before here, words same.
        result = (*wx).stringNumber()<(*wy).stringNumber();
        done = true;
        break;
      } else {
        ++i;++wx;++wy;
      };
    };
    if(!done) {
      // one word is a prefix of another. longer word larger
      result = szx<szy;
    };
    return result;
  };
  bool operator()(const TrieNode * x,const TrieNode * y) const {
    return (*this)(*x,*y);
  };
};
#endif
