// GMPField.hpp
// Mark Stankus (c) Tue Jul  7 15:19:58 PDT 2009

#ifndef INCLUDED_GMPFIELD_H
#define INCLUDED_GMPFIELD_H

#include <gmpxx.h>
#include <gmp.h>
#include "Debug1.hpp"
#include "AltInteger.hpp"
class MyOstream;
class Sink;

class Field { 
  mpq_class d_f;
public:
  Field() : d_f(0){};
  Field(int x) : d_f(x){};
  Field(int x,int y) : d_f(x){ d_f /= y;};
  Field(const Field & f) : d_f(f.d_f){};
  Field(const mpq_class & f) : d_f(f){};
  ~Field() {};
  void operator=(const Field & x) { d_f = x.d_f;};
  void operator=(int x) { d_f = x;};
  void assign(int x) { d_f= x;};
  void assign(long x) { d_f= x;};
  void assign(const Field & x) { d_f= x.d_f;};
  void setToZero() { d_f = 0.0;}
  void setToOne()  { d_f = 1.0;}
  int sgn() const { 
    if(d_f<0) { return -1;} else if (d_f==0.0) { return 0;};
    return 1;
  }; 
  bool operator==(const Field & x) const {
    return d_f==x.d_f;
  };
  bool operator!=(const Field & x) const { return d_f!=x.d_f;}

  Field operator - () const { Field f(d_f); f.d_f *= -1; return f;}

  void invert() { d_f = 1/d_f;};
  void operator+=(const Field & x) { d_f += x.d_f; };
  void operator-=(const Field & x) { d_f -= x.d_f; };
  void operator*=(const Field & x) { d_f *= x.d_f; };
  void operator/=(const Field & x) { d_f /= x.d_f; };
  Field operator+(const Field & x) { Field f(*this);f += x; return f;};
  Field operator-(const Field & x) { Field f(*this);f -= x; return f;};
  Field operator*(const Field & x) { Field f(*this);f *= x; return f;};
  Field operator/(const Field & x) { Field f(*this);f /= x; return f;};
  bool isZero() const { return d_f==0;};
  bool isOne() const { return d_f==1;}
  bool zero() const { return d_f==0;};
  bool one() const { return d_f==1;}
  friend MyOstream & operator<<(MyOstream & os,const Field & x) { 
    x.print(os); return os;
  }; 
  INTEGER numerator() const { return INTEGER(d_f.get_num().get_si());};
  INTEGER denominator() const { return INTEGER(d_f.get_den().get_si());};
  void print(MyOstream & os) const;
  void put(Sink &) const;
  /* added by Mauricio, Nov 09 */
  const std::string str() const { return d_f.get_str(); }
};
#endif
