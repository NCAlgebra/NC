// (c) Mark Stankus 1999
// CharBracketSource.c


#include "CharBracketSource.hpp"

CharBracketSource::~CharBracketSource() {
  if(d_own) {
    delete [] (char *) d_s;
  };
};

bool CharBracketSource::eof() const {
  return *d_current=='\0';
};

void CharBracketSource::vGet(char & c) {
  c = *d_current;
  if(c==d_front) {
    ++d_nest;
  } else if(c==d_back) {
    --d_nest;
  } else if(c=='\0') DBG();
  ++d_current;
};

void CharBracketSource::setUp(CharacterSource & so) {
  d_s = so.grabBracketed(d_front,d_back);
#if 0
GBStream << "MXS:Got it:" << d_s << '\n';
GBStream.flush();
#endif
  d_current = d_s;
};
