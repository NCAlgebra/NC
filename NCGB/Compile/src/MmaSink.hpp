// MmaSink.h

#ifndef INCLUDED_MMASINK_H
#define INCLUDED_MMASINK_H

#include "ISink.hpp"
#include "Choice.hpp"
//class MLink;
extern "C" {
#include "mathlink.h"
}
#include "Debug1.hpp"
#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "SimpleTable.hpp"
#endif

class  MmaSink : public ISink {
  static void errorh(int);
  static void errorc(int);
  void operator=(const MmaSink &);
    // not implemented
  MLink * d_mlink;
public:
  MmaSink(MLink * mlink)  : ISink(), d_mlink(mlink) {};
  MmaSink(const MmaSink & x) : ISink(), d_mlink(x.d_mlink) {};
  virtual ~MmaSink();
  void resetMLINK(MLink * mlink) { d_mlink = mlink;};
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
  virtual void put(const Holder&);
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const Polynomial&);
  virtual void put(const GroebnerRule&);
  virtual void noOutput();
  virtual bool verror() const;
  void checkforerror() const;
  MLink * mlink() { return d_mlink;};
#ifdef USE_VIRT_FIELD
  static SimpleTable<MmaSink> s_table;
#endif
  static const int s_ID;
};
#endif
