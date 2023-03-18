// FindSubWords.h

#ifndef INCLUDED_FINDSUBWORDS_H
#define INCLUDED_FINDSUBWORDS_H

#include "Monomial.hpp"
#include "triple.hpp"
#include "GBList.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class FindSubWords {
  vector<Monomial> d_monos;
  vector<list<int> > d_firstLetters;
  vector<list<triple<int,int,int> > > d_jumps;
    // When do we use d_jumps:
    // Suppose we have a match of a monomial mono against d_monos[i]
    // from position $[k1,k2]$ (zero-based counting) in mono.
    // Suppose position $k2+1$ of d_monos[i] is different from  the
    // correspoding position (that is, the $k2-k1+1$ position) of d_monos[i]. 
    // If (k2-k1+1,b,c) is in d_jumps[i], then
    // a prefix of length c d_monos[b] is a subword of monos.
  vector<int> d_stringNumberToStartMono;
  int d_sz;
  int advanceUntilMismatch(int & numLeft,int len,
       MonomialIterator & first1,
       MonomialIterator & first2) const;
  void setUp(const vector<Monomial> & m);
  void setUp(const Monomial & m);
  void setUpFirstVariable(const Monomial & m,int i);
  void setUpJumps(const Monomial & m,int i);
  int findValidFirstLetter(int & start,int & numLeft,MonomialIterator &) const;
public:
  FindSubWords(const vector<Monomial> & v) : d_monos(v), d_firstLetters(),
      d_jumps(), d_stringNumberToStartMono(), d_sz(0) { 
    setUp(v);
  }
  int findMatch(int & start,const Monomial & m) const;
  void findAllSubWords(const Monomial & m,list<pair<int,int> > & L) const;
};
#endif
