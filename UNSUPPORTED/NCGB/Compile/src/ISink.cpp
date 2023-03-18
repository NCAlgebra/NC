// (c) Mark Stankus 1999
// ISink.c

#include "ISink.hpp"
#include "Debug1.hpp"

ISink::~ISink() {};

void ISink::put(const Holder&) {
  errorc(__LINE__);
};

void ISink::put(const Field&) {
  errorc(__LINE__);
};

void ISink::put(const Variable&) {
  errorc(__LINE__);
};

void ISink::put(const Monomial&) {
  errorc(__LINE__);
};

void ISink::put(const Term&) {
  errorc(__LINE__);
};

void ISink::put(const RuleID &) {
  errorc(__LINE__);
};

void ISink::put(const Polynomial&) {
  errorc(__LINE__);
};

void ISink::put(const GroebnerRule&) {
  errorc(__LINE__);
};

void ISink::noOutput() {
  ++d_count;
};

bool ISink::verror() const {
  return false;
};

void ISink::errorh(int n) { DBGH(n); };

void ISink::errorc(int n) { DBGC(n); };
