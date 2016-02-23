// AdmissibleOrder.h

#ifndef INCLUDED_ADMISSIBLEORDER_H
#define INCLUDED_ADMISSIBLEORDER_H

class Monomial;
class Polynomial;
class GroebnerRule;
class Variable;
#include "Choice.hpp"
//#pragma warning(disable:4786)
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#include "VariableSet.hpp"
#include "vcpp.hpp"
#include "CreateOrder.hpp"

class AdmissibleOrder {
  static void errorh(int);
  static void errorc(int);
  AdmissibleOrder();
    // not implemented
  AdmissibleOrder(const AdmissibleOrder &);
    // not implemented
  void operator=(const AdmissibleOrder &);
    // not implemented
private:
  const int d_ID;
  static AdmissibleOrder * s_Current_p;
protected:
  explicit AdmissibleOrder(int id) : d_ID(id){};
public:
  virtual ~AdmissibleOrder();
  virtual bool verify(const GroebnerRule &) const = 0;
  virtual bool verify(const Polynomial &) const = 0;
  virtual bool variableLess(const Variable &,const Variable &) const = 0;
  virtual bool monomialLess(const Monomial &,const Monomial &) const = 0;
  virtual void ClearOrder() = 0;
  virtual void PrintOrder(MyOstream &) const = 0;
  bool monomialGreater(const Monomial & x,const Monomial & y) const {
    return monomialLess(y,x);
  };
  bool monomialLessEqual(const Monomial & x,const Monomial & y) const {
    return !monomialGreater(x,y);
  };
  bool monomialGreaterEqual(const Monomial & x,const Monomial & y) const {
    return !monomialLess(x,y);
  };
  virtual AdmissibleOrder * clone() const = 0;
  virtual const vector<int> & levels() const = 0;
  virtual int multiplicity() const = 0;
  virtual VariableSet variablesInOrder() const = 0;
  static void s_setCurrentClone(AdmissibleOrder *);
  static void s_setCurrentAdopt(AdmissibleOrder *);
  static AdmissibleOrder & s_getCurrent();
  static AdmissibleOrder const * s_getCurrentP();
  static bool s_currentValid();
  int ID() const { return d_ID;};
};

inline AdmissibleOrder & AdmissibleOrder::s_getCurrent() {
  if(!s_Current_p) {
    s_Current_p = CreateOrder();
  };
  return * s_Current_p;
};

inline AdmissibleOrder const * AdmissibleOrder::s_getCurrentP() {
  if(!s_Current_p) {
    s_Current_p = CreateOrder();
  };
  return s_Current_p;
};

inline bool AdmissibleOrder::s_currentValid() {
  return !! s_Current_p;
};
#endif
