// nnVariable.h

#ifndef INCLUDED_VARIABLE_H
#define INCLUDED_VARIABLE_H

class UniqueList;
class MyOstream;
class Composite;
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
//#define CHECK_VARIABLE
//#define COPY_STRING

class Variable {
  static int s_numberOfVariablesOut;
  // fixed the first time the variable with a given string
  int           d_num;
  const char *  d_string;
  // could be changed after the first time the variable with a given string
  const char ** d_texstring;
  Composite  ** d_composite;
  bool       *  d_cq_p;
  static UniqueList * d_stringList;
  static char * const s_Bogus_Variable_Name;
  friend class OKFriend;
public :
  Variable() {
    assign(s_Bogus_Variable_Name);
  };
  explicit Variable(const char * const x) {
    assign(x);
  };
  void assign(const char * const x);
  Variable(const Variable & x) : d_num(x.d_num), d_string(x.d_string), 
      d_texstring(x.d_texstring),d_composite(x.d_composite), 
      d_cq_p(x.d_cq_p) {  
    ++s_numberOfVariablesOut;
  };
  ~Variable() {
    --s_numberOfVariablesOut;
  };  
  void operator = (const Variable & x) {
    if(d_num!=x.d_num) {
      d_num=x.d_num;
      d_string=x.d_string; 
      d_texstring=x.d_texstring;
      d_composite=x.d_composite; 
      d_cq_p=x.d_cq_p;  
    };
  };
  void assign(const Variable & x) {
    operator=(x);
  };

  // CHECK EQUALITY
  bool operator == (const Variable & x) const {
    return d_num==x.d_num;
  };
  bool operator != (const Variable & x) const {
    return d_num!=x.d_num;
  };

  // ASCII METHODS
  const char * const cstring() const { 
    return d_string;
  };

  // TEX METHODS
  const char * const texstring() const { 
    return *d_texstring;
  };
  void texstring(const char * x) const { 
    delete [] *d_texstring;
    *d_texstring=new char[strlen(x)+1];
    strcpy((char *)*d_texstring,x);
  };

  // NUMBER METHODS
  int stringNumber() const { 
    return d_num;
  };
  
  // COMMUTATIVE METHODS
  bool commutativeQ() const {
    return * d_cq_p;
  };  
  void setCommutative(bool b) {
    * d_cq_p = b;
  }; 

  // COMPOSITE METHODS
  Composite * composite() const {
    return * d_composite;
  };  
  void composite(Composite &); 

  static int numberOfVariablesOut() {
    return s_numberOfVariablesOut;
  };
  int compareVariables(const Variable & x) const {
    return d_num-x.d_num;
  };
  friend MyOstream & operator << (MyOstream &,const Variable &);
  static int s_largestStringNumber();
  static void s_newStringList();
  static Variable s_variableFromNumber(int);
#ifdef CHECK_VARIABLE
  void check() const;
#endif
}; 
#endif 
