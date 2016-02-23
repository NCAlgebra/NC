#ifndef INCLUDED_VARIABLE_H
// DO NOT DO #define INCLUDED_VARIABLE_H
#include "ChoiceVariable.hpp"
#ifdef USE_OLD_VARIABLE
#include "oVariable.hpp"
#endif
#ifdef USE_N_VARIABLE
#include "nVariable.hpp"
#endif
#ifdef USE_NN_VARIABLE
#include "nnVariable.hpp"
#endif

class CompareOnStringNumber {
public:
  bool operator()(const Variable & v,const Variable & w) const {
    return v.stringNumber() < w.stringNumber();
  };
};
#endif
