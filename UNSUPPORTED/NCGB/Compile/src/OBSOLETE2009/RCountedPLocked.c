// RCountedPLocked.c

#include "RCountedPLocked.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

template<class T>
void RCountedPLocked<T>::printMessage() const {
  GBStream << "Not deleting for numbers " << d_data_p 
           << " which has a count of " << *d_refcnt_p << '\n';
}
