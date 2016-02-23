// Mark Stankus 1999 (c)
// SlowTrie.cpp


#include "SlowTrie.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <functional>
#else
#include <function.h>
#endif

SlowTrie::~SlowTrie() {};

bool SlowTrie::findRoot(TrieLocation & x,const Variable & v) {
  bool result = false;
  SET::const_iterator w = d_S.begin(), e = d_S.end(); 
  while(w!=e) {
    if(*((*w).begin())==v) {
      TrieLocation place(this,d_next_trie_location);
      ++d_next_trie_location;
      DBG();
      result = true;
      break;
    };
    ++w;
  };
  return result;
};

bool SlowTrie::isLeaf(const TrieLocation & x) const {
  if(!x.valid()) errorc(__LINE__);
  bool result = true;
#if 0
  Monomial m(mono(x));
  if(!simpleForward(x,v)) {
    while(!d_relpath.empty()) {
      if(searchpath(x,m)) {
        break;
      } else {
        d_relpath.erase(d_relpath.begin());
      };
    };
    result = !d_relpath.empty();
  };
#endif
  return result;
};

bool SlowTrie::simpleForward(TrieLocation & x,const Variable & v) {
  bool result = false;
  if(lastCount(x)!=count(x)) {
    ++count(x);
    ++moniter(x);
    if(*moninter(x)==v) {
      d_relpath.push_back(v);
      result = true;
    } else {
      remove(x);
    };
  };
  return result;
};

bool SlowTrie::searchpath(TrieLocation & x,
           const Variable & v,const Monomial & mono) {
  SET::const_iterator f = d_S.find(mon), e = d_S.end();
  if(f==e) errorc(__LINE__);
  ++f;
  bool result = false;
  Variable first(*mono.begin());
  if(f!=e) {
    if(*(*f).begin()!=first) {
      if(findRoot(x,first)) {
         f = d_S.find(mono);
      };
    };
  };
  while(f!=e) {
    result = true;
    const Monomial & it = *f;
    if(*it.begin()==first && it.numberOfFactors()>d_relpath.size()) {
      typedef list<Variable>::const_iterator LI;
      LI wL = d_relpath.begin(), eL = d_relpath.end();
      MonomialIterator wTry = it.begin();
      while(wL!=eL) {
        if(*wL!=wTry) {
          result = false;
          break;
        }; 
        ++wL;++wTry;
      };
      if(result) {
        result = *wTry==v;
      };
      if(result) {
        // set location
        errorc(__LINE__);
        break;
      };
    }; // if
    ++f;
  }; // while(f!=e) 
};

void SlowTrie::incrementLocationCount(const TrieLocation &);

void SlowTrie::decrementLocationCount(const TrieLocation &);

void SlowTrie::addMonomial(const Monomial & m) {
  d_S.insert(S);
};

void SlowTrie::addMonomial(const vector<Variable> & m) {
};
void SlowTrie::addMonomial(const list<Variable> & m) {
};
bool SlowTrie::findNext(TrieLocation & L,const Variable &) const {
};

void SlowTrie::errorh(int n) { DBGH(n); };

void SlowTrie::errorc(int n) { DBGC(n); };
