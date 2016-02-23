// Zp.c

#include "Zp.hpp"
#include "AsciiOutputVisitor.hpp"
#ifdef USE_VIRT_FIELD
#include "OutputVisitor.hpp"
#include "RecordHere.hpp"
#include "MyOstream.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "Sink.hpp"

void Zp::checkCharacteristic(const Zp &) const {};


int Zp::reciprocal(int n) const { 
  int result = 1;
  for(int i=1;i<s_characteristic;++i) {
    if(((i*n)%s_characteristic)==1) {
      result= i;
      break;
    };
  };
  return result;
};
void Zp::s_setCharacteristic(int charac) { 
  s_characteristic = charac;
#if 0
  s_reciprocal.reserve(s_characteristic);
  s_reciprocal.erase(s_reciprocal.begin(),s_reciprocal.end());
  int j,k;
  for(int i=1;i<s_characteristic;++i) {
    // find reciprocal
    for(j=1,k=i;j<s_characteristic;++j)  { 
      if(k==1) { break; }
      k += i;
      k = k % s_characteristic;
    };
    if(k!=0) DBG();
    s_reciprocal[i] = j;
  };
#endif
};

Zp::~Zp(){};

MyOstream & operator << (MyOstream & os, const Zp & x) {
  AsciiOutputVisitor v(os);
  x.print(v);
  return os;
};

FieldRep * Zp::make(int n) {
  RECORDHERE(FieldRep * p = new Zp(n);)
  return p;
};

int Zp::compareNumbers(const FieldRep & x) const { 
  const Zp & y = (const Zp &) x;
  return d_value-y.d_value;
};

FieldRep * Zp::make(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  RECORDHERE(FieldRep * p = new Zp(y);)
  return p;
};

FieldRep * Zp::clone()  const {
  RECORDHERE(FieldRep * p = new Zp(*this);)
  return p;
};

void Zp::setToZero() {
  d_value = 0; 
};

void Zp::setToOne() {
  d_value = 1; 
};

int Zp::sgn() const {
  return nvSgn();
};

void Zp::initialize(int n) {
  operator =(Zp(n));
};

void Zp::initialize(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  operator =(Zp(y));
};

bool Zp::equal(const FieldRep & x) const {
  const Zp & y = (const Zp &) x;
  return operator==(y);
};

bool Zp::less(const FieldRep &) const {
  DBG();
  return true;
};

void Zp::invert() {
  Zp u(*this);
  setToOne();
  (*this) /= u;
};

void Zp::add(int n) {
  operator += (n);
};

void Zp::add(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  operator +=(y);
};

void Zp::subtract(int n) {
  operator -= (n);
};

void Zp::subtract(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  operator -=(y);
};

void Zp::times(int n) {
  operator *= (n);
};

void Zp::times(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  operator *=(y);
};

void Zp::divide(const FieldRep & x) {
  const Zp & y = (const Zp &) x;
  operator *=(y);
};

void Zp::divide(int n) {
  operator /=(n);
};

bool Zp::isZero() const {
  return d_value ==0;
};

bool Zp::isOne() const {
  return d_value ==1;
};

void Zp::print(MyOstream & os) const {
  os << d_value << " (" << s_characteristic << ") ";
};

void Zp::print(OutputVisitor & v) const {
  v.go(*this);
};

void Zp::put(Sink & sink) const {
  bool fancy = false;
  if(fancy) {
    Sink si2(sink.outputFunction("Zp",2L));
    si2 << d_value;
    si2 << s_characteristic;
  } else {
    sink << d_value;
  };
};

#include "idValue.hpp"
int Zp::s_ID = idValue("Zp::s_ID");
int Zp::s_characteristic = 5;
vector<int> Zp::s_reciprocal;
#endif
