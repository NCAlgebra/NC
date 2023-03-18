// tRational.h

#ifndef INCLUDED_TRATIONAL_H
#define INCLUDED_TRATIONAL_H

#include "FieldRep.hpp" 
#include "Choice.hpp" 
#ifdef USE_VIRT_FIELD

template<class T> 
class tRational : public FieldRep {
public:
  tRational();
  tRational(const tRational & RightSide);
  explicit tRational(int);
  explicit tRational(long);
#ifdef USE_UNIX
  explicit tRational(long long);
#endif
  explicit tRational(long,long);
  explicit tRational(const T &);
  explicit tRational(const T & top, const T & bottom);
  virtual ~tRational();
  void operator = (const tRational & aQuotient);
  
  int nvSgn() const;
  
  void operator = (const T & aT);
  bool operator == (const tRational & aQuotient) const;
  bool operator != (const tRational & aQuotient) const;
  
  friend MyOstream & operator << (MyOstream & out,const tRational<T> & x);
  inline void nvSetToZero();
  bool zero() const;
  bool one() const;
  void nvInvert();
  
  // basic math functions
  tRational operator - () const;
  tRational operator + (const tRational &) const;
  tRational operator + (const T &) const;
  tRational operator - (const tRational &) const;
  tRational operator - (const T &) const;
  tRational operator * (const tRational &) const;
  tRational operator * (const T &) const;
  tRational operator / (const tRational &) const;
  tRational operator / (const T &) const;
  void operator +=(const tRational &);
  void operator +=(const T &);
  void operator -=(const tRational &);
  void operator -=(const T &);
  void operator *=(const tRational &);
  void operator *=(const T &);
  void operator /=(const tRational &);
  void operator /=(const T &);
  
  const T & numerator() const;
  const T & denominator() const;
  void  normalize();
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
private:
  T _numerator;
  T _denominator;
};

template<class T>
inline const T & tRational<T>::numerator() const {
  return _numerator;
};

template<class T>
inline const T & tRational<T>::denominator() const {
  return _denominator;
};

template<class T>
inline tRational<T>::tRational() : FieldRep(s_ID) {
  setToZero();
};

template<class T>
inline tRational<T>::tRational(const T & top,const T & bottom) :
  FieldRep(s_ID), _numerator(top), _denominator(bottom) {
  normalize();
};

template<class T>
inline tRational<T>::tRational(const T & top) : FieldRep(s_ID) {
  _numerator = top;
  _denominator.setToOne();
};

template<class T>
inline tRational<T>::tRational(const tRational & RightSide) : FieldRep(s_ID) {
  _numerator = RightSide._numerator;
  _denominator = RightSide._denominator;
};

template<class T>
inline bool tRational<T>::zero() const {
  return _numerator.zero();
};

template<class T>
inline bool tRational<T>::one() const {
  return _numerator==_denominator;
};

template<class T>
inline void tRational<T>::nvSetToZero() {
  _numerator.setToZero();
  _denominator.setToOne();
};

template<class T>
inline void tRational<T>::nvInvert() {
  T temp;
  temp = _numerator;
  _numerator = _denominator;
  _denominator = temp;
};

template<class T>
inline tRational<T> tRational<T>::operator * (const T  & aT) const {
  tRational newQuot(aT);
  return ((*this) * newQuot);
};

template<class T>
inline tRational<T> tRational<T>::operator / (const T & aT) const {
  tRational newQuot(aT);
  return ((*this) / newQuot);
};

template<class T>
inline void tRational<T>::operator = (const tRational & RightSide) {
  _numerator = RightSide._numerator;
  _denominator = RightSide._denominator;
};

template<class T>
inline void tRational<T>::operator = (const T & RightSide) {
  _numerator = RightSide;
  _denominator.setToOne();
};

template<class T>
inline int tRational<T>::nvSgn() const { 
  return _numerator.sgn()*_denominator.sgn();
};

template<class T>
inline bool tRational<T>::operator == (const tRational & x) const { 
  return compareNumbers(x)==0;
};

template<class T>
inline bool tRational<T>::operator !=(const tRational & x) const { 
  return compareNumbers(x)!=0;
};

template<class T>
inline tRational<T> tRational<T>::operator - () const { 
  return tRational(-_numerator, _denominator); 
};
#endif  
#endif  
