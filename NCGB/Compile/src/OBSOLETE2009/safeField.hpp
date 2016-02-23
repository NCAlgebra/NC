// safeField.h

#ifndef INCLUDED_FIELD_H
#define INCLUDED_FIELD_H

#ifndef INCLUDED_INTEGER_H
#include "AltInteger.hpp" 
#endif
long gcd(long,long);
class Sink;

#define USEQF

#define OTHER_QF_OPERATIONS

class Field {
public:
   typedef class INTEGER IntDom;
   Field();
   Field(const Field & RightSide);
   explicit Field(int);
   Field(int,int);
   explicit Field(long );
   explicit Field(const IntDom & top);
   explicit Field(const IntDom & top, const IntDom & bottom);
   inline ~Field(){};
   void operator = (const Field & aQuotient);
   void operator = (int);
   void operator = (const IntDom & aIntDom);
   void assign(const Field &);
   void assign(int);
   void assign(long );
   void assign(const IntDom & top);
   void assign(const IntDom & top, const IntDom & bottom);

   int sgn() const;

   bool operator == (const Field & aQuotient) const;
   bool operator != (const Field & aQuotient) const;

   
   void print(MyOstream & os) const;
   void put(Sink & ioh) const;
   inline void setToZero();
   void setToOne();
   bool isZero() const;
   bool isOne() const;
   bool zero() const;
   bool one() const;
   void invert();

   // basic math functions
   Field operator - () const;
#ifdef OTHER_QF_OPERATIONS
   Field operator + (const Field &) const;
   Field operator + (const IntDom &) const;
   Field operator - (const Field &) const;
   Field operator - (const IntDom &) const;
   Field operator * (const Field &) const;
   Field operator * (const IntDom &) const;
   Field operator / (const Field &) const;
   Field operator / (const IntDom &) const;
#endif
   void operator +=(const Field &);
   void operator +=(const IntDom &);
   void operator +=(int);
   void operator -=(const Field &);
   void operator -=(const IntDom &);
   void operator -=(int);
   void operator *=(const Field &);
   void operator *=(const IntDom &);
   void operator *=(int);
   void operator /=(const Field &);
   void operator /=(const IntDom &);
   void operator /=(int);
   int compareNumbers(const Field & right) const;

   const IntDom & numerator() const;
   const IntDom & denominator() const;
   void normalize();
   static const int s_ID;
private:
   IntDom _numerator;
   IntDom _denominator;
};

inline MyOstream & operator << (MyOstream & out,const Field & x) {
  x.print(out);
  return out;
};

inline const Field::IntDom & Field::numerator() const {
  return _numerator;
};

inline const Field::IntDom & Field::denominator() const {
  return _denominator;
};

inline void Field::normalize() {
  if(numerator().zero()) {
    _denominator.setToOne();
  } else if(INTEGER::gcds()) {
    if(denominator().internal()<0) {
      _numerator *= -1;
      _denominator *= -1;
    }
    IntDom ONE(1);
    if(!numerator().one() && !denominator().one() && !numerator().minusone()) {
      IntDom m(gcd(numerator().internal(),denominator().internal()));
      if(m!=ONE) {
        _numerator /= m;
        _denominator /= m;
      }
    }
  }
};

inline Field::Field() {
   setToZero();
};

inline Field::Field(int top,int bottom) :
   _numerator(top), _denominator(bottom) {
  normalize();
};

inline Field::Field(const IntDom & top,const IntDom & bottom) :
   _numerator(top), _denominator(bottom) {
  normalize();
};

inline void Field::assign(const IntDom & top,const IntDom & bottom) {
  _numerator=top;
  _denominator=bottom;
  normalize();
};

inline Field::Field(const IntDom & top) {
   _numerator = top;
   _denominator.setToOne();
};

inline void Field::assign(const IntDom & top) {
   _numerator = top;
   _denominator.setToOne();
};

inline Field::Field(int n) {
   _numerator = n;
   _denominator.setToOne();
};

inline void Field::assign(int n) {
   _numerator = n;
   _denominator.setToOne();
};

inline Field::Field(long n) {
   _numerator = n;
   _denominator.setToOne();
};

inline void Field::assign(long n) {
   _numerator = n;
   _denominator.setToOne();
};

inline Field::Field(const Field & rightside) {
   _numerator = rightside._numerator;
   _denominator = rightside._denominator;
};

inline void Field::assign(const Field & rightside) {
   _numerator = rightside._numerator;
   _denominator = rightside._denominator;
};

inline bool Field::zero() const {
   return _numerator.zero();
};

inline bool Field::one() const {
  return _numerator==_denominator;
};

inline void Field::setToZero() {
   _numerator.setToZero();
   _denominator.setToOne();
};

inline void Field::invert() {
   IntDom temp;
   temp = _numerator;
   _numerator = _denominator;
   _denominator = temp;
};

inline void Field::setToOne() {
   _numerator.setToOne();
   _denominator.setToOne();
};

#ifdef other_qf_operations
inline Field Field::operator * (const IntDom  & aIntDom) const {
   Field newQuot(aIntDom);
   return ((*this) * newQuot);
};

inline Field Field ::operator / (const IntDom & aIntDom) const {
   Field newQuot(aIntDom);
   return ((*this) / newQuot);
};
#endif

inline void Field::operator = (const Field & RightSide) {
   _numerator = RightSide._numerator;
   _denominator = RightSide._denominator;
};

inline void Field::operator = (const IntDom & RightSide) {
   _numerator = RightSide;
   _denominator.setToOne();
};

inline void Field::operator = (int x) {
   _numerator = x;
   _denominator.setToOne();
};
 
inline int Field::sgn() const { 
  return _numerator.sgn()*_denominator.sgn();
};

inline bool Field::operator == (const Field & x) const { 
  return compareNumbers(x)==0;
};

inline bool Field::operator !=(const Field & x) const { 
  return compareNumbers(x)!=0;
};

inline Field Field::operator - () const { 
  return Field(-_numerator, _denominator); 
};
#endif  /* Field_h */
