// UniqueList.h

#ifndef INCLUDED_UNIQUELIST_H
#define INCLUDED_UNIQUELIST_H

//#pragma warning(disable:4786)
#include "GBStream.hpp"
#include "ChoiceVariable.hpp"
#ifdef USE_N_VARIABLE
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "Composite.hpp"
#include "MyOstream.hpp"
#include "simpleString.hpp"
#include "Variable.hpp"
#include "vcpp.hpp"

extern bool s_record_string;
extern bool s_save_variables; 

class UniqueList {
  UniqueList(const UniqueList &);
    // not implemented
  void operator=(const UniqueList &);
    // not implemented
  typedef vector<pair<char *,bool *> >::const_iterator VI;
  vector<simpleString> d_texstring;
  vector<Composite *> d_composites;
public:
  UniqueList() {};
  ~UniqueList(){};
  vector<pair<char *,bool *> > d_vec;
  void current() {
    VI w = d_vec.begin(), e = d_vec.end();
    int i = 0;
    while(w!=e) {
      char * ptr = (*w).first;
      if(ptr) {
        GBStream << i << ' ' <<  ptr << '\n';
      };
      ++w;++i;
    };
  };
  pair<char*,bool *> insertElement(int & num,const char * const x) {
    pair<char *,bool *> result((char *)0,(bool*)0);
    VI w = d_vec.begin(), e = d_vec.end();
    int i=0;
    while(w!=e) {
      char * ptr = (*w).first;
      if(ptr) {
        if(strcmp(ptr,x)==0) {
          result = *w; 
          num = i;
          break;
        };
      };
      ++w;++i;
    };
    if(w==e) {
      num = d_vec.size();
      RECORDHERE(result.first= new char[strlen(x)+1];)
      strcpy(result.first,x);
      result.second = new bool(false);
      d_vec.push_back(result);
      bool s_save = s_record_string;
      s_record_string = s_save_variables; 
      simpleString S(x);
      s_record_string = s_save; 
      d_texstring.push_back(S);
      d_composites.push_back((Composite *)0);
    };
#if 0
cout << " gives " << num 
     << " and " << result.first 
     << " and " << result.second;
cout << " with count " << Variable::numberOfVariablesOut();
cout << '\n';
current();
#endif
    return result;
  };
  int largestNumber() const { 
    return d_vec.size();
  };
  Composite * const composite_p(int i) const { 
    return d_composites[i];
  };
  void setComposite(const Composite &,int i);
  void addString(const char * const value,int i,const char * const tag);
  const char * const string(int i,const char * const tag) const;
};
#endif
#endif
