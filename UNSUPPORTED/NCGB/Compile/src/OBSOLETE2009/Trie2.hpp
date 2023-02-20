
#include "Monomial.hpp"
#include "Variable.hpp"
#include "Location.hpp"
#include <map>

class Trie {
  map<Variable,Location> d_roots;
  void lookForLeafs(MonomialIterator w,MonomialIterator e,Filter & filter) {
    Variable v;
    bool go = true;
    MAPTWO::iterator f;
    while(w!=e&&go) {
      v = *w;
      f = d_roots.find(v);
      if(f==d_roots.end()) {
        ++w;
      } else { 
        go = lookForLeafs((*f).second,w,e,filter);
      }; 
    };
  };
