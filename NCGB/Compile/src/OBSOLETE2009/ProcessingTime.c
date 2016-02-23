// ProcessingTime.c

#include "Source.hpp"
#include "Sink.hpp"
#include "RecordHere.hpp"
#include "symbolGB.hpp"
#include "GBInput.hpp"
#include "AllTimings.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "GBStream.hpp"


long ProcessingTime(Source & so) {
  long time = 0L;
  long factor = 1L;
  symbolGB x;
  int n;
  Source source1(so.inputNamedFunction("List"));
  while(!source1.eoi()) {
    int type = source1.getType();
    if(isFunction(type)) {
      Source source2(source1.inputNamedFunction("Times"));
      source1 >> n >> x;
    } else {
      n = 1; 
      source1 >> x;
    };
    if(x=="NCGBSecond") {
      time += n*factor;
    } else if(x=="NCGBMinute") {
      time += n*60L*factor;
    } else if(x=="NCGBHour") {
      time += n*60L*60L*factor;
    } else if(x=="NCGBDay") {
      time += n*60L*60L*24L*factor;
    } else DBG();
  };
  return time;
};

long s_MaximumRunTime = 0L;
int s_MaximumRunTimeTimer = -1;

void _setMaximumRunTime(Source & so,Sink & si) {
  vector<Timing *> & V = AllTimings::s_otherTimers;
  if(s_MaximumRunTimeTimer!=-1) {
    RECORDHERE(delete V[s_MaximumRunTimeTimer];)
    V[s_MaximumRunTimeTimer] = (Timing *) 0;
  };
  s_MaximumRunTime = ProcessingTime(so);
  RECORDHERE(Timing * p = new Timing;)
  p->start();
  s_MaximumRunTimeTimer = V.size();
  V.push_back(p);
  // Do not delete p; This is done in the if statement above.
  so.shouldBeEnd();
  si.noOutput();
};

void _getMaximumRunTime(Source & so,Sink & si) {
  vector<Timing *> & V = AllTimings::s_otherTimers;
  long result = -1L;
  if(s_MaximumRunTimeTimer!=-1) {
    GBStream << "Maximum run time is " << s_MaximumRunTime << '\n';
    result = V[s_MaximumRunTimeTimer]->check();
    GBStream << "Actual run time is " << result << '\n';
  } else {
    GBStream << "A request for the maximum run time was given, but no"
             << " maximum run time was set.\n\n Returning the value'-1'.\n\n";
  };
  so.shouldBeEnd();
  si.noOutput();
};
