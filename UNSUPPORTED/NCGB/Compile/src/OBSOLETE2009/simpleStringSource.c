// (c) Mark Stankus 1999
// simpleStringSource.c

#include "simpleStringSource.hpp"
#include "Debug1.hpp"


simpleStringSource::~simpleStringSource(){};

bool simpleStringSource::eof() const {
  if(d_place>d_len) DBG();
  return d_place==d_len;
};

void simpleStringSource::vGet(char & c) {
  if(d_place>=d_len) DBG();
  c = d_s.chars()[d_place];
  ++d_place;
};
