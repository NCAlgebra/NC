// safeField.c

#include "safeField.hpp"
#include "Sink.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"
#include "GBOutput.hpp"

int Field::compareNumbers(const Field & Right) const {
  int  Result;
  if (this == &Right) {
    Result = 0;      //  Check if they are copies
  } else {
    int s1 = _numerator.sgn()*Right._numerator.sgn();
    int s2 = _denominator.sgn()*Right._denominator.sgn();

    // Check that numerators agree up to sign
    if(s1<0) {
      Result = _numerator.compareNumbers(-Right._numerator).asInt();
    } else {
      Result = _numerator.compareNumbers(Right._numerator).asInt();
    }

    // If numerators check out and signs check out, check denominator
    if(Result==0 && s1==s2 && s1!=0) {
      if(s2<0) {
        Result = _denominator.compareNumbers(-Right._denominator).asInt();
      } else {
        Result = _denominator.compareNumbers(Right._denominator).asInt();
      }
    }  
  }
  return Result;
};

Field Field::operator * (const INTEGER & x) const {
  Field newQuot(_numerator*x,_denominator);
  return newQuot;
};

Field Field ::operator / (const INTEGER & x) const {
   Field newQuot(_numerator,_denominator*x);
   return newQuot;
};

Field Field::operator * (const Field & aQuotient) const {
//GBStream << "Multiplying " << * this << " by " << aQuotient << '\n';
  IntDom top;
  top = _numerator * aQuotient._numerator; 
  IntDom bot;
  bot = aQuotient._denominator * _denominator;
  Field newQuot(top,bot);
//GBStream << "The answer is " << newQuot << '\n';
  return newQuot;
};

Field Field ::operator / (const Field & aQuotient) const {
   IntDom top;
   top = aQuotient._denominator * _numerator;
   IntDom bot; 
   bot = aQuotient._numerator * _denominator;
   Field newQuot(top,bot);
   return newQuot;
};

Field Field::operator + (
     const Field & aQuotient) const {
  IntDom top;
  top = (aQuotient._numerator * _denominator) +
        (aQuotient._denominator * _numerator);
  IntDom bottom;
  bottom = aQuotient._denominator * _denominator;
  Field newQuot(top,bottom);
  return newQuot;
};

Field Field::operator + (const IntDom & aIntDom) const {
  IntDom top;
  top = _numerator + 
        _denominator * aIntDom;   
  Field newQuot(top,_denominator);
  return newQuot;
};

Field Field::operator - (const Field & aQuotient) const {
  IntDom top;
  top = _numerator * aQuotient._denominator - 
        _denominator* aQuotient._numerator;
  IntDom bottom;
  bottom = aQuotient._denominator * _denominator;
   
  Field newQuot(top,bottom);

  return newQuot;
};

Field Field::operator - (const IntDom & aIntDom) const {
  IntDom top;
  top = _numerator  - _denominator * aIntDom;
  Field newQuot(top,_denominator);
  return newQuot;
};

void Field::print(MyOstream & os) const {
 if(numerator().needsParenthesis()) os << '(';
  os << numerator().internal();
  if(numerator().needsParenthesis()) os << ")";
  if(!denominator().one()) {
    os << "/(";
    os << denominator().internal();
    os << ")";
  }
};

void Field::put(Sink & sink1) const {
  Sink sink2(sink1.outputFunction("List",2L));
  sink1 << numerator().asInt() << denominator().asInt();
};

void Field::operator +=(const Field & x) {
  Field f = (*this) + x;
  operator=(f);
};

void Field::operator +=(const IntDom & x) {
  Field f = (*this) + x;
  operator=(f);
};

void Field::operator +=(int n) {
  IntDom N(n);
  operator +=(N);
};

void Field::operator -=(const Field & x) {
  Field f = (*this) - x;
  operator=(f);
};

void Field::operator -=(const IntDom & x) {
  Field f = (*this) - x;
  operator=(f);
};

void Field::operator -=(int n) {
  IntDom N(n);
  operator -=(N);
};

void Field::operator *=(const Field & x) {
  Field f((*this) * x);
  operator=(f);
};

void Field::operator *=(const IntDom & x) {
  Field f = (*this) * x;
  operator=(f);
};

void Field::operator *=(int n) {
  IntDom N(n);
  operator *=(N);
};

void Field::operator /=(const Field & x) {
  Field f = (*this) / x;
  operator=(f);
};

void Field::operator /=(const IntDom & x) {
  Field f = (*this) / x;
  operator=(f);
};

void Field::operator /=(int n) {
  IntDom N(n);
  operator /=(N);
};

void SwitchFields(int) {
  GBStream << "A call was made to the C++ routine SwitchFields"
           << " but this implementation of fields does"
           << " not allow switching. Sorry. \n"; 
};

#include "idValue.hpp"
const int Field::s_ID = idValue("Field::s_ID");
