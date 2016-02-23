// (c) Mark Stankus 1999
// ISource.h

#ifndef INCLUDED_ISOURCE_H
#define INCLUDED_ISOURCE_H

class Holder;
class stringGB;
class asStringGB;
class symbolGB;
class Field;
class Variable;
class Monomial;
class Term;
class Polynomial;
class GroebnerRule;
class RuleID;
// #pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "source_choice.hpp"
#ifdef SOURCE_USE_ALIAS
#include "Alias.hpp"
#endif
#ifdef SOURCE_USE_ICOPY
#include "ICopy.hpp"
#endif
#include "MyOstream.hpp"
#include "symbolGB.hpp"

class ISource {
  ISource(const ISource &);
    // not implemented
  void operator=(const ISource &);
    // not implemented
  void error();
  static void errorh(int);
  static void errorc(int);
protected:
  int d_count;
  symbolGB d_old_function_name;
  bool d_old_function_name_valid;
protected:
  const bool d_should_extra;
  bool d_eoi;
public:
  ISource(bool empty,bool extra) : d_count(0), d_old_function_name_valid(false), 
        d_should_extra(extra), d_eoi(empty) {};
  virtual ~ISource() = 0;
  void Count(int i) { d_count = i;};
  int  Count() const { return d_count;};
  virtual void get(bool&);
  virtual void get(int&) = 0;
  virtual void get(long&) = 0;
  virtual void get(stringGB &) = 0;
  virtual void get(symbolGB &) = 0;
  virtual void get(asStringGB &) = 0;
  virtual Alias<ISource> inputCommand(symbolGB &) = 0;
  virtual Alias<ISource> inputFunction(symbolGB &) = 0;
  virtual Alias<ISource> inputNamedFunction(const symbolGB &) = 0;
  virtual Alias<ISource> inputNamedFunction(const char *) = 0;
  pair<bool,Alias<ISource> > queryNamedFunction(const char * x)  {
    if(!d_old_function_name_valid) {
      vQueryNamedFunction();
    };
    pair<bool,Alias<ISource> > result;
    result.first = false;
    if(d_old_function_name==x) {
      result.first = true;
      result.second = inputNamedFunction(x);
    };
    return result;
  };
  virtual void vQueryNamedFunction() = 0;
  virtual void vShouldBeEnd() = 0;
  void setEOIFlag()  { d_eoi = true;}
  virtual ISource * clone() const = 0;
  virtual int getType() const = 0;
  virtual void passString() = 0;

  bool eoi() const { 
    return d_eoi;
  };
  bool extraQ() const {
    return d_should_extra;
  };
  void shouldBeEnd()  {
    if(d_count!=0) errorh(__LINE__);
    if(!eoi()) errorh(__LINE__);
    if(d_should_extra) vShouldBeEnd();
  };

  void setNotEndOfInput() {
    if(!d_eoi) {
      errorh(__LINE__);
    };
    d_eoi = false;
  };
  void print(void * v);
  virtual bool verror() const;
  virtual void get(Holder&);
#ifdef OLD_GCC
  bool operator==(const ISource & x) const { return this==&x;};
  bool operator!=(const ISource & x) const { return this!=&x;};
#endif
  // FAT interface -- implementation optional
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial&);
  virtual void get(GroebnerRule&);
};
#endif
