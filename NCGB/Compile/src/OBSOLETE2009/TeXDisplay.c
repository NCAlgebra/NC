// (c) Mark Stankus 1999
// TeXDisplay.cpp

#include "TeXDisplay.hpp"
#include "StringAccumulator.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

TeXDisplay::~TeXDisplay() {};

void TeXDisplay::initialMatter() {
  const char * font = "normalsize";
  int columns = 1;
  StringAccumulator baselineskip;
  if(strcmp(font,"normalsize")==0) {
    baselineskip.add("12pt");
  } else if(strcmp(font,"small")==0) {
    baselineskip.add("9pt");
  } else {
    GBStream << "FontSize " << font << " not supported.";
    DBG();
//    font = "normalsize";
    baselineskip.add("12pt");
  };
  if(columns==2) {
    d_sink.put("\\documentclass[proc]{article}\n");
    d_sink.put("\\textheight      25.0000cm\n");
    d_sink.put("\\textwidth         17.27cm\n");
    d_sink.put("\\topmargin       -3.0000cm\n");
    d_sink.put("\\oddsidemargin   -0.3462cm\n");
    d_sink.put("\\evensidemargin  -0.3462cm\n");
    d_sink.put("\\arraycolsep        2.5pt\n");
   } else {
    //d_sink << "\\documentclass[rep10,leqno]{report}\n"
    d_sink.put("\\documentclass[leqno]{report}\n");
    d_sink.put("\\voffset = -1in\n");
    d_sink.put("\\evensidemargin 0.1in\n");
    d_sink.put("\\oddsidemargin 0.1in\n");
    d_sink.put("\\textheight 9in\n");
    d_sink.put("\\textwidth 6in\n");
  };
};

void  TeXDisplay::frontMatter() {
  const char * const font = "normalsize";
  const char * const baselineskip = "12pt";
  d_sink.put("\\begin{document}\n");
  d_sink.put("\\");
  d_sink.put(font);
  d_sink.put('\n');
  d_sink.put("\\baselineskip=");
  d_sink.put(baselineskip);
  d_sink.put('\n');
  d_sink.put("\\noindent\n");
};

void TeXDisplay::endMatter() {
  d_sink.put("\\end{document}\n");
 // GBStream << "Done outputting results";
};

void TeXDisplay::finalMatter() {
  d_sink.put("\\end");
};

vector<float> TeXDisplay::RegOutRule(const char * const font,int columns) {
  vector<float> result;
  if(strcmp(font,"normalsize")==0) {
    result.push_back(1.879f);
    result.push_back(1.923f);
    result.push_back(1.701f);
    result.push_back(1.45f);
    result.push_back(2.18f);
  } else if(strcmp(font,"small")==0) {
    if(columns==1) {
      result.push_back(1.95f);
      result.push_back(2.0f);
      result.push_back(1.798f);
      result.push_back(1.56f);
      result.push_back(2.23f);
    } else {
      result.push_back(0.535f);
      result.push_back(0.573f);
      result.push_back(0.399f);
      result.push_back(0.137f);
      result.push_back(0.818f);
    };
  } else {
    d_sink.put("Font size ");
    d_sink.put(font);
    d_sink.put("not supported. Using small\n");
    result = RegOutRule("small",2);
  };
  return result;
};

void TeXDisplay::printIntSet(const vector<int> & x) {
  d_sink.put("$\\{");
  const int sz = x.size();
  vector<int>::const_iterator w = x.begin();
  if(sz>=1) {
    for(int i=1;i<sz;++i,++w) {
      d_sink.put(*w);
      d_sink.put(",\n$ $\n");
    };
    d_sink.put(*w);
  };
  d_sink.put("\\}$");
};

void TeXDisplay::printTeXVariableSet(const VariableSet & x) {
    d_sink.put(" $\\{$ ");
    Variable var;
    bool b = x.firstVariable(var);
    if(b) {
      d_sink.put(var);
      b = x.nextVariable(var);
      while(b) {
        d_sink.put(',');
        d_sink.put(var);
        b = x.nextVariable(var);
      };
    };
    d_sink.put(" $\\}$ ");
};

void TeXDisplay::printNotLastRule(const GroebnerRule & rule) {
  d_sink << "\\begin{minipage}{" << d_ColumnWidth << "in}\n";
  d_sink.put(rule);
  d_sink << "\n\\end{minipage}\\medskip \\\\\n";
};

void TeXDisplay::printLastRule(const GroebnerRule & rule) {
  d_sink << "\\begin{minipage}{" << d_ColumnWidth << "in}\n";
  d_sink.put(rule);
  d_sink << "\n\\end{minipage}\\\\\n";
};

void TeXDisplay::printListRulesHeaderLine() {
  outputsource() << "\\rule[3pt]{" << d_ColumnWidth << "in}{.7pt}\\\\\n";
};
