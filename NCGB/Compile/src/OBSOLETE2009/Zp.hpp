// Zp.h

#ifndef INCLUDED_ZP_H
#define INCLUDED_ZP_H

#include "FieldRep.hpp" 
//#pragma warning(disable:4786)
#include <vector> 
#ifdef USE_VIRT_FIELD
#include "vcpp.hpp"

class Zp : public FieldRep {
  static int s_characteristic;
  static vector<int> s_reciprocal;
  int d_value;
  static int s_one;
public:
  Zp() : FieldRep(s_ID), d_value(0) {};
  Zp(const Zp & x) : FieldRep(s_ID), d_value(x.d_value) { checkCharacteristic(x);} ;
  explicit Zp(int x) : FieldRep(s_ID), d_value(x) { normalize();};
  virtual ~Zp();
  void operator = (const Zp & x) { d_value = x.d_value;};

  int value() const { return d_value;};
  static int s_Characteristic() { return s_characteristic;};

  void checkCharacteristic(const Zp &) const;
  int reciprocal(int) const;
  void normalize() { d_value %= s_characteristic;};

  static void s_setCharacteristic(int i);

  int nvSgn() const { return d_value==0 ? 0 : 1 ;};

  void operator = (const int & x) { d_value=(x%s_characteristic);};
  bool operator == (const Zp & x) const { return d_value==x.d_value;};
  bool operator != (const Zp & x) const { return d_value!=x.d_value;};

  friend MyOstream & operator << (MyOstream & out,const Zp & x);
  bool zero() const { return d_value==0;};
  bool one() const { return d_value==1;};
  void nvInvert() { d_value = reciprocal(d_value);};

  // basic math functions
  Zp operator - () const {
    Zp result;
    result.d_value = d_value==0 ? 0 : s_characteristic-d_value;
    return result; 
  };
  Zp operator + (const Zp & x) const { 
    Zp result(*this);
    result.d_value += x.d_value;
    result.normalize();
    return result; 
  };
  Zp operator + (const int & x) const {
    Zp result(*this);
    result.d_value += x;
    result.normalize();
    return result; 
  };
  Zp operator - (const Zp & x) const {
    Zp result(*this);
    result.d_value -= x.d_value;
    result.normalize();
    return result; 
  };
  Zp operator - (const int & x) const {
    Zp result(*this);
    result.d_value -= x;
    result.normalize();
    return result; 
  };
  Zp operator * (const Zp & x) const {
    Zp result(*this);
    result.d_value *= x.d_value;
    result.normalize();
    return result; 
  };
  Zp operator * (const int & x) const {
    Zp result(*this);
    result.d_value *= x;
    result.normalize();
    return result; 
  };
  Zp operator / (const Zp & x) const {
    Zp result(*this);
    result.d_value *= reciprocal(x.d_value);
    result.normalize();
    return result; 
  };
  Zp operator / (const int & x) const {
    Zp result(*this);
    result.d_value *= reciprocal(x);
    result.normalize();
    return result; 
  };
  void operator +=(const Zp & x) {
    d_value += x.d_value;
    normalize();
  };
  void operator +=(const int & x) {
    d_value += x;
    normalize();
  };
  void operator -=(const Zp & x) {
    d_value -= x.d_value;
    normalize();
  };
  void operator -=(const int & x) {
    d_value -= x;
    normalize();
  };
  void operator *=(const Zp & x) {
    d_value *= x.d_value;
    normalize();
  };
  void operator *=(const int & x) {
    d_value *= x;
    normalize();
  };
  void operator /=(const Zp & x) {
    d_value *= reciprocal(x.d_value);
    normalize();
  };
  void operator /=(const int & x) {
    d_value *= reciprocal(x);
    normalize();
  };

  virtual  FieldRep * make(int n);
  virtual  FieldRep * make(const FieldRep &);
  virtual FieldRep * clone()  const;
  virtual void setToZero();
  virtual void setToOne();
  virtual int sgn() const;
  virtual void initialize(int);
  virtual void initialize(const FieldRep &);
  virtual bool equal(const FieldRep &) const;
  virtual bool less(const FieldRep &) const;
  virtual int compareNumbers(const FieldRep &) const;
  virtual void invert();
  virtual void add(int);
  virtual void add(const FieldRep &);
  virtual void subtract(int);
  virtual void subtract(const FieldRep &);
  virtual void times(int);
  virtual void times(const FieldRep &);
  virtual void divide(int);
  virtual void divide(const FieldRep &);
  virtual bool isZero() const;
  virtual bool isOne() const;
  virtual void print(MyOstream &) const;
  virtual void print(OutputVisitor &) const;
  virtual void put(Sink & ioh) const;
  static int s_ID;
};
#endif  
#endif  
