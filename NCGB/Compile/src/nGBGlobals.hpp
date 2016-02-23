// GBGlobals.h

#ifndef INCLUDED_GBGLOBALS_H
#define INCLUDED_GBGLOBALS_H

#define newGBGlobals

//#pragma warning(disable:4786)

#include "simpleString.hpp"
#include "GBList.hpp"
#ifndef INCLUDED_LOAD_FLAGS_H
#include "load_flags.hpp"
#endif
class RAListFactControl;
class RAListGBListPolynomial;
class RAListGBListGroebnerRule;
class RAListGBListVariable;
class RAListGBVectorint;
class RAListSpreadsheet;

class GBGlobals {
public:
  GBGlobals(){};
#ifdef PDLOAD
  static RAListFactControl & s_factControls();
#endif
  static RAListGBListPolynomial & s_polynomials();
  static RAListGBListGroebnerRule & s_rules();
  static RAListGBListVariable & s_variables();
  static RAListGBVectorint &  s_integers();
  static RAListSpreadsheet &  s_spreadsheets();

  static void s_recordMarker(int mark,const char * const);
  static void s_dismissMarker(int mark,const char * const);
  static const GBList<int> & s_currentMarkerNumbers();
  static const GBList<simpleString> & s_currentMarkerStrings();
  static bool s_validMarker(int,const char * const);
private:
  static GBList<int> s_CurrentMarkerNumbers;
  static GBList<simpleString> s_CurrentMarkerStrings;
};
#endif
