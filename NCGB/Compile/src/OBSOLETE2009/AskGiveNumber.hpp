// Mark Stankus 1999 (c)
// AskGiveNumber.hpp

#ifndef INCLUDED_ASKGIVENUMBER_H
#define INCLUDED_ASKGIVENUMBER_H

#pragma warning(disable:4786)

#include "Choice.hpp"
#include "GiveNumber.hpp"

template<class T>
class AskGiveNumber : public GiveNumber {
  T & d_askee;
public:
  AskGiveNumber(T & askee) : d_askee(askee) {};
  virtual ~AskGiveNumber();
  virtual int operator()(const Polynomial &);
  virtual const GroebnerRule & fact(int num) const;
  virtual GiveNumber * clone() const;
  virtual const vector<int> & perm_numbers() const;
  virtual void setNotPerm(int);
  virtual void setPerm(int);
};
#endif
