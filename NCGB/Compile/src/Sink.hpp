// (c) Mark Stankus 1999
// Sink.h

#ifndef INCLUDED_SINK_H
#define INCLUDED_SINK_H

#include "ISink.hpp"
#include "sink_choice.hpp"
#ifdef SINK_USE_ALIAS
#include "Alias.hpp"
#endif
#ifdef SINK_USE_ICOPY
#include "ICopy.hpp"
#endif
#include "Choice.hpp"
class stringGB;
class asStringGB;
class symbolGB;
class Field;
class Variable;
class Monomial;
class Term;
class GroebnerRule;

class Sink {
#ifdef SINK_USE_ALIAS
  Alias<ISink> d_sink;
#endif
#ifdef SINK_USE_ICOPY
  ICopy<ISink> d_sink;
#endif
public:
  Sink() : d_sink() {};
#ifdef SINK_USE_ALIAS
  Sink(const Alias<ISink> & x) : d_sink(x) {};
#endif
#ifdef SINK_USE_ICOPY
  Sink(const ICopy<ISink> & x) : d_sink(x) {};
#endif
  Sink(const Sink & x) : d_sink(x.d_sink) {};
  void operator=(Sink & x) { // not (const Sink &) on purpose
    d_sink=x.d_sink;
  };
#ifdef SINK_USE_ALIAS
  void operator=(Alias<ISink> & x) { // not (const Sink &) on purpose
    d_sink=x;
  };
#endif
#ifdef SINK_USE_ICOPY
  void operator=(ICopy<ISink> & x) { // not (const Sink &) on purpose
    d_sink=x;
  };
#endif
  ~Sink() {};
  Sink & operator<<(bool x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(int x) {
    d_sink.access().put(x);
    return * this;
  }
  Sink & operator<<(long x) {
    d_sink.access().put(x);
    return * this;
  }
#ifdef USE_UNIX
  Sink & operator<<(long long x) {
    d_sink.access().put(x);
    return * this;
  }
#endif
  void putString(const char * x) {
    d_sink.access().put(x);
  };
  Sink & operator<<(const stringGB & x) {
    d_sink.access().put(x);
    return * this;
  }
  Sink & operator<<(const symbolGB & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const asStringGB & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink outputFunction(const symbolGB & x,long L) {
    return Sink(d_sink.access().outputFunction(x,L));
  };
  Sink outputFunction(const char * x,long L) {
    return Sink(d_sink.access().outputFunction(x,L));
  };
  Sink & operator<<(const Field & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const Variable & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const Monomial & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const Term & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const Polynomial & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const GroebnerRule & x) {
    d_sink.access().put(x);
    return * this;
  };
  Sink & operator<<(const RuleID & x) {
    d_sink.access().put(x);
    return * this;
  };
  void noOutput() {
    d_sink.access().noOutput();
  };
  bool error() const {
   return d_sink().verror();
  };
  int Count() const {
    return d_sink().Count();
  };
};
#endif
