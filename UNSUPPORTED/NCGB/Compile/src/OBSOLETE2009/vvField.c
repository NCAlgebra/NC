// Field.c

#ifndef INCLUDED_FIELD_H
#include "vField.hpp"
#endif
#ifndef INCLUDED_FIELDREP_H
#include "FieldRep.hpp"
#endif
#include "AltInteger.hpp"
#include "CreateNumber.hpp"
#include "FieldRep.hpp"
#include "fieldRepMemory.hpp"
#include "RecordHere.hpp"
#include "Debug1.hpp"
#include "Ownership.hpp"
#include "MyOstream.hpp"

class FieldImplementation {
  FieldImplementation(const FieldImplementation &);
    // not implemented
  void operator=(const FieldImplementation &);
    // not implemented
public:
  FieldImplementation() : d_rep_p(fieldRepMemory()) {}; 
  FieldImplementation(FieldRep * rep,Adopt) : d_rep_p(rep) {}; 
  ~FieldImplementation(){ fieldRepMemory(d_rep_p);};
  FieldRep & operator()() { return * d_rep_p;};
  const FieldRep & operator()() const { return * d_rep_p;};
  FieldRep * d_rep_p; 
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
    delete d_impl_p;
    d_impl_p = new FieldImplementation();
    (*d_impl_p)().initialize((*f.d_impl_p)());
  };
};

void Field::operator = (const int & n) {
  (*d_impl_p)().setToOne();
  (*d_impl_p)() *= n;
};  

Field Field::operator -()  const {
  if((*d_impl_p)().ID()!=*Field::s_currentFieldNumber_p) DBG();
  Field result(*this);
  result *= -1;
  return result;
};

// Function changes object
void Field::invert() { 
  (*d_impl_p)().invert();
};

// basic math functions
void Field::operator +=(const int & i) { 
  (*d_impl_p)() += i;
};

void Field::operator -=(const int & i) {
  (*d_impl_p)() -= i;
};

void Field::operator *=(const int & i) {
  (*d_impl_p)() *= i;
};

void Field::operator /=(const int & i) {
  (*d_impl_p)() /= i;
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
  (*d_impl_p)() += (*f.d_impl_p)();
};

void Field::operator -=(const Field & f) {
  (*d_impl_p)() -= (*f.d_impl_p)();
};

void Field::operator *=(const Field & f) {
  (*d_impl_p)() *= (*f.d_impl_p)();
};

void Field::operator /=(const Field & f) {
  (*d_impl_p)() /= (*f.d_impl_p)();
};

int Field::sgn() const { return (*d_impl_p)().sgn();};

bool Field::operator == (const Field & f) const {
  return (*d_impl_p)()==(*f.d_impl_p)();
};

bool Field::isZero() const { return (*d_impl_p)().isZero();};

bool Field::isOne() const { return (*d_impl_p)().isOne();};

int Field::compareNumbers(const Field & x) const {
    return (*d_impl_p)().compareNumbers((*x.d_impl_p)());
};

bool Field::zero() const { return (*d_impl_p)().isZero();};

bool Field::one() const { return (*d_impl_p)().isOne();};

void Field::setToZero() { 
  (*d_impl_p)().setToZero();
};

void Field::setToOne() { (*d_impl_p)().setToOne(); };

const FieldRep & Field::rep() const { return (*d_impl_p)();};
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
  RECORDHERE(d_impl_p = new FieldImplementation();)
  (*d_impl_p)().setToZero();
};

Field::Field(const Field & f) : d_impl_p(0) {
  RECORDHERE(d_impl_p = new FieldImplementation();)
  (*d_impl_p)().setToOne();
  (*d_impl_p)() *= f.rep();
};

Field::Field(int n) : d_impl_p(0) {
  RECORDHERE(d_impl_p = new FieldImplementation();)
  (*d_impl_p)().setToOne();
  (*d_impl_p)() *= n;
};

Field::Field(const INTEGER & n) : d_impl_p(0) {
  Adopt x;
  RECORDHERE(d_impl_p = new FieldImplementation(CreateNumber(n),x);)
};

Field::Field(const INTEGER & num,const INTEGER & den) : d_impl_p(0) {
  Adopt x;
  RECORDHERE(d_impl_p = new FieldImplementation(CreateNumber(num,den),x);)
};

#include "tRational.hpp"
#include "AltInteger.hpp"
FieldRep * Field::s_currentRep_p = new tRational<INTEGER>();
const int * Field::s_currentFieldNumber_p = &tRational<INTEGER>::s_ID;

bool Field::less(const Field & f) const {
   return (*d_impl_p)().less((*f.d_impl_p)());
};
