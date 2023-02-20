// ncgbadvance.h

#ifndef INCLUDED_NCGBADVANCE_H
#define INCLUDED_NCGBADVANCE_H

#include "GBList.hpp"

template<class T>
void ncgbadvance(T * & w,int i) {
  w += i;
};

template<class T>
void ncgbadvance(T & w,int i) {
  for(int j=1;j<=i;++j,++w) {};
};
#endif
