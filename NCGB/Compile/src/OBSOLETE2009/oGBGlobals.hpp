// GBGlobals.h

#ifndef INCLUDED_GBGLOBALS_H
#define INCLUDED_GBGLOBALS_H

#define newGBGlobals

#pragma warning(disable:4786)

#include "simpleString.hpp"
#ifndef INCLUDED_LOAD_FLAGS_H
#include "load_flags.hpp"
#endif
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

class GBGlobals {
public:
  GBGlobals(){};
#ifdef PDLOAD
  static RAList<FactControl> s_d_factControls;
  static RAList<FactControl>  & s_factControls() {
    return s_d_factControls;
  };
#endif
  static RAList<GBList<Polynomial> > s_d_polynomials;
  static RAList<GBList<Polynomial> > & s_polynomials() {
    return s_d_polynomials;
  };
  static RAList<GBList<GroebnerRule> > s_d_rules;
  static RAList<GBList<GroebnerRule> > & s_rules() {
    return s_d_rules;
  };
  static RAList<GBList<Variable> > s_d_variables;
  static RAList<GBList<Variable> > & s_variables() {
    return s_d_variables;
  };
  static RAList<GBVector<int> > s_d_integers;
  static RAList<GBVector<int> > & s_integers() {
    return s_d_integers;
  };
  static RAList<Spreadsheet > s_d_spreadsheets;
  static RAList<Spreadsheet > & s_spreadsheets() {
    return s_d_spreadsheets;
  };

  static void s_recordMarker(int mark,const char * const);
  static void s_dismissMarker(int mark,const char * const);
  static const GBList<int> & s_currentMarkerNumbers();
  static const GBList<simpleString> & s_currentMarkerStrings();
  static bool s_validMarker(int,const char * const);
private:
  static GBList<int> s_CurrentMarkerNumbers;
  static GBList<simpleString> s_CurrentMarkerStrings;
};

inline const GBList<int> & GBGlobals::s_currentMarkerNumbers() {
  return s_CurrentMarkerNumbers;
};

inline const GBList<simpleString> & GBGlobals::s_currentMarkerStrings() {
  return s_CurrentMarkerStrings;
};
#endif
