// (c) Mark Stankus 1999
// RuleSet.h

#ifndef INCLUDED_RULESET_H
#define INCLUDED_RULESET_H

#pragma warning(disable:4786)
#include "RuleID.hpp"
#include "vcpp.hpp"

class RuleSet {
protected:
  int d_largest;
public:
  RuleSet() : d_largest(-1) {};
  virtual ~RuleSet() = 0;
  virtual RuleSet * clone() const = 0;
  virtual void insert(const RuleID & x) = 0;
  int largestSoFar() const { 
    return d_largest;
  };
  virtual void print(MyOstream & os) const = 0;
};
#endif
