// Mark Stankus 1999 (c) 
// Tag.c

#include "Tag.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

Tag::~Tag(){};

IntTag::~IntTag(){};

#include "idValue.hpp"
const int IntTag::s_ID = idValue("IntTag::s_ID");

bool IntTag::less(const Tag & x) const {
  const IntTag & y = (const IntTag &) x;
  return d_n < y.d_n;
};

bool IntTag::equal(const Tag & x) const {
  const IntTag & y = (const IntTag &) x;
  return d_n==y.d_n;
};

void IntTag::print(MyOstream & x) const {
  x << d_n;
};

void Tag::errorh(int n) { DBGH(n); };

void Tag::errorc(int n) { DBGC(n); };
