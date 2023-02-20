// Mark Stankus 1999 (c)
// TimeStampFactory.cpp

#include "TimeStampFactory.hpp"

TimeStampFactory::~TimeStampFactory() {};

Tag * TimeStampFactory::Create() {
  d_timestamper.passtime();
  return new IntTag(d_timestamper.time());
};
