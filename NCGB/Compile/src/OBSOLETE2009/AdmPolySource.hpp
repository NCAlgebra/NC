// (c) Mark Stankus 1999
// AdmPolySource.h

#ifndef INCLUDED_ADMPOLYSOURCE_H
#define INCLUDED_ADMPOLYSOURCE_H

#include "PolySource.hpp"
#include "AdmRuleSet.hpp"

class AdmPolySource : public PolySource {
  static void errorh(int);
  static void errorc(int);
  AdmPolySource(const AdmPolySource & x);
    // not implemented
  void operator=(const AdmPolySource &);
    // not implemented
  const AdmissibleOrder & d_ord;
  AdmRuleSet d_rset;
public:
  AdmPolySource(const AdmissibleOrder & ord,const AdmRuleSet & rset); 
  virtual ~AdmPolySource();
  virtual bool getNext(Polynomial & p,Tag*,Tag&);
  virtual void insert(const RuleID &);
  virtual void insert(const PolynomialData &);
  virtual void remove(const RuleID &);
  virtual void fillForUnknownReason();
  virtual void print(MyOstream &) const;
  virtual void setPerm(int);
  virtual void setNotPerm(int);
  static const int s_ID;
};
#endif
