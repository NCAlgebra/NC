// Mark Stankus 1999 (c)
// FCGiveNumber.hpp

#ifndef INCLUDED_FCGIVENUMBER_H
#define INCLUDED_FCGIVENUMBER_H

#include "Choice.hpp"
class FactControl;
#include "GiveNumber.hpp"


class FCGiveNumber : public GiveNumber {
  FactControl & d_fc;
  mutable vector<int> * d_vec_p;
public:
  FCGiveNumber(FactControl & fc) : d_fc(fc), d_vec_p(0) {};
  virtual ~FCGiveNumber();
  virtual int operator()(const Polynomial &);
  virtual const GroebnerRule & fact(int num) const;
  virtual GiveNumber * clone() const;
  const FactControl & fc() const { return d_fc;};
  FactControl & fc() { return d_fc;};
  virtual const vector<int> & perm_numbers() const;
  virtual void setNotPerm(int);
  virtual void setPerm(int);
};
#endif
