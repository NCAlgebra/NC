// NRAList.c

#include "NRAList.hpp"
#include "MyOstream.hpp"

template<class T>
void RAList<T>::check(int n) const {
  list<T>::const_iterator f = _holes.find(n);
  if(f!=_holes.end()) {
     GBStream << "An attempt was made to access a hole in an RAList.\n";
     GBStream <<  "Did you try to access a marker which was destroyed?\n";
     GBStream << "It was marker number: " << n << " of unknown type (sorry).\n";
     DBG();
  }
  if(n<1 || n>d_items.size()) {
    GBStream << "Tried to access a marker number out of range.\n";
    GBStream << "The number was " << n << '\n';
    DBG();
  }
};
