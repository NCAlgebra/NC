// MLex.c

#include "MLex.hpp"
#include "CompareOnDouble.hpp"
#include "RecordHere.hpp"
#include "PrintVector.hpp"
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#include "Debug3.hpp"
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#include "MyOstream.hpp"
#include "GBVector.hpp"

MLex::MLex() : AdmWithLevels(s_ID,*(const vector<vector<Variable> > *)0) { DBG();};

MLex::MLex(const vector<vector<Variable> > & L) : AdmWithLevels(s_ID,L) {};

MLex::MLex(const MLex & x) : AdmWithLevels(x) {};

MLex::~MLex(){};

AdmissibleOrder * MLex::clone() const {
  RECORDHERE(AdmissibleOrder * p = new MLex(*this);)
  return p;
};

extern int s_UPDATEMONOMIAL_COMMAND;
extern int s_SETORDER_COMMAND;
extern int s_COUNTS_COMMAND;

bool MLex::verify(const GroebnerRule & r) const {
  const Polynomial & p = r.RHS();
  bool result = p.zero();
  if(!result) {
     result = monomialLess(r.RHS().tip().MonomialPart(),r.LHS()) && verify(p);
  };
  return result;
};

bool MLex::verify(const Polynomial & p) const {
  Monomial last;
  bool result = true;
  Polynomial q(p);
  if(!q.zero()) {
    last = q.removetip().MonomialPart();
    while(!q.zero() && result) {
      const Monomial & t = q.removetip().MonomialPart();
      result = monomialLess(t,last);
      last = t;
    };
  };
  return result;
};

bool MLex::monomialLess(const Monomial & first,const Monomial & second) const {
  if(AllTimings::timingOn) {
    AllTimings::orderTiming->restart();
  }
  bool result=true;
  int lena = first.numberOfFactors();
  int lenb = second.numberOfFactors();
  ComparisonExtended temp= ComparisonExtended::s_EQUIVALENT;
  if(multiplicity()>1) {
    temp= CompareOnDouble(first,second);
    if(temp==ComparisonExtended::s_LESS) {
      result = true;
    } else if(temp==ComparisonExtended::s_GREATER) {
      result = false;
    } else if(temp==ComparisonExtended::s_INCOMPARABLE) {
      DBG();
    };
  } else if(lena!=lenb) {
    result = lena<lenb;
    if(result) {
      temp=ComparisonExtended::s_LESS;
    } else {
      temp=ComparisonExtended::s_GREATER;
    };
  };
  if(temp==ComparisonExtended::s_EQUIVALENT) {
    if(lena==lenb) {
      // Here the lengths are equal
      bool done = false;
      result  = false;
      MonomialIterator w1 = first.begin();
      MonomialIterator w2 = second.begin();
      for(int i=1;i<=lena&&(!done);++i,++w1,++w2) {
        const Variable & v1 = *w1;
        const Variable & v2 = *w2;
        done = v1!=v2;
        if(done) {
// new code 1-24-98
          int L1 = level(v1); 
          int L2 = level(v2); 
          if(L1==L2) {
            const vector<Variable> & V = monomialsAtLevel(L1);
            vector<Variable>::const_iterator w = V.begin(), e = V.end();
            done = false;
            while(w!=e) {
              const Variable & temp = *w;
              if(v1==temp) {
                result = true;
                done = true;
                break;
              } else if(v2==temp) {
                result = false;
                done = true;
                break;
              };
              ++w;
            };
            if(!done) DBG();
          } else {
            result = L1 < L2;
          }; 
#if 0
          done = false;
          const int sz1 = d_v.size();
          vector<vector<Variable> >::const_iterator ww = d_v.begin();
          for(int j1=1;j1<=sz1&&!done;++j1,++ww) {
            const vector<Variable> & V = (*ww);
            const int sz2 = V.size();
            vector<Variable>::const_iterator www = V.begin();
            for(int j2=1;j2<=sz2&&!done;++j2,++www) {
              const Variable & v = (*www);
              if(v==v1) {
                result = true; done = true;
              } else if(v==v2) {
                result = false; done = true;
              };
            };
          };
          if(!done) {
            PrintOrder(GBStream);
            DBG();
          };
#endif
        };
      };
    } else DBG();
  }
  if(AllTimings::timingOn) {
    Debug3::s_TimingFile() << "order: " 
                           << AllTimings::orderTiming->check() << '\n';
    AllTimings::orderTiming->pause();
  }
//Debug3::s_ErrorFile() << first << " < " << second 
//                      << ((result==1) ? "true" : "false") << '\n';
  return result;
};  

// Print the order to the MyOstream os 
void MLex::PrintOrder(MyOstream & os) const {
  PrintOrderViaString(os,"<<");
#if 0
  if (d_v.size()==0) {
    os << "(Empty Order).\n";
  } else {
    bool needDouble = false;
    bool foundOne = false;
    const int sz  = d_v.size();
    vector<vector<Variable> >::const_iterator w = d_v.begin();
    for (int i=1; i<=sz; ++i,++w) {
      const vector<Variable> & V = *w;
      foundOne = false;
      const int MvSize = V.size();
      vector<Variable>::const_iterator iter = V.begin();
      for (int i=1; i<=MvSize;++i,++iter) {
        if(foundOne) {
          os << " < ";
        } else if(needDouble) {
          os << " << \n";
          needDouble = false;
        }
        os << (*iter);
        foundOne = true;
      }
      if(foundOne) needDouble = true;
    }
    os << '\n'; 
  }
#endif
};

#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

const int MLex::s_ID = idValue("MLex::s_ID");

void MLex::ClearOrder() {
  vector<vector<Variable> > empty;
  setVariables(empty);
};
