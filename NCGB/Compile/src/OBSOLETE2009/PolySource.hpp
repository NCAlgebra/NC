// (c) Mark Stankus 1999
// PolySource.h

#ifndef INCLUDED_POLYSOURCE_H
#define INCLUDED_POLYSOURCE_H

class Polynomial;
class RuleID;
class MyOstream;
class Tag;
class PolynomialData;
class Polynomial;
class ReductionHint;

class PolySource {
  int d_ID;
protected:
  PolySource(int id) : d_ID(id) {};
public:
  virtual ~PolySource() = 0;
  int ID() const { return d_ID;};
  virtual bool getNext(Polynomial & p,ReductionHint &,Tag *,Tag & limit) = 0;
  virtual void insert(const RuleID &) = 0;
  virtual void insert(const PolynomialData &) = 0;
  virtual void remove(const RuleID &) = 0;
  virtual void fillForUnknownReason() = 0;
  virtual void print(MyOstream &) const = 0;
  virtual void setPerm(int) = 0;
  virtual void setNotPerm(int) = 0;
};
#endif
