// GBGlobals.c

#include "GBGlobals.hpp"
#pragma warning(disable:4786)
#include "load_flags.hpp"

void GBGlobals::s_dismissMarker(int num,const char * const x) {
  if(x) {
    const GBList<int> & L1 = s_CurrentMarkerNumbers;
    const int sz = L1.size(); 
    const GBList<simpleString> & L2 = s_CurrentMarkerStrings;
    GBList<int>::const_iterator      w1 = L1.begin();
    GBList<simpleString>::const_iterator w2 = L2.begin();
    if(sz!=L2.size()) DBG();
    for(int i=1;i<=sz;++i,++w1,++w2) {
      if((num==*w1) && (*w2)==x) {
        s_CurrentMarkerNumbers.removeElement(i);
        s_CurrentMarkerStrings.removeElement(i);
        break;
      }
    };
  };
};

void GBGlobals::s_recordMarker(int mark,const char * const s) {
  s_CurrentMarkerNumbers.push_back(mark);
  simpleString aString(s);
  s_CurrentMarkerStrings.push_back(aString);
};

bool GBGlobals::s_validMarker(int n,const char * const s) {
  bool result = false;
  GBList<int>::iterator w1 = s_CurrentMarkerNumbers.begin();
  GBList<simpleString>::iterator w2 = s_CurrentMarkerStrings.begin();
  const int sz = s_CurrentMarkerNumbers.size();
  for(int i=1;i<=sz&&!result;++i,++w1,++w2) {
    result = (*w1)==n && (*w2)==s;
  };
  return result;
};

#include "RAList.hpp"
#include "Choice.hpp"
#include "GBList.hpp"
#include "GBVector.hpp"
#include "Polynomial.hpp"
#include "Variable.hpp"


template class RAList<GBVector<int> >;
RAList<GBVector<int> > GBGlobals::s_d_integers;
#ifdef PDLOAD
template class RAList<FactControl>;
#endif

#ifdef USE_UNIX
template class RAList<GBList<GroebnerRule> >;
const char * const RAList<GBList<GroebnerRule> >::s_string = "GBList<GroebnerRule>";
template class GBList<Polynomial>;
template class RAList<GBList<Polynomial> >;
const char * const RAList<GBList<Polynomial> >::s_string = "GBList<Polynomial>";
template class GBList<Variable>;
template class RAList<GBList<Variable> >;
const char * const RAList<GBList<Variable> >::s_string = "GBList<Variable>";
#endif
RAList<GBList<Polynomial> > GBGlobals::s_d_polynomials;
RAList<GBList<Variable> > GBGlobals::s_d_variables;

#ifdef PDLOAD
const char * RAList<FactControl>::s_string = "FactControls";
RAList<FactControl> GBGlobals::s_d_factControls;
#endif
RAList<GBList<GroebnerRule> > GBGlobals::s_d_rules;
template class RAList<Spreadsheet>;
const char * const RAList<Spreadsheet>::s_string = "Spreadsheets";
RAList<Spreadsheet> GBGlobals::s_d_spreadsheets;

#ifdef USE_UNIX
#include "GBList.c"
#else
#include "GBList.cpp"
#endif
GBList<int> GBGlobals::s_CurrentMarkerNumbers;
GBList<simpleString> GBGlobals::s_CurrentMarkerStrings;

