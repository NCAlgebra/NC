// (c) Mark Stankus 1999
// CountSource.h

#ifndef INCLUDED_COUNTSOURCE_H
#define INCLUDED_COUNTSOURCE_H

#include "Source.hpp"
#include "TheChoice.hpp"

#ifdef USE_GB
#include "IISource.hpp"
class  CountSource : public IISource {
#else
#include "ISource.hpp"
class  CountSource : public ISource {
#endif
  static void errorh(int);
  static void errorc(int);
  CountSource(const CountSource &);
    // not implemented
  void operator=(const CountSource &);
    // not implemented
  ISource & d_source;
  long d_count;
  void (*f_atend)();
public:
#ifdef USE_GB
  CountSource(ISource & source,long count,void (*atend)()) : 
      IISource(count==0L,true), d_source(source), d_count(count), 
      f_atend(atend)  {};
#else
  CountSource(ISource & source,long count,void (*atend)()) : 
      ISource(count==0L,true), d_source(source), d_count(count), 
      f_atend(atend)  {};
#endif
  virtual ~CountSource();
  virtual void get(bool &);
  virtual void get(int&);
  virtual void get(long&);
  virtual void get(stringGB &);
  virtual void get(symbolGB &);
  virtual void get(asStringGB &);
  virtual Alias<ISource> inputCommand(symbolGB &);
  virtual Alias<ISource> inputFunction(symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const char *);
  virtual Alias<ISource> inputNamedFunction(const symbolGB &);
  virtual void vQueryNamedFunction();
  virtual int getType() const;
  virtual void vShouldBeEnd();
  virtual ISource * clone() const;
  virtual void get(Holder&);
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial &);
  virtual void passString();
};
#endif
