// (c) Mark Stankus 1999
// simpleStringSource.h

#ifndef INCLUDED_SIMPLESTRINGSOURCE_H
#define INCLUDED_SIMPLESTRINGSOURCE_H

#include "Choice.hpp"
#include "simpleString.hpp"
#include "CharacterSource.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif

class  simpleStringSource : public CharacterSource {
  simpleStringSource(const simpleStringSource &);
    // not implemented
  void operator=(const simpleStringSource &);
    // not implemented
  simpleString & d_s;
  int d_len;
  int d_place;
public:
  simpleStringSource(simpleString & x) : 
         d_s(x), d_len(strlen(x.chars())), d_place(0) {};
  virtual ~simpleStringSource();
  virtual bool eof() const;
  virtual void vGet(char & c);
};
#endif
