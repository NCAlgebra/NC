// (c) Mark Stankus 1999
// TeX1Display.hpp

#ifndef INCLUDED_TEX1DISPLAY_H
#define INCLUDED_TEX1DISPLAY_H

#include "TeXDisplay.hpp"
#include "GroebnerRule.hpp"
#include "Spreadsheet.hpp"
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

class TeX1Display : public TeXDisplay {
  const Spreadsheet & d_spr;
  AdmissibleOrder & d_ord;  
  static bool s_showOne;
  static bool s_showPlusWithNumbers;
  void setUp();
  TeX1Display();
    // not implemented
  TeX1Display(const TeX1Display &);
    // not implemented
public:
  TeX1Display(TeXSink & sink,
              const Spreadsheet & x,
              AdmissibleOrder & ord) 
       : TeXDisplay(sink), d_spr(x), d_ord(ord) {}; 
  virtual ~TeX1Display();
  virtual void perform() const;
  void BuildSpread();
  void Build(const AdmissibleOrder &);
  static bool s_CollapsePowers;
private:
  void Build(const Categories &,const Spreadsheet &);
  void OutputANumberCategoryForTeX(const Spreadsheet & x,int n,
                                   float ColumnWidth);
  void OutputASingleTeXCategory(const Spreadsheet & x,
              const Categories & cat,float ColumnWidth);
};
#endif
