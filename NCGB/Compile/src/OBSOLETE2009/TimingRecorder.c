// TimingRecorder.c

#include "TimingRecorder.hpp"
  
TimingRecorder::TimingRecorder() {};

TimingRecorder::~TimingRecorder() {};

#include "idValue.hpp"
int s_cleanUpBasisTiming = idValue("::s_cleanUpBasisTiming");
int s_matchesTiming = idValue("::s_matchesTiming");
int s_spolynomialsTiming = idValue("::s_spolynomialsTiming");
int s_reductionTiming = idValue("::s_reductionTiming");
int s_orderTiming = idValue("::s_orderTiming");
int s_reductionMatchingTiming = idValue("::s_reductionMatchingTiming");
int s_reductionPolyTiming = idValue("::s_reductionPolyTiming");
