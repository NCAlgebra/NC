// (c) Mark Stankus 1999
// RuleDisplayPart.hpp

#ifndef INCLUDED_RULEDISPLAYPART_H
#define INCLUDED_RULEDISPLAYPART_H

#include "DisplayPart.hpp"
class BuildOutput;
#include "GroebnerRule.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class RuleDisplayPart : public DisplayPart {
  Sink & d_sink;
public:
  RuleDisplayPart(Sink & sink) : d_sink(sink) {};
  virtual ~RuleDisplayPart();
  virtual void perform() const;
  list<GroebnerRule> d_list;
};
#endif
