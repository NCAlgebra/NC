// Field.c

#ifndef INCLUDED_FIELD_H
#include "vField.hpp"
#endif
#ifndef INCLUDED_FIELDREP_H
#include "FieldRep.hpp"
#endif
#include "CreateNumber.hpp"
#include "GBStream.hpp"
#include "AltInteger.hpp"
#include "CreateNumber.hpp"
#include "Ownership.hpp"
#include "FieldRep.hpp"
#include "RecordHere.hpp"
#include "MyOstream.hpp"

class FieldImplementation : public RCountedPLocked<FieldRep> {
public:
  FieldImplementation() : 
         RCountedPLocked<FieldRep>(){};
  ~FieldImplementation(){}; 
  FieldImplementation(const FieldRep & x) :
         RCountedPLocked<FieldRep>(x){};
  FieldImplementation(FieldRep * p,Adopt x) :
         RCountedPLocked<FieldRep>(p,x){};
  FieldImplementation(const RCountedPLocked<FieldRep> & x) :
         RCountedPLocked<FieldRep>(x){};
};

void FieldRepReport(const FieldRep & x) {
  GBStream << "(*d_impl_p)().ID() " << x.ID() << '\n';
  GBStream << "Field::s_currentFieldNumber " 
           << *Field::s_currentFieldNumber_p << '\n';
  DBG();
};

Field::~Field() {
  if((*d_impl_p)().ID()!=*Field::s_currentFieldNumber_p) {
     FieldRepReport((*d_impl_p)());
  };
  delete d_impl_p;
};

void Field::operator = (const Field & f) {
  if((*d_impl_p)().ID()!=*Field::s_currentFieldNumber_p) DBG();
  if((*f.d_impl_p)().ID()!=*Field::s_currentFieldNumber_p) DBG();
  if(this!=&f) {
    (*d_impl_p) = *f.d_impl_p;
  };
};

void Field::operator = (const int & n) {
  (*d_impl_p).access().setToOne();
  (*d_impl_p).access() *= n;
};  

void Field::assign(const INTEGER & num) {
  (*d_impl_p).access().setToOne();
  (*d_impl_p).access() *= num.internal();
};

void Field::assign(const INTEGER & num,const INTEGER & den) {
  (*d_impl_p).access().setToOne();
  (*d_impl_p).access() *= num.internal();
  (*d_impl_p).access() /= den.internal();
};

void Field::operator = (const long & n) {
  (*d_impl_p).access().setToOne();
  (*d_impl_p).access() *= n;
};  

Field Field::operator -()  const {
  if((*d_impl_p)().ID()!=*Field::s_currentFieldNumber_p) DBG();
  Field result(*this);
  result *= -1;
  return result;
};

// Function changes object
void Field::invert() { 
  (*d_impl_p).access().invert();
};

// basic math functions
void Field::operator +=(const int & i) { 
  (*d_impl_p).access() += i;
};

void Field::operator -=(const int & i) {
  (*d_impl_p).access() -= i;
};

void Field::operator *=(const int & i) {
  (*d_impl_p).access() *= i;
};

void Field::operator /=(const int & i) {
  (*d_impl_p).access() /= i;
};

Field Field::operator +(const Field & f) const {
  Field g(*this);
  g += f;
  return g;
};

Field Field::operator -(const Field & f) const {
  Field g(*this);
  g -= f;
  return g;
};

Field Field::operator *(const Field & f) const {
  Field g(*this);
  g *= f;
  return g;
};

Field Field::operator /(const Field & f) const {
  Field g(*this);
  g /= f;
  return g;
};

void Field::operator +=(const Field & f) {
  (*d_impl_p).access() += (*f.d_impl_p)();
};

void Field::operator -=(const Field & f) {
  (*d_impl_p).access() -= (*f.d_impl_p)();
};

void Field::operator *=(const Field & f) {
  (*d_impl_p).access() *= (*f.d_impl_p)();
};

void Field::operator /=(const Field & f) {
  (*d_impl_p).access() /= (*f.d_impl_p)();
};

int Field::sgn() const { return (*d_impl_p)().sgn();};

bool Field::operator == (const Field & f) const {
  return (*d_impl_p).simpleEqual(*f.d_impl_p) || 
         (*d_impl_p)()==(*f.d_impl_p)();
};

bool Field::isZero() const { return (*d_impl_p)().isZero();};

bool Field::isOne() const { return (*d_impl_p)().isOne();};

int Field::compareNumbers(const Field & x) const {
    return (*d_impl_p)().compareNumbers((*x.d_impl_p)());
};

bool Field::zero() const { return (*d_impl_p)().isZero();};

bool Field::one() const { return (*d_impl_p)().isOne();};

void Field::setToZero() { 
  (*d_impl_p).access().setToZero();
};

void Field::setToOne() { (*d_impl_p).access().setToOne(); };

const FieldRep & Field::rep() const { return (*d_impl_p)();};
FieldRep & Field::rep() { return (*d_impl_p).access();};
const FieldRep & Field::helper() const { return (*d_impl_p)();};

void Field::print(OutputVisitor & v) const { 
  (*d_impl_p)().print(v);
};

void Field::put(Sink & ioh) const { 
  (*d_impl_p)().put(ioh);
};

void Field::print(MyOstream & v) const { 
  (*d_impl_p)().print(v);
};

Field::Field() : d_impl_p(0) {
  RECORDHERE(d_impl_p = new FieldImplementation(s_currentRep_p->make(0),Adopt());)
};

Field::Field(const Field & f) : d_impl_p(0) {
   RECORDHERE(d_impl_p = new FieldImplementation(*f.d_impl_p);)
};

Field::Field(int n) : d_impl_p(0) {
  if(!s_currentRep_p)  {
    if(s_inInitialize) {
      s_currentRep_p = CreateNumber(n,1);
    } else {
      cerr << "Error with field setting\n";
    };
  };
  RECORDHERE(d_impl_p = new FieldImplementation(s_currentRep_p->make(n),Adopt());)
};

Field::Field(const INTEGER & n) : d_impl_p(0) {
  RECORDHERE(d_impl_p = 
             new FieldImplementation(CreateNumber(n),Adopt::s_dummy);)
};

Field::Field(const INTEGER & num,const INTEGER & den) : d_impl_p(0) {
   RECORDHERE(d_impl_p = 
              new FieldImplementation(CreateNumber(num,den),Adopt::s_dummy);)
};

#include "tRational.hpp"
#include "AltInteger.hpp"
#if 1
FieldRep * Field::s_currentRep_p = new tRational<INTEGER>();
const int * Field::s_currentFieldNumber_p = &tRational<INTEGER>::s_ID;
#else
FieldRep * Field::s_currentRep_p = new tRational<MyInteger>();
const int * Field::s_currentFieldNumber_p = &tRational<MyInteger>::s_ID;
#endif

bool Field::less(const Field & f) const {
   return (*d_impl_p)().less((*f.d_impl_p)());
};

#if 0 
INTEGER Field::numerator() const {
};

INTEGER Field::denominator() const {
};
#endif
