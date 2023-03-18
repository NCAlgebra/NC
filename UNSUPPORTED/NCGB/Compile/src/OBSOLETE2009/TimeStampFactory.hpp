// Mark Stankus 1999 (c)
// TimeStampFactory.hpp

#ifndef INCLUDED_TIMESTAMPFACTORY_H
#define INCLUDED_TIMESTAMPFACTORY_H

#include "TagFactory.hpp"
#include "TimeStamper.hpp"

class TimeStampFactory : public TagFactory {
  TimeStamper d_timestamper;
public:
  TimeStampFactory(const TimeStamper & x) : d_timestamper(x) {};
  virtual Tag * Create();
};
#endif
