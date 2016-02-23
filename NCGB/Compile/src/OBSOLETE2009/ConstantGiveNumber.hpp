// Mark Stankus 1999 (c)
// ConstantGiveNumber.hpp

#ifndef INCLUDED_CONSTANTGIVENUMBER_H
#define INCLUDED_CONSTANTGIVENUMBER_H

#pragma warning(disable:4786)

#include "GiveNumber.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

using namespace std;


class Polynomial;
class GroebnerRule;

class ConstantGiveNumber : public GiveNumber {
public:
  ConstantGiveNumber() {};
  virtual ~ConstantGiveNumber();
  virtual int operator()(const Polynomial &);
  virtual const GroebnerRule & fact(int num) const;
  virtual GiveNumber * clone() const;
  virtual const vector<int> & perm_numbers() const;
  virtual void setNotPerm(int);
  virtual void setPerm(int);
};
#endif
