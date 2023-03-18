// (c) Mark Stankus 1999
// CountSink.c

#include "CountSink.hpp"

CountSink::~CountSink() {};

ISink * CountSink::clone() const {
  return new CountSink(d_sink,d_count);
};

void CountSink::put(bool x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(int x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(long x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

#ifdef USE_UNIX
void CountSink::put(long long x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};
#endif


void CountSink::put(const char * x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink.putString(x);
  --d_count;
};

void CountSink::put(const stringGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const asStringGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const symbolGB & x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

Alias<ISink> CountSink::outputCommand(const symbolGB &) {
  errorc(__LINE__);
  return *(Alias<ISink> *)0;
};

Alias<ISink> CountSink::outputFunction(const symbolGB &,long) {
  errorc(__LINE__);
  return *(Alias<ISink> *)0;
};

Alias<ISink> CountSink::outputFunction(const char *,long) {
  errorc(__LINE__);
  return *(Alias<ISink> *)0;
};

void CountSink::put(const Field& x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const Variable& x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const Monomial& x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const Term& x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const RuleID & x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::put(const GroebnerRule & x) {
  if(d_count<=0) errorc(__LINE__);
  d_sink << x;
  --d_count;
};

void CountSink::vShouldBeEnd() {
  errorc(__LINE__);
};

void CountSink::errorh(int n) { DBGH(n); };

void CountSink::errorc(int n) { DBGC(n); };
