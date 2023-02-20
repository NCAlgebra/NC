// AllTimings.c

#include "AllTimings.hpp"
#include "RecordHere.hpp"

bool AllTimings::timingOn = false;
Timing * * AllTimings::s_AllTimings_pp = 0;
Timing * AllTimings::cleanUpBasisTiming = 0;
Timing * AllTimings::matchesTiming = 0;
Timing * AllTimings::spolynomialsTiming = 0;
Timing * AllTimings::reductionTiming = 0;
Timing * AllTimings::orderTiming = 0;
Timing * AllTimings::reductionMatchingTiming = 0;
Timing * AllTimings::reductionPolyTiming1 = 0;
Timing * AllTimings::reductionPolyTiming2 = 0;
Timing * AllTimings::reductionPolyTiming3 = 0;

// ------------------------------------------------------------------

AllTimings::AllTimings() {
  typedef Timing * TimingPtr;
  if(!s_AllTimings_pp) {
    RECORDHERE(s_AllTimings_pp = new TimingPtr[20];);
    int & jj = s_numberBuiltInCounter;
    RECORDHERE(s_AllTimings_pp[jj] = cleanUpBasisTiming = new Timing(); ++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = matchesTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = spolynomialsTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = spolynomialsTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = reductionTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = orderTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = reductionMatchingTiming = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = reductionPolyTiming1 = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = reductionPolyTiming2 = new Timing();++jj;)
    RECORDHERE(s_AllTimings_pp[jj] = reductionPolyTiming3 = new Timing();++jj;)
  };
  for(int ii=0;ii<s_numberBuiltInCounter;++ii) {
    s_AllTimings_pp[ii]->start();
    (void) s_AllTimings_pp[ii]->check();
#if 0
    long L = s_AllTimings_pp[ii]->check();
    GBStream << "AllTiming: " << ii << ":" << L << '\n';
#endif
    s_AllTimings_pp[ii]->pause();
  };                                
}

vector<pair<simpleString,long> > AllTimings::s_report() {
  vector<pair<simpleString,long> > result;
  pair<simpleString,long> pr;
  pr.first = "cleanUpBasisTiming";
  pr.second = cleanUpBasisTiming->check();
  result.push_back(pr);
  pr.first = "matchesTiming";
  pr.second = matchesTiming->check();
  result.push_back(pr);
  pr.first = "spolynomialsTiming";
  pr.second = spolynomialsTiming->check();
  result.push_back(pr);
  pr.first = "reductionTiming ";
  pr.second = reductionTiming->check();
  result.push_back(pr);
  pr.first = "orderTiming ";
  pr.second = orderTiming->check();
  result.push_back(pr);
  pr.first = "reductionMatchingTiming ";
  pr.second = reductionMatchingTiming->check();
  result.push_back(pr);
  pr.first = "reductionPolyTiming1 ";
  pr.second = reductionPolyTiming1->check();
  result.push_back(pr);
  pr.first = "reductionPolyTiming2";
  pr.second = reductionPolyTiming2->check();
  result.push_back(pr);
  pr.first = "reductionPolyTiming3";
  pr.second = reductionPolyTiming3->check();
  result.push_back(pr);
  return result;
};

vector<Timing *> AllTimings::s_otherTimers;

int AllTimings::s_numberBuiltInCounter = 0;
