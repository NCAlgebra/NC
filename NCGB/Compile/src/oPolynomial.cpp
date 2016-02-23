// Polynomial.c

#include "Polynomial.hpp"
#include "RecordHere.hpp"
#include "AdmissibleOrder.hpp"
#include "VariableSet.hpp"
#ifndef INCLUDED_LOAD_FLAGS_H
#include "load_flags.hpp"
#endif
#include "MyOstream.hpp"
#include "GBStream.hpp"
#ifndef INCLUDED_OUTERM_H
#include "OuTerm.hpp"
#endif

//#define CHECK_FOR_ZERO_COEFFICIENTS

#ifndef INCLUDED_ADMISSIBLEORDER_H
#include "AdmissibleOrder.hpp"
#endif

MyOstream & operator << (MyOstream & os,const Polynomial & x) { 
  PolynomialIterator i = x.begin();
  const int len = x.numberOfTerms();
  if(len==0) {
    os << '0';
  } else {
    OuTerm::NicePrint(os,*i);
    ++i;
    for(int k=2;k<=len;++k,++i) {
      const Term & t = *i;
      if(t.CoefficientPart().sgn()<=0) {
        os << " - ";
        OuTerm::NicePrint(os,- t);
      } else {
        os << " + ";
        OuTerm::NicePrint(os,t);
      }
    }
  }
  return os;
};

void Polynomial::printNegative(MyOstream & os) {
  PolynomialIterator i = begin();
  const int len = numberOfTerms();
  if(len==0) {
    os << '0';
  } else {
    OuTerm::NicePrint(os,-*i);
    ++i;
    for(int k=2;k<=len;++k,++i) {
      const Term & t = *i;
      if(t.CoefficientPart().sgn()<=0) {
        os << " + ";
        OuTerm::NicePrint(os,- t);
      } else {
        os << " - ";
        OuTerm::NicePrint(os,-t);
      }
    }
  }
};

Polynomial::Polynomial(const Polynomial & RightSide) :
    _terms(RightSide._terms) , _numberOfTerms(RightSide._numberOfTerms)
   ,_totalDegree(RightSide._totalDegree) { };

void Polynomial::setToOne() {
   setToZero();
   operator =(Term::s_TERM_ONE);
   if(AdmissibleOrder::s_getCurrentP()==0) {
     GBStream << "Invalid order pointer.\n";
     errorc(__LINE__);
   }
};

#if 0
void Polynomial::operator -= (const Term & aTERM) {
  reOrderPolynomial();
  if(!aTERM.CoefficientPart().zero()) {
    const int num = numberOfTerms();
    if(num==0) {
      addTermToEnd(-aTERM);
    } else {
      PolynomialIterator iter = begin();
      bool shouldLoop = true;
      int cmp=-999; // a bogus value to get around compiler warning
      int place = 1;
      for (int i=1; i<=num && shouldLoop; ++i) { 
        cmp = compareTwoMonomials(aTERM.MonomialPart(),
                                  (*iter).MonomialPart());
        shouldLoop = cmp<0;
        if(shouldLoop) {
          ++place;++iter;
        }
      }
      // Either we are at the monomial or past it
#if 0
// slow data integrity check for debugging
if(!shouldLoop) {
PolynomialIterator tempiter = _terms.begin();
tempiter.advance(place-1);
if((*tempiter)!=(*iter)) errorc(__LINE__);
};
#endif
      // If we are on the monomial
      if(cmp==0) {
#ifdef DEBUG_POLY_ARITH
        if((*iter).MonomialPart()!=aTERM.MonomialPart()) errorc(__LINE__);
#endif
        // Compute new coefficient
        Field newCoeff;
        newCoeff = (*iter).CoefficientPart() - aTERM.CoefficientPart();
        // If new coefficient is zero, eliminate, else modify
        if(newCoeff.zero()) {
          _terms.removeElement(place);
          _numberOfTerms--;
          if(aTERM.MonomialPart().numberOfFactors()==_totalDegree) {
            recomputeTotalDegree();
          }
        } else {
           InternalContainerType::iterator w = _terms.begin();
           w.advance(place-1);
#ifdef DEBUG_POLY_ARITH
           if((*w).MonomialPart()!=aTERM.MonomialPart()) {
             GBStream << "*w:" << *w << '\n';
             GBStream << "aTERM:" << aTERM << '\n';
             GBStream << "place:" << place << '\n';
             GBStream << "*this:" << *this << '\n';
             errorc(__LINE__);
           }
#endif
           (*w).CoefficientPart(newCoeff);
        }
      } else if(place<=num) {
        // We are at a monomial higher with respect to compareTwoMonomials
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
if(aTERM.CoefficientPart().zero()) errorc(__LINE__);
#endif
        _terms.addElement(aTERM, place);
        _numberOfTerms++;
        if(_totalDegree<aTERM.MonomialPart().numberOfFactors()) {
          _totalDegree = aTERM.MonomialPart().numberOfFactors();
        }
      } else // shouldLoop is True here 
      {
        // The new term goes at the end of the list.
        addTermToEnd(aTERM);
      }
    }
  }
#if 0
  // slow data integrity check for debugging
  // A double check...REALLY SLOW
  const int finalsz = _numberOfTerms;
  PolynomialIterator iter = begin();
  for(int ell=1;ell<=finalsz;++ell,++iter) {
    if((*iter).CoefficientPart().zero()) errorc(__LINE__);
  };
#endif
};
#endif

#if 0
void Polynomial::operator += (const Term & aTERM) {
  reOrderPolynomial();
  if(!aTERM.CoefficientPart().zero()) {
    const int num = numberOfTerms();
    if(num==0) {
      addTermToEnd(aTERM);
    } else {
      PolynomialIterator iter = begin();
      bool shouldLoop = true;
      int cmp=-999; // a bogus value to get around compiler warning
      int place = 1;
      for (int i=1; i<=num && shouldLoop; ++i) { 
        cmp = compareTwoMonomials(aTERM.MonomialPart(),
                                  (*iter).MonomialPart());
        shouldLoop = cmp<0;
        if(shouldLoop) {
          ++place;++iter;
        }
      }
      // Either we are at the monomial or past it
#if 0
// slow data integrity check for debugging
if(!shouldLoop) {
PolynomialIterator tempiter = _terms.begin();
tempiter.advance(place-1);
if((*tempiter)!=(*iter)) errorc(__LINE__);
};
#endif
      // If we are on the monomial
      if(cmp==0) {
#ifdef DEBUG_POLY_ARITH
        if((*iter).MonomialPart()!=aTERM.MonomialPart()) errorc(__LINE__);
#endif
        // Compute new coefficient
        Field newCoeff;
        newCoeff = (*iter).CoefficientPart() + aTERM.CoefficientPart();
        // If new coefficient is zero, eliminate, else modify
        if(newCoeff.zero()) {
          _terms.removeElement(place);
          _numberOfTerms--;
          if(aTERM.MonomialPart().numberOfFactors()==_totalDegree) {
            recomputeTotalDegree();
          }
        } else {
           InternalContainerType::iterator w = _terms.begin();
           w.advance(place-1);
#ifdef DEBUG_POLY_ARITH
           if((*w).MonomialPart()!=aTERM.MonomialPart()) {
             GBStream << "*w:" << *w << '\n';
             GBStream << "aTERM:" << aTERM << '\n';
             GBStream << "place:" << place << '\n';
             GBStream << "*this:" << *this << '\n';
             errorc(__LINE__);
           }
#endif
           (*w).CoefficientPart(newCoeff);
        }
      } else if(place<=num) {
        // We are at a monomial higher with respect to compareTwoMonomials
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
if(aTERM.CoefficientPart().zero()) errorc(__LINE__);
#endif
        _terms.addElement(aTERM, place);
        _numberOfTerms++;
        if(_totalDegree<aTERM.MonomialPart().numberOfFactors()) {
          _totalDegree = aTERM.MonomialPart().numberOfFactors();
        }
      } else // shouldLoop is True here 
      {
        // The new term goes at the end of the list.
        addTermToEnd(aTERM);
      }
    }
  }
#if 0
  // slow data integrity check for debugging
  // A double check...REALLY SLOW
  const int finalsz = _numberOfTerms;
  PolynomialIterator iter = begin();
  for(int ell=1;ell<=finalsz;++ell,++iter) {
    if((*iter).CoefficientPart().zero()) errorc(__LINE__);
  };
#endif
};
#endif

#define FASTARITH

#ifndef FASTARITH
void Polynomial::operator += (const Polynomial & bPolynomial) {
  PolynomialIterator i = bPolynomial.begin();
  const int len = bPolynomial.numberOfTerms();
  for(int j=1;j<=len;++j,++i) {
     operator += (*i); 
  }
};
#else
// INEFFICIENT

void Polynomial::operator +=(const Polynomial & p) {
//GBStream << *this << "+=" << p << '\n';
  if(!p.zero()) {
    if(zero()) {
      operator =(p);
    } else {
      Polynomial temp(*this);
      setToZero();
      const int sz1 = temp.numberOfTerms();
      const int sz2 = p.numberOfTerms();
      PolynomialIterator w1 = temp.begin();
      PolynomialIterator w2 = p.begin();
      int i1=1;
      int i2=1;
      Term t1 = * w1;
      Term t2 = * w2;
      while(i1<=sz1 && i2<=sz2) {
        int cmp = compareTwoMonomials(t1.MonomialPart(),t2.MonomialPart());
//GBStream << "Add: cmp is " << cmp << '\n';
        if(cmp==0) {
          t1.Coefficient() += t2.CoefficientPart();
          if(!t1.CoefficientPart().zero()) {
//GBStream << "Adding element" << TERM(c,t1.MonomialPart()) << '\n';
            addTermToEnd(t1);
          }
          ++w1; ++i1; 
          ++w2; ++i2;
          if(i1<=sz1 && i2<=sz2) {
            t1 = * w1;
            t2 = * w2;
          }
        } else if(cmp<0) {
//GBStream << "Adding element" << t2 << '\n';
          addTermToEnd(t2);
          ++w2; ++i2;
          if(i2<=sz2) t2 = * w2;
        } else // if(cmp>0)
        {
//GBStream << "Adding element" << t1 << '\n';
          addTermToEnd(t1);
          ++w1; ++i1;
          if(i1<=sz1) t1 = * w1;
        }
      }
      for(;i1<=sz1;++i1,++w1) {
//GBStream << "Adding element" << *w1 << '\n';
        addTermToEnd(*w1);
      }
      for(;i2<=sz2;++i2,++w2) {
//GBStream << "Adding element" << *w2 << '\n';
        addTermToEnd(*w2);
      }
    }
  }
};
#endif
#ifdef FASTARITH
void Polynomial::operator -=(const Polynomial & p) {
  if(!p.zero()) {
#if 0
    if(zero()) {
      InternalContainerType::iterator w = _terms.begin();
      const int sz = numberOfTerms();
      for(int i=1;i<=sz;++i,++w) {
        (*w).Coefficient() = -1;
      }
    } else {
#endif
      Polynomial temp(*this);
      setToZero();
      const int sz1 = temp.numberOfTerms(); 
      const int sz2 = p.numberOfTerms(); 
      PolynomialIterator w1 = temp.begin();
      PolynomialIterator w2 = p.begin();
      int i1=1;
      int i2=1;
#if 1
if(sz1>0) {
#endif
      Term t1 = * w1;
      Term t2 = * w2;
      while(i1<=sz1 && i2<=sz2) {
        int cmp = compareTwoMonomials(t1.MonomialPart(),t2.MonomialPart());
//GBStream << "Subtract: cmp is " << cmp << '\n';
        if(cmp==0) {
          t1.Coefficient() -= t2.CoefficientPart();
          if(!t1.Coefficient().zero()) {
//GBStream << "-=: Adding element" << TERM(c,t1.MonomialPart()) << '\n';
            addTermToEnd(t1);
          }
          ++w1; ++i1;
          ++w2; ++i2;
          if(i1<=sz1 && i2<=sz2) {
            t1 = * w1;
            t2 = * w2;
          }
        } else if(cmp<0) {
//GBStream << "-=Adding element" << t2 << '\n';
          addTermToEnd(-t2);
          ++w2; ++i2;
          if(i2<=sz2) t2 = * w2;
        } else // if(cmp>0)
        {
//GBStream << "-=Adding element" << t1 << '\n';
          addTermToEnd(t1);
          ++w1; ++i1;
          if(i1<=sz1) t1 = * w1;
        }
      }
#if 1
}
#endif
      for(;i1<=sz1;++i1,++w1) {
//GBStream << "-=Adding element" << *w1 << '\n';
        addTermToEnd(*w1);
      }
      for(;i2<=sz2;++i2,++w2) {
//GBStream << "-=Adding element" << -*w2 << '\n';
        addTermToEnd(-(*w2));
      }
#if 0
    }
#endif
  }
};
#else 
// INEFFICIENT
void Polynomial::operator -= (const Polynomial & bPolynomial) {
  PolynomialIterator i = bPolynomial.begin();
  const int len = bPolynomial.numberOfTerms();
  for(int j=1;j<=len;++j,++i) {
    operator -= (*i); 
  }
};
#endif

void Polynomial::variablesIn(VariableSet & result) const {
  const int len = numberOfTerms();
  // Bypass the reordering of the polynomial
  PolynomialIterator j = _terms.begin();
  for(int i=1;i<=len&&!result.full();++i,++j) {
    (*j).MonomialPart().variablesIn(result);
  }
};

bool Polynomial::operator==(const Polynomial & x) const {
  bool result = true;
  if(this!=&x) {
    const int num = numberOfTerms();
    if(num!=x.numberOfTerms()) {
      result = false;
    } else {
      PolynomialIterator j = begin();
      PolynomialIterator k = x.begin();
      for (int i=1;i<=num;++i,++j,++k) {
        if((*j)!=(*k)) {
          result = false;
          break;
        };
      };
    };
  };
  return result;
};

void Polynomial::doubleProduct(const Field & f,const Monomial & x,
        const Polynomial &  poly,const Monomial & y) {
  if(&poly==this) errorc(__LINE__);
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
GBStream << "MXS:doubleProduct:poly:" << poly << '\n';
GBStream << "MXS:doubleProduct:aTerm:" << aTerm << '\n';
GBStream << "MXS:doubleProduct:bTerm:" << bTerm << '\n';
#endif
  setToZero();
  if(!f.zero())  {
    const int sz = poly.numberOfTerms();
    PolynomialIterator w = poly.begin();
    Term t;
    for(int i=1;i<=sz;++i,++w) {
      t = *w;
      t.Coefficient() *= f;
      Monomial & m = t.MonomialPart();
      Monomial result(x);
      result *= m;
      result *= y;
      m = result;
      addTermToEnd(t);
    }
  }
};  

void Polynomial::doubleProduct(const Monomial & x,
        const Polynomial &  poly,const Monomial & y) {
  if(&poly==this) errorc(__LINE__);
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
GBStream << "MXS:doubleProduct:poly:" << poly << '\n';
GBStream << "MXS:doubleProduct:aTerm:" << aTerm << '\n';
GBStream << "MXS:doubleProduct:bTerm:" << bTerm << '\n';
#endif
  setToZero();
  const int sz = poly.numberOfTerms();
  PolynomialIterator w = poly.begin();
  Term result;
  for(int i=1;i<=sz;++i,++w) {
    result.assign(x);
    result *= (*w);
    result *= y;
    addTermToEnd(result);
  }
};  

int Polynomial::totalDegree() const {
  int save = _totalDegree;
  _totalDegree = 0;
  int temp;
  PolynomialIterator w = _terms.begin();
  int sz = numberOfTerms();
  for(int i=1;i<=sz;++i,++w) {
    temp = (*w).MonomialPart().numberOfFactors();
    if(temp>_totalDegree) _totalDegree = temp;
  }
  if(save!= _totalDegree) {
    WARNStream << "MXS:FIX:Polynomial::_totalDegree "
             << "save: " << save << " actual: " << _totalDegree
             << '\n';
  }
  return _totalDegree;
};

void Polynomial::recomputeTotalDegree() {
  _totalDegree = 0;
  int temp;
  // The following code bypasses possible reordering.
  PolynomialIterator w = 
    ((const GBList<Term> &)_terms).begin();
  int sz = numberOfTerms();
  for(int i=1;i<=sz;++i,++w) {
    temp = (*w).MonomialPart().numberOfFactors();
    if(temp>_totalDegree) _totalDegree = temp;
  }
};

void Polynomial::reOrderPolynomialPrivate() const {
  // fill this code in later
#if 0
  GBStream << 
     "Code for Polynomial::reorderPolynomial needs to be written\n";
#endif
};

int Polynomial::compareTwoMonomials(const Monomial & m1,
                                const Monomial & m2) const {
  int cmp;
  if(m1==m2) {
    cmp = 0;
  } else {
    bool flag = false; // false to prevent warnings from the compiler
    if(false) {
    } else if(isPD()) {
      if(AdmissibleOrder::s_getCurrentP()==0) {
        GBStream << "Invalid order pointer." << '\n';
        errorc(__LINE__);
      }
      flag = AdmissibleOrder::s_getCurrent().monomialGreater(m1,m2);
    } else errorc(__LINE__);
    cmp = flag ? 1 : -1;
  }
  return cmp;
};

void Polynomial::error1(int index) const {
  GBStream << "The " << index << "th term was requested.\n";
  errorc(__LINE__);
};

void Polynomial::error2(int index) const {
  GBStream << "The " << index << "th term was requested.\n";
  GBStream << "There are only " << numberOfTerms() << " terms.\n";
  errorc(__LINE__);
};

void Polynomial::operator *= (const Field & aNumber) {
  if(!aNumber.zero()) {
    InternalContainerType::iterator w= _terms.begin();
    int sz = _terms.size();
    for(int i=1;i<=sz;++i,++w) {
      (*w).Coefficient() *= aNumber;
    };
  };
};

void Polynomial::addNewLastTerm(const Term & t) {
  PolynomialIterator w(begin());
  const int sz = numberOfTerms();
  if(sz>0) {
    for(int i=1;i<sz;++i,++w) {};
    const Monomial & m = (*w).MonomialPart();
    if(AdmissibleOrder::s_getCurrent().monomialGreater(t.MonomialPart(),m)) {
      errorc(__LINE__);
    };
    if(t.MonomialPart()==m) {
      errorc(__LINE__);
    };
  };
  addTermToEnd(t);
};

void Polynomial::removetip(const Term & t) {
  if(t!=*begin()) errorc(__LINE__);
  _terms.removeElement(1);
  _numberOfTerms--;
};

Term Polynomial::removetip() {
  Term t(*begin());
  _terms.removeElement(1);
  _numberOfTerms--;
  return t;
};

void Polynomial::Removetip() {
  _terms.removeElement(1);
  _numberOfTerms--;
};

void Polynomial::setWithList(const list<Term> & x) {
  setToZero();
  typedef list<Term>::const_iterator LI;
  LI w(x.begin()), e(x.end());
  Polynomial p;
  while(w!=e) {
    p = *w;
    operator +=(p);
    ++w;
  };
};

void Polynomial::errorh(int n) { DBGH(n); };

void Polynomial::errorc(int n) { DBGC(n); };
