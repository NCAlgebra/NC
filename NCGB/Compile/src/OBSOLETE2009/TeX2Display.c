// (c) Mark Stankus 1999
// TeX2Display.cpp

#include "TeX2Display.hpp"
#include "MLex.hpp"
#include "GroebnerRule.hpp"
#include "Debug1.hpp"
#include "MonomialToPowerList.hpp"
#pragma warning(disable:4687)
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

TeX2Display::~TeX2Display() {};

void TeX2Display::setUp() {
  typedef map<Monomial,set<GroebnerRule,ByAdmissible>,
              ByAdmissible>::iterator MI; 
  typedef list<GroebnerRule>::const_iterator VI;
  VI w = d_x.begin(), e = d_x.end();
  Monomial m;
  while(w!=e) {
    const GroebnerRule & rule = *w;
    MonomialMakePowerLess(rule.LHS(),m);
    MI f = d_map.find(m);
    if(f==d_map.end()) {
      set<GroebnerRule,ByAdmissible> S(d_by);
      S.insert(rule);
      pair<const Monomial,set<GroebnerRule,ByAdmissible> > pr(m,S);
      d_map.insert(pr);
    } else {
      (*f).second.insert(rule);
    };
    ++w;
  };
};

void TeX2Display::perform() const {
  TeX2Display * alias = const_cast<TeX2Display*>(this);
  alias->initialMatter();
  alias->frontMatter();
  alias->Build();
  alias->endMatter();
  alias->finalMatter();
};

void TeX2Display::Build() {
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
  outputsource() << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[3] /* fourth element */ << "in}{4pt}\n"
       << "\\ SOME RELATIONS WHICH APPEAR BELOW\\ \n"
       << "\\rule[2pt]{" << rulewidth[3] /* fourth element */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << rulewidth[4] /* fifth element */ << "in}{4pt}\n"
       << "\\ MAY BE UNDIGESTED\\ \n"
       << "\\rule[2pt]{" << rulewidth[4] /* fifth element */ << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << columnwidth << "in}{4pt}\\hfil\\break\n";
  outputsource() << "\\smallskip\n";
  typedef  map<Monomial,set<GroebnerRule,ByAdmissible>,
               ByAdmissible>::const_iterator MI;
  typedef set<GroebnerRule,ByAdmissible>::const_iterator SI;
  MI w1 = d_map.begin(), e1 = d_map.end();
  while(w1!=e1) {
    d_sink << "The rules with powerless LHS $";
    d_sink.put((*w1).first);
    d_sink << "$\\\\\n";
    const set<GroebnerRule,ByAdmissible> & S = (*w1).second;
    SI w2 = S.begin(), e2 = S.end();
    while(w2!=e2) {
      d_sink << "$";
      d_sink.put(*w2);
      d_sink << "$\\\\\n";
      ++w2;
    };
    ++w1;
    d_sink << "\\\\\n";
  };
};
