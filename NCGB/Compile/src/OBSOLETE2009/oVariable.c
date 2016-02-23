// Variable.c

#include "Variable.hpp"
#include "RecordHere.hpp"
#ifndef INCLUDED_UNIQUELIST_H
#include "UniqueList.hpp"
#endif
#ifndef INCLUDED_IOSTREAM_H
#define INCLUDED_IOSTREAM_H
#include "MyOstream.hpp"
#endif

int Variable::s_largestStringNumber() {
  return _stringList ? _stringList->largestNumber() : -1;
};

void Variable::s_newStringList() {
  RECORDHERE(delete _stringList;)
  RECORDHERE(_stringList = new UniqueList();)
};

const char * const Variable::cstring() const {
#ifdef CHECK_VARIABLE
  check();
#endif
 return _stringList->stringElement(_stringNumber);
};

Variable::Variable()   : _stringNumber(0) {
  if(_stringList!=0) {
    _stringNumber = _stringList->insertElement("dumbVariable");
  } else DBG();
#ifdef CHECK_VARIABLE
  check();
#endif
};

Variable::Variable(const Variable & var) {
#ifdef CHECK_VARIABLE
  var.check();
#endif
  _stringNumber = var._stringNumber;
  _stringList->increment(_stringNumber);
#ifdef CHECK_VARIABLE
  check();
  var.check();
#endif
}; 

Variable::~Variable() {
#ifdef CHECK_VARIABLE
  check();
#endif
  _stringList->decrement(_stringNumber);
};

Variable::Variable(const char * aCharString) : _stringNumber(0) { 
  if(_stringList!=0) {
    _stringNumber = _stringList->insertElement(aCharString);
  }
#ifdef CHECK_VARIABLE
  check();
#endif
};

void Variable::assign(const char * const x) {
#ifdef CHECK_VARIABLE
  check();
#endif
  if(_stringNumber!=0) {
    _stringList->decrement(_stringNumber);
  }
  _stringNumber = _stringList->insertElement(x);
#ifdef CHECK_VARIABLE
  check();
#endif
};

bool Variable::commutativeQ() const {
#ifdef CHECK_VARIABLE
  check();
#endif
  return _stringList->commutativeQ(_stringNumber);
};

void Variable::setCommutative(bool yn) {
#ifdef CHECK_VARIABLE
  check();
#endif
  _stringList->setCommutative(_stringNumber,yn);
};

void Variable::assign(const Variable & var) {
#ifdef CHECK_VARIABLE
  check();
  var.check();
#endif
  if(this!=&var) {
    int n = _stringNumber;
    _stringNumber = var._stringNumber;
    _stringList->increment(_stringNumber);
    _stringList->decrement(n);
  }
#ifdef CHECK_VARIABLE
  check();
  var.check();
#endif
};


void Variable::operator = (const Variable & var) {
#ifdef CHECK_VARIABLE
  check();
  var.check();
#endif
  if(this!=&var) {
    int n = _stringNumber;
    _stringNumber = var._stringNumber;
    _stringList->increment(_stringNumber);
    _stringList->decrement(n);
  }
#ifdef CHECK_VARIABLE
  check();
  var.check();
#endif
};

MyOstream & operator << (MyOstream & os,const Variable & x) { 
#ifdef CHECK_VARIABLE
  x.check();
#endif
  os << Variable::_stringList->stringElement(x._stringNumber);   
  return os;
};

Variable Variable::s_variableFromNumber(int n) {
  return Variable(_stringList->stringElement(n));
};

#ifdef CHECK_VARIABLE
int ss_check_count = 0;

void Variable::check() const {
  ++ss_check_count;
#if 0
  GBStream << "ss_check_count:" << ss_check_count << '\n';
#endif
  if(stringNumber()<-2) DBG();
  if(stringNumber()>1000) DBG();
};
#endif

const Composite * Variable::composite() const {
  return d_stringList->composite_p(stringNumber());
};

void Variable::composite(Composite & x) {
  d_stringList->setComposite(x,stringNumber());
};

const char * const Variable::texstring() const {
  return d_stringList->string(stringNumber(),"tex");
};

void Variable::texstring(const char * x) const {
  d_stringList->addString(x,stringNumber(),"tex");
};
