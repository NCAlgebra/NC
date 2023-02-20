// BaGBListIterator.c

#include "BaGBListIterator.hpp"
#include "ListChoice.hpp"
#ifdef USE_OLD_GBLIST
#include "MyOstream.hpp"

BaGBListIterator::~BaGBListIterator(){};

MyOstream & operator <<(MyOstream & os,
                      const BaGBListIterator & iter) {
  os << iter._p;
#ifdef DEBUGGBListIterator
  os << ' ' << iter._ptr->length();
#endif
  os << '\n'; 
  return os;
};

void BaGBListIterator::advance(int n) { 
  for(int i=1;i<=n;++i) {
    if(_p==0) {
      GBStream << "Tried to increment the zero pix\n";
      DBG();
    };
    _ptr->next(_p);
  }
#ifdef DEBUGGBListIterator
  _n += n;
  if(_n>_ptr->length()+1) {
    GBStream << _n << "\n";
    GBStream << _ptr->length()+1 << "\n";
    DBG();
  }
#endif
};

void BaGBListIterator::error1() const {
    GBStream << "Tried to increment the zero pix\n";
    DBG();
};
#endif
