// (c) Mark Stankus 1999
// ISink.h

#ifndef INCLUDED_ISINK_H
#define INCLUDED_ISINK_H

class stringGB;
class asStringGB;
class symbolGB;
class Holder;
class Field;
class Variable;
class Monomial;
class Term;
class Polynomial;
class GroebnerRule;
class RuleID;
#include "Choice.hpp"
#include "sink_choice.hpp"
#ifdef SINK_USE_ALIAS
#include "Alias.hpp"
#endif
#ifdef SINK_USE_ICOPY
#include "ICopy.hpp"
#endif

class ISink {
  static void errorh(int);
  static void errorc(int);
  ISink(const ISink &);
    // not implemented
  void operator=(const ISink &);
    // not implemented
  void error();
protected:
  int d_count;
public:
  ISink() : d_count(0) {};
  virtual ~ISink() = 0;
  void Count(int i) { d_count = i;};
  int Count() const { return d_count;};
  virtual void put(bool) = 0;
  virtual void put(int) = 0;
  virtual void put(long) = 0;
#ifdef USE_UNIX
  virtual void put(long long) = 0;
#endif
  virtual void put(const char *) = 0;
  virtual void put(const stringGB &) = 0;
  virtual void put(const symbolGB &) = 0;
  virtual void put(const asStringGB &) = 0;

  virtual Alias<ISink> outputFunction(const symbolGB &,long L) = 0;
  virtual Alias<ISink> outputFunction(const char * s,long L) = 0;
  virtual ISink * clone() const = 0;

  // FAT interface -- implementation optional
  virtual void put(const Holder&);
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const Polynomial&);
  virtual void put(const RuleID&);
  virtual void put(const GroebnerRule&);
  virtual void noOutput();
  virtual bool verror() const;
#ifdef OLD_GCC
  bool operator==(const ISink & x) const { return this==&x;};
  bool operator!=(const ISink & x) const { return this==&x;};
#endif
};
#endif
