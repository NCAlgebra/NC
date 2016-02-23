// Mark Stankus 1999 (c)
// FunctionSource.c

#include "FunctionSource.hpp"
  
template<class IN,class OUT,class FUNC>
FunctionSource<IN,OUT,FUNC>::~FunctionSource() {};


template<class IN,class OUT,class FUNC>
bool FunctionSource<IN,OUT,FUNC>::getNext(OUT & p) {
  if(d_out.empty()) {
    IN in;
    while(d_in.getNext(in)) {
      if(d_out.empty()) break;
    };
  };
  bool result = !d_out.empty();
  if(result) {
    p = d_out.front();
    d_out.pop_front();
  };
  return result;
};

template<class IN,class OUT,class FUNC>
SetSource * FunctionSource<IN,OUT,FUNC>::clone() const {
  return FunctionSource(d_in,d_func);
};

template<class IN,class OUT,class FUNC>
void FunctionSource<IN,OUT,FUNC>::fillForUnknownReason() {
  d_in.fillForUnknownReason();
};
