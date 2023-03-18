// newerUniqueList.h

#ifndef INCLUDED_UNIQUELIST_H
#define INCLUDED_UNIQUELIST_H

#pragma warning(disable:4786)
#include "ChoiceVariable.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "Composite.hpp"
#include "nnVariable.hpp"
#include "simpleString.hpp"
#include "vcpp.hpp"

extern bool s_save_variables;

class UniqueList {
  UniqueList(const UniqueList &);
    // not implemented
  void operator=(const UniqueList &);
    // not implemented
  class Datum;
  class DatumCompare;
  map<char *,Datum *> d_map;
  vector<Datum *> d_vec;
  vector<char *> d_string_vec;
public:
  const map<char *,Datum *> & MAP() const {
    return d_map;
  };
  const vector<Datum *> & VEC() const {
    return d_vec;
  };
  const vector<char *> & STRINGVEC() const {
    return d_string_vec;
  };
  class Datum { 
    Datum(const Datum &);
    void operator=(const Datum &);
  public:
    Datum(int num,bool commutative) : d_num(num), d_commutative(commutative), 
        d_texstring(0), d_composite(0) {};
    const int d_num;
    bool d_commutative;
    const char * d_texstring;
    Composite * d_composite;
  };
  UniqueList() {};
  ~UniqueList(){};
  const char * const string(int i,const char * const tag) const;
  pair<char * const,Datum *> insertElement(char * const x) {
    typedef map<char *,Datum *>::iterator MI;
    MI w = d_map.find(x), e = d_map.end();
    if(w==e) {
      int num = d_vec.size();
      RECORDHERE(char * str = new char[strlen(x)+1];)
      if(s_save_variables) {
        simpleString forSideEffects(str);
      };
      strcpy(str,x);
      RECORDHERE(Datum * result = new Datum(num,false);)
      d_vec.push_back(result);
      d_string_vec.push_back(str);
      pair<char * const,Datum *> pr(str,result);
      d_map.insert(pr);
      return pr;
    };
    return *w;
  };
  int largestNumber() const { 
    return d_vec.size();
  };
  const Composite * const composite_p(int i) const { 
    return d_vec[i]->d_composite;
  };
  void setComposite(const Composite &,int i);
  void addString(const char * const value,int i,const char * const tag);
};
#endif
#endif
