// Mark Stankus 1999 (c)
// FunctionSource.h

#ifndef INCLUDED_FUNCTIONSOURCE_H
#define INCLUDED_FUNCTIONSOURCE_H

#include "SetSource.hpp"

template<class IN,class OUT,class FUNC>
class FunctionSource : public SetSource<OUT> {
  ICopy<SetSource<IN> > d_in;
  FUNC d_func;
  list<OUT> d_out;
public:
  FunctionSource(const ICopy<SetSource<IN> > & in,FUNC func) : 
         d_in(in), d_func(func){};
  virtual ~FunctionSource();
  virtual bool getNext(OUT & p);
  virtual SetSource * clone() const;
  virtual void fillForUnknownReason();
};
#endif
