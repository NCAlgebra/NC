// Mark Stankus 1999 (c)
// SimpleTable.c

#include "SimpleTable.hpp"
#include "SimpleTableError.hpp"
#include "GBStream.hpp"
#include "idValue.hpp"

//#define DEBUG_SIMPLE_TABLE

template<class CLASS>
void SimpleTable<CLASS>::error(const CLASS &,const Holder & h,int n) {
  int i = h.ID();
  GBStream << "We are working with the class with ID " 
           <<  CLASS::s_ID;
  if(numberOfIdStrings()> CLASS::s_ID) {
    GBStream << "The following may or may not be helpful:"
             << idString(CLASS::s_ID) << '\n';
  } else {
    GBStream << "No idString available.\n";
  };
  GBStream << "The executeconst method for ID " << i 
           << " has not been set.\n'";
  if(numberOfIdStrings()> i) {
    GBStream << "The following may or may not be helpful:"
             << idString(i) << '\n';
  } else {
    GBStream << "No idString available.\n";
  };
  SimpleTableError::errorc(n);
};

template<class CLASS>
void SimpleTable<CLASS>::execute(CLASS & x,Holder & h) {
  int i = h.ID();
#ifdef DEBUG_SIMPLE_TABLE
  GBStream << "Looking for " << CLASS::s_ID << " with " 
           << i << '\n';
#endif
  typename VEC::const_iterator w = d_V.begin(), e = d_V.end();
  if(w==e) {
    GBStream << "No execute methods for " << CLASS::s_ID 
             << " against " << i << '\n';
 } else {
    while(w!=e && (*w).first< i) { 
#ifdef DEBUG_SIMPLE_TABLE
      GBStream << (*w).first << '\n';
#endif
      ++w; 
    };
#ifdef DEBUG_SIMPLE_TABLE
    GBStream << "Done looking\n";
#endif
  };
  if(w==e || (*w).first!=i) error(x,h,__LINE__);
  (*w).second(x,h);
};


template<class CLASS>
void SimpleTable<CLASS>::executeconst(CLASS & x,const Holder & h) {
  int i = h.ID();
#ifdef DEBUG_SIMPLE_TABLE
  GBStream << "Looking for " << CLASS::s_ID << " with " 
           << i << '\n';
#endif
  typename VECC::const_iterator w = d_VC.begin(), e = d_VC.end();
  if(w==e) {
    GBStream << "No const execute methods for " << CLASS::s_ID 
             << " against " << i << '\n';
  } else {
    while(w!=e && (*w).first< i) { 
#ifdef DEBUG_SIMPLE_TABLE
      GBStream << (*w).first << '\n';
#endif
      ++w; 
    };
#ifdef DEBUG_SIMPLE_TABLE
    GBStream << "Done looking\n";
#endif
  };
  if(w==e || (*w).first!=i) error(x,h,__LINE__);
  (*w).second(x,h);
};

template<class CLASS>
void SimpleTable<CLASS>::add(int i,void(*f)(CLASS &,Holder &)) {
#ifdef DEBUG_SIMPLE_TABLE
  GBStream << "Adding for " << CLASS::s_ID << " with " << i << '\n';
#endif
  typename VEC::iterator w = d_V.begin(), e = d_V.end();
  while(w!=e && (*w).first< i) { ++w; };
  if(w==e || (*w).first>i) {
    pair<int,void(*)(CLASS &,Holder &)> pr(i,f);
    d_V.insert(w,pr);
  } else {
    GBStream << "Adding the same entry to a SimpleTable twice\n";
    SimpleTableError::errorc(__LINE__);
  };
};

template<class CLASS>
void SimpleTable<CLASS>::addconst(int i,void(*f)(CLASS &,const Holder &)) {
#ifdef DEBUG_SIMPLE_TABLE
  GBStream << "Adding const for " << CLASS::s_ID << " with " << i << '\n';
#endif
  typename VECC::iterator w = d_VC.begin(), e = d_VC.end();
  while(w!=e && (*w).first< i) { ++w; };
  if(w==e || (*w).first>i) {
    pair<int,void(*)(CLASS &,const Holder &)> pr(i,f);
    d_VC.insert(w,pr);
  } else {
    GBStream << "Adding the same entry to a SimpleTable twice\n";
    SimpleTableError::errorc(__LINE__);
  };
};
