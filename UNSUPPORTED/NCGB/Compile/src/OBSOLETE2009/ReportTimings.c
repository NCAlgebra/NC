// ReportTimings.c

#include "GBIO.hpp"
#include "GBStream.hpp"
#include "AllTimings.hpp"
#include "simpleString.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "vcpp.hpp"

void ReportTimings() {
  vector<pair<simpleString,long> > V(AllTimings::s_report());
  int sz =  V.size();
  vector<pair<simpleString,long> >::const_iterator w = V.begin();
  for(int ii=1;ii<=sz;++ii,++w) {
    const pair<simpleString,long> & pr = *w;
    GBStream << "Timing for " << pr.first << " was " << pr.second << "\n";
  };
};
