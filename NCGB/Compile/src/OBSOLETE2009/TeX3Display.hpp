// (c) Mark Stankus 1999
// TeX3Display.hpp

#ifndef INCLUDED_TEX3DISPLAY_H
#define INCLUDED_TEX3DISPLAY_H

#include "TeXDisplay.hpp"
#include "GroebnerRule.hpp"
#include "Sheet1.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
class AdmissibleOrder;
#include "vcpp.hpp"

class TeX3Display : public TeXDisplay {
  const Sheet1 & d_spr;
  AdmissibleOrder & d_ord;  
  static bool s_showOne;
  static bool s_showPlusWithNumbers;
  void setUp();
  TeX3Display();
    // not implemented
  TeX3Display(const TeX3Display &);
    // not implemented
public:
  TeX3Display(TeXSink & sink,
              const Sheet1 & x,
              AdmissibleOrder & ord) 
       : TeXDisplay(sink), d_spr(x), d_ord(ord) {}; 
  virtual ~TeX3Display();
  virtual void perform() const;
  void BuildSheet();
  static bool s_CollapsePowers;
};
#endif
