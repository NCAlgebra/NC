// Mark Stankus 1999 (c)
// CartesianSource.c 

#include "CartesianSource.hpp" 
#include "Debug1.hpp" 

template<class T,class U>
void CartesianSource<T,U>::advance() {
  ++d_place1;
  if(d_place1==-1) {
    DBG();
  } else if(d_place1==d_sz1) {
    d_place1 = 0;
    ++d_place2;
    if(d_place2==d_sz2) { 
      d_place1 = -1;
      d_place2 = -1;
    };
  };
};

template<class T,class U>
CartesianSource<T,U>::~CartesianSource() {};

template<class T,class U>
bool CartesianSource<T,U>::getNext(pair<T,U> & x) {
  bool result = d_place1!=-1;
  if(result) {
    x.first = d_first[d_place1];
    x.second = d_second[d_place2];
    advance();
  };
  return result;
};
 
template<class T,class U> 
SetSource<pair<T,U> > * CartesianSource<T,U>::clone() const {
  CartesianSource * result = new CartesianSource(d_first,d_second);
  return result; 
};

template<class T,class U> 
void CartesianSource<T,U>::fillForUnknownReason() {};

template class CartesianSource<int,int>;
