// Variable.h

#ifndef INCLUDED_VARIABLE_H
#define INCLUDED_VARIABLE_H

class UniqueList;
class MyOstream;
class Composite;
//#define CHECK_VARIABLE
//#define COPY_STRING

class Variable {
  static int s_numberOfVariablesOut;
  bool * d_cq_p;
  char * d_string;
  void slowDelete();
  int d_num;
  static UniqueList * d_stringList;
public :
  friend class OKFriend;
  Variable();
  explicit Variable(const char * s);
  void assign(const char * x);
  Variable(const Variable & x) : d_cq_p(x.d_cq_p), d_string(x.d_string), 
      d_num(x.d_num) {
    ++s_numberOfVariablesOut;
#ifdef COPY_STRING
     d_string = new char[strlen(x.d_string)+1];
     strcpy(d_string,x.d_string);
#endif
  };
  ~Variable() {
    --s_numberOfVariablesOut;
  };  
  void operator = (const Variable & x) {
    if(d_num!=x.d_num) {
#ifdef COPY_STRING
     d_string = new char[strlen(x.d_string)+1];
     strcpy(d_string,x.d_string);
#else
     d_string = x.d_string;
#endif
      d_num = x.d_num;
      d_cq_p = x.d_cq_p;
    };
  };
  void assign(const Variable & x) {
    if(d_num!=x.d_num) {
#ifdef COPY_STRING
     d_string = new char[strlen(x.d_string)+1];
     strcpy(d_string,x.d_string);
#else
     d_string = x.d_string;
#endif
      d_num = x.d_num;
      d_cq_p = x.d_cq_p;
    };
  };

  // EQUALITY METHODS
  bool operator == (const Variable & x) const {
    return d_num==x.d_num;
  };
  bool operator != (const Variable & x) const {
    return d_num!=x.d_num;
  };

  // STRING METHODS
  const char * const cstring() const { 
    return d_string;
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

  // TEX METHODS
  const char * const texstring() const;
  void texstring(const char * x) const;

  // COMPOSITE METHODS
  Composite * composite() const;
  void composite(Composite & x);

  
  int compareVariables(const Variable &) const;
  static int s_largestStringNumber();
  // Do NOT manipulate this directly
  static void s_newStringList();
  static Variable s_variableFromNumber(int);
#ifdef CHECK_VARIABLE
  void check() const;
#endif
  static int numberOfVariablesOut() {
    return s_numberOfVariablesOut;
  };
}; 

MyOstream & operator << (MyOstream &,const Variable &);
#endif 
