// (c) Mark Stankus 1999
//  CntSource.h

#ifndef INCLUDED_CNTSOURCE_H
#define INCLUDED_CNTSOURCE_H

#include "SetSource.hpp"
#include "ICopy.hpp"

template<class TYPE,class REGENERATE>
class CntSource : public SetSource<TYPE> {
  int d_count;
  ICopy<SetSource<TYPE> > d_src;
  REGENERATE & d_regen;
public:
  CntSource(int count,const ICopy<SetSource<TYPE> > & src,REGENERATE & regen) : 
     d_count(count), d_src(src), d_regen(regen){};
  virtual ~CntSource();
  virtual bool getNext(TYPE & p);
  virtual SetSource<TYPE> * clone() const;
  virtual void fillForUnknownReason();
};
#endif
