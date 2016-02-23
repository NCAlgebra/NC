// (c) Mark Stankus 1999
// AdmReduce.h
#ifndef INCLUDED_ADMREDUCE_H 
#define INCLUDED_ADMREDUCE_H

#include "Reduce.hpp"
#include "AdmRuleSet.hpp"
class AdmissibleOrder;

class AdmReduce : public Reduce {
  AdmReduce(const AdmReduce&);
    // not implemented
  void operator=(const AdmReduce &);
    // not implemented
  AdmissibleOrder & d_ord;
  AdmRuleSet d_rules;
public:
  AdmReduce(AdmissibleOrder & ord) : Reduce(true), d_ord(ord),d_rules(ord) {};
  virtual ~AdmReduce();
    // return value answers: did it change?
  virtual bool reduce(Polynomial &) const;
  virtual bool reduce(Polynomial &,Tag*) const;
  virtual void insert(const RuleID &);
  virtual void remove(const RuleID &);
  virtual History * history() const;
  virtual void print(MyOstream&) const;
  const AdmRuleSet & RULES() const { return d_rules;};
};
#endif 
