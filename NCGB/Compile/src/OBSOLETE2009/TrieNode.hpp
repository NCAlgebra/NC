// Mark Stankus 1999 (c)
// TrieNode.h

#ifndef INCLUDED_TRIENODE_H
#define INCLUDED_TRIENODE_H

#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

class TrieNode {
  static void errorh(int);
  static void errorc(int);
public:
  TrieNode(const Monomial & m,const Polynomial & p) : d_initialpower(-1),
       d_m(m), d_L(),d_subword(0) {
    d_L.push_back(p);
    int sz = m.numberOfFactors();
    MonomialIterator w = m.begin();
    const Variable v(*w);
    while(sz) {
      if(*w==v) ++d_initialpower;
      --sz;++w;
    };
  };
  ~TrieNode() {
    if(!d_superwords.empty()) errorh(__LINE__);
  };
  void addSubword(TrieNode * p) {
    if(d_subword) DBG();
    d_subword = p;
    d_subword.d_superwords.push_back(this);
  };
  void clear() {
    if(d_subword) {
      typedef vector<TrieNode*>::iterator VI;
      VI f = find(d_subword->d_superwords.begin(),
                  d_subword->d_superwords.end(),
                  d_subword);         
      if(f==d_subword->d_superwords.end()) {
        errorh(__LINE__);
      } else {
        d_subword->d_superwords.erase(f);
      };
      d_subword = 0;
    };
  };
public:
  int d_initialpower;
  Monomial d_m;
  list<Polynomial> d_L;
  TrieNode * d_subword;
  vector<TrieNode *> d_superwords;
};
#endif
