// MyInteger.h

#ifndef INCLUDED_MYINTEGER_H
#define INCLUDED_MYINTEGER_H

class MyOstream;

#include "IntegerChoice.hpp"
#include "FieldChoice.hpp"

#ifdef USE_MyInteger
#include "GNUInteger.hpp"

class MyInteger {
  Integer d_i;
public:
  // Constructors
  inline MyInteger() : d_i(){};
  explicit inline MyInteger(int n) : d_i(n) {};
  explicit inline MyInteger(long n) : d_i(n) {};
  inline MyInteger(const MyInteger & x) : d_i(x.d_i) {};
  explicit inline MyInteger(const Integer & x) : d_i(x) {};
  ~MyInteger(){};
  void operator = (const MyInteger & x) { d_i = x.d_i;};
  void operator = (int i) { d_i = i;};

  bool needsParenthesis() const { return false;}

  friend MyOstream & operator << (MyOstream & os,const MyInteger &);

  void setToOne() { d_i = 1;}
  void setToZero() { d_i = 0;};

  bool operator ==(const MyInteger & x) { return d_i==x.d_i;};
  bool operator !=(const MyInteger & x) { return !(d_i==x.d_i);};

  // Overloaded operators
  void operator += (const MyInteger & x) { d_i += x.d_i;}
  void operator -= (const MyInteger & x) { d_i -= x.d_i;}
  void operator *= (const MyInteger & x) { d_i *= x.d_i;};
  void operator /= (const MyInteger & x) { d_i /= x.d_i;};

  MyInteger operator - () const { 
    Integer u = - d_i;
    return MyInteger(u);
  };
  MyInteger operator + (const MyInteger & x) const { 
     return MyInteger(d_i+x.d_i);
  };
  MyInteger operator - (const MyInteger & x) const { 
     return MyInteger(d_i-x.d_i);
  };
  MyInteger operator * (const MyInteger & x) const {
     return MyInteger(d_i*x.d_i);
  };
  MyInteger operator / (const MyInteger & x) const {
     return MyInteger(d_i/x.d_i);
  };

  bool zero() const { return d_i==0;}
  bool one() const { return d_i==1;};
  
  int sgn() const { return d_i>0 ? 1 : (d_i==0 ? 0 : -1);}

  MyInteger compareNumbers(const MyInteger & x) const {
    return MyInteger(d_i-x.d_i);
  }
  bool operator == (const MyInteger & x) const { 
    return d_i==x.d_i;
  };

  int asInt() const { return (int) lg(d_i);};

  const Integer & internal() const { return d_i;}
  static void gcds(int yn);
  static int gcds();
private:
  static bool s_gcds;
};

inline void MyInteger::gcds(int yn) {
  s_gcds = yn;
};

inline int MyInteger::gcds() {
  return s_gcds;
};         
#endif
#endif
