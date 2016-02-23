// (c) Mark Stankus 1999
// PDReduce.h

#ifndef INCLUDED_PDREDUCE_H
#define INCLUDED_PDREDUCE_H

#include "PDReduce.hpp"
class Tag;

class PDReduce : public Reduce {
  PDReduce();
    // not implemented
  PDReduce(const PDReduce &);
    // not implemented
  void operator=(const Reduce &);
    // not implemented
  bool d_tip;
public:
  PDReduce() : Reduce(true) {};
  virtual ~Reduce() = 0;
    // return value answers: did it change?
  virtual void reduce(Polynomial &) const;
  virtual void reduce(Polynomial &,Tag *) const;
  virtual void insert(const RuleID &);
  virtual void remove(const RuleID &);
  bool tipReduction() const {
    return d_tip;
  };
  Reduce * make_full() const;
};
#endif 
