// (c) Mark Stankus 1999
// Reduce.h

#ifndef INCLUDED_REDUCE_H
#define INCLUDED_REDUCE_H

class Polynomial;
class RuleID;
class History;
class MyOstream;
class Tag;

class Reduce {
  Reduce();
    // not implemented
  Reduce(const Reduce&);
    // not implemented
  void operator=(const Reduce &);
    // not implemented
  bool d_tip;
public:
  Reduce(bool tip) : d_tip(tip) {};
  virtual ~Reduce() = 0;
    // return value answers: did it change?
  virtual bool reduce(Polynomial &) const = 0;
  virtual bool reduce(Polynomial &,Tag *) const = 0;
  virtual void insert(const RuleID &) = 0;
  virtual void remove(const RuleID &) = 0;
  virtual History * history() const = 0;
  bool tipReduction() const {
    return d_tip;
  };
  Reduce * make_full();
  virtual void print(MyOstream &) const = 0;
};
#endif 
