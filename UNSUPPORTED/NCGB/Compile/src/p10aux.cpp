// p11c_aux10.c

#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "GBStream.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif
#include "MyOstream.hpp"
#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif
#include "PrintGBList.hpp"
#include "RA2.hpp"
#include "RA3.hpp"


// ------------------------------------------------------------------
void _AppendMarker(Source & so,Sink & si) {
  marker mark1,mark2;
  mark1.get(so);
  mark2.get(so);
  if(!mark1.nameis(mark2.name())) DBG();
  int m = mark1.num(),n = mark2.num();
  simpleString x(mark1.name());
  so.shouldBeEnd();
  si.noOutput();
  if(x=="polynomials") {
    const GBList<Polynomial> & source = 
            GBGlobals::s_polynomials().const_reference(n);
    GBList<Polynomial> & dest = 
       GBGlobals::s_polynomials().reference(m);
    GBList<Polynomial>::const_iterator w = 
          source.begin();
    const int len = source.size();
    for(int i=0;i<len;++i,++w) {
        dest.push_back(*w);
    }
  }  else if(x=="rules") {
    const GBList<GroebnerRule> & source = 
          GBGlobals::s_rules().const_reference(n);
    GBList<GroebnerRule> & dest = 
          GBGlobals::s_rules().reference(m);
    GBList<GroebnerRule>::const_iterator w = 
           source.begin();
    const int len = source.size();
    for(int i=0;i<len;++i,++w) {
        dest.push_back(*w);
    }
  } else DBG();
};

AddingCommand temp1p10aux("AppendMarker",2,_AppendMarker);

// ------------------------------------------------------------------

void _MarkerTake(Source & so,Sink & si) {
  marker mark;
  mark.get(so);
  int m = mark.num();
  stringGB x(mark.name());
  vector<int> intptr;
  GBInputSpecial(intptr,so);
  int len = intptr.size();
  so.shouldBeEnd();
  marker result;
  result.name(x.value().chars());
  if(result.nameis("polynomials")) {
    result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));
    const GBList<Polynomial> & source = 
              GBGlobals::s_polynomials().const_reference(m);
    GBList<Polynomial> & dest =
              GBGlobals::s_polynomials().reference(result.num());
    GBList<Polynomial>::const_iterator w = source.begin();
    int place = 1;
    const int sz = source.size();
    for(int i=0;i<len;++i) {
      if(intptr[i]<1 || intptr[i]>sz) {
        GBStream << "The value requested is " << intptr[i] << '\n';
        GBStream << "The choices are up to " << sz << '\n';
        GBStream << "The polynomials are ";
	PrintGBList(0,source);
	GBStream << '\n';
        DBG();
     }
     if(place<=intptr[i]) {
       int diff = intptr[i]-place;
       w.advance(diff);
     } else {
       w = source.begin();
       w.advance(intptr[i]-1);
     }
     place = intptr[i];
     dest.push_back(*w);
     }
   }  else if(result.nameis("rules")) {
     result.num(GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
     const GBList<GroebnerRule> & source = 
        GBGlobals::s_rules().const_reference(m);
     GBList<GroebnerRule> & dest =
        GBGlobals::s_rules().reference(result.num());
     GBList<GroebnerRule>::const_iterator w = source.begin();
     int place = 1;
     const int sz = source.size();
     for(int i=0;i<len;++i) {
       if(intptr[i]<1 || intptr[i]>sz) {
         GBStream << "The value requested is " 
                  << intptr[i] << '\n';
         GBStream << "The choices are up to " << sz << '\n';
         GBStream << "The rules are ";
	 PrintGBList(0,source);
         GBStream << '\n';
         DBG();
       }
       if(place<=intptr[i]) {
         int diff = intptr[i]-place;
         w.advance(diff);
       } else {
         w = source.begin();
         w.advance(intptr[i]-1);
       }
       place = intptr[i];
       dest.push_back(*w);
     }
   }  else DBG();
   result.put(si);
};

AddingCommand temp2p10aux("MarkerTake",2,_MarkerTake);

// ------------------------------------------------------------------

void _CPlusMarkers(Source & so,Sink & si) {
  GBGlobals TEMP;
  so.shouldBeEnd();
  GBStream << "The current GBMarkers are\nBEGIN LIST\n";
  GBList<int>::const_iterator w =
      TEMP.s_currentMarkerNumbers().begin();
  GBList<simpleString>::const_iterator ww =
      TEMP.s_currentMarkerStrings().begin();
  const int sz = TEMP.s_currentMarkerNumbers().size();
  for(int i=1;i<=sz;++i,++w,++ww) {
    GBStream << "GBMarker[" << *w << " " << *ww << "]\n";
  };
  GBStream << "END LIST\n";
  si.noOutput();
};

AddingCommand temp3p10aux("CPlusMarkers",0,_CPlusMarkers);
