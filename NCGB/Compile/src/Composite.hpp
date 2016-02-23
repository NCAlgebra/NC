// Composite.h

#ifndef INCLUDED_COMPOSITE_H
#define INCLUDED_COMPOSITE_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
class Source;
#include "Sink.hpp"
#include "symbolGB.hpp"
#include "Polynomial.hpp"
#include "simpleString.hpp"
#include "RecordHere.hpp"

using namespace std;

class Composite {
  static simpleString s_invalid;
  simpleString d_head;
  vector<Polynomial> * d_list_p;
public:
  Composite() : d_head(s_invalid), d_list_p((vector<Polynomial> *) 0) {};
  Composite(const char * const s,vector<Polynomial> & L) : d_head(s), d_list_p(0) {
    RECORDHERE(d_list_p = new vector<Polynomial>;)
    *d_list_p = L;
  };
  Composite(const char * const s) : d_head(s), d_list_p((vector<Polynomial> *) 0) {};
  Composite(const Composite & x) : d_head(x.d_head), 
     d_list_p((vector<Polynomial> *) 0) {
     if(x.d_list_p) {
       RECORDHERE(d_list_p = new vector<Polynomial>;)
       *d_list_p = *(x.d_list_p);
     };
  };
  void operator=(const Composite & x) {
    if(this!=&x) {
      d_head=x.d_head; 
      if(d_list_p) {
        RECORDHERE(delete d_list_p;)
        d_list_p = (vector<Polynomial> *) 0;
      };
      if(x.d_list_p) {
        RECORDHERE(d_list_p = new vector<Polynomial>;)
        *d_list_p = *(x.d_list_p);
      }
    }
  };
  ~Composite() {
    if(d_list_p) {
      RECORDHERE(delete d_list_p;)
      d_list_p = (vector<Polynomial> *) 0;
    };
  };
  void put(Sink & sink) const {
    if(d_list_p) {
      const int sz = d_list_p->size();
      vector<Polynomial>::const_iterator w = d_list_p->begin();
      Sink sink2(sink.outputFunction(d_head.chars(),sz));
      for(int i=1;i<=sz;++i,++w) {
        sink2 << *w;
      };
    } else {
     symbolGB x(d_head.chars());
     sink << x;
    };
  };
};

Composite GetComposite(Source &);
#endif
