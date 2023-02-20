// (c) Mark Stankus 1999
// WFileSink.h

#ifndef INCLUDED_WFILESINK_H
#define INCLUDED_WFILESINK_H

#include "Choice.hpp"
#ifdef USE_WFILE
#include "ISink.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

using namespace std;

class WFileSink : public ISink {
  WFileSink(const WFileSink &);
    // not implemented
  void operator=(const WFileSink &);
    // not implemented
  void error();
  ofstream & d_ofs;
public:
  WFileSink(ofstream &);
  virtual ~WFileSink();
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
  virtual Alias<ISink> outputFunction(const symbolGB &,long L);
  virtual Alias<ISink> outputFunction(const char * s,long L);
  virtual ISink * clone() const;

  // FAT interface -- implementation optional
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const Polynomial&);
  virtual void put(const RuleID&);
  virtual void put(const GroebnerRule&);
  virtual void noOutput();
};
#endif
#endif
