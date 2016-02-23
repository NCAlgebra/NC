// (c) Mark Stankus 1999
// TeXDisplay.hpp

#ifndef INCLUDED_TEXDISPLAY_H
#define INCLUDED_TEXDISPLAY_H

#include "DisplayPart.hpp"
#include "TeXSink.hpp"
#include "VariableSet.hpp"
class GroebnerRule;
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

class TeXDisplay : public DisplayPart {
  static bool s_showOne;
  static bool s_showPlusWithNumbers;
  TeXDisplay();
    // not implemented
  TeXDisplay(const TeXDisplay &);
    // not implemented
protected:
  TeXSink & d_sink;
  float d_ColumnWidth;
  void printNotLastRule(const GroebnerRule &);
  void printLastRule(const GroebnerRule &);
public:
  TeXDisplay(TeXSink & sink) : d_sink(sink) {};
  virtual ~TeXDisplay() = 0;
  virtual void printListRulesHeaderLine();
  void perform() const = 0;
  void initialMatter();
  void frontMatter();
  void endMatter();
  void finalMatter();
  void printTeXVariableSet(const VariableSet &);
  void printIntSet(const vector<int> &);
  vector<float> RegOutRule(const char * const font,int columns);
  TeXSink & outputsource() { return d_sink;};
  static bool s_CollapsePowers;
};
#endif

