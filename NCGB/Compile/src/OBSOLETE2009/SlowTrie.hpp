// Mark Stankus 1999 (c)
// SlowTrie.h

#ifndef INCLUDED_SLOWTRIE_H
#define INCLUDED_SLOWTRIE_H

#include "Trie.hpp"
#include "Monomial.hpp"
#include "PrefixOrder.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <functional>
#include <map>
#include <set>
#else
#include <function.h>
#include <map.h>
#include <set.h>
#endif

class SlowTrie : public Trie {
  static void errorh(int);
  static void errorc(int);
/*
      is trie integer
      |
      |        is trie count
      |        |
      |        |
      |        |
*/
  class LocationStuff {
    LocationStuff();
    void operator=(const LocationStuff &);
  public:
    LocationStuff(int i,MonomialIterator w,Monomial m) 
              : d_i(i), d_w(w), d_m(m) {};
    int d_i;
    MonomialIterator d_w;
    const Monomial d_m;
  };
  typedef map<int,LocationStuff,less<int> > MAP;
  typedef set<Monomial,PrefixOrder> SET;
  int d_next_trie_location;
  list<Variable> d_relpath;
  MAP d_M;
  SET d_S;
  const Monomial & mono(const TrieLocation & x) const {
    if(!x.valid()) errorh(__LINE__);
    MAP::const_iterator f = d_M.find(x.num());
    if(f==d_M.end()) errorh(__LINE__); 
    return (*f).second.d_m; 
  };
  bool lastCount(const TrieLocation &) const;
  const MonomialIterator & moniter(const TrieLocation & x) const {
    if(!x.valid()) errorh(__LINE__);
    MAP::const_iterator f = d_M.find(x.num());
    if(f==d_M.end()) errorh(__LINE__); 
    return (*f).second.d_w; 
  };
  MonomialIterator & moniter(TrieLocation & x) {
    if(!x.valid()) errorh(__LINE__);
    MAP::iterator f = d_M.find(x.num());
    if(f==d_M.end()) errorh(__LINE__); 
    return (*f).second.d_w; 
  };
  int count(const TrieLocation & x) const {
    if(!x.valid()) errorh(__LINE__);
    MAP::const_iterator f = d_M.find(x.num());
    if(f==d_M.end()) errorh(__LINE__); 
    return (*f).second.d_i; 
  };
  int & count(TrieLocation & x) {
    if(!x.valid()) errorh(__LINE__);
    MAP::iterator f = d_M.find(x.num());
    if(f==d_M.end()) errorh(__LINE__); 
    return (*f).second.d_i; 
  };
  bool simpleForward(TrieLocation &,const Variable &);
  bool searchpath(TrieLocation &,const Variable &,const Monomial &);
public:
  SlowTrie(){};
  virtual ~SlowTrie();
  virtual bool findRoot(TrieLocation & x,const Variable & v);
  virtual bool isLeaf(const TrieLocation & L) const;
  virtual void incrementLocationCount(const TrieLocation &);
  virtual void decrementLocationCount(const TrieLocation &);
  virtual void addMonomial(const Monomial & m);
  virtual void addMonomial(const vector<Variable> & m);
  virtual void addMonomial(const list<Variable> & m);
  virtual bool findNext(TrieLocation & L,const Variable &) const;
};
#endif
