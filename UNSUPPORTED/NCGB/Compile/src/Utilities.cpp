// Utilities.c

#pragma warning(disable:4786)
#include <algorithm>
#include "Utilities.hpp"
#include "RuleInformation.hpp"
#include "GroebnerRule.hpp"
#include "Field.hpp"
#include "expandVector.hpp"
#include "MyOstream.hpp"

int Utilities::s_computeDegree(const GroebnerRule & r) {
  int result = r.LHS().numberOfFactors();
  const Polynomial & p = r.RHS();
  int n = s_computeDegree(p);
  return result>n ? result : n;
};

int Utilities::s_computeTipNumber(const GroebnerRule &) {
  return 1;
};

int Utilities::s_computeTipNumber(const Polynomial&) {
  return 1;
};

int Utilities::s_computeDegree(const Polynomial & p) {
  int result = -1;
  const int sz = p.numberOfTerms();
  PolynomialIterator w = p.begin();
  int n;
  for(int i=1;i<=sz;++i,++w) {
    n = (*w).MonomialPart().numberOfFactors();
    if(n>result) result = n;
  }
  return result;
};

int Utilities::s_computeLeafCount(const GroebnerRule & r) {
  int result = r.LHS().numberOfFactors();
  const Polynomial & p = r.RHS();
  return result + s_computeLeafCount(p);
};

int Utilities::s_computeLeafCount(const Polynomial & p) {
  int result = 0;
  const int sz = p.numberOfTerms();
  PolynomialIterator w = p.begin();
  for(int i=1;i<=sz;++i,++w) {
    result += (*w).MonomialPart().numberOfFactors();
  }
  return result;
};

int Utilities::s_computeVariableCount(const GroebnerRule & r) {
  vector<int> flags;
  int result = 0;
  s_computeVariableMonomial(result,flags,r.LHS());
  const Polynomial & p = r.RHS();
  const int sz = p.numberOfTerms();
  PolynomialIterator w = p.begin();
  for(int i=1;i<=sz;++i,++w) {
    s_computeVariableMonomial(result,flags,(*w).MonomialPart());
  }
  return result;
};

int Utilities::s_computeVariableCount(const Polynomial & p) {
  vector<int> flags;
  int result = 0;
  const int sz = p.numberOfTerms();
  PolynomialIterator w = p.begin();
  for(int i=1;i<=sz;++i,++w) {
    s_computeVariableMonomial(result,flags,(*w).MonomialPart());
  }
  return result;
};

void Utilities::s_computeVariableMonomial(int & result,vector<int> & vec,const Monomial & m) {
  const int sz = m.numberOfFactors();
  MonomialIterator w = m.begin();
  int n;
  for(int i=1;i<=sz;++i,++w) {
    n = (*w).stringNumber();
    if(n>=0) {
      if(n>(int)vec.size()) expandVector(vec,n,0);
      if(vec[n]==0) {
        ++result;
      };
      ++vec[n];
    };
  };
};

int Utilities::s_computeMultiplicity(const GroebnerRule &) {
  DBG();
  return 0;
};

int Utilities::s_computeMultiplicity(const Polynomial &) {
  DBG();
  return 0;
};

void Utilities::s_computeVariablesLHS(vector<int> & V,const GroebnerRule & r) {
  int n;
  s_computeVariableMonomial(n,V,r.LHS());
};

void Utilities::s_computeFirstOccuranceLHS(vector<int> & vec,
        const GroebnerRule & r) {
  const Monomial & m = r.LHS();
  const int sz = m.numberOfFactors();
  MonomialIterator w = m.begin();
  int n;
  for(int i=1;i<=sz;++i,++w) {
    n = (*w).stringNumber();
    if(n>=0) {
      if(n>(int)vec.size()) expandVector(vec,n,-1);
      if(vec[n]==-1) {
        vec[n] = i; 
      };
    };
  };
};

void Utilities::s_computeDoubleCounts(vector<int> & vec,
              const GroebnerRule & r) {
  const Monomial & m = r.LHS();
  const int sz = m.numberOfFactors();
  MonomialIterator w = m.begin();
  if(sz>2) {
    int first,second;
    first = (*w).stringNumber();
    first = first >= RuleInformation::s_number_primes ? 
                     RuleInformation::s_number_primes-1 : first; 
    first = RuleInformation::s_primes[first];
    ++w;
    for(int i=2;i<sz;++i,++w) {
      second = (*w).stringNumber();
      second = second >= RuleInformation::s_number_primes ? 
                         RuleInformation::s_number_primes-1 : second; 
      second = RuleInformation::s_primes[second];
      vec.push_back(first*second);
      first = second;
    };
  };
  sort(vec.begin(),vec.end());
};

int Utilities::s_computeMinimalSupport(const Polynomial &,vector<Monomial> &) {
  DBG();
  return *(int *)0;
};

INTEGER  Utilities::s_NegOne(-1L);
