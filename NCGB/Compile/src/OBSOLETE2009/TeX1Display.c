// (c) Mark Stankus 1999
// TeX1Display.cpp

#include "TeX1Display.hpp"
#include "MLex.hpp"
#include "GroebnerRule.hpp"
#include "Debug1.hpp"
#pragma warning(disable:4687)
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

TeX1Display::~TeX1Display() {};

void TeX1Display::perform() const {
  TeX1Display * alias = const_cast<TeX1Display*>(this);
  alias->initialMatter();
  alias->frontMatter();
  alias->BuildSpread();
  alias->endMatter();
  alias->finalMatter();
};

void TeX1Display::BuildSpread() {
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

  const list<GroebnerRule>  & singleRuleList = d_spr.singleRules();
  const VariableSet & singleVarList = d_spr.singleVariables();
  const VariableSet & nonsingleVarList = d_spr.nonsingleVariables();
  const vector<GroebnerRule> & RULES = d_spr.RULES();
  const AdmissibleOrder & order = d_spr.order();
#if 0
  int mult = order.levels().size();
#endif

  outputsource() << "THE ORDER IS NOW THE FOLLOWING:\\hfil\\break\n";
  Build(order);
  outputsource() << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[0] /* 1st entry */ << "in}{4pt}\n"
       << "\\ YOUR SESSION HAS DIGESTED\\ \n"
       << "\\rule[2pt]{" << rulewidth[0] /* 1st entry */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[1] /* 2nd entry */ << "in}{4pt}\n"
       << "\\ THE FOLLOWING RELATIONS\\ \n"
       << "\\rule[2pt]{" << rulewidth[1] /* 2nd entry */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n";
  if(singleRuleList.size()!=0) {
    outputsource() << "THE FOLLOWING VARIABLES HAVE BEEN SOLVED FOR:\\hfil\\break\n";
    printTeXVariableSet(singleVarList);
    outputsource() << "\n\\smallskip\\\\\n";
    outputsource() << "The corresponding rules are the following:"
         << "\\smallskip\\\\\n";
    list<GroebnerRule>::const_iterator singleRuleListb = singleRuleList.begin();
    list<GroebnerRule>::const_iterator singleRuleListe = singleRuleList.end();
    while(singleRuleListb!=singleRuleListe) {
      outputsource() << "\\begin{minipage}{" << columnwidth << "in}\n";
      outputsource().put(*singleRuleListb);
      ++singleRuleListb;
      if(singleRuleListb!=singleRuleListe) {
        outputsource() << "\n\\end{minipage}\\medskip \\\\\n";
      } else {
        outputsource() << "\n\\end{minipage}\\\\\n";
      };
    };
  };
  const list<int> & userselects = d_spr.userselected();
  OutputANumberCategoryForTeX(d_spr,0,columnwidth);
  outputsource() << "\\rule[2pt]{" << columnwidth << "in}{1pt}\\hfil\\break\n"
       << "\\rule[2.5pt]{" << rulewidth[2] /* 3rd entry */ << "in}{1pt}\n"
       << "\\ USER CREATIONS APPEAR BELOW\\ \n"
       << "\\rule[2.5pt]{" << rulewidth[2] /* 3rd entry */ << "in}{1pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << columnwidth << "in}{1pt}\\hfil\\break\n";
  list<int> num(userselects);
  list<int>::const_iterator w2 =  num.begin();
  const int userSsz = num.size();
  for(int i=1;i<=userSsz;++i,++w2) {
    int number = *w2;
    outputsource() << "\\begin{minipage}{" << columnwidth << "in}\n";
    outputsource().put(RULES[number]);
    if(i!=userSsz) {
      outputsource() << "\n\\end{minipage}\\medskip\\\\\n";
    } else {
      outputsource() << "\n\\end{minipage}\\smallskip\\\\\n";
    };
  };
  outputsource() << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[3] /* fourth element */ << "in}{4pt}\n"
       << "\\ SOME RELATIONS WHICH APPEAR BELOW\\ \n"
       << "\\rule[2pt]{" << rulewidth[3] /* fourth element */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[4] /* fifth element */ << "in}{4pt}\n"
       << "\\ MAY BE UNDIGESTED\\ \n"
       << "\\rule[2pt]{" << rulewidth[4] /* fifth element */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n"
       << "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\\hfil\\break\n";
    printTeXVariableSet(nonsingleVarList);
  outputsource() << "\n\\smallskip\\\\\n";
  int max = d_spr.categories().size()-1;
  for(int number=1;number<=max;++number) {
    OutputANumberCategoryForTeX(d_spr,number,columnwidth);
  };
};

void TeX1Display::Build(const Categories & x,const Spreadsheet & y) {
  const vector<GroebnerRule> & RULES = y.RULES();
  const list<int> & L = x.ruleNumbers();
  const int sz = L.size();
  list<int>::const_iterator w = L.begin();
  for(int i=1;i<=sz;++i,++w) {
    int j = *w;
    GBStream << "j is:" << j << '\n';
    const GroebnerRule & r = RULES[j];
    outputsource().put(r);
    outputsource() << '\n';
  };
};

void TeX1Display::Build(const AdmissibleOrder & x) {
  if(x.ID()==MLex::s_ID) {
    const MLex & OR = (const MLex &) x;
    const int sz = OR.multiplicity();
    for(int i=1;i<=sz;++i) {
      const vector<Variable> & V = OR.monomialsAtLevel(i); 
      vector<Variable> ::const_iterator w = V.begin();
      const int sz2 = V.size();
      if(sz2>0) {
        for(int j=1;j<sz2;++j,++w) {
          outputsource().put(*w);
          outputsource() << " $ < $ ";
        };
        outputsource().put(*w);
      };
      if(i==sz) {
        outputsource() << "\\\\\n";
      } else {
        outputsource() << "$\\ll$\n";
      };
   };
  } else DBG();
};

void TeX1Display::OutputANumberCategoryForTeX(
     const Spreadsheet & x,int n,float ColumnWidth
    ) {
#if 0
  bool outputedHeader = false;
#endif
  const list<Categories> & C  = x.categories()[n];
  list<Categories>::const_iterator w = C.begin();
  const int sz = C.size();
  for(int i=1;i<=sz;++i,++w) {
    const Categories & temp = *w;
    OutputASingleTeXCategory(x,temp,ColumnWidth);
  };
};

void TeX1Display::OutputASingleTeXCategory(
    const Spreadsheet & x,const Categories & cat,float ColumnWidth
      ) {
  const vector<GroebnerRule> & RULES = x.RULES();
  const VariableSet & knowns = cat.knowns();
  const VariableSet & unknowns = cat.unknowns();
  outputsource() << "\\rule[3pt]{" << ColumnWidth << "in}{.7pt}\\\\\n";
  outputsource() << "The expressions with unknown variables ";
  printTeXVariableSet(unknowns);
  
  outputsource() << "\\\\\n";

  outputsource() << "and knowns ";
  printTeXVariableSet(knowns);
  outputsource() << "\\smallskip\\\\\n";

  const list<int> & rules = cat.ruleNumbers();
  list<int>::const_iterator ww = rules.begin();
  const int sz = rules.size();
  for(int j=1;j<sz;++j,++ww) {
    printNotLastRule(RULES[*ww]);
   };
   if(sz!=1) {
    printLastRule(RULES[*ww]);
   };
   outputsource().flush();
};
