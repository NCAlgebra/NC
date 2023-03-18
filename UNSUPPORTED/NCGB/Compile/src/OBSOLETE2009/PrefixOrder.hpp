// Mark Stankus 1999 (c)
// PrefixOrder.hpp

#include "Monomial.hpp"

struct PrefixOrder {
  bool operator()(const Monomial & m,const Monomial & n) const {
    bool result = false;
    const int msz = m.numberOfFactors();
    const int nsz = n.numberOfFactors();
    int mcnt = msz, ncnt = nsz; 
    MonomialIterator mw = m.begin();
    MonomialIterator nw = n.begin();
    while(mcnt>0 && ncnt>0) {
      if(*mw!=*nw) break;
      --mcnt;--ncnt;++mw;++nw;
    };
    if(mcnt==0) {
      result = ncnt>0;
    } else if(ncnt==0) {
      result = false;
    } else {
      result = (*mw).stringNumber() < (*nw).stringNumber();
    };
    return result;
  };
};
