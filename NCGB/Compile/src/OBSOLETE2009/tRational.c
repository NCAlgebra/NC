// tRational.c

#include "tRational.hpp"
#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "OutputVisitor.hpp"
#include "RecordHere.hpp"
#include "MyOstream.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "AsciiOutputVisitor.hpp"

template<class T>
tRational<T>::tRational(int m) : FieldRep(s_ID), _numerator(m), 
      _denominator(1) {};

template<class T>
tRational<T>::tRational(long m) : FieldRep(s_ID), _numerator(m), 
      _denominator(1) {};

#ifdef USE_UNIX
template<class T>
tRational<T>::tRational(long long m) : FieldRep(s_ID), _numerator((long)m), 
      _denominator(1) {};
#endif

template<class T>
tRational<T>::tRational(long m,long n) : FieldRep(s_ID), _numerator(m), 
      _denominator(n) { normalize();};

template<class T>
tRational<T>::~tRational(){};

template<class T>
int tRational<T>::compareNumbers(const FieldRep & Right) const {
  const tRational<T> & y = (const tRational<T> &) Right;
  int Result;
  if (this == &Right) {
    Result = 0;      //  Check if they are copies
  } else {
    int s1 = _numerator.sgn()*y._numerator.sgn();
    int s2 = _denominator.sgn()*y._denominator.sgn();

    // Check that numerators agree up to sign
    if(s1<0) {
      Result = _numerator.compareNumbers(-y._numerator).asInt();
    } else {
      Result = _numerator.compareNumbers(y._numerator).asInt();
    }

    // If numerators check out and signs check out, check denominator
    if(Result==0 && s1==s2 && s1!=0) {
      if(s2<0) {
        Result = _denominator.compareNumbers(-y._denominator).asInt();
      } else {
        Result = _denominator.compareNumbers(y._denominator).asInt();
      }
    }  
  }
  return Result;
}

template<class T>
tRational<T> tRational<T>::operator * (const tRational<T> & aQuotient) const {
//GBStream << "Multiplying " << * this << " by " << aQuotient << '\n';
  T top;
  top = _numerator * aQuotient._numerator; 
  T bot;
  bot = aQuotient._denominator * _denominator;
  tRational<T> newQuot(top,bot);
//GBStream << "The answer is " << newQuot << '\n';
  return newQuot;
};

template<class T>
tRational<T> tRational<T>::operator / (const tRational<T> & aQuotient) const {
   T top;
   top = aQuotient._denominator * _numerator;
   T bot; 
   bot = aQuotient._numerator * _denominator;
   tRational<T> newQuot(top,bot);
   return newQuot;
};

template<class T>
tRational<T> tRational<T>::operator + (
     const tRational<T> & aQuotient) const {
  T top;
  top = (aQuotient._numerator * _denominator) +
        (aQuotient._denominator * _numerator);
  T bottom;
  bottom = aQuotient._denominator * _denominator;
  tRational<T> newQuot(top,bottom);
  return newQuot;
};

template<class T>
tRational<T> tRational<T>::operator + (const T & aT) const {
  T top;
  top = _numerator + 
        _denominator * aT;   
  tRational<T> newQuot(top,_denominator);
  return newQuot;
};

template<class T>
tRational<T> tRational<T>::operator - (const tRational<T> & aQuotient) const {
  T top;
  top = _numerator * aQuotient._denominator - 
        _denominator* aQuotient._numerator;
  T bottom;
  bottom = aQuotient._denominator * _denominator;
   
  tRational<T> newQuot(top,bottom);

  return newQuot;
};

template<class T>
tRational<T> tRational<T>::operator - (const T & aT) const {
  T top = _numerator  - _denominator * aT;
  tRational<T> newQuot(top,_denominator);
  return newQuot;
};


template<class T>
FieldRep * tRational<T>::make(int n) {
  RECORDHERE(FieldRep * p = new tRational<T>(n);)
  return p;
};

template<class T>
FieldRep * tRational<T>::make(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  RECORDHERE(FieldRep * p = new tRational<T>(y);)
  return p;
};

template<class T>
FieldRep * tRational<T>::clone()  const {
  RECORDHERE(FieldRep * p = new tRational<T>(*this);)
  return p;
};

template<class T>
void tRational<T>::setToZero() {
  _numerator.setToZero(); 
  _denominator.setToOne(); 
};

template<class T>
void tRational<T>::setToOne() {
  _numerator.setToOne(); 
  _denominator.setToOne(); 
};

template<class T>
int tRational<T>::sgn() const {
  return nvSgn();
};

template<class T>
void tRational<T>::initialize(int n) {
  operator =(tRational<T>(n));
};

template<class T>
void tRational<T>::initialize(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  operator =(tRational<T>(y));
};

template<class T>
bool tRational<T>::equal(const FieldRep & x) const {
  const tRational<T> & y = (const tRational<T> &) x;
  return operator==(y);
};

template<class T>
bool tRational<T>::less(const FieldRep &) const {
  DBG();
  return true;
};

template<class T>
void tRational<T>::invert() {
  tRational<T> u(*this);
  setToOne();
  (*this) /= u;
};

template<class T>
void tRational<T>::add(int n) {
  T t(n);
  operator += (t);
};

template<class T>
void tRational<T>::add(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  operator +=(y);
};

template<class T>
void tRational<T>::subtract(int n) {
  T t(n);
  operator -= (t);
};

template<class T>
void tRational<T>::subtract(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  operator -=(y);
};

template<class T>
void tRational<T>::times(int n) {
  T t(n);
  operator *= (t);
};

template<class T>
void tRational<T>::times(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  operator *=(y);
};

template<class T>
void tRational<T>::divide(const FieldRep & x) {
  const tRational<T> & y = (const tRational<T> &) x;
  operator /=(y);
};

template<class T>
void tRational<T>::divide(int n) {
  T N(n);
  operator /=(N);
};

template<class T>
bool tRational<T>::isZero() const {
  return _numerator==T(0);
};

template<class T>
bool tRational<T>::isOne() const {
  return _numerator==_denominator;
};

template<class T>
void tRational<T>::operator +=(const tRational<T> & x) {
  tRational<T> temp((*this) + x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator -=(const tRational<T> & x) {
  tRational<T> temp((*this) - x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator *=(const tRational<T> & x) {
  tRational<T> temp((*this) * x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator /=(const tRational<T> & x) {
  tRational<T> temp((*this) / x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator +=(const T & x) {
  tRational<T> temp((*this) + x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator -=(const T & x) {
  tRational<T> temp((*this) - x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator *=(const T &  x) {
  tRational<T> temp((*this) * x);
  operator=(temp);
};

template<class T>
void tRational<T>::operator /=(const T &  x)  {
  tRational<T> temp((*this) / x);
  operator=(temp);
};

template<class T>
void tRational<T>::print(MyOstream & os) const {
  os << (*this);
};

template<class T>
void tRational<T>::print(OutputVisitor & v) const {
  v.go(*this);
};

template<class T>
void tRational<T>::put(Sink & ioh) const {
  OutputVisitor::s_put(*this,ioh);
};

#ifdef USE_MyInteger
#include "MyInteger.hpp"
#endif

long gcd(long m,long n);
long GCD(long m,long n) { return gcd(m,n);}
#ifdef USE_MyInteger
Integer GCD(const Integer & m,const Integer & n)  { return gcd(m,n);};
#endif

template<class T>
void tRational<T>::normalize() {
  if(numerator().zero()) {
    _denominator.setToOne();
  } else if(T::gcds()) {
    if(!numerator().one() && !denominator().one()) {
      T m(GCD(numerator().internal(),denominator().internal()));
// INEFFICIENT
      if(m!=T(1)) {
        T i(m);
        _numerator /= i;
        _denominator /= i;
        if(denominator().internal()<0) {
          T MINUSONE(-1);
          _numerator *= MINUSONE;
          _denominator *= MINUSONE;
        }
      }
    }
  }
};

#include "idValue.hpp"
#include "AltInteger.hpp"
template<> int tRational<INTEGER>::s_ID = idValue("tRational<INTEGER>::s_ID");
MyOstream & operator << (MyOstream & os, const tRational<INTEGER> & x) {
  AsciiOutputVisitor v(os);
  x.print(v);
  return os;
};
template class tRational<INTEGER>;
#include "LINTEGER.hpp"
MyOstream & operator << (MyOstream & os, const tRational<LINTEGER> & x) {
  AsciiOutputVisitor v(os);
  x.print(v);
  return os;
};
template class tRational<LINTEGER>;
template<> int tRational<LINTEGER>::s_ID = idValue("tRational<LINTEGER>::s_ID");
#ifdef USE_MyInteger
#include "MyInteger.hpp"
MyOstream & operator << (MyOstream & os, const tRational<MyInteger> & x) {
  AsciiOutputVisitor v(os);
  x.print(v);
  return os;
};
template class tRational<MyInteger>;
template<> int tRational<MyInteger>::s_ID = idValue("tRational<MyInteger>::s_ID");
#endif
#endif
