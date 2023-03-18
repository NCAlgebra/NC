// Mark Stankus 1999 (c)
// Location.hpp

#ifndef INCLUDED_LOCATION_H
#define INCLUDED_LOCATION_H

#include "TrieNode.hpp"
#include "Monomial.hpp"
#include "MyOstream.hpp"

struct Location {
  static void errorh(int);
  static void errorc(int);
  TrieNode * d_node_p;
  MonomialIterator d_w;
  int d_i;
public:
  Location(TrieNode * node_p,MonomialIterator w,int i) :
     d_node_p(node_p), d_w(w), d_i(i) {};
  ~Location() {};
  Location(const Location & x) { operator=(x);};
  void operator=(const Location & x) {
    d_node_p = d_node_p;
    d_w = d_w;
    d_i = d_i;
  };
  void increment() { ++d_w;++d_i;};
  void addSubword(TrieNode * p) {
    if(d_subword) DBG();
    d_subword = p;
  };
  void clear() {
    d_subword = 0;
  };
  void print(MyOstream& os) const {
    os << "monomial:" << d_node_p->d_m << " at variable "
       << *d_w << " which is in spot " << d_i << '\n';
  };
};
#endif
