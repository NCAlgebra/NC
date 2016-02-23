// PointerCompare.h

#ifndef INCLUDED_POINTERCOMPARE_H 
#define INCLUDED_POINTERCOMPARE_H 

template<class T>
struct PointerCompare {
  bool operator()(T * p,T * q) const {
    return p<q;
  };
};
#endif
