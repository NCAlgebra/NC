// Generator.h

#ifndef INCLUDED_GENERATOR_H
#define INCLUDED_GENERATOR_H

#include "Choice.hpp"
#ifdef OLD_GCC
#include "SPI.hpp"
#include "GBMatch.hpp"
#else
class SPI;
class Match;
#endif
#include "SPIID.hpp"
class Polynomial;
class GroebnerRule;
class Monomial;
class GBHistory;
//#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

// a FAT interface

class Generator {
  static void errorc(int);
  Generator(const Generator &);
    // not implemented
  void operator=(const Generator &);
    // not implemented
#if 0
  void helpConvert(const Polynomial & p1,const Monomial & onRight,
                   const Monomial & onLeft,const Polynomial & p2,
                   Polynomial & result) const;
#endif
protected:
  const GroebnerRule * d_first_rule_p;
  const GroebnerRule * d_second_rule_p;
  SPIID d_first_id;
  SPIID d_second_id;
  bool d_first_or_second_rule_changed;
public:
  Generator() : d_first_rule_p(0), d_second_rule_p(0),d_first_or_second_rule_changed(false)  {};
  virtual ~Generator() = 0;

  // SPI Specific
  virtual void insert(const SPI &);
  virtual void insert(const SPIID &);
  virtual void remove(const SPIID &);
   // remove spis involving BOTH  ids
  virtual void remove(const SPIID &,const SPIID &);
  virtual void remove(const SPIID &,list<SPI>&);
  virtual bool getNext(SPI &);

  // Match Specific
  virtual void insert(const Match &);
  virtual void remove(int,list<Match>&);
  virtual bool getNext(Match &);

  // Polynomial Specific
  virtual bool getNext(Polynomial &);

  // Polynomial And GBHistory Specific
  virtual bool getNext(Polynomial &,GBHistory &);

  // SPI and Polynomial Specific
  virtual bool getNext(SPI &,Polynomial &);

  // SPI and Polynomial and GBHistory Specific
  virtual bool getNext(SPI &,Polynomial &,GBHistory &);

  // Match and Polynomial Specific
  virtual bool getNext(Match &,Polynomial &);

  // Match and Polynomial and GBHistory Specific
  virtual bool getNext(Match &,Polynomial &,GBHistory &);

  // General 
  virtual void clear() = 0;
  virtual long size() const = 0;
  virtual Generator * clone() const = 0;
  virtual bool empty() const = 0;
  virtual bool iterationEmpty() const = 0;
  virtual void fillForUnknownReason() = 0;
  virtual const GroebnerRule & retrieve(const SPIID &) const = 0;

  // SPI to Polynomial
  void convert(const SPI &,Polynomial &) const;

  // Match to Polynomial
  void convert(const Match &,const GroebnerRule &,const GroebnerRule &,
               Polynomial &) const;

  const GroebnerRule & first_rule() {
    return * d_first_rule_p;
  };
  const GroebnerRule & second_rule() {
    return * d_second_rule_p;
  };
  const SPIID & first_id() const {
    return d_first_id;
  };
  const SPIID & second_id() const {
    return d_second_id;
  };
  bool first_or_second_rule_changed() const {
    return d_first_or_second_rule_changed;
  };
  void haveReadRules() {
    d_first_or_second_rule_changed = false;
  };
};
#endif
