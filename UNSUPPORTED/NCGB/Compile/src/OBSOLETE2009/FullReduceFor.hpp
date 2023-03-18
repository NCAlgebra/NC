// (c) Mark Stankus 1999
// FullReduceFor.h

#ifndef INCLUDED_FULLREDUCEFOR_H
#define INCLUDED_FULLREDUCEFOR_H

#include "Reduce.hpp"

class FullReduceFor : public Reduce {
  FullReduceFor(const FullReduceFor&);
    // not implemented
  void operator=(const FullReduceFor &);
    // not implemented
  Reduce & d_x;
public:
  FullReduceFor(Reduce & x) : Reduce(true), d_x(x) {};
  virtual ~FullReduceFor();
  virtual bool reduce(Polynomial &) const;
  virtual void insert(const RuleID &);
  virtual void remove(const RuleID &);
  virtual void print(MyOstream&) const;
  virtual History * history() const;
};
#endif 
