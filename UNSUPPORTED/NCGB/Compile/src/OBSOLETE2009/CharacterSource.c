// CharacterSource.c 

#include "CharacterSource.hpp"
#include "Debug1.hpp"

CharacterSource::~CharacterSource() {};

void CharacterSource::errorh(int n) {
  DBGH(n);
};

void CharacterSource::errorc(int n) {
  DBGC(n);
};
