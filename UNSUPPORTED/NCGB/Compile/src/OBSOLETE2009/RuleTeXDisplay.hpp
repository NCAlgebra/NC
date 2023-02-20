// (c) Mark Stankus 1999
// RuleTeXDisplay.hpp

#ifndef INCLUDED_RULETEXDISPLAY_H
#define INCLUDED_RULETEXDISPLAY_H

#include "DisplayPart.hpp"
#include "TeXSink.hpp"
#include "AdmissibleOrder.hpp"

template<class CONT,class ITER>
class RuleTeXDisplay : public DisplayPart {
  TeXSink & d_sink;
  const CONT & d_L;
  float d_columnwidth;
public:
  RuleTeXDisplay(TeXSink & x,const CONT & L,float width) : d_sink(x), d_L(L),
       d_columnwidth(width) {};
  virtual ~RuleTeXDisplay();
  virtual void perform() const;
};
#endif
