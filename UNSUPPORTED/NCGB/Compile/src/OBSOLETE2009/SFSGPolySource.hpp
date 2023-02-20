// (c) Mark Stankus 1999
// SFSGPolySource.h

#ifndef INCLUDED_SFSGPOLYSOURCE_H
#define INCLUDED_SFSGPOLYSOURCE_H

#include "BiMap.hpp"
#include "PolySource.hpp"
#include "BiMap.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "SFSGExtra.hpp"
#include "ByAdmissible.hpp"
class Tag;
class Polynomial;
class RuleID;
class PolynomialData;
class MyOstream;

class SFSGPolySource : public PolySource {
  typedef BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> BIMAP;
  BIMAP d_M;
public:
  SFSGPolySource(BIMAP & M) : PolySource(s_ID), d_M(M) {};
  virtual ~SFSGPolySource();
  virtual bool getNext(Polynomial & p,ReductionHint &,Tag *,Tag & limit);
  virtual void insert(const RuleID &);
  virtual void insert(const PolynomialData &);
  void insert(const Polynomial &);
  virtual void remove(const RuleID &);
  virtual void fillForUnknownReason();
  virtual void print(MyOstream &) const;
  virtual void setPerm(int);
  virtual void setNotPerm(int);
  static const int s_ID;
private:
  void goforit(const BIMAP::PAIR &,const BIMAP::PAIR &,list<Polynomial> &);
};
#endif
