// Match.h

#ifndef INCLUDED_GBMATCH_H
#define INCLUDED_GBMATCH_H
#define Match_h

#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
class MyOstream;

#define USE_COPY_MONOMIAL
#ifdef USE_COPY_MONOMIAL
#include "Copy.hpp"
#endif

class Match  {
public:
#ifdef USE_COPY_MONOMIAL
  Match() {
    d_left1.assign(new Monomial,Adopt::s_dummy);
    d_left2.assign(new Monomial,Adopt::s_dummy);
    d_right1.assign(new Monomial,Adopt::s_dummy);
    d_right2.assign(new Monomial,Adopt::s_dummy);
  };
#else
  Match() {
    Monomial x;
    d_left1 = x;
    d_left2 = x;
    d_right1 = x;
    d_right2 = x;
  };
#endif
  Match(const Match &);
  ~Match(){};
  void operator = (const Match &);

#ifdef USE_COPY_MONOMIAL
  typedef Copy<Monomial> M;
  const Monomial & const_left1() const { return d_left1();};
  const Monomial & const_left2() const { return d_left2();};
  const Monomial & const_right1() const { return d_right1();};
  const Monomial & const_right2() const { return d_right2();};
  Monomial & left1() { return d_left1.access();};
  Monomial & left2() { return d_left2.access();};
  Monomial & right1() { return d_right1.access();};
  Monomial & right2() { return d_right2.access();};
#else
  typedef Monomial M;
  const Monomial & const_left1() const { return d_left1;};
  const Monomial & const_left2() const { return d_left2;};
  const Monomial & const_right1() const { return d_right1;};
  const Monomial & const_right2() const { return d_right2;};
  Monomial & left1() { return d_left1;};
  Monomial & left2() { return d_left2;};
  Monomial & right1() { return d_right1;};
  Monomial & right2() { return d_right2;};
#endif
  bool subsetMatch,overlapMatch;
  int firstGBData,secondGBData;
  bool operator ==(const Match & x) const;
  bool operator !=(const Match & x) const;
  void InstanceToOStream(MyOstream & os) const;
private:
  M d_left1,d_right1,d_left2,d_right2;
};

inline MyOstream & operator << (MyOstream & os,const Match & x) { 
  x.InstanceToOStream(os); 
  return os;
};

inline bool Match::operator ==(const Match & x) const { 
  return d_left1==x.d_left1 && d_right1==x.d_right1 &&
         d_left2==x.d_left2 && d_right2==x.d_right2;
};

inline bool Match::operator !=(const Match & x) const {
  return ! (operator==(x));
};

inline Match::Match(const Match & x) {
  operator =(x);
};
#endif 
