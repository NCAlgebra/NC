// GrbSink.h

#ifndef INCLUDED_GRBSINK_H
#define INCLUDED_GRBSINK_H

#include "Sink.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "Debug1.hpp"

class  GrbSink : public Sink {
  GrbSink(const GrbSink &);
    // not implemented
  void operator=(const GrbSink &);
    // not implemented
  ofstream & d_ofs;
public:
  GrbSink(ofstream & ofs)  : Sink(), d_ofs(ofs) {};
  virtual ~GrbSink();
  virtual Sink & operator<<(int);
  virtual Sink & operator<<(const stringGB &);
  virtual Sink & operator<<(const symbolGB &);
  virtual Alias<ISink> outputFunction(const symbolGB &,long L);
  virtual Alias<ISink> outputFunction(const char * s,long L);

  virtual Sink & operator<<(const Field&);
  virtual Sink & operator<<(const Variable&);
  virtual Sink & operator<<(const Monomial&);
  virtual Sink & operator<<(const Term&);
  virtual Sink & operator<<(const Polynomial&);
};
#endif
