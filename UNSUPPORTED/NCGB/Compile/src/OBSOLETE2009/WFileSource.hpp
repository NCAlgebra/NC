// Mark Stankus 1999 (c)
// WFileSource.h

#ifndef INCLUDED_WFILESOURCE_H
#define INCLUDED_WFILESOURCE_H

#include "Choice.hpp"
#ifdef USE_WFILE
#include "CharacterSource.hpp"
#include "symbolGB.hpp"

#ifdef USE_GB
#include "IISource.hpp"
class WFileSource : public IISource {
#else
#include "ISource.hpp"
class WFileSource : public ISource {
#endif
  WFileSource();
    // not implemented
  WFileSource(const WFileSource &);
    // not implemented
  void operator =(const WFileSource &);
    // not implemented
  int d_type; 
  bool d_type_valid;
  int d_count;
  int d_len;
  int fastType() const;
  CharacterSource & d_so;
public:
#ifdef USE_GB
  explicit WFileSource(CharacterSource & so) : IISource(false,true),
      d_type(0), d_type_valid(false), d_count(0), d_len(0), d_so(so) {};
#else
  explicit WFileSource(CharacterSource & so) : ISource(false,true),
      d_type(0), d_type_valid(false), d_count(0), d_len(0), d_so(so) {};
#endif
  virtual ~WFileSource();
  virtual void get(int&);
  virtual void get(long&);
  virtual void get(stringGB &);
  virtual void get(symbolGB &);
  virtual void get(asStringGB &);
  virtual void vShouldBeEnd();
  virtual Alias<ISource> inputCommand(symbolGB &);
  virtual Alias<ISource> inputFunction(symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const char *);
  virtual void vQueryNamedFunction();
  virtual void get(Holder&);
  virtual void get(Variable&);
  virtual ISource * clone() const;
  virtual int getType() const;
  virtual void passString();
};
#endif
#endif
