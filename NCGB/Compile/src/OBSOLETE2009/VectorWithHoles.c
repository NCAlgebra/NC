// VectorWithHoles.c

#include "VectorWithHoles.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

template<class T>
void VectorWithHoles<T>::check(int n) const {
  vector<int>::const_iterator w = d_holes.begin();
  vector<int>::const_iterator e = d_holes.end();
  if(find(w,e,n)==e) {
     GBStream << "An attempt was made to access a hole in an RAList.\n";
     GBStream <<  "Did you try to access a marker which was destroyed?\n";
     GBStream << "It was marker number: " << n << " of unknown type (sorry).\n";
     DBG();
  }
  if(n<0 || n>=(int)d_items.size()) {
    GBStream << "Tried to access a marker number out of range.\n";
    GBStream << "The number was " << n << '\n';
    DBG();
  }
};
