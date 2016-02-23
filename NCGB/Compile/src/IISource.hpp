// (c) Mark Stankus 1999
// IISource.h

#ifndef INCLUDED_IISOURCE_H
#define INCLUDED_IISOURCE_H

#include "ISource.hpp"

class StringAccumulator;

class IISource : public ISource {
public:
  IISource(bool empty,bool extra) : ISource(empty,extra) {};
  virtual ~IISource() = 0;
  virtual void get(int&) = 0;
  virtual void get(long&) = 0;
  virtual void get(stringGB &) = 0;
  virtual void get(symbolGB &) = 0;
  virtual void get(asStringGB &) = 0;
  virtual Alias<ISource> inputCommand(symbolGB &) = 0;
  virtual Alias<ISource> inputFunction(symbolGB &) = 0;
  virtual Alias<ISource> inputNamedFunction(const symbolGB &) = 0;
  virtual Alias<ISource> inputNamedFunction(const char *) = 0;
  virtual void vQueryNamedFunction() = 0;
  virtual void vShouldBeEnd() = 0;
  virtual ISource * clone() const = 0;
  virtual int getType() const = 0;
  virtual void passString() = 0;
  // FAT interface -- implementation optional
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial&);
  virtual void get(GroebnerRule&);
  void getAnything(StringAccumulator &); 
};
#endif
