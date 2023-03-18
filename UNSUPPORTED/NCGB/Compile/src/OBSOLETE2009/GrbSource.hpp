// (c) Mark Stankus 1999
// GrbSource.h 

#ifndef INCLUDED_GRBSOURCE_H 
#define INCLUDED_GRBSOURCE_H 

#include "CharacterSource.hpp"
#include "TheChoice.hpp"

#ifdef USE_GB
#include "IISource.hpp"
class  GrbSource : public IISource {
#else
#include "ISource.hpp"
class  GrbSource : public ISource {
#endif
  static void errorh(int);
  static void errorc(int);
  GrbSource(const GrbSource &);
    // not implemented
  void operator=(const GrbSource &);
    // not implemented
  CharacterSource & d_so;
public:
#ifdef USE_GB
  GrbSource(CharacterSource & so)  : IISource(false,false), d_so(so) {};
#else
  GrbSource(CharacterSource & so)  : ISource(false,false), d_so(so) {};
#endif
  virtual ~GrbSource();
  virtual void get(bool &);
  virtual void get(int &);
  virtual void get(long &);;
  virtual void get(stringGB &);
  virtual void get(asStringGB &);
  virtual void get(symbolGB &);
  virtual Alias<ISource> inputCommand(symbolGB &);
  virtual Alias<ISource> inputFunction(symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const char *);
  virtual void vQueryNamedFunction();
  virtual void vShouldBeEnd();
  virtual ISource * clone() const;
  virtual int getType() const;
  virtual void get(Holder&);
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial&);
  virtual void passString();
};
#endif
