// UniqueList.h

#ifndef INCLUDED_UNIQUELIST_H
#define INCLUDED_UNIQUELIST_H

#pragma warning(disable:4786)
#include "ChoiceVariable.hpp"
#ifdef USE_OLD_VARIABLE
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "Composite.hpp"
#include "GBList.hpp"
#include "simpleString.hpp"
#ifndef INCLUDED_MEMBER_H
#include "Member.hpp"
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "Debug1.hpp"

#include "vcpp.hpp"

class UniqueList {
  static void errorh(int);
  static void errorc(int);
  UniqueList(const UniqueList &);
    // not implemented
  void operator=(const UniqueList &);
    // not implemented
public:
  UniqueList(){};
  ~UniqueList(){};

  void addString(const char * const value,int i,const char * const tag);
  const char * const string(int i,const char * const tag) const;

  // Adding to list (with reference count)
  int insertElement(const char * const);
  // This function increments the reference count
  void increment(int i);

  // This function increments the reference count
  void decrement(int i);

  // Ask what the reference count is (probably just for debugging)
  int count(int i) const;

  // accessor
  const char * const stringElement(int i) const;
  static const char * const s_newline;
  int largestNumber() const { return d_list.size();};
  bool commutativeQ(int n) const { 
    return d_commutative[n];
  };
  void setCommutative(int n,bool yn) { 
    d_commutative[n] = yn;
  };
  const Composite * const composite_p(int i) const { 
    return d_composites[i];
  };
  void setComposite(const Composite &,int i);
private:
  vector<simpleString> d_list;
  vector<simpleString> d_texstring;
  vector<Composite *> d_composites;
  vector<int> d_refCounts;
  GBList<int> d_zeroCount;
  vector<bool> d_commutative;
  int find(const simpleString & t) const;
  void error1() const;
};

inline int UniqueList::find(const simpleString & t) const {
  int result = -1;
  int sz = d_list.size();
  vector<simpleString>::const_iterator ww= d_list.begin();
  for(int i=0;i<sz;++i,++ww) {
    if((*ww)==t) {
      result = i;
      break;
    };
  }
  return result;
};

inline int UniqueList::count(int i) const {
  return d_refCounts[i];
};

inline void UniqueList::decrement(int i) {
  --d_refCounts[i];
  if(d_refCounts[i]==0) {
    if(IsMember(d_zeroCount,i)) error1();
    d_zeroCount.push_back(i);
  }
};

inline const char * const UniqueList::stringElement(int i) const {
  return d_list[i].chars();
};

inline void UniqueList::increment(int i) {
  ++d_refCounts[i];
};
  
extern bool s_record_string;
extern bool s_save_variables; 

// The smallest element gets a number of 1
inline int UniqueList::insertElement(const char * const t) {
  bool save = s_record_string;
  s_record_string = s_save_variables; 
  simpleString T(t);
  s_record_string = save;

  int n = find(T);
  if(n==-1) {
    if(d_zeroCount.size()>0) {
      n = (* d_zeroCount.begin());
      d_zeroCount.pop_front();
      d_list[n] = T;
      d_texstring[n] = T;
      if(d_composites[n]) {
        RECORDHERE(delete d_composites[n];)
      };
      d_composites[n] = (Composite *) 0;
      d_commutative[n] = false;
      if(d_refCounts[n]!=0) errorh(__LINE__);
      ++d_refCounts[n];
    } else {
      d_list.push_back(T);
      d_texstring.push_back(T);
      d_composites.push_back((Composite *) 0);
      n = d_list.size()-1;
      d_refCounts.push_back(1);
      d_commutative.push_back(false);
    }
  } else {
     if(d_refCounts[n]<0) errorh(__LINE__);
     if(d_refCounts[n]==0) {
       int result = -1;
       const GBList<int> & L = d_zeroCount;
       GBList<int>::const_iterator w = L.begin();
       const int sz = d_zeroCount.size();
       for(int i=1;i<=sz;++i,++w) {
         if(*w==n) {
           result = i;
           break;
         };
       };
       if(result==-1) errorh(__LINE__);
       d_zeroCount.removeElement(result);
     };
     ++d_refCounts[n];
  }
  return n;
};
#endif
#endif
