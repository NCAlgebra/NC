// Field.h

#ifndef INCLUDED_FIELD_H
#define INCLUDED_FIELD_H

//#ifndef INCLUDED_RCOUNTEDPLOCKED_H
//#include "RCountedPLocked.hpp"
//#endif
//#ifndef INCLUDED_FIELDREP_H
//#include "FieldRep.hpp"
//#endif
class FieldRep;
class INTEGER;
class MyOstream;
class OutputVisitor;
class Sink;

class FieldImplementation;

class Field {
  FieldImplementation * d_impl_p;
#if 0
  RCountedPLocked<FieldRep> d_data;
#endif
public:
  Field();
  explicit Field(int n);
  explicit Field(const INTEGER & n);
  explicit Field(const INTEGER & num,const INTEGER & den);
  Field(const Field & f);
  ~Field();
  void assign(const Field & x) { operator=(x);};
  void assign(int x) { operator=(x);};
  void assign(long x) { operator=(x);};
  void assign(const INTEGER & top);
  void assign(const INTEGER & top, const INTEGER & bottom);
  INTEGER numerator() const;
  INTEGER denominator() const;
  void operator = (const Field & f);
  void operator = (const int & n);
  void operator = (const long & n);
  int sgn() const;
  bool operator == (const Field & f) const;
  bool less(const Field & f) const;
  bool isZero() const;
  bool isOne() const;
  Field operator -() const;
  int compareNumbers(const Field & x) const;
  bool operator<(const Field & f) const {
     return compareNumbers(f)>0;
  };
  bool zero() const;
  bool one() const;

  // Functions that change the object -- fast
  void setToZero();
  void setToOne();
  // Function changes object
  void invert(); 
  // basic math functions
  void operator +=(const int & i); 
  void operator -=(const int & i);
  void operator *=(const int & i);
  void operator /=(const int & i);
  Field operator +(const Field & f) const;
  Field operator -(const Field & f) const;
  Field operator *(const Field & f) const;
  Field operator /(const Field & f) const;
  void operator +=(const Field & f);
  void operator -=(const Field & f);
  void operator *=(const Field & f);
  void operator /=(const Field & f);
  const FieldRep & helper() const;
  const FieldRep & rep() const;
  FieldRep & rep();
  void print(OutputVisitor &) const;
  void print(MyOstream & os) const;
  void put(Sink &) const;
public:
  static const int * s_currentFieldNumber_p;
  static FieldRep * s_currentRep_p;
};

inline MyOstream & operator << (MyOstream & out,const Field & x) {
  x.print(out);
  return out;
};
#endif  
