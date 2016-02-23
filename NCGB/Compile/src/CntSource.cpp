// (c) Mark Stankus 1999
//  CntSource.c

#include "CntSource.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"

template<class TYPE,class REGEN>
CntSource<TYPE,REGEN>::~CntSource(){};

template<class TYPE,class REGEN>
bool CntSource<TYPE,REGEN>::getNext(TYPE & p) {
  bool b = d_src.access().getNext(p);
  return b;
};

template<class TYPE,class REGEN>
SetSource<TYPE> * CntSource<TYPE,REGEN>::clone() const {
  return new CntSource<TYPE,REGEN>(d_count,d_src,d_regen);
};

template<class TYPE,class REGEN>
void CntSource<TYPE,REGEN>::fillForUnknownReason() {
  if(d_count>0) {
    d_src = d_regen();
    --d_count;
  };
};
