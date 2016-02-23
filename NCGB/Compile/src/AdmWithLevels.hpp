// AdmWithLevels.h

#ifndef INCLUDED_ADMWITHLEVELS_H
#define INCLUDED_ADMWITHLEVELS_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
class GroebnerRule;
class Polynomial;
#include "Variable.hpp"
#include "VariableSet.hpp"
#include "GBList.hpp"
#ifndef INCLUDED_ADMISSIBLEORDER_H
#include "AdmissibleOrder.hpp"
#endif

// Lowest level is 1!!!

class AdmWithLevels : public AdmissibleOrder {
  static void errorh(int);
  static void errorc(int);
  AdmWithLevels();
    // not implemented
  void operator=(const AdmWithLevels &);
    // not implemented
  int d_number_known_levels;
protected:
  explicit AdmWithLevels(int id,const vector<vector<Variable> > &);
  AdmWithLevels(const AdmWithLevels & x);
public:
  virtual ~AdmWithLevels();

  void NumberKnownLevels(int i) { d_number_known_levels = i;}
  int NumberKnownLevels() { return d_number_known_levels;}

  virtual void setVariables(const vector<vector<Variable> > &);
  virtual void setVariables(const vector<Variable> &,int n);
  virtual void addVariable(const Variable &,int n);
   
  // VIRTUAL FUNCTIONS
  virtual bool verify(const GroebnerRule & r) const = 0;
  virtual bool verify(const Polynomial &) const = 0;
  virtual bool variableLess(const Variable &,const Variable &) const;
  virtual bool monomialLess(const Monomial &,const Monomial &) const = 0;
  virtual AdmissibleOrder * clone() const = 0;
  virtual void ClearOrder() = 0;
  virtual void PrintOrder(MyOstream &) const = 0;

  void PrintOrderViaString(MyOstream & os,const char * s) const;

  virtual const vector<int> & levels() const;
  virtual int multiplicity() const;

  virtual VariableSet variablesInOrder() const;

  // OTHER FUNCTIONS
  int level(const Monomial &) const;
  int level(const Variable &) const;
  const vector<Variable> & monomialsAtLevel(int n) const {
    return d_v[n-1];
  }; 
  const vector<Variable> & variablesIn() const;
  static const int s_ID;
  const VariableSet & Knowns() const {
    return d_knowns;
  };  
  const VariableSet & Unknowns() const {
    return d_unknowns;
  };
  void sortIntoKnownsAndUnknowns(const VariableSet & x,
    VariableSet & knowns,VariableSet & unknowns) const;
  static bool s_print_knowns_bar;
protected:
  vector<vector<Variable> > d_v;
  vector<int> _stringNumberToLevel;
  void error1(const Variable &) const;
  VariableSet d_knowns;
  VariableSet d_unknowns;
};
#endif 
