// Mark Stankus 1999 (c)
// GiveNumber.hpp

#ifndef INCLUDED_GIVENUMBER_H
#define INCLUDED_GIVENUMBER_H

//#pragma warning(disable:4786)

#include "Choice.hpp"

#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

using namespace std;


class Polynomial;
class GroebnerRule;

class GiveNumber {
protected:
  int d_number_facts;
  int d_number_perm_facts;
public:
  GiveNumber() : d_number_facts(0), d_number_perm_facts(0) {};
  virtual ~GiveNumber() = 0;
  virtual int operator()(const Polynomial &) = 0;
  virtual const GroebnerRule & fact(int num) const = 0;
  virtual GiveNumber * clone() const = 0;
  virtual const vector<int> & perm_numbers() const = 0;
  virtual void setNotPerm(int) = 0;
  virtual void setPerm(int) = 0;
  int numberFacts() const { return d_number_facts;};
  int numberOfPermanentFacts() const { return d_number_perm_facts;};
};
#endif
