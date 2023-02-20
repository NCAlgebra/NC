// GBGlobals.c

#include "nGBGlobals.hpp"
#include "load_flags.hpp"
#ifndef INCLUDED_RALIST_H
#include "RAList.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#ifdef PDLOAD
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#endif
#include "Spreadsheet.hpp"

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

const GBList<int> & GBGlobals::s_currentMarkerNumbers() {
  return s_CurrentMarkerNumbers;
};

const GBList<simpleString> & GBGlobals::s_currentMarkerStrings() {
  return s_CurrentMarkerStrings;
};


#include "RAs.hpp"

RAListFactControl  GBGRAListFactControl;
RAListGBListPolynomial  GBGRAListGBListPolynomial;
RAListGBListGroebnerRule GBGRAListGBListGroebnerRule;
RAListGBListVariable GBGRAListGBListVariable;
RAListGBVectorint GBGRAListGBVectorint;
RAListSpreadsheet GBGRAListSpreadsheet;

#ifdef PDLOAD
RAListFactControl & GBGlobals::s_factControls() {
  return GBGRAListFactControl;
};
#endif
RAListGBListPolynomial & GBGlobals::s_polynomials() {
  return GBGRAListGBListPolynomial;
};

RAListGBListGroebnerRule & GBGlobals::s_rules(){
  return GBGRAListGBListGroebnerRule;
};

RAListGBListVariable  & GBGlobals::s_variables() {
  return GBGRAListGBListVariable;
};

RAListGBVectorint & GBGlobals::s_integers() {
  return GBGRAListGBVectorint;
};

RAListSpreadsheet & GBGlobals::s_spreadsheets() {
  return GBGRAListSpreadsheet;
};

#include "GBList.hpp"
GBList<int> GBGlobals::s_CurrentMarkerNumbers;
GBList<simpleString> GBGlobals::s_CurrentMarkerStrings;

