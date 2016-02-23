// SubSpreadsheet.c

#include "Debug1.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#include "GBGlobals.hpp"
#include "Spreadsheet.hpp"
#include "RA6.hpp"
#include "marker.hpp"
#include "Command.hpp"
#include "simpleString.hpp"
#include "GBInput.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <functional>
#else
#include <function.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "vcpp.hpp"


void _SubSpreadsheet(Source & so,Sink & si) {
  marker input;
  input.get(so);
  if(!input.nameis("spreadsheet")) DBG();
  vector<int> L;
  GBInputSpecial(L,so);
  so.shouldBeEnd();
  const Spreadsheet & y = GBGlobals::s_spreadsheets().const_reference(input.num());
  const vector<GroebnerRule> & RULES = y.RULES();
  const int sz = L.size();
  vector<int>::const_iterator w = L.begin();
  vector<GroebnerRule> V;
  V.reserve(sz);
  for(int i=1;i<=sz;++i,++w) {
    V.push_back(RULES[*w]);
  };
  Spreadsheet result(V,y.order());
  int m = GBGlobals::s_spreadsheets().push_back(result);
  marker output(input);
  output.num(m);
  output.put(si);
};

AddingCommand temp1SubSpr("SubSpreadsheet",2,_SubSpreadsheet);
