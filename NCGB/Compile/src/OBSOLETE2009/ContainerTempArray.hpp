// ContainerTempArray.h

#ifndef INCLUDED_CONTAINERTEMPARRAY_H
#define INCLUDED_CONTAINERTEMPARRAY_H

template<class T,class CONT>
class ContainerTempArray : public TempArray {
  ContainerTempArray(CONT & c) : TempArray(c.size()) {
    CONT::const_iterator w = c.begin();
    CONT::const_iterator e = c.end();
    T * * q = d_pp;
    while(w!=e) {
      *q = *w;
      ++w;++q;
    };
  };
  ~ContainerTempArray();
};
#endif
