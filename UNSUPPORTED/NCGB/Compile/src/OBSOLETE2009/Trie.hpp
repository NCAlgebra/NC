// Mark Stankus 1999 (c)
// Trie.h

#ifndef INCLUDED_TRIE_H
#define INCLUDED_TRIE_H

class Trie;
#include "Variable.hpp"
#include "Monomial.hpp"

class TrieLocation {
  Trie * d_owner;
  int d_i;
public:
  TrieLocation() : d_owner(0), d_i(-1) {};
  TrieLocation(Trie * owner,int i) : d_owner(owner), d_i(i) {};
  TrieLocation(const TrieLocation & x) : d_owner(x.d_owner), d_i(x.d_i) {};
  void operator=(const TrieLocation & x);
  ~TrieLocation() {
    if(!d_owner) removeOwner();
  };
  inline void removeOwner();
  int num() const { return d_i;};
  bool valid() const { return d_i!=-1;};
};

class Trie {
protected:
  Trie(){};
public:
  virtual ~Trie();

  virtual bool findRoot(TrieLocation & x,const Variable & v) = 0;
  virtual bool isLeaf(const TrieLocation & L) const = 0;
  virtual void incrementLocationCount(const TrieLocation &) = 0;
  virtual void decrementLocationCount(const TrieLocation &) = 0;
  virtual void addMonomial(const Monomial & m) = 0;
  virtual void addMonomial(const vector<Variable> & m) = 0;
  virtual void addMonomial(const list<Variable> & m) = 0;
  virtual bool findNext(TrieLocation & L,const Variable &) const = 0;

  void lookForLeafs(MonomialIterator w,MonomialIterator e) {
    TrieLocation L;
    Variable v;
    bool go = true;
    while(w!=e&&go) {
      v = *w;
      if(findRoot(L,v)) {
        ++w;
      } else {
        go = lookForLeafs(L,w,e);
      };
    };
  };
  bool lookForLeafs(TrieLocation L,MonomialIterator & w,MonomialIterator e) {
    bool result = true;
    while(w!=e) {
     if(isLeaf(L)) {
       result = false;
       break;
     };
     ++w;
     if(!findNext(L,*w)) break;
    };
    return result;
  };
};

inline void TrieLocation::operator=(const TrieLocation & x) {
  if(!d_owner) removeOwner();
  d_owner=x.d_owner;
  d_i=x.d_i;
  d_owner->incrementLocationCount(*this);
};

inline void TrieLocation::removeOwner() {
  d_owner->decrementLocationCount(*this);
  d_owner = 0;
  d_i = 0;
};
#endif

