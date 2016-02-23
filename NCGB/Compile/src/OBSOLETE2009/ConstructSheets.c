// (c) Mark Stankus 1999
// ConstructSheets.cpp

#pragma warning(disable:4786)
#include "Source.hpp"
#include "Sink.hpp"
#include "TeXSink.hpp"
#include "FactControl.hpp"
#ifdef USE_CONTRUCTSHEETS
#include "TeX1Display.hpp"
#include "TeX2Display.hpp"
#include "TeX3Display.hpp"
#endif
#include "load_flags.hpp"
#include "stringGB.hpp"
#include "RecordHere.hpp"
#include "Command.hpp"
#include "MyOstream.hpp"
#include "PlatformSpecific.hpp"
#include "StringAccumulator.hpp"

#ifndef INCLUDED_GBOUTPUT_H
#include "GBOutput.hpp"
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#ifndef INCLUDED_TERM_H
#include "Term.hpp"
#endif
#ifndef INCLUDED_CATEGORIES_H
#include "Categories.hpp"
#endif
#include "MngrStart.hpp"
#include "MngrSuper.hpp"
#if 0
#include "Sheet1.hpp"
#else
#include "Spreadsheet.hpp"
#endif
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#ifndef INCLUDED_STDLIB_H
#define INCLUDED_STDLIB_H
#include <stdlib.h>
#endif
#include "simpleString.hpp"
class AdmissibleOrder;


extern MngrStart * run;

#ifdef USE_CONTRUCTSHEETS

void _ConstructSheets(Source & so,Sink & si) {
  simpleString filename("build_output.tex");
  ofstream output(filename.chars());
  MyOstream output2(output);
#ifdef WANT_MNGRADAPTER
  PartialGB & pgb = (PartialGB &) ((ManagerAdapter *)run)->PARTIALGB();
  Spreadsheet x(pgb,AdmissibleOrder::s_getCurrent());
#endif
#ifdef WANT_MNGRSUPER
    FactControl & fc = 
        (FactControl &) ((MngrSuper *)run)->GetFactBase();
//    GBStream << fc;
#if 1
    const GBList<int> VEC(fc.indicesOfPermanentFacts());
    GBList<int>::const_iterator VECB = VEC.begin();
    vector<GroebnerRule> vec;
    const int VECSZ = VEC.size();
    vec.reserve(VECSZ);
    for(int iii=1;iii<=VECSZ;++iii,++VECB) {
      vec.push_back(fc.fact(*VECB));
    };
    Sheet1 x(vec,AdmissibleOrder::s_getCurrent());
#else
    Spreadsheet x(fc,AdmissibleOrder::s_getCurrent());
    x.uglyprint(GBStream);
#endif
    TeXSink tex_sink(output2);
#if 0
    TeX1Display tester(tex_sink,x,AdmissibleOrder::s_getCurrent());
#endif
#if 0
    list<GroebnerRule> L;
    copy(x.d_rules.begin(),x.d_rules.end(),back_inserter(L));
    TeX2Display tester(tex_sink,L,AdmissibleOrder::s_getCurrent());
#endif
#if 1
    TeX3Display tester(tex_sink,x,AdmissibleOrder::s_getCurrent());
#endif
    tester.perform();
#endif
  GBStream << '\n';
  so.shouldBeEnd();
  si.noOutput();
  os.flush();
  output.close();
};

AddingCommand temp0TestBuild("DisplayIt",0,_DisplayIt);

void _CreateDisplay(Source & so,Sink & si) {
  DisplayPart::part()->perform();
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp0aTestBuild("CreateDisplay",0,_CreateDisplay);
#endif

void _ShowTeX(Source & so,Sink & si) {
  stringGB format;
  so >> format;
  StringAccumulator x;
  x.add(PlatformSpecific::s_dvi_viewer());
  x.add(format.value().chars());
  x.add(PlatformSpecific::s_background());
  so.shouldBeEnd();
  si.noOutput();
  system(x.chars());
};

AddingCommand temp3TestBuild("ShowTeX",1,_ShowTeX);

void _CppTeXTheFile(Source & so,Sink & si) {
  stringGB format;
  so >> format;
  StringAccumulator x;
  x.add(PlatformSpecific::s_latex_command());
  x.add(format.value().chars());
  so.shouldBeEnd();
  si.noOutput();
  system(x.chars());
};

AddingCommand temp4TestBuild("CppTeXTheFile",1,_CppTeXTheFile);
