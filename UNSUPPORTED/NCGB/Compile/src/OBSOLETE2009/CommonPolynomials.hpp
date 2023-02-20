// Mark Stankus (c) 1999
// CommonPolynomials.hpp

#ifndef INCLUDED_COMMONPOLYNOMIALS_H
#define INCLUDED_COMMONPOLYNOMIALS_H

#include "PolySource.hpp"
#include "Choice.hpp"
#include "RuleID.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <vector>
#else
#include <list.h>
#include <vector.h>
#endif
class PolynomialData;
#include "GroebnerRule.hpp"

class CommonPolynomials : public PolySource {
  class Status {
    int d_n;
  public:
    static const int s_UNREDUCED;
    static const int s_REDUCED;
    static const int s_CIRCLEREDUCED;

    Status() : d_n(s_UNREDUCED) {};
    Status(const Status & x) : d_n(x.d_n) {};
    virtual ~Status(){};
    void operator=(const Status & x) { d_n = x.d_n;};
    bool operator==(const Status & x) { return d_n==x.d_n;};
    bool operator!=(const Status & x) { return d_n!=x.d_n;};

    void setUNREDUCED() { d_n = s_UNREDUCED;};
    void setREDUCED() { d_n = s_REDUCED;};
    void setCIRCLEREDUCED() { d_n = s_REDUCED;};
    int status() const { return d_n;}
  };
  list<RuleID> d_polys;
  list<Status> d_status;
  vector<int> d_vec;
  int d_num;
  GroebnerRule * d_rule_p;
public:
  CommonPolynomials() : PolySource(s_ID), d_num(0), 
      d_rule_p(new GroebnerRule) {};
  virtual ~CommonPolynomials();
  virtual bool getNext(Polynomial & p,Tag *,Tag & limit);
  virtual void insert(const RuleID & x);
  virtual void insert(const PolynomialData & x);
  virtual void remove(const RuleID & x);
  virtual void print(MyOstream &) const; 
  virtual void fillForUnknownReason();
  virtual void setPerm(int);
  virtual void setNotPerm(int);
  bool reduce(list<RuleID>::const_iterator & x);
  int findInt(const Polynomial &);
  int findInt(const RuleID & x);
  const GroebnerRule & fact(int num) const;
  const vector<int> & perm_numbers() const {
    return d_vec;
  };
  static const int s_ID;
};
#endif
