// Mark Stankus 1999 (c)
// ConstantGiveNumber.cpp

#include "ConstantGiveNumber.hpp"

ConstantGiveNumber::~ConstantGiveNumber() {};

int ConstantGiveNumber::operator()(const Polynomial &) {
  return 0;
};

const GroebnerRule & ConstantGiveNumber::fact(int num) const{
  return *((GroebnerRule*) 0);
};

GiveNumber * ConstantGiveNumber::clone() const {
  return (GiveNumber *) 0;
};

const vector<int> & ConstantGiveNumber::perm_numbers() const {
  return *((vector<int> *) 0);
};

void ConstantGiveNumber::setNotPerm(int) {};

void ConstantGiveNumber::setPerm(int) {};
