// Utilities.h

#ifndef INCLUDED_UTILITIES_H
#define INCLUDED_UTILITIES_H

class GroebnerRule;
class Polynomial;
#include "Choice.hpp"
#ifdef OLD_GCC
#include "Monomial.hpp"
#else
class Monomial;
#endif
#include "AltInteger.hpp"
//#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

struct Utilities {
  static int s_computeDegree(const GroebnerRule &);
  static int s_computeMultiplicity(const GroebnerRule &);
  static int s_computeLeafCount(const GroebnerRule &);
  static int s_computeVariableCount(const GroebnerRule &);
  static void s_computeVariablesLHS(vector<int> &,const GroebnerRule &);
  static void s_computeFirstOccuranceLHS(vector<int> &,const GroebnerRule &);

  static int s_computeDegree(const Polynomial &);
  static int s_computeMultiplicity(const Polynomial &);
  static int s_computeLeafCount(const Polynomial &);
  static int s_computeVariableCount(const Polynomial &);
  static int s_computeTipNumber(const GroebnerRule &);
  static int s_computeTipNumber(const Polynomial &);
  static int s_computeMinimalSupport(const Polynomial &,vector<Monomial> &);
  static bool s_isInMinimalSupport(const Monomial &,const vector<Monomial> &);

  static void s_computeVariableMonomial(int &,vector<int> &,const Monomial &);
  static void s_computeDoubleCounts(vector<int> & vec,const GroebnerRule & r);

  static INTEGER s_NegOne;
};
#endif
