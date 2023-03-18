// (c) Mark Stankus 1999
// Source.h

#ifndef INCLUDED_SOURCE_H
#define INCLUDED_SOURCE_H

#include "Alias.hpp"
#include "ISource.hpp"
class stringGB;
class asStringGB;
class symbolGB;
class ById;
class Field;
class Variable;
class Monomial;
class Term;
class Polynomial;

class Source {
  Alias<ISource> d_source;
public:
  Source() : d_source() {};
  Source(const Alias<ISource> & x) : d_source(x) {};
  Source(const Source & x) : d_source(x.d_source) {};
  void operator=(Source & x) { // not (const Source &) on purpose
    d_source=x.d_source;
  };
  void operator=(const Alias<ISource> & x) { 
    d_source=x;
  };
  ~Source() {};
  Source & operator>>(bool & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(int & x) {
    d_source.access().get(x);
    return * this;
  }
  Source & operator>>(long & x) {
    d_source.access().get(x);
    return * this;
  }
  Source & operator>>(stringGB & x) {
    d_source.access().get(x);
    return * this;
  }
  Source & operator>>(symbolGB & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(asStringGB & x) {
    d_source.access().get(x);
    return * this;
  };
  int    getType() const {
    return d_source().getType();
  };
  Source inputCommand(symbolGB & x) {
    return Source(d_source.access().inputCommand(x));
  };
  Source inputFunction(symbolGB & x) {
    return Source(d_source.access().inputFunction(x));
  };
  Source inputNamedFunction(const symbolGB & x) {
    return Source(d_source.access().inputNamedFunction(x));
  };
  Source inputNamedFunction(const char * x) {
    return Source(d_source.access().inputNamedFunction(x));
  };
  bool eoi() const { 
    return d_source().eoi();
  };
  bool extraQ() const {
    return d_source().extraQ();
  };
  void shouldBeEnd()  {
    d_source.access().shouldBeEnd();
  };
  Source & operator>>(Field & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(Variable & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(Monomial & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(Term & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(Polynomial & x) {
    d_source.access().get(x);
    return * this;
  };
  Source & operator>>(GroebnerRule & x) {
    d_source.access().get(x);
    return * this;
  };
  void passString() {
    d_source.access().passString();
  };
  void setNotEndOfInput() {
    d_source.access().setNotEndOfInput();
  };
  void print() {
    d_source.access().print(this);
  };
  bool error() const {
    return d_source().verror();
  };
  int Count() const {
    return d_source().Count();
  };
};
#endif
