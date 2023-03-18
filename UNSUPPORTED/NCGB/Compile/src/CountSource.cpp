// (c) Mark Stankus 1999
// CountSource.c

#include "CountSource.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"

CountSource::~CountSource() {};

ISource * CountSource::clone() const {
  errorc(__LINE__);
  return new CountSource(d_source,d_count,0);
}; 

void CountSource::get(int & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(long & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(bool & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(stringGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::passString() {
  if(d_count<=0) errorc(__LINE__);
  d_source.passString();
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(asStringGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(symbolGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

Alias<ISource> CountSource::inputCommand(symbolGB &) {
  errorc(__LINE__);
  if(d_count<=0) errorc(__LINE__);
  --d_count;
  if(d_count==0) d_eoi = true;
  return *(Alias<ISource> *)0;
};

Alias<ISource> CountSource::inputFunction(symbolGB & x) {
  if(d_count<=0) errorc(__LINE__);
  --d_count;
  Alias<ISource> result(d_source.inputFunction(x));
  if(d_count==0) d_eoi = true;
  return result;
};

Alias<ISource> CountSource::inputNamedFunction(const symbolGB & x) {
  if(d_count<=0) errorc(__LINE__);
  --d_count;
  Alias<ISource> result(d_source.inputNamedFunction(x));
  if(d_count==0) d_eoi = true;
  return result;
};

Alias<ISource> CountSource::inputNamedFunction(const char * x) {
  if(d_count<=0) errorc(__LINE__);
  --d_count;
  Alias<ISource> result(d_source.inputNamedFunction(x));
  if(d_count==0) d_eoi = true;
  return result;
};
void CountSource::get(Holder & x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};


void CountSource::get(Field& x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(Variable& x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(Monomial& x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(Term& x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::get(Polynomial& x) {
  if(d_count<=0) errorc(__LINE__);
  d_source.get(x);
  --d_count;
  if(d_count==0) d_eoi = true;
};

void CountSource::vShouldBeEnd() {
  if(f_atend) f_atend();
};

int CountSource::getType() const  {
  return d_source.getType();
};

void CountSource::vQueryNamedFunction() {
  d_source.vQueryNamedFunction();
}; 

void CountSource::errorh(int n) { DBGH(n); };

void CountSource::errorc(int n) { DBGC(n); };
