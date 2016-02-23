// ConstTempArray.c

#include "ConstTempArray.hpp"

template<class T>
ConstTempArray<T>::~ConstTempArray() { 
  delete [] d_p;
};
