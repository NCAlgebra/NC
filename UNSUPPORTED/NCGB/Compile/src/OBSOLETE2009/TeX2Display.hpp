// (c) Mark Stankus 1999
// TeX2Display.hpp

#ifndef INCLUDED_TEX2DISPLAY_H
#define INCLUDED_TEX2DISPLAY_H

#include "TeXDisplay.hpp"
#include "GroebnerRule.hpp"
#include "MyOstream.hpp"
#include "ByAdmissible.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
class AdmissibleOrder;
#include "vcpp.hpp"

class TeX2Display : public TeXDisplay {
  const list<GroebnerRule> & d_x;
  AdmissibleOrder & d_ord;  
  ByAdmissible d_by;
  map<Monomial,set<GroebnerRule,ByAdmissible>,ByAdmissible> d_map;
  static bool s_showOne;
  static bool s_showPlusWithNumbers;
  void setUp();
  TeX2Display();
    // not implemented
  TeX2Display(const TeX2Display &);
    // not implemented
public:
  TeX2Display(TeXSink & sink,
              const list<GroebnerRule> & x,
              AdmissibleOrder & ord) 
       : TeXDisplay(sink), d_x(x), d_ord(ord), d_by(ord), d_map(d_by) {
     setUp();
  }; 
  virtual ~TeX2Display();
  virtual void perform() const;
  void Build();
  static bool s_CollapsePowers;
};
#endif
