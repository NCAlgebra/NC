// NCASink.h

#ifndef INCLUDED_NCASINK_H
#define INCLUDED_NCASINK_H

#include "ISink.hpp"
#include "FieldChoice.hpp"
#include "TeXSink.hpp"
#pragma warning(disable:4786)
#include "TheChoice.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "Debug1.hpp"
#ifdef USE_VIRT_FIELD
#include "SimpleTable.hpp"
#endif

class  NCASink : public ISink {
  static void errorh(int);
  static void errorc(int);
  NCASink(const NCASink &);
    // not implemented
  void operator=(const NCASink &);
    // not implemented
  ofstream & d_ofs;
public:
  NCASink(ofstream & ofs)  : ISink(), d_ofs(ofs) {};
  virtual ~NCASink();
  virtual void put(int);
  virtual void put(long);
#ifdef USE_UNIX
  virtual void put(long long);
#endif
  virtual void put(bool);
  virtual void put(const char *);
  virtual void put(const stringGB &);
  virtual void put(const symbolGB &);
  virtual void put(const asStringGB &);
  virtual ISink * clone() const;

  virtual Alias<ISink> outputFunction(const symbolGB &,long L);
  virtual Alias<ISink> outputFunction(const char * s,long L);
#ifdef USE_GB
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const Polynomial&);
  virtual void put(const GroebnerRule&);
#endif
  static bool s_showPlusWithNumbers;
  static bool s_CollapsePowers;
  ofstream & stream() const { return d_ofs;};
  static const int s_ID;
#ifdef USE_VIRT_FIELD
  static SimpleTable<NCASink> s_table;
#endif
};
#endif
