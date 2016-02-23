// StringImpl.h

#ifndef INCLUDED_STRINGIMPL_H
#define INCLUDED_STRINGIMPL_H

#include "Hashable.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

struct StringImpl {
  static vector<Hashable *> s_hashes;
  int d_place;
  int d_hash;
  StringImpl() :  d_place(-999), d_hash(-999) {};
  StringImpl(const StringImpl & x) :  d_place(x.d_place), 
     d_hash(x.d_hash) {};
  ~StringImpl() {};
  void operator=(const StringImpl & x) {
    d_hash = x.d_hash;
    d_place = x.d_place;
  };
  void operator=(const char * s) {
    d_hash = -999;
    d_place = -999;
    typedef vector<Hashable *>::const_iterator VI;
    VI w = s_hashes.begin(),e = s_hashes.end();
    int i = 0;
    while(w!=e) {
      Hashable & xx = **w;
      if(xx.Hash(s,d_hash)) {
        d_place = i;
        break;
      };
      ++w;++i;
    };
  };
  char * value(int & len) {
    return s_hashes[d_place]->HashString(d_hash,len);
  };
  bool operator ==(const StringImpl & x) const {
    return d_place==x.d_place && d_hash==x.d_hash;
  };
};
#endif
