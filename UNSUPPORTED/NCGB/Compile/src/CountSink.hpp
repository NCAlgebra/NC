// (c) Mark Stankus 1999
// CountSink.h

#ifndef INCLUDED_COUNTSOURCE_H
#define INCLUDED_COUNTSOURCE_H

#include "ISink.hpp"
#include "Sink.hpp"
#include "Choice.hpp"

class  CountSink : public ISink {
  static void errorh(int);
  static void errorc(int);
  CountSink(const CountSink &);
    // not implemented
  void operator=(const CountSink &);
    // not implemented
  Sink & d_sink;
  long d_count;
public:
  CountSink(Sink & sink,long count) : ISink(), d_sink(sink), d_count(count) {};
  virtual ~CountSink();
  virtual void put(bool);
  virtual void put(int);
  virtual void put(long);
#ifdef USE_UNIX
  virtual void put(long long);
#endif
  virtual void put(const char *);
  virtual void put(const stringGB &);
  virtual void put(const symbolGB &);
  virtual void put(const asStringGB &);
  virtual Alias<ISink> outputCommand(const symbolGB &);
  virtual Alias<ISink> outputFunction(const symbolGB &,long);
  virtual Alias<ISink> outputFunction(const char *,long);
  virtual void vShouldBeEnd();
  virtual ISink * clone() const;
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const RuleID&);
  virtual void put(const GroebnerRule&);
};
#endif
