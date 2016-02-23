// (c) Mark Stankus 1999
// OrderTeXDisplay.hpp

#ifndef INCLUDED_ORDERTEXDISPLAY_H
#define INCLUDED_ORDERTEXDISPLAY_H

#include "DisplayPart.hpp"
#include "TeXSink.hpp"
#include "AdmissibleOrder.hpp"

class OrderTeXDisplay : public DisplayPart {
  TeXSink & d_sink;
  const AdmissibleOrder & d_ord;
public:
  OrderTeXDisplay(TeXSink & x,const AdmissibleOrder & ord) : 
       d_sink(x), d_ord(ord) {};
  virtual ~OrderTeXDisplay();
  virtual void perform() const;
};
#endif
