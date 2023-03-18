// KludgeHistory.c

 
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "Source.hpp"
#include "Sink.hpp"
#include "FactControl.hpp"
#include "Command.hpp"
#ifndef INCLUDED_GBSTRING_H
#include "GBString.hpp"
#endif
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
#endif
#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
// #pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif

#define NOFS
#ifdef NOFS
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#endif

extern MngrStart * run;

// ------------------------------------------------------------------

void _TheHistory(Source & source,Sink & sink) {
  vector<int> vec;
  GBInputSpecial(vec,source);
  source.shouldBeEnd();
  long sz = vec.size();
  Sink sink2(sink.outputFunction("List",sz));
  vector<int>::const_iterator w = vec.begin();
  for (long i = 0;i<=sz;++i,++w) {
    Sink sink3(sink2.outputFunction("List",4L));
    int rulenumber = *w;
    sink3 << rulenumber;
    sink3 << run->rule(rulenumber);
    const FactControl & fc = (const FactControl &) run->factbase();
    GBHistory hist(fc.history(rulenumber));
    Sink sink4(sink3.outputFunction("List",2L));
    sink4 << hist.first();
    sink4 << hist.second();
    const GBHistory::HistoryContainerType::Internal & LL = 
        hist.reductions().SET();
     long len = LL.size();
     typedef GBHistory::HistoryContainerType::Internal::const_iterator LLI;
     LLI ww = LL.begin(), ee = LL.end();
     // Need to do something for the history
     Sink sink5(sink3.outputFunction("List",len));
     while(ww!=ee) {
       sink5 << (*ww).d_data;
       ++ww;
     };
  };
};

// ------------------------------------------------------------------

void _KludgeHistory(Source & so,Sink & si) {
#if 0
  const char filename[] = "gbhistory.txt";
  int i,len2;
#endif
  GBString s("",100);
  VariableSet vars;
  ofstream outfile;

  s = "{";
  vector<int> vec;
  GBInputSpecial(vec,so);
  so.shouldBeEnd();
#ifdef NOFS
  Debug1::s_not_supported("Kluge history is");
#else
  long len = vec.size();
  int lenm1;
   vector<int>::const_iterator w = vec.begin();
   for (int i = 0; i < len;++i,++w) {
     vars.clear();

// The relation number
     s += '{';
     AppendItoString(*w,s);
     s += ',';

// The variables
    run->rule(*w).variablesIn(vars);
    len2 = vars.size();
    lenm1 = len2-1;
    Variable xx;
    bool todo = vars.firstVariable(xx);
    while(todo) {
      s += xx.cstring();
      s += "**";
      todo = vars.nextVariable(xx);
    };
    if (len2 > 0) {
      s += (*iter).cstring();
    } else {
      s += '1';
    };

// The relation number (So the string is:  product of variables -> i)
    s+= " -> ";
    AppendItoString(*w,s);

// The history
     s += ",{";
     const GBHistory & histRef = run->rawHistory(*w);
     AppendItoString(histRef.first(),s);
     s += ',';
     AppendItoString(histRef.second(),s);
     s += "},{"; 

     lenm1 = histRef.reductions().size() - 1;

     GBList<int>::const_iterator iter2 =
           histRef.reductions().begin();
     for(int j=1;j<=lenm1;++j,++iter2) {
          AppendItoString(*iter2,s);
          s += ',';
     }
     if(lenm1>-1) {
       AppendItoString(*iter2,s);
     }
     s += "}}";
     if(i<len-1) {
       s += ',';
     }
   }

   s += '}';

   outfile.open(filename);
   outfile << s;

#endif
  GBOutputString(s.chars(),si);
} /* _KludgeHistory */

AddingCommand temp1Kludge("KludgeHistory",1,_KludgeHistory);
