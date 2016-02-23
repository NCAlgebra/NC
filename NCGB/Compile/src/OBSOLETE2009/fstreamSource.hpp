// (c) Mark Stankus 1999
// fstreamSource.h

#ifndef INCLUDED_FSTREAMSOURCE_H
#define INCLUDED_FSTREAMSOURCE_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "CharacterSource.hpp"

class  fstreamSource : public CharacterSource {
  fstreamSource(const fstreamSource &);
    // not implemented
  void operator=(const fstreamSource &);
    // not implemented
  ifstream & d_ifs;
public:
  fstreamSource(ifstream & ifs) : d_ifs(ifs) {};
  virtual ~fstreamSource();
  virtual bool eof() const;
  virtual void vGet(char & c);
};
#endif
