// Variable.h

#ifndef INCLUDED_VARIABLE_H
#define INCLUDED_VARIABLE_H

class UniqueList;
class MyOstream;
class Composite;
//#define CHECK_VARIABLE

class Variable {
public :
   friend class OKFriend;
   Variable();
   explicit Variable(const char *);
   Variable(const Variable &);
   ~Variable(); 
   void operator = (const Variable &);
   void assign(const char * x);
   void assign(const Variable &);

   bool operator == (const Variable &) const;
   bool operator != (const Variable &) const;

   const char * const cstring() const;

  // TEX METHODS
  const char * const texstring() const;
  void texstring(const char * x) const;

  // COMPOSITE METHODS
  const Composite * composite() const;
  void composite(Composite & x);

   friend MyOstream & operator << (MyOstream &,const Variable &);
   int compareVariables(const Variable &) const;
   int stringNumber() const;
   bool commutativeQ() const; 
   void setCommutative(bool); 
   static int s_largestStringNumber();
   // Do NOT manipulate this directly
   static void s_newStringList();
   static Variable s_variableFromNumber(int);
#ifdef CHECK_VARIABLE
   void check() const;
#endif
private:
   int _stringNumber;
   static UniqueList * _stringList;
}; 

inline int Variable::stringNumber() const {
  return _stringNumber;
};

inline bool Variable::operator == (const Variable & x) const {
#ifdef CHECK_VARIABLE
  check();
  x.check();
#endif
  return _stringNumber==x._stringNumber;
};

inline bool Variable::operator != (const Variable & x) const {
#ifdef CHECK_VARIABLE
  check();
  x.check();
#endif
  return _stringNumber!=x._stringNumber;
};

inline int Variable::compareVariables(const Variable & x) const {
#ifdef CHECK_VARIABLE
  check();
  x.check();
#endif
  return _stringNumber - x._stringNumber;
};
#endif /* Variable_h */
