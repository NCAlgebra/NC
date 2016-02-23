// p11c_aux8.c

#include "GBIO.hpp"
#include "PDReduction.hpp"
#include "SPIID.hpp"
#include "GBOutputSpecial.hpp"
#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif
#include "RA1.hpp"
#include "RA2.hpp"
#include "RA3.hpp"
#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif
#include "Command.hpp"
#include "FCGiveNumber.hpp"



void ReduceUsingMarkersHelper(const GBList<GroebnerRule> & rules,
   const GBList<Polynomial> & polys,
   GBList<Polynomial> & resultPolynomials) {
  FactControl fc;
  FCGiveNumber fcgive(fc);
  PDReduction reducer(fcgive);

  const int szr = rules.size();
  GBList<GroebnerRule>::const_iterator w = rules.begin();
  int i=1;
  for(;i<=szr;++i,++w) {
    fc.addFactAndHistory(*w,GBHistory(0,0),0);
    reducer.addFact(SPIID(i));
  }

  GBList<Polynomial>::const_iterator ww = polys.begin();
  const int szp = polys.size();
  Polynomial presult;

  // fill the GBMarker[ans,"polynomials"] container 
  for(i=1;i<=szp;++i,++ww) {
    reducer.reduce(*ww,presult);
    resultPolynomials.push_back(presult); 
  }
};

// ------------------------------------------------------------------

void _ReduceUsingMarkers(Source & so,Sink & si) {
#ifdef PDLOAD
  int polyC,ruleC;
  so >> polyC >> ruleC;
  so.shouldBeEnd();
  // Set up rules first
  const GBList<GroebnerRule> & rules = 
      GBGlobals::s_rules().reference(ruleC);

  // Allocate the new container
  // Must be deallocated elsewhere
  marker result;
  result.name("polynomials");
  result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));

  // Grab a reference to the result for speed
  GBList<Polynomial> & resultPolynomials = 
     GBGlobals::s_polynomials().reference(result.num());

  // Grab a constant reference to the polynomial container
  const GBList<Polynomial> & polys = 
     GBGlobals::s_polynomials().const_reference(polyC);

  ReduceUsingMarkersHelper(rules,polys,resultPolynomials);

  result.put(si);
#else
  Debug1::s_not_supported("_ReduceUsingMarkers");
  so.shouldBeEnd();
  si.noOutput();
#endif
};

AddingCommand temp1p8aux("ReduceUsingMarkers",2,_ReduceUsingMarkers);

// ------------------------------------------------------------------

void _informZeros(Source & so,Sink & si) {
  marker mark;
  mark.getNamed("polynomials",so);
  so.shouldBeEnd();
  int polyC = mark.num();
  // Store ans in vector because we do not know how
  // many zeros there will be
  GBVector<int> ans;

  // Grab a reference to the polynomial container
  const GBList<Polynomial> & polys = 
     GBGlobals::s_polynomials().const_reference(polyC);
  GBList<Polynomial>::const_iterator ww = polys.begin();
  const int szp = polys.size();
  Polynomial result;

  for(int i=1;i<=szp;++i,++ww) {
    if((*ww).zero()) ans.push_back(i);
  }
  GBOutputSpecial(ans,si);
};

AddingCommand temp2p8aux("informZeros",1,_informZeros);
