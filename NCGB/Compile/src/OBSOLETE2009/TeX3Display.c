// (c) Mark Stankus 1999
// TeX3Display.cpp

#include "TeX3Display.hpp"
#include "Sheet1.hpp"
#include "OrderTeXDisplay.hpp"
#include "RuleTeXDisplay.hpp"
#include "GroebnerRule.hpp"
#include "Debug1.hpp"
#include "Banner1TeX.hpp"
#pragma warning(disable:4687)
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

TeX3Display::~TeX3Display() {};

void TeX3Display::perform() const {
  TeX3Display * alias = const_cast<TeX3Display*>(this);
  alias->initialMatter();
  alias->frontMatter();
  alias->BuildSheet();
  alias->endMatter();
  alias->finalMatter();
};

void TeX3Display::BuildSheet() {
  bool did_knowns = false;
  int columns=1;
  float columnwidth;
  char * FontSize = "normalsize";
  vector<float> rulewidth(RegOutRule(FontSize,columns));
  if(columns==1) {
    columnwidth=6;
  } else {
    columnwidth=3.2f;
  };
  d_ColumnWidth = columnwidth;

  outputsource() << "THE ORDER IS NOW THE FOLLOWING:\\hfil\\break\n";
  OrderTeXDisplay junk1(d_sink,d_spr.order());
  junk1.perform();
  Banner1TeX banner(d_sink,columnwidth,rulewidth);
  banner.first();
  const list<GroebnerRule>  & singleRuleList = d_spr.VarToRule();
  const VariableSet & singleVarList = d_spr.solvedFor();
  if(singleRuleList.size()!=0) {
    outputsource() << "THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:\\hfil\\break\n";
    printTeXVariableSet(singleVarList);
    outputsource() << "\n\\smallskip\\\\\n";
    outputsource() << "The corresponding rules are the following:"
         << "\\smallskip\\\\\n";
    RuleTeXDisplay<list<GroebnerRule>,list<GroebnerRule>::const_iterator>
          displaySingles(d_sink,singleRuleList,columnwidth);
    displaySingles.perform();
  };
  VariableSet empty;
  map<VariableSet,VariableSet,ByAdmissible>::const_iterator f;
  f = d_spr.UnknownsToKnowns().find(empty);
  if(f!=d_spr.UnknownsToKnowns().end()) {
    banner.front1();
    printTeXVariableSet(empty);
    banner.front2();
    printTeXVariableSet((*f).second);
    banner.front3();
    RuleTeXDisplay<set<GroebnerRule,ByAdmissible>,
                   set<GroebnerRule,ByAdmissible>::const_iterator>
         junk3(d_sink,(*d_spr.theCategories().find(empty)).second,columnwidth);
    junk3.perform();
    did_knowns = true;
  };
  banner.second();
  RuleTeXDisplay<list<GroebnerRule>,list<GroebnerRule>::const_iterator>
         junk2(d_sink,d_spr.userselected(),columnwidth);
  junk2.perform();
  banner.third();
  printTeXVariableSet(d_spr.notSolvedFor());
  outputsource() << "\n\\smallskip\\\\\n";
  typedef map<VariableSet,set<GroebnerRule,ByAdmissible>,
              ByAdmissible>::const_iterator MI;
  MI w = d_spr.theCategories().begin();
  MI e = d_spr.theCategories().end();
  if(did_knowns) ++w;
  while(w!=e) {
    const VariableSet & unk = (*w).first;
    banner.front1();
    printTeXVariableSet(unk);
    banner.front2();
    printTeXVariableSet((*(d_spr.UnknownsToKnowns().find(unk))).second);
    banner.front3();
    RuleTeXDisplay<set<GroebnerRule,ByAdmissible>,
                   set<GroebnerRule,ByAdmissible>::const_iterator>
         junk4(d_sink,(*w).second,columnwidth);
    junk4.perform();
    ++w;
  };
};
