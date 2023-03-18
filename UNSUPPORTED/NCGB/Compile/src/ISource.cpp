// (c) Mark Stankus 1999
// ISource.c

#include "ISource.hpp"
#include "symbolGB.hpp"
#include "GBInputNumbers.hpp"
#include "TellHead.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

ISource::~ISource() {};

void ISource::get(bool & x) {
  symbolGB y;
  get(y);
  if(y=="True") {
    x = true;
  } else if(y=="False") {
    x = false;
  } else errorc(__LINE__);
};

void ISource::get(Holder&) {
  errorc(__LINE__);
};

void ISource::get(Field&) {
  errorc(__LINE__);
};

void ISource::get(Variable&) {
  errorc(__LINE__);
};

void ISource::get(Monomial&) {
  errorc(__LINE__);
};

void ISource::get(Term&) {
  errorc(__LINE__);
};

void ISource::get(Polynomial &) {
  errorc(__LINE__);
};

void ISource::get(GroebnerRule &) {
  errorc(__LINE__);
};

void ISource::print(void * v) {
  GBStream << "Source:" << v << "\nISource:" << this << "\nEOI:" 
           << d_eoi << '\n';
};

bool ISource::verror() const {
  return false;
};

void ISource::errorh(int n) {
  DBGH(n);
};

void ISource::errorc(int n) {
  DBGC(n);
};
