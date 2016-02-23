// triple.h

#ifndef INCLUDED_TRIPLE_H
#define INCLUDED_TRIPLE_H

template<class A,class B,class C> 
class triple {
public:
  triple(const A & a,const B & b,const C & c) : first(a), second(b),
             third(c) {};
  triple(const triple<A,B,C> & x) : first(x.first), second(x.second),
     third(x.third) {};
  void operator=(const triple<A,B,C> & x) {
    first = x.first;
    second = x.second;
    third = x.third;
  };
  bool operator==(const triple<A,B,C> & x) const {
    return first==x.first && second==x.second && third==x.third;
  };
  bool operator!=(const triple<A,B,C> & x) const {
    return !(first==x.first && second==x.second && third==x.third);
  };
  A first;
  B second;
  C third;
};
  

#endif
