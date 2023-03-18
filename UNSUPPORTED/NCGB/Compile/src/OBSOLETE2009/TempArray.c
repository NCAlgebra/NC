// TempArray.c

#include "TempArray.hpp"

template<class T>
TempArray<T>::~TempArray() { 
  delete [] d_p;
};
